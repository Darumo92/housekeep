import 'package:flutter/material.dart';

import '../../domain/enums/item_category.dart';

/// Per-category bg/fg pair used by `HkCategoryTile`.
/// See `design_handoff_redesign/phases/phase_2_shared_components.md` §2.5.
class AppCategoryPalette {
  const AppCategoryPalette._();

  static const Color _generalBg = Color(0xFFF1D7E4);
  static const Color _generalFg = Color(0xFF7C2D58);

  static const Map<ItemCategory, ({Color bg, Color fg})> entries = {
    ItemCategory.kitchen: (bg: Color(0xFFFCE9D8), fg: Color(0xFF8A5728)),
    ItemCategory.bathroom: (bg: Color(0xFFD7E7F3), fg: Color(0xFF28567F)),
    ItemCategory.laundry: (bg: Color(0xFFE2D9F1), fg: Color(0xFF4B3A82)),
    ItemCategory.living: (bg: Color(0xFFD6EBE6), fg: Color(0xFF1F6A5E)),
    ItemCategory.bedroom: (bg: Color(0xFFEEDDE9), fg: Color(0xFF6B2B5C)),
    ItemCategory.garden: (bg: Color(0xFFD9ECCE), fg: Color(0xFF3D7128)),
    ItemCategory.garage: (bg: Color(0xFFFBE6BA), fg: Color(0xFF7A5613)),
    ItemCategory.plumbing: (bg: Color(0xFFCFE5EE), fg: Color(0xFF1F5468)),
    ItemCategory.electrical: (bg: Color(0xFFFCE3C0), fg: Color(0xFF7A4C0E)),
    ItemCategory.security: (bg: Color(0xFFE0DFD2), fg: Color(0xFF5E5A3D)),
    ItemCategory.general: (bg: _generalBg, fg: _generalFg),
  };

  static ({Color bg, Color fg}) of(ItemCategory category) =>
      entries[category] ?? const (bg: _generalBg, fg: _generalFg);
}
