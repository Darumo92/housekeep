import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../domain/enums/urgency_level.dart';
import '../../../domain/models/upcoming_event.dart';
import '../../../shared/widgets/hk_button.dart';
import '../../../shared/widgets/hk_card.dart';
import '../../../shared/widgets/hk_category_tile.dart';
import '../../../shared/widgets/hk_chip.dart' show HkTone;
import '../../../shared/widgets/hk_status_pill.dart';
import '../../../shared/widgets/hk_summary_stat.dart';
import '../../onboarding/widgets/onboarding_art.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.greeting,
    required this.userName,
    required this.subtitle,
  });

  final String greeting;
  final String userName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = userName.isEmpty ? '?' : userName.characters.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial.toUpperCase(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryTriplet extends StatelessWidget {
  const SummaryTriplet({
    super.key,
    required this.due,
    required this.soon,
    required this.ok,
  });

  final int due;
  final int soon;
  final int ok;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: HkSummaryStat(
              count: due,
              label: l10n.homeSummaryDue,
              tone: HkTone.danger,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: HkSummaryStat(
              count: soon,
              label: l10n.homeSummarySoon,
              tone: HkTone.warn,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: HkSummaryStat(
              count: ok,
              label: l10n.homeSummaryOk,
              tone: HkTone.ok,
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineSectionHeader extends StatelessWidget {
  const TimelineSectionHeader({super.key, required this.onSeeAll});

  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              l10n.homeTimelineTitle,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                minimumSize: const Size(0, 36),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.homeSeeAll,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Symbols.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class TimelineRow extends StatelessWidget {
  const TimelineRow({super.key, required this.event, required this.onTap});

  final UpcomingEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = event.daysUntilDue();
    return HkCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          _leading(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (event.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    event.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          HkStatusPill(
            status: _pillStatus(event.urgency),
            label: shortDayLabel(AppLocalizations.of(context), days),
          ),
        ],
      ),
    );
  }

  Widget _leading() {
    final category = event.category;
    if (event.type == UpcomingEventType.document) {
      final icon = event.documentType?.icon ?? Symbols.description_rounded;
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppRadii.tile),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: AppColors.primary),
      );
    }
    if (category == null) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadii.tile),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Symbols.build_rounded,
          size: 22,
          color: AppColors.textMuted,
        ),
      );
    }
    return HkCategoryTile(category: category, size: 44);
  }

  static HkStatus _pillStatus(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.overdue:
        return HkStatus.overdue;
      case UrgencyLevel.urgent:
        return HkStatus.due;
      case UrgencyLevel.upcoming:
        return HkStatus.soon;
      case UrgencyLevel.ok:
        return HkStatus.ok;
    }
  }
}

String shortDayLabel(AppLocalizations l10n, int days) {
  if (days == 0) return l10n.homeShortDayToday;
  if (days == 1) return l10n.homeShortDayTomorrow;
  if (days > 1) return l10n.homeShortDayIn(days);
  if (days == -1) return l10n.homeShortDayYesterday;
  return l10n.homeShortDayAgo(-days);
}

class ProUpsellCard extends StatelessWidget {
  const ProUpsellCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.85),
                  AppColors.accent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(AppRadii.card),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Symbols.auto_awesome_rounded,
                    size: 22,
                    color: Colors.white,
                    fill: 1,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.homeProUpsellTitle,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.homeProUpsellSub,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadii.btn),
                  ),
                  child: Text(
                    l10n.homeProUpsellCta,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 100),
      children: [
        const Center(child: OnboardingArtHomeCluster()),
        const SizedBox(height: 24),
        Text(
          l10n.homeEmptyTitle,
          style: theme.textTheme.displaySmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.homeEmptyBody,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HkButton(
              label: l10n.homeEmptyCta,
              icon: Symbols.add_rounded,
              size: HkButtonSize.lg,
              onPressed: onAdd,
            ),
          ],
        ),
      ],
    );
  }
}
