import 'package:flutter/material.dart';

/// HouseKeep palette — Cozy direction (redesign Phase 1).
/// See `design_handoff_redesign/DESIGN_TOKENS.md` §1.
class AppColors {
  const AppColors._();

  // Surfaces
  static const Color bg = Color(0xFFF6F1E9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFBF6EE);
  static const Color border = Color(0x1A2E7D6F);

  // Text
  static const Color text = Color(0xFF1F2624);
  static const Color textMuted = Color(0xFF6B7270);
  static const Color textFaint = Color(0xFFA4A8A4);

  // Primary (teal cálido)
  static const Color primary = Color(0xFF2E7D6F);
  static const Color primarySoft = Color(0xFFDBEAE5);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Accent (ámbar)
  static const Color accent = Color(0xFFE0913A);
  static const Color accentSoft = Color(0xFFFBE9D2);

  // Semantic (semáforo)
  static const Color ok = Color(0xFF3F9C5C);
  static const Color warn = Color(0xFFD4A017);
  static const Color danger = Color(0xFFC8513C);
  static const Color okSoft = Color(0xFFDCEFD6);
  static const Color warnSoft = Color(0xFFFCEFC8);
  static const Color dangerSoft = Color(0xFFF6DAD0);

  // Stripe del placeholder de fotos
  static const Color placeholderStripe = Color(0x0F2E7D6F);

  // Retro-compat aliases — keep widgets compiled until they migrate.
  static const Color background = bg;
  static const Color secondary = accent;
  static const Color secondaryLight = accentSoft;
  static const Color onSecondary = Colors.white;
  static const Color success = ok;
  static const Color warning = warn;
  static const Color error = danger;
  static const Color textPrimary = text;
  static const Color textSecondary = textMuted;
  static const Color textTertiary = textFaint;
  static const Color primaryLight = primarySoft;
  static const Color primaryDark = Color(0xFF1B5E50);
  static const Color surfaceVariant = surfaceAlt;
  static const Color outline = Color(0xFFB4ADA1);
  static const Color shadow = Color(0x14000000);
}

/// Status colors (success / warning) — aligned to Cozy semantic tokens.
class AppStatusColors {
  const AppStatusColors._();

  static const Color success = AppColors.ok;
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = AppColors.okSoft;
  static const Color onSuccessContainer = Color(0xFF0E2D11);

  static const Color warning = AppColors.warn;
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color warningContainer = AppColors.warnSoft;
  static const Color onWarningContainer = Color(0xFF3A1F00);
}
