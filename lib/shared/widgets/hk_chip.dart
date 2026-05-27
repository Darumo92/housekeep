import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

enum HkTone { primary, accent, ok, warn, danger }

/// Filter chip / status pill. See design Phase 2.3.
class HkChip extends StatelessWidget {
  const HkChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
    this.tone = HkTone.primary,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;
  final HkTone tone;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(tone);
    final bg = active ? palette.fg : palette.bg;
    final fg = active ? Colors.white : palette.fg;

    final body = Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: fg,
          height: 1.1,
        ),
      ),
    );

    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: body,
      ),
    );
  }

  static _TonePalette _palette(HkTone tone) {
    switch (tone) {
      case HkTone.primary:
        return const _TonePalette(AppColors.primarySoft, AppColors.primary);
      case HkTone.accent:
        return const _TonePalette(AppColors.accentSoft, AppColors.accent);
      case HkTone.ok:
        return const _TonePalette(AppColors.okSoft, AppColors.ok);
      case HkTone.warn:
        return const _TonePalette(AppColors.warnSoft, AppColors.warn);
      case HkTone.danger:
        return const _TonePalette(AppColors.dangerSoft, AppColors.danger);
    }
  }
}

class _TonePalette {
  const _TonePalette(this.bg, this.fg);
  final Color bg;
  final Color fg;
}
