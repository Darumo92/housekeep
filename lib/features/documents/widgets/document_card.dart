import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/utils/date_calculations.dart';
import '../../../domain/enums/urgency_level.dart';
import '../../../domain/models/document.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    required this.onDelete,
  });

  final Document document;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final urgency = document.urgencyLevel(now: now);
    final daysUntilExpiry = DateCalculations.calendarDaysUntil(
      document.expiryDate,
      now,
    );

    final expiryLabel = switch (urgency) {
      UrgencyLevel.overdue => l10n.documentExpiredAgo(daysUntilExpiry.abs()),
      _ when daysUntilExpiry == 0 => l10n.documentExpiresToday,
      _ => l10n.documentExpiryIn(daysUntilExpiry),
    };

    final formatter = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('document-card-${document.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: urgency.color.withValues(alpha: 0.16),
                child: Icon(document.type.icon, color: urgency.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.type.label(l10n),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expiryLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: urgency.color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatter.format(document.expiryDate),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_CardAction>(
                onSelected: (action) {
                  switch (action) {
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
                    value: _CardAction.edit,
                    child: Text(l10n.documentEdit),
                  ),
                  PopupMenuItem(
                    value: _CardAction.delete,
                    child: Text(l10n.documentDelete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _CardAction { edit, delete }
