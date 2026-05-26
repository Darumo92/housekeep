import 'package:flutter/material.dart';

/// HouseKeep palette — warm sage primary + terracotta secondary.
///
/// Legacy static constants kept for compatibility with [UrgencyLevel],
/// [WarrantyBadge] and onboarding indicators. Prefer reading from
/// [ColorScheme] via `Theme.of(context)` in new code.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF2E7D6F);
  static const Color primaryLight = Color(0xFF4DA89A);
  static const Color primaryDark = Color(0xFF1B5E50);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFC47A4A);
  static const Color secondaryLight = Color(0xFFE8B493);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFCFAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF4EFE8);
  static const Color outline = Color(0xFFB4ADA1);
  static const Color shadow = Color(0x14000000);

  static const Color success = Color(0xFF2F7A3A);
  static const Color warning = Color(0xFFB5651D);
  static const Color error = Color(0xFFB3261E);

  static const Color textPrimary = Color(0xFF1B1A17);
  static const Color textSecondary = Color(0xFF5D5A52);
  static const Color textTertiary = Color(0xFF837D72);
}

/// Light Material 3 palette tokens.
class AppColorsLight {
  const AppColorsLight._();

  static const Color primary = Color(0xFF2E7D6F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFCDEAE3);
  static const Color onPrimaryContainer = Color(0xFF0E3B33);

  static const Color secondary = Color(0xFFC47A4A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFF5DCC9);
  static const Color onSecondaryContainer = Color(0xFF3A1F0E);

  static const Color tertiary = Color(0xFF6B7FB8);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFDDE4FA);
  static const Color onTertiaryContainer = Color(0xFF1A2649);

  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  static const Color background = Color(0xFFFCFAF7);
  static const Color onBackground = Color(0xFF1B1A17);
  static const Color surface = Color(0xFFFCFAF7);
  static const Color onSurface = Color(0xFF1B1A17);
  static const Color onSurfaceVariant = Color(0xFF5D5A52);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFAF6F0);
  static const Color surfaceContainer = Color(0xFFF4EFE8);
  static const Color surfaceContainerHigh = Color(0xFFEEE8DF);
  static const Color surfaceContainerHighest = Color(0xFFE8E1D6);

  static const Color outline = Color(0xFFB4ADA1);
  static const Color outlineVariant = Color(0xFFDCD6CA);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF302E2A);
  static const Color onInverseSurface = Color(0xFFF4EFE8);
  static const Color inversePrimary = Color(0xFF8FD3C3);
  static const Color surfaceTint = primary;
}

/// Dark Material 3 palette tokens.
/// Defined in advance; not yet wired in `MaterialApp.themeMode`.
/// TODO(theme): wire `themeMode` + Settings toggle in dark-mode sprint.
class AppColorsDark {
  const AppColorsDark._();

  static const Color primary = Color(0xFF8FD3C3);
  static const Color onPrimary = Color(0xFF0E3B33);
  static const Color primaryContainer = Color(0xFF1F574B);
  static const Color onPrimaryContainer = Color(0xFFCDEAE3);

  static const Color secondary = Color(0xFFE8B493);
  static const Color onSecondary = Color(0xFF3A1F0E);
  static const Color secondaryContainer = Color(0xFF6A3F22);
  static const Color onSecondaryContainer = Color(0xFFF5DCC9);

  static const Color tertiary = Color(0xFFB4C2EE);
  static const Color onTertiary = Color(0xFF1A2649);
  static const Color tertiaryContainer = Color(0xFF34487F);
  static const Color onTertiaryContainer = Color(0xFFDDE4FA);

  static const Color error = Color(0xFFF2B8B5);
  static const Color onError = Color(0xFF601410);
  static const Color errorContainer = Color(0xFF8C1D18);
  static const Color onErrorContainer = Color(0xFFF9DEDC);

  static const Color background = Color(0xFF14130F);
  static const Color onBackground = Color(0xFFECE6DA);
  static const Color surface = Color(0xFF14130F);
  static const Color onSurface = Color(0xFFECE6DA);
  static const Color onSurfaceVariant = Color(0xFFB9B3A6);

  static const Color surfaceContainerLowest = Color(0xFF0F0E0B);
  static const Color surfaceContainerLow = Color(0xFF1B1A17);
  static const Color surfaceContainer = Color(0xFF1F1E1A);
  static const Color surfaceContainerHigh = Color(0xFF2A2823);
  static const Color surfaceContainerHighest = Color(0xFF35332D);

  static const Color outline = Color(0xFF837D72);
  static const Color outlineVariant = Color(0xFF4A4740);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFFECE6DA);
  static const Color onInverseSurface = Color(0xFF302E2A);
  static const Color inversePrimary = Color(0xFF2E7D6F);
  static const Color surfaceTint = primary;
}

/// Status colors (success / warning) — not part of M3 [ColorScheme].
/// Kept stable across light/dark for semantic recognition.
class AppStatusColors {
  const AppStatusColors._();

  static const Color success = Color(0xFF2F7A3A);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFD6EFD8);
  static const Color onSuccessContainer = Color(0xFF0E2D11);

  static const Color warning = Color(0xFFB5651D);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color warningContainer = Color(0xFFF8E2C0);
  static const Color onWarningContainer = Color(0xFF3A1F00);
}
