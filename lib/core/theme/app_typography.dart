import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale for the Cozy redesign (Phase 1).
/// Inter for everything; JetBrains Mono for technical numerals.
/// See `design_handoff_redesign/DESIGN_TOKENS.md` §2.
class AppTypography {
  const AppTypography._();

  /// Build a complete [TextTheme] tinted by the active [ColorScheme].
  static TextTheme build(ColorScheme cs) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -0.6,
        color: cs.onSurface,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -0.5,
        color: cs.onSurface,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: -0.4,
        color: cs.onSurface,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.3,
        color: cs.onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.2,
        color: cs.onSurface,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.2,
        color: cs.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: cs.onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: cs.onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: cs.onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: cs.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: cs.onSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: cs.onSurface,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: cs.onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
        color: cs.onSurface,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.3,
        color: cs.onSurface,
      ),
    );
  }

  /// JetBrains Mono for dates, technical numerals, and counters ("3 / 5").
  static TextStyle mono(double size, Color color) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: color, height: 1.3);
}
