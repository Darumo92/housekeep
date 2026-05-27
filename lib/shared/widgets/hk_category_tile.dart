import 'package:flutter/material.dart';

import '../../core/theme/app_category_palette.dart';
import '../../core/theme/app_radii.dart';
import '../../domain/enums/item_category.dart';

/// Rounded square tile for a category icon. See design Phase 2.5.
class HkCategoryTile extends StatelessWidget {
  const HkCategoryTile({
    super.key,
    required this.category,
    this.size = 44,
  });

  final ItemCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = AppCategoryPalette.of(category);
    final iconSize = size >= 60 ? 30.0 : (size >= 56 ? 26.0 : 22.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: palette.bg,
        borderRadius: BorderRadius.circular(AppRadii.tile),
      ),
      alignment: Alignment.center,
      child: Icon(category.icon, size: iconSize, color: palette.fg),
    );
  }
}
