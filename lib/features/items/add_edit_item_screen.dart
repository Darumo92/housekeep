import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../data/services/photo_service.dart';
import '../../data/services/photo_service_providers.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';
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
  final _modelController = TextEditingController();
  final _warrantyMonthsController = TextEditingController();
  final _notesController = TextEditingController();

  ItemCategory _selectedCategory = ItemCategory.general;
  String? _loadedItemId;
  String? _photoPath;

  bool get _supportsCameraCapture => Platform.isAndroid || Platform.isIOS;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _warrantyMonthsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = widget.itemId == null ? l10n.itemAddTitle : l10n.itemEditTitle;

    if (widget.itemId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: _ItemForm(
          formKey: _formKey,
          nameController: _nameController,
          brandController: _brandController,
          modelController: _modelController,
          warrantyMonthsController: _warrantyMonthsController,
          notesController: _notesController,
          selectedCategory: _selectedCategory,
          photoPath: _photoPath,
          onCategoryChanged: _onCategoryChanged,
          onPhotoPressed: _onPhotoPressed,
          onSave: () => _saveItem(),
        ),
      );
    }

    final itemAsync = ref.watch(itemByIdProvider(widget.itemId!));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const SizedBox.shrink();
          }

          _populateFromItem(item);

          return _ItemForm(
            formKey: _formKey,
            nameController: _nameController,
            brandController: _brandController,
            modelController: _modelController,
            warrantyMonthsController: _warrantyMonthsController,
            notesController: _notesController,
            selectedCategory: _selectedCategory,
            photoPath: _photoPath,
            onCategoryChanged: _onCategoryChanged,
            onPhotoPressed: _onPhotoPressed,
            onSave: () => _saveItem(existingItem: item),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }

  void _onCategoryChanged(ItemCategory? category) {
    if (category == null) return;
    setState(() {
      _selectedCategory = category;
    });
  }

  void _populateFromItem(Item item) {
    if (_loadedItemId == item.id) return;

    _loadedItemId = item.id;
    _nameController.text = item.name;
    _brandController.text = item.brand ?? '';
    _modelController.text = item.model ?? '';
    _warrantyMonthsController.text = item.warrantyMonths?.toString() ?? '';
    _notesController.text = item.notes ?? '';
    _selectedCategory = item.category;
    _photoPath = item.photoPath;
  }

  Future<void> _onPhotoPressed() async {
    final action = await showPhotoPickerSheet(
      context,
      showRemoveAction: _photoPath != null,
      showCameraAction: _supportsCameraCapture,
    );
    if (action == null || !mounted) return;

    final photoService = await ref.read(photoServiceProvider.future);

    switch (action) {
      case PhotoPickerAction.camera:
        if (!_supportsCameraCapture) return;
        final nextPhotoPath = await photoService.pickFromCamera();
        await _replacePhoto(nextPhotoPath, photoService);
        break;
      case PhotoPickerAction.gallery:
        final nextPhotoPath = await photoService.pickFromGallery();
        await _replacePhoto(nextPhotoPath, photoService);
        break;
      case PhotoPickerAction.remove:
        await _removePhoto(photoService);
        break;
    }
  }

  Future<void> _replacePhoto(
    String? nextPhotoPath,
    PhotoService photoService,
  ) async {
    if (nextPhotoPath == null) return;

    final previousPhotoPath = _photoPath;
    if (previousPhotoPath != null && previousPhotoPath != nextPhotoPath) {
      await photoService.deletePhoto(previousPhotoPath);
    }

    if (!mounted) return;
    setState(() {
      _photoPath = nextPhotoPath;
    });
  }

  Future<void> _removePhoto(PhotoService photoService) async {
    final previousPhotoPath = _photoPath;
    if (previousPhotoPath == null) return;

    await photoService.deletePhoto(previousPhotoPath);

    if (!mounted) return;
    setState(() {
      _photoPath = null;
    });
  }

  Future<void> _saveItem({Item? existingItem}) async {
    if (!_formKey.currentState!.validate()) return;

    final texts = NotificationTexts.fromL10n(AppLocalizations.of(context));
    final now = DateTime.now();
    final warrantyMonthsText = _warrantyMonthsController.text.trim();
    final item = Item(
      id: existingItem?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      brand: _trimmedOrNull(_brandController.text),
      model: _trimmedOrNull(_modelController.text),
      purchaseDate: existingItem?.purchaseDate,
      warrantyMonths: warrantyMonthsText.isEmpty
          ? null
          : int.parse(warrantyMonthsText),
      photoPath: _photoPath,
      notes: _trimmedOrNull(_notesController.text),
      createdAt: existingItem?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await ref.read(saveItemProvider.notifier).save(item);
    } catch (_) {
      return;
    }

    final isPro = await ref.read(isProProvider.future);
    await ref
        .read(notificationSchedulerProvider)
        .rescheduleWarranty(item: item, isPro: isPro, texts: texts);

    if (!mounted) return;

    context.pop();
  }

  String? _trimmedOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _ItemForm extends ConsumerWidget {
  const _ItemForm({
    required this.formKey,
    required this.nameController,
    required this.brandController,
    required this.modelController,
    required this.warrantyMonthsController,
    required this.notesController,
    required this.selectedCategory,
    required this.photoPath,
    required this.onCategoryChanged,
    required this.onPhotoPressed,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController warrantyMonthsController;
  final TextEditingController notesController;
  final ItemCategory selectedCategory;
  final String? photoPath;
  final ValueChanged<ItemCategory?> onCategoryChanged;
  final Future<void> Function() onPhotoPressed;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isSaving = ref.watch(saveItemProvider).isLoading;

    return SafeArea(
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: _AddEditItemScreenState._nameFieldKey,
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.itemNameLabel),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.itemValidationName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ItemCategory>(
              initialValue: selectedCategory,
              decoration: InputDecoration(labelText: l10n.itemCategoryLabel),
              items: [
                for (final category in ItemCategory.values)
                  DropdownMenuItem<ItemCategory>(
                    value: category,
                    child: Text(category.label(l10n)),
                  ),
              ],
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: _AddEditItemScreenState._brandFieldKey,
              controller: brandController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.itemBrandLabel),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: modelController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.itemModelLabel),
            ),
            const SizedBox(height: 16),
            _PhotoSection(photoPath: photoPath, onPressed: onPhotoPressed),
            const SizedBox(height: 16),
            TextFormField(
              controller: warrantyMonthsController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.itemWarrantyMonthsLabel,
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return null;
                return int.tryParse(trimmed) == null
                    ? l10n.itemValidationWarrantyMonths
                    : null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: notesController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(labelText: l10n.itemNotesLabel),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isSaving ? null : onSave,
              child: Text(l10n.itemSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.photoPath, required this.onPressed});

  final String? photoPath;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPhoto = photoPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.itemPhotoLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Ink(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: hasPhoto
                  ? Image.file(File(photoPath!), fit: BoxFit.cover)
                  : const Icon(Icons.photo_outlined, size: 48),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onPressed,
          child: Text(hasPhoto ? l10n.itemPhotoReplace : l10n.itemPhotoAdd),
        ),
      ],
    );
  }
}
