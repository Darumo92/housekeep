import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_dimens.dart';
import '../../domain/models/upcoming_event.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/item_picker_sheet.dart';
import '../../shared/widgets/status_banner.dart';
import '../documents/documents_provider.dart';
import '../items/items_provider.dart';
import 'home_provider.dart';
import 'widgets/home_expandable_fab.dart';
import 'widgets/home_skeleton.dart';
import 'widgets/home_summary_card.dart';
import 'widgets/upcoming_event_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(homeSummaryProvider);
    final eventsAsync = ref.watch(upcomingEventsProvider());

    Future<void> addItem() async {
      final destination = await ref.read(addItemDestinationProvider.future);
      if (!context.mounted) return;
      context.push(destination);
    }

    Future<void> addDocument() async {
      final destination = await ref.read(
        addDocumentDestinationProvider.future,
      );
      if (!context.mounted) return;
      context.push(destination);
    }

    Future<void> addMaintenance() async {
      final items = await ref.read(homeItemsProvider.future);
      if (!context.mounted) return;
      if (items.isEmpty) return;
      String itemId;
      if (items.length == 1) {
        itemId = items.first.id;
      } else {
        final picked = await showItemPickerSheet(
          context,
          items: items,
          title: l10n.homeAddMaintenancePickItemTitle,
        );
        if (picked == null || !context.mounted) return;
        itemId = picked;
      }
      context.push('/items/$itemId/maintenance/add');
    }

    void openEvent(UpcomingEvent event) {
      switch (event.type) {
        case UpcomingEventType.maintenance:
        case UpcomingEventType.warranty:
          final itemId = event.relatedItemId;
          if (itemId != null) {
            context.push('/items/$itemId');
          }
          break;
        case UpcomingEventType.document:
          final docId = event.relatedItemId;
          if (docId != null) {
            context.push('/documents/$docId/edit');
          }
          break;
      }
    }

    final summary = summaryAsync.valueOrNull;
    final hasNoData = summary != null &&
        summary.totalItems == 0 &&
        summary.totalDocuments == 0 &&
        summary.totalMaintenances == 0;

    final canShowMaintenance = (summary?.totalItems ?? 0) > 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: HomeExpandableFab(
        onAddItem: addItem,
        onAddMaintenance: canShowMaintenance ? addMaintenance : null,
        onAddDocument: addDocument,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeItemsProvider);
          ref.invalidate(homeUpcomingMaintenancesProvider);
          ref.invalidate(homeExpiringDocumentsProvider);
          await Future<void>.delayed(const Duration(milliseconds: 250));
        },
        child: summaryAsync.when(
          loading: () => const HomeSkeleton(),
          error: (error, _) => ErrorState(
            onRetry: () => ref.invalidate(homeSummaryProvider),
          ),
          data: (summary) {
            if (hasNoData) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 80),
                children: [
                  EmptyState(
                    icon: Icons.home_outlined,
                    title: l10n.homeEmptyTitle,
                    body: l10n.homeEmptyBody,
                    actionLabel: l10n.homeEmptyCta,
                    onAction: addItem,
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.l,
                Spacing.l,
                Spacing.l,
                96,
              ),
              children: [
                HomeSummaryCard(summary: summary),
                const SizedBox(height: Spacing.xl),
                if (summary.isAllClear) ...[
                  StatusBanner(
                    variant: StatusBannerVariant.success,
                    title: l10n.homeAllClearTitle,
                    body: l10n.homeAllClearBody,
                  ),
                  const SizedBox(height: Spacing.l),
                ],
                Text(
                  l10n.homeTimelineTitle,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: Spacing.m),
                _EventsList(eventsAsync: eventsAsync, onTap: openEvent),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  const _EventsList({required this.eventsAsync, required this.onTap});

  final AsyncValue<List<UpcomingEvent>> eventsAsync;
  final ValueChanged<UpcomingEvent> onTap;

  @override
  Widget build(BuildContext context) {
    return eventsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => const ErrorState(compact: true),
      data: (events) {
        if (events.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            for (final event in events)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: UpcomingEventCard(
                  event: event,
                  onTap: () => onTap(event),
                ),
              ),
          ],
        );
      },
    );
  }
}

