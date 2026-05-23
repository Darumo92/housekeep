import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/models/item.dart';
import 'item_photo.dart';
import 'warranty_badge.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({required this.item, this.onTap, super.key});

  final Item item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailParts = <String>[
      item.category.label(l10n),
      if (item.brand case final brand?) brand,
      if (item.model case final model?) model,
    ];

    return Card(
      child: InkWell(
        key: ValueKey('item-card-${item.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemPhoto(photoPath: item.photoPath, icon: item.category.icon),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (detailParts.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        detailParts.join(' • '),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    WarrantyBadge(item: item),
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
