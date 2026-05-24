import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/utils/date_calculations.dart';
import '../../../domain/enums/urgency_level.dart';
import '../../../domain/models/maintenance.dart';

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
    required this.maintenance,
    required this.onTap,
    required this.onMarkDone,
    required this.onDelete,
  });

  final Maintenance maintenance;
  final VoidCallback onTap;
  final VoidCallback onMarkDone;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final urgency = maintenance.urgencyLevel(now: now);
    final daysUntilDue = DateCalculations.calendarDaysUntil(
      maintenance.nextDueAt,
      now,
    );

    final dueLabel = switch (urgency) {
      UrgencyLevel.overdue =>
        l10n.maintenanceOverdueBy(daysUntilDue.abs()),
      _ when daysUntilDue == 0 => l10n.maintenanceDoneToday,
      _ => l10n.maintenanceNextDueIn(daysUntilDue),
    };

    final formatter = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final lastDoneLabel = maintenance.lastDoneAt == null
        ? l10n.maintenanceLastDoneNeverShort
        : l10n.maintenanceHistoryTitle(
            formatter.format(maintenance.lastDoneAt!),
          );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _UrgencyDot(color: urgency.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      maintenance.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  PopupMenuButton<_CardAction>(
                    onSelected: (action) {
                      switch (action) {
                        case _CardAction.markDone:
                          onMarkDone();
                          break;
                        case _CardAction.edit:
                          onTap();
                          break;
                        case _CardAction.delete:
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _CardAction.markDone,
                        child: Text(l10n.maintenanceMarkDone),
                      ),
                      PopupMenuItem(
                        value: _CardAction.edit,
                        child: Text(l10n.maintenanceEdit),
                      ),
                      PopupMenuItem(
                        value: _CardAction.delete,
                        child: Text(l10n.maintenanceDelete),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dueLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: urgency.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.maintenanceIntervalMonths(
                        maintenance.intervalMonths,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastDoneLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _CardAction { markDone, edit, delete }

class _UrgencyDot extends StatelessWidget {
  const _UrgencyDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
