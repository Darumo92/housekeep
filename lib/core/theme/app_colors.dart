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

/// Dark palette tokens — warm charcoal companion to the Cozy light theme.
class AppColorsDark {
  const AppColorsDark._();

  // Surfaces
  static const Color bg = Color(0xFF14130F);
  static const Color surface = Color(0xFF1F1D18);
  static const Color surfaceAlt = Color(0xFF27241E);
  static const Color border = Color(0x24FFFFFF);

  // Text
  static const Color text = Color(0xFFF1ECE3);
  static const Color textMuted = Color(0xFFAFA99E);
  static const Color textFaint = Color(0xFF75716A);

  // Primary (teal cálido, aclarado para contraste en oscuro)
  static const Color primary = Color(0xFF5BC0AE);
  static const Color primarySoft = Color(0xFF1E3E38);
  static const Color onPrimary = Color(0xFF04231E);

  // Accent (ámbar)
  static const Color accent = Color(0xFFEBA45A);
  static const Color accentSoft = Color(0xFF3A2C18);
  static const Color onAccent = Color(0xFF2A1D06);

  // Semantic (semáforo, aclarado)
  static const Color ok = Color(0xFF67C784);
  static const Color warn = Color(0xFFE0C05C);
  static const Color danger = Color(0xFFE58367);
  static const Color okSoft = Color(0xFF1E3626);
  static const Color warnSoft = Color(0xFF373016);
  static const Color dangerSoft = Color(0xFF3E241C);
  static const Color onOkSoft = Color(0xFFCDEBD3);
  static const Color onWarnSoft = Color(0xFFF3E4B0);

  static const Color placeholderStripe = Color(0x0FFFFFFF);
  static const Color outline = Color(0xFF5A615E);
  static const Color primaryDark = Color(0xFF8FE0D1);
  static const Color shadow = Color(0x33000000);
}

/// Theme-aware semantic palette. Resolved via [BuildContext.hkc] so widgets
/// automatically flip between light and dark. All Cozy tokens live here.
@immutable
class HkColors extends ThemeExtension<HkColors> {
  const HkColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.primary,
    required this.primarySoft,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.ok,
    required this.warn,
    required this.danger,
    required this.okSoft,
    required this.warnSoft,
    required this.dangerSoft,
    required this.onOkSoft,
    required this.onWarnSoft,
    required this.placeholderStripe,
    required this.outline,
    required this.primaryDark,
    required this.shadow,
  });

  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color primary;
  final Color primarySoft;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color ok;
  final Color warn;
  final Color danger;
  final Color okSoft;
  final Color warnSoft;
  final Color dangerSoft;
  final Color onOkSoft;
  final Color onWarnSoft;
  final Color placeholderStripe;
  final Color outline;
  final Color primaryDark;
  final Color shadow;

  // Semantic aliases (retro-compat with old AppColors names).
  Color get success => ok;
  Color get warning => warn;
  Color get error => danger;

  static const HkColors light = HkColors(
    bg: AppColors.bg,
    surface: AppColors.surface,
    surfaceAlt: AppColors.surfaceAlt,
    border: AppColors.border,
    text: AppColors.text,
    textMuted: AppColors.textMuted,
    textFaint: AppColors.textFaint,
    primary: AppColors.primary,
    primarySoft: AppColors.primarySoft,
    onPrimary: AppColors.onPrimary,
    accent: AppColors.accent,
    accentSoft: AppColors.accentSoft,
    onAccent: Colors.white,
    ok: AppColors.ok,
    warn: AppColors.warn,
    danger: AppColors.danger,
    okSoft: AppColors.okSoft,
    warnSoft: AppColors.warnSoft,
    dangerSoft: AppColors.dangerSoft,
    onOkSoft: AppStatusColors.onSuccessContainer,
    onWarnSoft: AppStatusColors.onWarningContainer,
    placeholderStripe: AppColors.placeholderStripe,
    outline: AppColors.outline,
    primaryDark: AppColors.primaryDark,
    shadow: AppColors.shadow,
  );

  static const HkColors dark = HkColors(
    bg: AppColorsDark.bg,
    surface: AppColorsDark.surface,
    surfaceAlt: AppColorsDark.surfaceAlt,
    border: AppColorsDark.border,
    text: AppColorsDark.text,
    textMuted: AppColorsDark.textMuted,
    textFaint: AppColorsDark.textFaint,
    primary: AppColorsDark.primary,
    primarySoft: AppColorsDark.primarySoft,
    onPrimary: AppColorsDark.onPrimary,
    accent: AppColorsDark.accent,
    accentSoft: AppColorsDark.accentSoft,
    onAccent: AppColorsDark.onAccent,
    ok: AppColorsDark.ok,
    warn: AppColorsDark.warn,
    danger: AppColorsDark.danger,
    okSoft: AppColorsDark.okSoft,
    warnSoft: AppColorsDark.warnSoft,
    dangerSoft: AppColorsDark.dangerSoft,
    onOkSoft: AppColorsDark.onOkSoft,
    onWarnSoft: AppColorsDark.onWarnSoft,
    placeholderStripe: AppColorsDark.placeholderStripe,
    outline: AppColorsDark.outline,
    primaryDark: AppColorsDark.primaryDark,
    shadow: AppColorsDark.shadow,
  );

  @override
  HkColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? primary,
    Color? primarySoft,
    Color? onPrimary,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? ok,
    Color? warn,
    Color? danger,
    Color? okSoft,
    Color? warnSoft,
    Color? dangerSoft,
    Color? onOkSoft,
    Color? onWarnSoft,
    Color? placeholderStripe,
    Color? outline,
    Color? primaryDark,
    Color? shadow,
  }) {
    return HkColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      ok: ok ?? this.ok,
      warn: warn ?? this.warn,
      danger: danger ?? this.danger,
      okSoft: okSoft ?? this.okSoft,
      warnSoft: warnSoft ?? this.warnSoft,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      onOkSoft: onOkSoft ?? this.onOkSoft,
      onWarnSoft: onWarnSoft ?? this.onWarnSoft,
      placeholderStripe: placeholderStripe ?? this.placeholderStripe,
      outline: outline ?? this.outline,
      primaryDark: primaryDark ?? this.primaryDark,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  HkColors lerp(ThemeExtension<HkColors>? other, double t) {
    if (other is! HkColors) return this;
    return HkColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      ok: Color.lerp(ok, other.ok, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      okSoft: Color.lerp(okSoft, other.okSoft, t)!,
      warnSoft: Color.lerp(warnSoft, other.warnSoft, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      onOkSoft: Color.lerp(onOkSoft, other.onOkSoft, t)!,
      onWarnSoft: Color.lerp(onWarnSoft, other.onWarnSoft, t)!,
      placeholderStripe:
          Color.lerp(placeholderStripe, other.placeholderStripe, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Access the active [HkColors] palette. Falls back to light if unregistered.
extension HkColorsContext on BuildContext {
  HkColors get hkc =>
      Theme.of(this).extension<HkColors>() ?? HkColors.light;
}
