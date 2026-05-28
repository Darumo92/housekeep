import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/date_calculations.dart';
import '../../../domain/models/document.dart';
import '../../../shared/widgets/hk_action_sheet.dart';
import '../../../shared/widgets/hk_card.dart';
import '../../../shared/widgets/hk_status_pill.dart';

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
    final daysUntilExpiry = DateCalculations.calendarDaysUntil(
      document.expiryDate,
      now,
    );
    final status = switch (daysUntilExpiry) {
      < 0 => HkStatus.overdue,
      <= 30 => HkStatus.due,
      <= 90 => HkStatus.soon,
      _ => HkStatus.ok,
    };
    final statusLabel = switch (daysUntilExpiry) {
      < 0 => l10n.homeShortDayAgo(daysUntilExpiry.abs()),
      0 => l10n.homeShortDayToday,
      _ => l10n.homeShortDayIn(daysUntilExpiry),
    };

    return HkCard(
      key: ValueKey('document-card-${document.id}'),
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadii.card * .5),
            ),
            alignment: Alignment.center,
            child: Icon(document.type.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(document.expiryDate),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          HkStatusPill(status: status, label: statusLabel),
          IconButton(
            icon: const Icon(
              Symbols.more_vert_rounded,
              color: AppColors.textFaint,
            ),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 34, minHeight: 44),
            onPressed: () => _showActions(context, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _showActions(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final selected = await showHkActionSheet(
      context,
      title: document.name,
      actions: [
        HkSheetAction(icon: Symbols.edit_rounded, label: l10n.documentEdit),
        HkSheetAction(
          icon: Symbols.delete_outline_rounded,
          label: l10n.documentDelete,
          destructive: true,
        ),
      ],
    );
    switch (selected) {
      case 0:
        onTap();
        break;
      case 1:
        onDelete();
        break;
    }
  }
}
