import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/item.dart';

class WarrantyBadge extends StatelessWidget {
  const WarrantyBadge({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isActive = item.isWarrantyActive();
    final hasWarranty = item.warrantyExpiryDate != null;
    final label = hasWarranty
        ? (isActive ? l10n.itemWarrantyActive : l10n.itemWarrantyExpired)
        : l10n.itemNoWarranty;
    final color = hasWarranty
        ? (isActive ? AppColors.success : AppColors.error)
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
