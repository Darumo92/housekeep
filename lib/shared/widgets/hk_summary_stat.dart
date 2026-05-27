import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import 'hk_chip.dart' show HkTone;

/// Small stat card: colored dot + number + label. See design Phase 2.11.
class HkSummaryStat extends StatelessWidget {
  const HkSummaryStat({
    super.key,
    required this.count,
    required this.label,
    required this.tone,
  });

  final int count;
  final String label;
  final HkTone tone;

  @override
  Widget build(BuildContext context) {
    final dotColor = _toneColor(tone);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card * 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(animation);
              return ClipRect(
                child: FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                ),
              );
            },
            child: Text(
              '$count',
              key: ValueKey<int>(count),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
                height: 1.05,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  static Color _toneColor(HkTone tone) {
    switch (tone) {
      case HkTone.primary:
        return AppColors.primary;
      case HkTone.accent:
        return AppColors.accent;
      case HkTone.ok:
        return AppColors.ok;
      case HkTone.warn:
        return AppColors.warn;
      case HkTone.danger:
        return AppColors.danger;
    }
  }
}
