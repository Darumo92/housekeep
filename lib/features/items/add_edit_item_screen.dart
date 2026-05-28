import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';
import '../../shared/widgets/hk_button.dart';
import '../../shared/widgets/hk_form_field.dart';
import '../../shared/widgets/hk_photo_slot.dart';
import '../../shared/widgets/photo_error_snackbar.dart';
import '../../shared/widgets/photo_picker_sheet.dart';
import 'items_provider.dart';

class AddEditItemScreen extends ConsumerStatefulWidget {
  const AddEditItemScreen({super.key, this.itemId});

  final String? itemId;

  @override
  ConsumerState<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends ConsumerState<AddEditItemScreen> {
  static const _uuid = Uuid();
  static const _nameFieldKey = ValueKey('item-form-name');
  static const _brandFieldKey = ValueKey('item-form-brand');

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _warrantyMonthsController = TextEditingController();
  final _notesController = TextEditingController();

  ItemCategory _selectedCategory = ItemCategory.general;
  DateTime? _purchaseDate;
  String? _loadedItemId;
  String? _photoPath;

  bool get _supportsCameraCapture => Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    if (_supportsCameraCapture) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _recoverLostPhoto());
    }
  }

  Future<void> _recoverLostPhoto() async {
    try {
      final photoService = await ref.read(photoServiceProvider.future);
      final recovered = await photoService.recoverLostPhoto();
      if (recovered != null) await _replacePhoto(recovered, photoService);
    } on PhotoPickerException catch (e) {
      if (mounted) showPhotoPickerError(context, e);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _warrantyMonthsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.itemId != null;
    final title = isEdit ? l10n.itemEditTitle : l10n.itemAddTitle;

    if (!isEdit) {
      return _buildScaffold(title);
    }

    final itemAsync = ref.watch(itemByIdProvider(widget.itemId!));
    return itemAsync.when(
      data: (item) {
        if (item == null) return const SizedBox.shrink();
        _populateFromItem(item);
        return _buildScaffold(title, existingItem: item);
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildScaffold(String title, {Item? existingItem}) {
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
                    onPickPhoto: _onPhotoPressed,
                  ),
                  const SizedBox(height: 22),
                  _buildNameField(),
                  const SizedBox(height: 14),
                  _buildBrandField(),
                  const SizedBox(height: 14),
                  _buildCategoryPicker(),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPurchaseDateField()),
                      const SizedBox(width: 10),
                      Expanded(child: _buildWarrantyMonthsField()),
                    ],
                  ),
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
                onCancel: () => context.pop(),
                onSave: () => _saveItem(existingItem: existingItem),
                isSaving: ref.watch(saveItemProvider).isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.itemNameLabel,
      child: TextFormField(
        key: _nameFieldKey,
        controller: _nameController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(hintText: 'Caldera, lavadora…'),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return l10n.itemValidationName;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBrandField() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.itemBrandLabel,
      child: TextFormField(
        key: _brandFieldKey,
        controller: _brandController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(hintText: 'Vaillant ecoTEC plus'),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.itemCategoryLabel,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final cat in ItemCategory.values)
            _CategoryChip(
              category: cat,
              active: _selectedCategory == cat,
              onTap: () => setState(() => _selectedCategory = cat),
            ),
        ],
      ),
    );
  }

  Widget _buildPurchaseDateField() {
    final l10n = AppLocalizations.of(context);
    final fmt = DateFormat('yyyy-MM-dd');
    final text = _purchaseDate == null ? 'YYYY-MM-DD' : fmt.format(_purchaseDate!);
    return HkFormField(
      label: l10n.addFieldPurchased,
      child: InkWell(
        onTap: _pickPurchaseDate,
        borderRadius: BorderRadius.circular(AppRadii.btn),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.btn),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Symbols.calendar_today_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: _purchaseDate == null
                        ? AppColors.textFaint
                        : AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarrantyMonthsField() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.itemWarrantyMonthsLabel,
      child: TextFormField(
        controller: _warrantyMonthsController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 15,
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(hintText: '24'),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          final trimmed = value?.trim() ?? '';
          if (trimmed.isEmpty) return null;
          return int.tryParse(trimmed) == null
              ? l10n.itemValidationWarrantyMonths
              : null;
        },
      ),
    );
  }

  Widget _buildNotesField() {
    final l10n = AppLocalizations.of(context);
    return HkFormField(
      label: l10n.itemNotesLabel,
      child: TextFormField(
        controller: _notesController,
        minLines: 2,
        maxLines: 5,
        decoration: const InputDecoration(hintText: '…'),
      ),
    );
  }

  Future<void> _pickPurchaseDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() => _purchaseDate = picked);
  }

  void _populateFromItem(Item item) {
    if (_loadedItemId == item.id) return;
    _loadedItemId = item.id;
    _nameController.text = item.name;
    final brandModel = [
      if (item.brand != null) item.brand!,
      if (item.model != null) item.model!,
    ].join(' ');
    _brandController.text = brandModel;
    _warrantyMonthsController.text = item.warrantyMonths?.toString() ?? '';
    _notesController.text = item.notes ?? '';
    _selectedCategory = item.category;
    _photoPath = item.photoPath;
    _purchaseDate = item.purchaseDate;
  }

  Future<void> _onPhotoPressed() async {
    final action = await showPhotoPickerSheet(
      context,
      showRemoveAction: _photoPath != null,
      showCameraAction: _supportsCameraCapture,
    );
    if (action == null || !mounted) return;

    final photoService = await ref.read(photoServiceProvider.future);

    try {
      switch (action) {
        case PhotoPickerAction.camera:
          if (!_supportsCameraCapture) return;
          final next = await photoService.pickFromCamera();
          await _replacePhoto(next, photoService);
          break;
        case PhotoPickerAction.gallery:
          final next = await photoService.pickFromGallery();
          await _replacePhoto(next, photoService);
          break;
        case PhotoPickerAction.remove:
          await _removePhoto(photoService);
          break;
      }
    } on PhotoPickerException catch (e) {
      if (!mounted) return;
      showPhotoPickerError(context, e);
    }
  }

  Future<void> _replacePhoto(
    String? next,
    PhotoService photoService,
  ) async {
    if (next == null) return;
    final prev = _photoPath;
    if (prev != null && prev != next) {
      await photoService.deletePhoto(prev);
    }
    if (!mounted) return;
    setState(() => _photoPath = next);
  }

  Future<void> _removePhoto(PhotoService photoService) async {
    final prev = _photoPath;
    if (prev == null) return;
    await photoService.deletePhoto(prev);
    if (!mounted) return;
    setState(() => _photoPath = null);
  }

  Future<void> _saveItem({Item? existingItem}) async {
    if (!_formKey.currentState!.validate()) return;

    final texts = NotificationTexts.fromL10n(AppLocalizations.of(context));
    final now = DateTime.now();
    final warrantyMonthsText = _warrantyMonthsController.text.trim();
    final brandText = _brandController.text.trim();
    final item = Item(
      id: existingItem?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      brand: brandText.isEmpty ? null : brandText,
      model: existingItem?.model,
      purchaseDate: _purchaseDate ?? existingItem?.purchaseDate,
      warrantyMonths:
          warrantyMonthsText.isEmpty ? null : int.parse(warrantyMonthsText),
      photoPath: _photoPath,
      notes: _trimmedOrNull(_notesController.text),
      createdAt: existingItem?.createdAt ?? now,
      updatedAt: now,
    );

    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(saveItemProvider.notifier).save(item);
    } catch (_) {
      return;
    }

    try {
      final isPro = ref.read(isProProvider).valueOrNull ?? false;
      await ref
          .read(notificationSchedulerProvider)
          .rescheduleWarranty(item: item, isPro: isPro, texts: texts);
    } catch (e) {
      debugPrint('[HouseKeep] Warranty reschedule skipped: $e');
    }

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.itemSavedSuccess)),
    );
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
    final theme = Theme.of(context);
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
            style: theme.textTheme.titleLarge?.copyWith(
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
  const _PhotoBlock({required this.photoPath, required this.onPickPhoto});

  final String? photoPath;
  final Future<void> Function() onPickPhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPickPhoto,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: photoPath == null
              ? const SizedBox(
                  width: 86,
                  height: 86,
                  child: HkPhotoSlot(label: 'photo', height: 86),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              HkButton(
                label: l10n.addPhotoCamera,
                icon: Symbols.photo_camera_rounded,
                variant: HkButtonVariant.outline,
                size: HkButtonSize.sm,
                onPressed: onPickPhoto,
                full: true,
              ),
              const SizedBox(height: 8),
              HkButton(
                label: l10n.addPhotoGallery,
                icon: Symbols.image_rounded,
                variant: HkButtonVariant.outline,
                size: HkButtonSize.sm,
                onPressed: onPickPhoto,
                full: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.active,
    required this.onTap,
  });

  final ItemCategory category;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bg = active ? AppColors.primary : AppColors.surfaceAlt;
    final fg = active ? AppColors.onPrimary : AppColors.text;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(
                category.label(l10n),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.onCancel,
    required this.onSave,
    required this.isSaving,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isSaving;

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
          colors: [
            AppColors.bg.withValues(alpha: 0),
            AppColors.bg,
          ],
          stops: const [0, 0.6],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: HkButton(
                label: l10n.addCancel,
                variant: HkButtonVariant.ghost,
                size: HkButtonSize.md,
                onPressed: isSaving ? null : onCancel,
                full: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: HkButton(
                label: l10n.addSave,
                icon: Symbols.check_rounded,
                size: HkButtonSize.md,
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
