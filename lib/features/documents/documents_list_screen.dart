import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_calculations.dart';
import '../../core/utils/haptics.dart';
import '../../data/repositories/repository_providers.dart' show isProProvider;
import '../../data/services/notification_providers.dart';
import '../../domain/models/document.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/hk_button.dart';
import '../../shared/widgets/hk_card.dart';
import '../../shared/widgets/hk_fab.dart';
import '../../shared/widgets/shimmer.dart';
import 'documents_provider.dart';
import 'widgets/document_card.dart';

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
    final documentsAsync = ref.watch(documentsProvider);
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: context.hkc.bg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 4),
        child: HkFab(
          icon: Symbols.add_rounded,
          onPressed: _isNavigatingToAdd ? null : _navigateToAdd,
          tooltip: l10n.documentsEmptyCta,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(count: documentsAsync.valueOrNull?.length ?? 0, isPro: isPro),
          const SizedBox(height: 16),
          Expanded(
            child: documentsAsync.when(
              data: (documents) {
                if (documents.isEmpty) {
                  return _EmptyDocuments(onAdd: _navigateToAdd);
                }
                return _GroupedDocuments(
                  documents: documents,
                  onOpen: (document) =>
                      context.push('/documents/${document.id}/edit'),
                  onDelete: (document) =>
                      _deleteDocument(context, ref, document),
                );
              },
              error: (error, stackTrace) =>
                  ErrorState(onRetry: () => ref.invalidate(documentsProvider)),
              loading: () => const ListSkeleton(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAdd() async {
    if (_isNavigatingToAdd) return;
    setState(() => _isNavigatingToAdd = true);
    try {
      final destination = await ref.read(addDocumentDestinationProvider.future);
      if (mounted) context.push(destination);
    } finally {
      if (mounted) setState(() => _isNavigatingToAdd = false);
    }
  }

  Future<void> _deleteDocument(
    BuildContext context,
    WidgetRef ref,
    Document document,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context: context,
      title: l10n.documentDeleteTitle,
      body: l10n.documentDeleteBody,
      confirmLabel: l10n.documentDeleteConfirm,
    );
    if (!confirmed) return;
    AppHaptics.destructive();

    await ref.read(notificationSchedulerProvider).cancelDocument(document.id);

    try {
      await ref.read(deleteDocumentProvider.notifier).delete(document.id);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.documentDeletedSuccess)),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.documentDeleteFailed)),
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count, required this.isPro});

  final int count;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overLimit = !isPro && count > AppConstants.freeDocumentsLimit;
    final counter = isPro
        ? l10n.documentsCount(count)
        : l10n.documentsCountFree(count);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              l10n.documentsTitle,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: context.hkc.text),
            ),
          ),
          Text(
            counter,
            style: isPro
                ? TextStyle(
                    fontSize: 13,
                    color: context.hkc.textMuted,
                    fontWeight: FontWeight.w500,
                  )
                : GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: overLimit ? context.hkc.danger : context.hkc.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }
}

class _GroupedDocuments extends StatelessWidget {
  const _GroupedDocuments({
    required this.documents,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Document> documents;
  final ValueChanged<Document> onOpen;
  final ValueChanged<Document> onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final sorted = List<Document>.of(documents)
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    final expired = sorted
        .where(
          (document) =>
              DateCalculations.calendarDaysUntil(document.expiryDate, now) < 0,
        )
        .toList();
    final soon = sorted
        .where(
          (document) =>
              DateCalculations.calendarDaysUntil(document.expiryDate, now) >=
                  0 &&
              DateCalculations.calendarDaysUntil(document.expiryDate, now) <=
                  90,
        )
        .toList();
    final current = sorted
        .where(
          (document) =>
              DateCalculations.calendarDaysUntil(document.expiryDate, now) > 90,
        )
        .toList();
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.only(bottom: HkFab.scrollReserve),
      children: [
        if (expired.isNotEmpty)
          _DocumentSection(
            label: l10n.documentsSectionExpired,
            tone: context.hkc.danger,
            documents: expired,
            onOpen: onOpen,
            onDelete: onDelete,
          ),
        if (soon.isNotEmpty)
          _DocumentSection(
            label: l10n.documentsSectionSoon,
            tone: context.hkc.warn,
            documents: soon,
            onOpen: onOpen,
            onDelete: onDelete,
          ),
        if (current.isNotEmpty)
          _DocumentSection(
            label: l10n.documentsSectionCurrent,
            tone: context.hkc.ok,
            documents: current,
            onOpen: onOpen,
            onDelete: onDelete,
          ),
      ],
    );
  }
}

class _DocumentSection extends StatelessWidget {
  const _DocumentSection({
    required this.label,
    required this.tone,
    required this.documents,
    required this.onOpen,
    required this.onDelete,
  });

  final String label;
  final Color tone;
  final List<Document> documents;
  final ValueChanged<Document> onOpen;
  final ValueChanged<Document> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: tone,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: context.hkc.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${documents.length}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: context.hkc.textFaint,
                  ),
                ),
              ],
            ),
          ),
          for (var index = 0; index < documents.length; index++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DocumentCard(
                document: documents[index],
                onTap: () => onOpen(documents[index]),
                onDelete: () => onDelete(documents[index]),
              ),
            ),
            if (index < documents.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 54, 18, HkFab.scrollReserve),
      child: HkCard(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: context.hkc.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.description_rounded,
                color: context.hkc.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.documentsEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.documentsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.hkc.textMuted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),
            HkButton(
              label: l10n.documentsEmptyCta,
              icon: Symbols.add_rounded,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
