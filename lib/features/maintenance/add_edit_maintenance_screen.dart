import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import '../../domain/models/maintenance_template.dart';
import '../items/items_provider.dart';
import 'maintenances_provider.dart';
import 'widgets/template_picker_sheet.dart';

class AddEditMaintenanceScreen extends ConsumerStatefulWidget {
  const AddEditMaintenanceScreen({
    super.key,
    required this.itemId,
    this.maintenanceId,
  });

  final String itemId;
  final String? maintenanceId;

  @override
  ConsumerState<AddEditMaintenanceScreen> createState() =>
      _AddEditMaintenanceScreenState();
}

class _AddEditMaintenanceScreenState
    extends ConsumerState<AddEditMaintenanceScreen> {
  static const _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _intervalController = TextEditingController(text: '6');
  final _notifyDaysController = TextEditingController(text: '7');

  DateTime? _lastDoneAt;
  bool _isFromTemplate = false;
  String? _loadedMaintenanceId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _intervalController.dispose();
    _notifyDaysController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.maintenanceId != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _isEditing
        ? l10n.maintenanceEditTitle
        : l10n.maintenanceAddTitle;
    final itemAsync = ref.watch(itemByIdProvider(widget.itemId));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const SizedBox.shrink();
          }
          if (_isEditing) {
            return _buildEditing(item);
          }
          return _buildForm(item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }

  Widget _buildEditing(Item item) {
    final maintenanceAsync = ref.watch(
      maintenanceByIdProvider(widget.maintenanceId!),
    );
    return maintenanceAsync.when(
      data: (maintenance) {
        if (maintenance == null) {
          return const SizedBox.shrink();
        }
        _populateFromMaintenance(maintenance);
        return _buildForm(item, existing: maintenance);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }

  void _populateFromMaintenance(Maintenance maintenance) {
    if (_loadedMaintenanceId == maintenance.id) return;
    _loadedMaintenanceId = maintenance.id;
    _nameController.text = maintenance.name;
    _descriptionController.text = maintenance.description ?? '';
    _intervalController.text = maintenance.intervalMonths.toString();
    _notifyDaysController.text = maintenance.notifyDaysBefore.toString();
    _lastDoneAt = maintenance.lastDoneAt;
    _isFromTemplate = maintenance.isFromTemplate;
  }

  Widget _buildForm(Item item, {Maintenance? existing}) {
    final l10n = AppLocalizations.of(context);
    final category = item.category;
    final isSaving = ref.watch(saveMaintenanceProvider).isLoading;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_isEditing)
              OutlinedButton.icon(
                onPressed: () => _pickTemplate(category),
                icon: const Icon(Icons.auto_awesome_outlined),
                label: Text(l10n.maintenanceUseTemplate),
              ),
            if (!_isEditing) const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.maintenanceNameLabel,
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.maintenanceValidationName
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.maintenanceDescriptionLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _intervalController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.maintenanceIntervalLabel,
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                final parsed = int.tryParse(trimmed);
                if (parsed == null || parsed <= 0) {
                  return l10n.maintenanceValidationInterval;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notifyDaysController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.maintenanceNotifyDaysLabel,
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                final parsed = int.tryParse(trimmed);
                if (parsed == null || parsed < 0) {
                  return l10n.maintenanceValidationNotifyDays;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _LastDoneField(
              value: _lastDoneAt,
              onPick: _pickLastDone,
              onClear: () => setState(() => _lastDoneAt = null),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () => _save(item: item, existing: existing),
              child: Text(l10n.maintenanceSave),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLastDone() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastDoneAt ?? now,
      firstDate: DateTime(now.year - 20),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _lastDoneAt = picked);
    }
  }

  Future<void> _pickTemplate(ItemCategory category) async {
    final template = await showMaintenanceTemplatePicker(
      context,
      category: category,
    );
    if (template == null || !mounted) return;
    _applyTemplate(template);
  }

  void _applyTemplate(MaintenanceTemplate template) {
    final isSpanish =
        Localizations.localeOf(context).languageCode == 'es';
    setState(() {
      _nameController.text = isSpanish ? template.nameEs : template.nameEn;
      _descriptionController.text = isSpanish
          ? template.descriptionEs
          : template.descriptionEn;
      _intervalController.text = template.intervalMonths.toString();
      _notifyDaysController.text = template.notifyDaysBefore.toString();
      _isFromTemplate = true;
    });
  }

  Future<void> _save({required Item item, Maintenance? existing}) async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final texts = NotificationTexts.fromL10n(l10n);
    final now = DateTime.now();
    final intervalMonths = int.parse(_intervalController.text.trim());
    final notifyDaysBefore = int.parse(_notifyDaysController.text.trim());
    final description = _descriptionController.text.trim();
    final nextDueAt = computeNextDueAt(
      lastDoneAt: _lastDoneAt,
      intervalMonths: intervalMonths,
      now: now,
    );

    final maintenance = Maintenance(
      id: existing?.id ?? _uuid.v4(),
      itemId: widget.itemId,
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      intervalMonths: intervalMonths,
      lastDoneAt: _lastDoneAt,
      nextDueAt: nextDueAt,
      notifyDaysBefore: notifyDaysBefore,
      isFromTemplate:
          (existing?.isFromTemplate ?? false) || _isFromTemplate,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(saveMaintenanceProvider.notifier).save(maintenance);
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.maintenanceSaveFailed)),
      );
      return;
    }

    try {
      final isPro = ref.read(isProProvider).valueOrNull ?? false;
      await ref
          .read(notificationSchedulerProvider)
          .rescheduleMaintenance(
            maintenance: maintenance,
            item: item,
            isPro: isPro,
            texts: texts,
          );
    } catch (e) {
      debugPrint('[HouseKeep] Maintenance reschedule skipped: $e');
    }

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.maintenanceSavedSuccess)),
    );
    context.pop();
  }
}

class _LastDoneField extends StatelessWidget {
  const _LastDoneField({
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final label = value == null
        ? l10n.maintenanceLastDoneNever
        : formatter.format(value!);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: l10n.maintenanceLastDoneLabel,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (value != null)
            IconButton(
              tooltip: l10n.maintenanceLastDoneNever,
              icon: const Icon(Icons.clear),
              onPressed: onClear,
            ),
          IconButton(
            tooltip: l10n.maintenanceLastDoneLabel,
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: onPick,
          ),
        ],
      ),
    );
  }
}
