import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/models/document.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import 'documents_provider.dart';
import 'widgets/document_card.dart';
import 'widgets/document_type_picker.dart';

class DocumentsListScreen extends ConsumerStatefulWidget {
  const DocumentsListScreen({super.key});

  @override
  ConsumerState<DocumentsListScreen> createState() =>
      _DocumentsListScreenState();
}

class _DocumentsListScreenState extends ConsumerState<DocumentsListScreen> {
  bool _isNavigatingToAdd = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedType = ref.watch(selectedDocumentTypeProvider);
    final documentsAsync = ref.watch(filteredDocumentsProvider);

    Future<void> navigateToAdd() async {
      if (_isNavigatingToAdd) return;

      setState(() {
        _isNavigatingToAdd = true;
      });

      try {
        final destination = await ref.read(
          addDocumentDestinationProvider.future,
        );
        if (!context.mounted) return;

        context.push(destination);
      } finally {
        if (mounted) {
          setState(() {
            _isNavigatingToAdd = false;
          });
        }
      }
    }

    void selectType(DocumentType type) {
      ref.read(selectedDocumentTypeProvider.notifier).select(type);
    }

    void clearType() {
      ref.read(selectedDocumentTypeProvider.notifier).clear();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isNavigatingToAdd ? null : navigateToAdd,
        icon: const Icon(Icons.add),
        label: Text(l10n.documentsEmptyCta),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          DocumentTypePicker(
            selectedType: selectedType,
            onTypeSelected: selectType,
            onClear: clearType,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: documentsAsync.when(
              data: (documents) {
                if (documents.isEmpty) {
                  if (selectedType != null) {
                    return EmptyState(
                      icon: selectedType.icon,
                      title: l10n.documentsFilteredEmptyTitle,
                      body: l10n.documentsFilteredEmptyBody,
                      actionLabel: l10n.documentsClearFilter,
                      onAction: clearType,
                    );
                  }

                  return EmptyState(
                    icon: Icons.description_rounded,
                    title: l10n.documentsEmptyTitle,
                    body: l10n.documentsEmptyBody,
                    actionLabel: l10n.documentsEmptyCta,
                    onAction: navigateToAdd,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: documents.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) => DocumentCard(
                    document: documents[index],
                    onTap: () => context.push(
                      '/documents/${documents[index].id}/edit',
                    ),
                    onDelete: () =>
                        _deleteDocument(context, ref, documents[index]),
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDocument(
    BuildContext context,
    WidgetRef ref,
    Document document,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context: context,
      title: l10n.documentDeleteTitle,
      body: l10n.documentDeleteBody,
      confirmLabel: l10n.documentDeleteConfirm,
    );
    if (!confirmed) return;

    try {
      await ref.read(deleteDocumentProvider.notifier).delete(document.id);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.documentDeleteFailed)),
      );
    }
  }
}

