import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/enums/urgency_level.dart';
import '../../../domain/models/upcoming_event.dart';

class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final UpcomingEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final daysUntilDue = event.daysUntilDue(now: now);
    final formatter = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );

    final typeLabel = switch (event.type) {
      UpcomingEventType.maintenance => l10n.homeEventMaintenance,
      UpcomingEventType.document => l10n.homeEventDocument,
      UpcomingEventType.warranty => l10n.homeEventWarranty,
    };
    final dueLabel = switch (event.urgency) {
      UrgencyLevel.overdue => l10n.homeEventOverdueBy(daysUntilDue.abs()),
      _ when daysUntilDue == 0 => l10n.homeEventDueToday,
      _ => l10n.homeEventDueIn(daysUntilDue),
    };
    final typeIcon = switch (event.type) {
      UpcomingEventType.maintenance => Icons.build_outlined,
      UpcomingEventType.document => Icons.description_outlined,
      UpcomingEventType.warranty => Icons.verified_outlined,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: event.urgency.color(context).withValues(alpha: 0.16),
                child: Icon(typeIcon, color: event.urgency.color(context)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (event.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        event.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      dueLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: event.urgency.color(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      formatter.format(event.dueDate),
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
