import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../home_provider.dart';

class HomeSummaryCard extends StatelessWidget {
  const HomeSummaryCard({super.key, required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = summary.overallUrgency.color;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusDot(
                  color: color,
                  semanticLabel: summary.overallUrgency.label(l10n),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.homeSummaryTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.homeSummarySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _SummaryRow(
              icon: Icons.kitchen_outlined,
              count: summary.totalItems,
              labelBuilder: l10n.homeSummaryItems,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              icon: Icons.build_outlined,
              count: summary.pendingMaintenances,
              labelBuilder: l10n.homeSummaryPendingMaintenances,
              accentColor: summary.pendingMaintenances > 0 ? color : null,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              icon: Icons.description_outlined,
              count: summary.urgentDocuments,
              labelBuilder: l10n.homeSummaryUrgentDocuments,
              accentColor: summary.urgentDocuments > 0 ? color : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.count,
    required this.labelBuilder,
    this.accentColor,
  });

  final IconData icon;
  final int count;
  final String Function(int) labelBuilder;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Theme.of(context).colorScheme.onSurface;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight:
              accentColor == null ? FontWeight.normal : FontWeight.w600,
        );
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: TweenAnimationBuilder<int>(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            tween: IntTween(begin: 0, end: count),
            builder: (context, value, _) =>
                Text(labelBuilder(value), style: style),
          ),
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color, required this.semanticLabel});

  final Color color;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
