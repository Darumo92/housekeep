import 'package:flutter/material.dart';

/// Elevation tokens for the Cozy redesign (Phase 1).
/// See `design_handoff_redesign/DESIGN_TOKENS.md` §4.
class AppShadows {
  const AppShadows._();

  /// Soft, primary-tinted shadow used on default cards.
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: Color(0x05000000), offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F2E7D6F), offset: Offset(0, 2), blurRadius: 8),
  ];

  /// Stronger shadow for the floating action button.
  static const List<BoxShadow> fab = <BoxShadow>[
    BoxShadow(color: Color(0x2E000000), offset: Offset(0, 8), blurRadius: 24),
  ];
}
