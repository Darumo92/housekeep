import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

enum HkButtonVariant { primary, accent, soft, outline, ghost }

enum HkButtonSize { sm, md, lg }

/// Reusable button with brand variants and sizes. See design Phase 2.2.
class HkButton extends StatelessWidget {
  const HkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = HkButtonVariant.primary,
    this.size = HkButtonSize.md,
    this.full = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final HkButtonVariant variant;
  final HkButtonSize size;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors();
    final dims = _resolveDimensions();

    final row = Row(
      mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: dims.iconSize, color: colors.foreground),
          SizedBox(width: dims.gap),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: dims.fontSize,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
              height: 1.1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final inner = Container(
      constraints: BoxConstraints(minHeight: dims.minHeight),
      padding: EdgeInsets.symmetric(
        horizontal: dims.padH,
        vertical: dims.padV,
      ),
      alignment: Alignment.center,
      child: row,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.btn),
      side: colors.border != null
          ? BorderSide(color: colors.border!, width: 1)
          : BorderSide.none,
    );

    final material = Material(
      color: colors.background,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadii.btn),
        child: inner,
      ),
    );

    if (full) return SizedBox(width: double.infinity, child: material);
    return material;
  }

  _ButtonColors _resolveColors() {
    switch (variant) {
      case HkButtonVariant.primary:
        return const _ButtonColors(
          background: AppColors.primary,
          foreground: AppColors.onPrimary,
        );
      case HkButtonVariant.accent:
        return const _ButtonColors(
          background: AppColors.accent,
          foreground: Colors.white,
        );
      case HkButtonVariant.soft:
        return const _ButtonColors(
          background: AppColors.primarySoft,
          foreground: AppColors.primary,
        );
      case HkButtonVariant.outline:
        return const _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.text,
          border: AppColors.border,
        );
      case HkButtonVariant.ghost:
        return const _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.text,
        );
    }
  }

  _ButtonDims _resolveDimensions() {
    switch (size) {
      case HkButtonSize.sm:
        return const _ButtonDims(
          padH: 14,
          padV: 8,
          fontSize: 13,
          iconSize: 16,
          gap: 6,
          minHeight: 44,
        );
      case HkButtonSize.md:
        return const _ButtonDims(
          padH: 18,
          padV: 13,
          fontSize: 14.5,
          iconSize: 18,
          gap: 8,
          minHeight: 48,
        );
      case HkButtonSize.lg:
        return const _ButtonDims(
          padH: 22,
          padV: 16,
          fontSize: 16,
          iconSize: 20,
          gap: 10,
          minHeight: 54,
        );
    }
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}

class _ButtonDims {
  const _ButtonDims({
    required this.padH,
    required this.padV,
    required this.fontSize,
    required this.iconSize,
    required this.gap,
    required this.minHeight,
  });

  final double padH;
  final double padV;
  final double fontSize;
  final double iconSize;
  final double gap;
  final double minHeight;
}
