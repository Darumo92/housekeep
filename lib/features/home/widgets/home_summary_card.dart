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
                _StatusDot(color: color),
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
              label: l10n.homeSummaryItems(summary.totalItems),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              icon: Icons.build_outlined,
              label: l10n.homeSummaryPendingMaintenances(
                summary.pendingMaintenances,
              ),
              accentColor: summary.pendingMaintenances > 0 ? color : null,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              icon: Icons.description_outlined,
              label: l10n.homeSummaryUrgentDocuments(summary.urgentDocuments),
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
    required this.label,
    this.accentColor,
  });

  final IconData icon;
  final String label;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: accentColor == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
