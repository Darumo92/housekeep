import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../domain/models/item.dart';

class WarrantyBadge extends StatelessWidget {
  const WarrantyBadge({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isActive = item.isWarrantyActive();
    final hasWarranty = item.warrantyExpiryDate != null;
    final label = hasWarranty
        ? (isActive ? l10n.itemWarrantyActive : l10n.itemWarrantyExpired)
        : l10n.itemNoWarranty;

    final (Color background, Color foreground) =
        switch ((hasWarranty, isActive)) {
      (true, true) => (
          context.hkc.okSoft,
          context.hkc.onOkSoft,
        ),
      (true, false) => (
          theme.colorScheme.errorContainer,
          theme.colorScheme.onErrorContainer,
        ),
      _ => (
          theme.colorScheme.surfaceContainerHigh,
          theme.colorScheme.onSurfaceVariant,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.m,
        vertical: Spacing.s - 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
