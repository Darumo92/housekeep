import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

enum HkStatus { overdue, due, soon, ok }

/// Status pill with a colored dot. See design Phase 2.4.
class HkStatusPill extends StatelessWidget {
  const HkStatusPill({
    super.key,
    required this.status,
    required this.label,
  });

  final HkStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: palette.bg,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: palette.fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: palette.fg,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  static _StatusPalette _palette(HkStatus status) {
    switch (status) {
      case HkStatus.overdue:
      case HkStatus.due:
        return const _StatusPalette(AppColors.dangerSoft, AppColors.danger);
      case HkStatus.soon:
        return const _StatusPalette(AppColors.warnSoft, AppColors.warn);
      case HkStatus.ok:
        return const _StatusPalette(AppColors.okSoft, AppColors.ok);
    }
  }
}

class _StatusPalette {
  const _StatusPalette(this.bg, this.fg);
  final Color bg;
  final Color fg;
}
