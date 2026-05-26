import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../../data/services/photo_service.dart';
import '../../data/services/photo_service_providers.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/models/document.dart';
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

class _AddEditDocumentScreenState
    extends ConsumerState<AddEditDocumentScreen> {
  static const _uuid = Uuid();
  static const _nameFieldKey = ValueKey('document-form-name');

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notifyDaysController = TextEditingController(text: '30');
  final _notesController = TextEditingController();

  DocumentType _selectedType = DocumentType.other;
  DateTime? _expiryDate;
  String? _photoPath;
  String? _loadedDocumentId;

  bool get _isEditing => widget.documentId != null;
  bool get _supportsCameraCapture => Platform.isAndroid || Platform.isIOS;

  @override
  void dispose() {
    _nameController.dispose();
    _notifyDaysController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title =
        _isEditing ? l10n.documentEditTitle : l10n.documentAddTitle;

    if (!_isEditing) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: _buildForm(),
      );
    }

    final documentAsync = ref.watch(documentByIdProvider(widget.documentId!));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: documentAsync.when(
        data: (document) {
          if (document == null) {
            return const SizedBox.shrink();
          }
          _populateFromDocument(document);
          return _buildForm(existing: document);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }

  void _populateFromDocument(Document document) {
    if (_loadedDocumentId == document.id) return;
    _loadedDocumentId = document.id;
    _nameController.text = document.name;
    _notifyDaysController.text = document.notifyDaysBefore.toString();
    _notesController.text = document.notes ?? '';
    _selectedType = document.type;
    _expiryDate = document.expiryDate;
    _photoPath = document.photoPath;
  }

  Widget _buildForm({Document? existing}) {
    final l10n = AppLocalizations.of(context);
    final isSaving = ref.watch(saveDocumentProvider).isLoading;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: _nameFieldKey,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.documentNameLabel),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.documentValidationName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DocumentType>(
              initialValue: _selectedType,
              decoration:
                  InputDecoration(labelText: l10n.documentTypeLabel),
              items: [
                for (final type in DocumentType.values)
                  DropdownMenuItem<DocumentType>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(type.icon, size: 20),
                        const SizedBox(width: 8),
                        Text(type.label(l10n)),
                      ],
                    ),
                  ),
              ],
              onChanged: (type) {
                if (type == null) return;
                setState(() => _selectedType = type);
              },
            ),
            const SizedBox(height: 16),
            _ExpiryDateField(
              value: _expiryDate,
              onPick: _pickExpiryDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notifyDaysController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.documentNotifyDaysLabel,
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                final parsed = int.tryParse(trimmed);
                if (parsed == null || parsed < 0) {
                  return l10n.documentValidationNotifyDays;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _PhotoSection(
              photoPath: _photoPath,
              onPressed: _onPhotoPressed,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              minLines: 3,
              maxLines: 5,
              decoration:
                  InputDecoration(labelText: l10n.documentNotesLabel),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isSaving ? null : () => _save(existing: existing),
              child: Text(l10n.documentSave),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 50),
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
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
    String? nextPhotoPath,
    PhotoService photoService,
  ) async {
    if (nextPhotoPath == null) return;
    final previous = _photoPath;
    if (previous != null && previous != nextPhotoPath) {
      await photoService.deletePhoto(previous);
    }
    if (!mounted) return;
    setState(() => _photoPath = nextPhotoPath);
  }

  Future<void> _removePhoto(PhotoService photoService) async {
    final previous = _photoPath;
    if (previous == null) return;
    await photoService.deletePhoto(previous);
    if (!mounted) return;
    setState(() => _photoPath = null);
  }

  Future<void> _save({Document? existing}) async {
    final l10n = AppLocalizations.of(context);
    final formValid = _formKey.currentState!.validate();
    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.documentValidationExpiry)),
      );
      return;
    }
    if (!formValid) return;

    final now = DateTime.now();
    final notes = _notesController.text.trim();
    final document = Document(
      id: existing?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      expiryDate: _expiryDate!,
      notifyDaysBefore: int.parse(_notifyDaysController.text.trim()),
      photoPath: _photoPath,
      notes: notes.isEmpty ? null : notes,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(saveDocumentProvider.notifier).save(document);
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.documentSaveFailed)),
      );
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
    } catch (e) {
      debugPrint('[HouseKeep] Document reschedule skipped: $e');
    }

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.documentSavedSuccess)),
    );
    context.pop();
  }
}

class _ExpiryDateField extends StatelessWidget {
  const _ExpiryDateField({required this.value, required this.onPick});

  final DateTime? value;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final label =
        value == null ? l10n.documentExpiryDatePick : formatter.format(value!);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: l10n.documentExpiryDateLabel,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          IconButton(
            tooltip: l10n.documentExpiryDateLabel,
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: onPick,
          ),
        ],
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
        Text(
          l10n.documentPhotoLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
