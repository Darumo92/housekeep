import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';

/// Rounded-square accent FAB. See design Phase 2.10.
class HkFab extends StatelessWidget {
  const HkFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  static const double _size = 56;
  static const double _radius = AppRadii.card * 0.9;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: context.hkc.accent,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: AppShadows.fab,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 26),
    );

    final tappable = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_radius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_radius),
        child: body,
      ),
    );

    return tooltip == null
        ? tappable
        : Tooltip(message: tooltip!, child: tappable);
  }
}
