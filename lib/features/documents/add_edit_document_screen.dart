import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../data/services/photo_service.dart';
import '../../data/services/photo_service_providers.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/models/document.dart';
import '../../shared/widgets/hk_button.dart';
import '../../shared/widgets/hk_form_field.dart';
import '../../shared/widgets/hk_photo_slot.dart';
import '../../shared/widgets/photo_error_snackbar.dart';
import '../../shared/widgets/photo_picker_sheet.dart';
import 'documents_provider.dart';

class AddEditDocumentScreen extends ConsumerStatefulWidget {
  const AddEditDocumentScreen({super.key, this.documentId});

  final String? documentId;

  @override
  ConsumerState<AddEditDocumentScreen> createState() =>
      _AddEditDocumentScreenState();
}

class _AddEditDocumentScreenState extends ConsumerState<AddEditDocumentScreen> {
  static const _uuid = Uuid();
  static const _nameFieldKey = ValueKey('document-form-name');
  static const _reminderOptions = [30, 15, 7, 1];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  DocumentType _selectedType = DocumentType.other;
  DateTime? _expiryDate;
  int _notifyDaysBefore = 30;
  String? _photoPath;
  String? _loadedDocumentId;

  bool get _isEditing => widget.documentId != null;
  bool get _supportsCameraCapture => Platform.isAndroid || Platform.isIOS;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _isEditing ? l10n.documentEditTitle : l10n.documentAddTitle;

    if (!_isEditing) return _buildScaffold(title);

