import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/repository_providers.dart' show isProProvider;
import '../../domain/enums/urgency_level.dart';
import '../../domain/models/upcoming_event.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/hk_fab.dart';
import 'home_provider.dart';
import 'widgets/home_redesign_widgets.dart';
import 'widgets/home_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summaryAsync = ref.watch(homeSummaryProvider);
    final eventsAsync = ref.watch(upcomingEventsProvider(limit: 6));
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;

    Future<void> addItem() async => context.push('/items/add');

    void openEvent(UpcomingEvent event) {
      switch (event.type) {
        case UpcomingEventType.maintenance:
        case UpcomingEventType.warranty:
          final itemId = event.relatedItemId;
          if (itemId != null) context.push('/items/$itemId');
          break;
        case UpcomingEventType.document:
          final docId = event.relatedItemId;
          if (docId != null) context.push('/documents/$docId/edit');
          break;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 4),
        child: HkFab(
          icon: Symbols.add_rounded,
          onPressed: addItem,
          tooltip: l10n.homeEmptyCta,
        ),
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
            final isEmpty = summary.totalItems == 0 &&
                summary.totalDocuments == 0 &&
                summary.totalMaintenances == 0;
            if (isEmpty) return HomeEmptyState(onAdd: addItem);

            final events =
                eventsAsync.valueOrNull ?? const <UpcomingEvent>[];
            final due = events
                .where((e) =>
                    e.urgency == UrgencyLevel.overdue ||
                    e.urgency == UrgencyLevel.urgent)
                .length;
            final soon = events
                .where((e) => e.urgency == UrgencyLevel.upcoming)
                .length;
            final total =
                summary.totalMaintenances + summary.totalDocuments;
            final ok = (total - due - soon).clamp(0, total);

            final greeting = _greeting(l10n);
            final userName = l10n.homeFallbackName;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                GreetingHeader(
                  greeting: greeting,
                  userName: userName,
                  subtitle: l10n.homeSubtitle,
                ),
                SummaryTriplet(due: due, soon: soon, ok: ok),
                TimelineSectionHeader(
                  onSeeAll: events.isEmpty
                      ? null
                      : () => context.push('/items'),
                ),
                if (events.isEmpty)
                  const SizedBox(height: 8)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        for (final event in events)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TimelineRow(
                              event: event,
                              onTap: () => openEvent(event),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (!isPro) ...[
                  const SizedBox(height: 16),
                  ProUpsellCard(onTap: () => context.push('/paywall')),
                ],
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  String _greeting(AppLocalizations l10n) {
    final h = DateTime.now().hour;
    if (h < 12) return l10n.homeGreetingMorning;
    if (h < 20) return l10n.homeGreetingAfternoon;
    return l10n.homeGreetingEvening;
  }
}