    final documentAsync = ref.watch(documentByIdProvider(widget.documentId!));
    return documentAsync.when(
      data: (document) {
        if (document == null) return const SizedBox.shrink();
        _populateFromDocument(document);
        return _buildScaffold(title, existing: document);
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: Text(error.toString())),
      ),
    );
  }

  Widget _buildScaffold(String title, {Document? existing}) {
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 120),
                children: [
                  _Header(title: title, onBack: () => context.pop()),
                  const SizedBox(height: 18),
                  _PhotoBlock(
                    photoPath: _photoPath,
                    cameraEnabled: _supportsCameraCapture,
                    onPreviewPressed: _onPhotoPressed,
                    onCameraPressed: _pickFromCamera,
                    onGalleryPressed: _pickFromGallery,
                  ),
                  const SizedBox(height: 22),
                  _buildTypePicker(),
                  const SizedBox(height: 14),
                  _buildNameField(),
                  const SizedBox(height: 14),
                  _buildExpiryDateField(),
                  const SizedBox(height: 14),
                  _buildReminderField(isPro: isPro),
                  const SizedBox(height: 14),
                  _buildNotesField(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _SaveBar(
                isSaving: ref.watch(saveDocumentProvider).isLoading,
                onCancel: () => context.pop(),
                onSave: () => _save(existing: existing),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypePicker() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.documentTypeLabel,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final type in DocumentType.values)
            _DocumentTypeChip(
              type: type,
              active: type == _selectedType,
              onTap: () => setState(() => _selectedType = type),
            ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.documentNameLabel,
      child: TextFormField(
        key: _nameFieldKey,
        controller: _nameController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(hintText: l10n.documentNameHint),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return l10n.documentValidationName;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildExpiryDateField() {
    final l10n = AppLocalizations.of(context);
    final text = _expiryDate == null
        ? 'YYYY-MM-DD'
        : DateFormat('yyyy-MM-dd').format(_expiryDate!);
    return HkFormField(
      label: l10n.documentExpiryDateLabel,
      child: InkWell(
        onTap: _pickExpiryDate,
        borderRadius: BorderRadius.circular(AppRadii.btn),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.btn),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Symbols.calendar_today_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: _expiryDate == null
                      ? AppColors.textFaint
                      : AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderField({required bool isPro}) {
    final l10n = AppLocalizations.of(context);
    if (isPro) {
      return HkFormField(
        label: l10n.documentNotifyDaysLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ReminderChip(
                  label: l10n.documentReminderDaysBefore(90),
                  selected: true,
                ),
                _ReminderChip(
                  label: l10n.documentReminderDaysBefore(30),
                  selected: true,
                ),
                _ReminderChip(
                  label: l10n.documentReminderDaysBefore(7),
                  selected: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.documentReminderProHint,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    final options = [
      if (!_reminderOptions.contains(_notifyDaysBefore)) _notifyDaysBefore,
      ..._reminderOptions,
    ];
    return HkFormField(
      label: l10n.documentNotifyDaysLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final days in options)
                _ReminderChip(
                  label: l10n.documentReminderDaysBefore(days),
                  selected: _notifyDaysBefore == days,
                  onTap: () => setState(() => _notifyDaysBefore = days),
                ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => context.push('/paywall'),
            child: Text(
              l10n.documentReminderFreeHint,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.documentNotesLabel,
      child: TextFormField(
        controller: _notesController,
        minLines: 2,
        maxLines: 4,
        decoration: InputDecoration(hintText: l10n.documentNotesHint),
      ),
    );
  }

  void _populateFromDocument(Document document) {
    if (_loadedDocumentId == document.id) return;
    _loadedDocumentId = document.id;
    _nameController.text = document.name;
    _notesController.text = document.notes ?? '';
    _selectedType = document.type;
    _expiryDate = document.expiryDate;
    _notifyDaysBefore = document.notifyDaysBefore;
    _photoPath = document.photoPath;
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime(now.year + 1, now.month, now.day),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 30),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _onPhotoPressed() async {
    final action = await showPhotoPickerSheet(
      context,
      showRemoveAction: _photoPath != null,
      showCameraAction: _supportsCameraCapture,
    );
    if (action != null && mounted) await _applyPhotoAction(action);
  }

  Future<void> _pickFromCamera() => _applyPhotoAction(PhotoPickerAction.camera);

  Future<void> _pickFromGallery() =>
      _applyPhotoAction(PhotoPickerAction.gallery);

  Future<void> _applyPhotoAction(PhotoPickerAction action) async {
    if (action == PhotoPickerAction.camera && !_supportsCameraCapture) return;
    final photoService = await ref.read(photoServiceProvider.future);
    try {
      switch (action) {
        case PhotoPickerAction.camera:
          await _replacePhoto(
            await photoService.pickFromCamera(),
            photoService,
          );
          break;
        case PhotoPickerAction.gallery:
          await _replacePhoto(
            await photoService.pickFromGallery(),
            photoService,
          );
          break;
        case PhotoPickerAction.remove:
          await _removePhoto(photoService);
          break;
      }
    } on PhotoPickerException catch (error) {
      if (mounted) showPhotoPickerError(context, error);
    }
  }

  Future<void> _replacePhoto(String? next, PhotoService photoService) async {
    if (next == null) return;
    final previous = _photoPath;
    if (previous != null && previous != next) {
      await photoService.deletePhoto(previous);
    }
    if (mounted) setState(() => _photoPath = next);
  }

  Future<void> _removePhoto(PhotoService photoService) async {
    final previous = _photoPath;
    if (previous == null) return;
    await photoService.deletePhoto(previous);
    if (mounted) setState(() => _photoPath = null);
  }

  Future<void> _save({Document? existing}) async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_expiryDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.documentValidationExpiry)));
      return;
    }

    final now = DateTime.now();
    final document = Document(
      id: existing?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      expiryDate: _expiryDate!,
      notifyDaysBefore: _notifyDaysBefore,
      photoPath: _photoPath,
      notes: _trimmedOrNull(_notesController.text),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(saveDocumentProvider.notifier).save(document);
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.documentSaveFailed)),
        );
      }
      return;
    }

    try {
      final isPro = ref.read(isProProvider).valueOrNull ?? false;
      await ref
          .read(notificationSchedulerProvider)
          .rescheduleDocument(
            document: document,
            isPro: isPro,
            texts: NotificationTexts.fromL10n(l10n),
          );
    } catch (error) {
      debugPrint('[HouseKeep] Document reschedule skipped: $error');
    }

    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.documentSavedSuccess)));
    context.pop();
  }

  String? _trimmedOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Symbols.arrow_back_rounded, color: AppColors.text),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoBlock extends StatelessWidget {
  const _PhotoBlock({
    required this.photoPath,
    required this.cameraEnabled,
    required this.onPreviewPressed,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  final String? photoPath;
  final bool cameraEnabled;
  final VoidCallback onPreviewPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPreviewPressed,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: photoPath == null
              ? SizedBox(
                  width: 86,
                  height: 86,
                  child: HkPhotoSlot(
                    label: l10n.documentScanPlaceholder,
                    height: 86,
                  ),
                )
              : SizedBox(
                  width: 86,
                  height: 86,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                    child: Image.file(File(photoPath!), fit: BoxFit.cover),
                  ),
                ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HkButton(
                label: l10n.documentScan,
                icon: Symbols.photo_camera_rounded,
                variant: HkButtonVariant.soft,
                size: HkButtonSize.sm,
                onPressed: cameraEnabled ? onCameraPressed : null,
                full: true,
              ),
              const SizedBox(height: 8),
              HkButton(
                label: l10n.documentGallery,
                icon: Symbols.image_rounded,
                variant: HkButtonVariant.outline,
                size: HkButtonSize.sm,
                onPressed: onGalleryPressed,
                full: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentTypeChip extends StatelessWidget {
  const _DocumentTypeChip({
    required this.type,
    required this.active,
    required this.onTap,
  });

  final DocumentType type;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active ? AppColors.onPrimary : AppColors.text;
    return Material(
      color: active ? AppColors.primary : AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(type.icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                type.label(AppLocalizations.of(context)),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderChip extends StatelessWidget {
  const _ReminderChip({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surfaceAlt,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? Colors.transparent : AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.isSaving,
    required this.onCancel,
    required this.onSave,
  });

  final bool isSaving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bg.withValues(alpha: 0), AppColors.bg],
          stops: const [0, .6],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: HkButton(
                label: l10n.documentCancel,
                variant: HkButtonVariant.ghost,
                onPressed: isSaving ? null : onCancel,
                full: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: HkButton(
                label: l10n.documentSave,
                icon: Symbols.check_rounded,
                onPressed: isSaving ? null : onSave,
                full: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
