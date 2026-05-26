import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(_lightScheme(), Brightness.light);

  /// Dark theme is fully defined but not yet wired in `MaterialApp.themeMode`.
  /// TODO(theme): expose via Settings toggle in dark-mode sprint.
  static ThemeData dark() => _build(_darkScheme(), Brightness.dark);

  static ColorScheme _lightScheme() => const ColorScheme(
        brightness: Brightness.light,
        primary: AppColorsLight.primary,
        onPrimary: AppColorsLight.onPrimary,
        primaryContainer: AppColorsLight.primaryContainer,
        onPrimaryContainer: AppColorsLight.onPrimaryContainer,
        secondary: AppColorsLight.secondary,
        onSecondary: AppColorsLight.onSecondary,
        secondaryContainer: AppColorsLight.secondaryContainer,
        onSecondaryContainer: AppColorsLight.onSecondaryContainer,
        tertiary: AppColorsLight.tertiary,
        onTertiary: AppColorsLight.onTertiary,
        tertiaryContainer: AppColorsLight.tertiaryContainer,
        onTertiaryContainer: AppColorsLight.onTertiaryContainer,
        error: AppColorsLight.error,
        onError: AppColorsLight.onError,
        errorContainer: AppColorsLight.errorContainer,
        onErrorContainer: AppColorsLight.onErrorContainer,
        surface: AppColorsLight.surface,
        onSurface: AppColorsLight.onSurface,
        onSurfaceVariant: AppColorsLight.onSurfaceVariant,
        surfaceContainerLowest: AppColorsLight.surfaceContainerLowest,
        surfaceContainerLow: AppColorsLight.surfaceContainerLow,
        surfaceContainer: AppColorsLight.surfaceContainer,
        surfaceContainerHigh: AppColorsLight.surfaceContainerHigh,
        surfaceContainerHighest: AppColorsLight.surfaceContainerHighest,
        outline: AppColorsLight.outline,
        outlineVariant: AppColorsLight.outlineVariant,
        shadow: AppColorsLight.shadow,
        scrim: AppColorsLight.scrim,
        inverseSurface: AppColorsLight.inverseSurface,
        onInverseSurface: AppColorsLight.onInverseSurface,
        inversePrimary: AppColorsLight.inversePrimary,
        surfaceTint: AppColorsLight.surfaceTint,
      );

  static ColorScheme _darkScheme() => const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColorsDark.primary,
        onPrimary: AppColorsDark.onPrimary,
        primaryContainer: AppColorsDark.primaryContainer,
        onPrimaryContainer: AppColorsDark.onPrimaryContainer,
        secondary: AppColorsDark.secondary,
        onSecondary: AppColorsDark.onSecondary,
        secondaryContainer: AppColorsDark.secondaryContainer,
        onSecondaryContainer: AppColorsDark.onSecondaryContainer,
        tertiary: AppColorsDark.tertiary,
        onTertiary: AppColorsDark.onTertiary,
        tertiaryContainer: AppColorsDark.tertiaryContainer,
        onTertiaryContainer: AppColorsDark.onTertiaryContainer,
        error: AppColorsDark.error,
        onError: AppColorsDark.onError,
        errorContainer: AppColorsDark.errorContainer,
        onErrorContainer: AppColorsDark.onErrorContainer,
        surface: AppColorsDark.surface,
        onSurface: AppColorsDark.onSurface,
        onSurfaceVariant: AppColorsDark.onSurfaceVariant,
        surfaceContainerLowest: AppColorsDark.surfaceContainerLowest,
        surfaceContainerLow: AppColorsDark.surfaceContainerLow,
        surfaceContainer: AppColorsDark.surfaceContainer,
        surfaceContainerHigh: AppColorsDark.surfaceContainerHigh,
        surfaceContainerHighest: AppColorsDark.surfaceContainerHighest,
        outline: AppColorsDark.outline,
        outlineVariant: AppColorsDark.outlineVariant,
        shadow: AppColorsDark.shadow,
        scrim: AppColorsDark.scrim,
        inverseSurface: AppColorsDark.inverseSurface,
        onInverseSurface: AppColorsDark.onInverseSurface,
        inversePrimary: AppColorsDark.inversePrimary,
        surfaceTint: AppColorsDark.surfaceTint,
      );

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final textTheme = AppTypography.textTheme(scheme.onSurface);
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      fontFamily: AppTypography.fontFamily,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final overlayStyle = brightness == Brightness.light
        ? SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: scheme.surface,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent,
          )
        : SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: scheme.surface,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: Colors.transparent,
          );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: scheme.onSurface),
        systemOverlayStyle: overlayStyle,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.l,
          vertical: Spacing.l,
        ),
        border: _inputBorder(BorderSide.none),
        enabledBorder: _inputBorder(BorderSide(color: scheme.outlineVariant)),
        focusedBorder: _inputBorder(
          BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: _inputBorder(BorderSide(color: scheme.error)),
        focusedErrorBorder: _inputBorder(
          BorderSide(color: scheme.error, width: 1.5),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: 14,
          ),
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: 14,
          ),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: 14,
          ),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primaryContainer,
        secondarySelectedColor: scheme.primaryContainer,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.m,
          vertical: Spacing.s,
        ),
        labelStyle: textTheme.labelMedium,
        shape: const StadiumBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        indicatorColor: scheme.secondaryContainer,
        elevation: 0,
        height: 76,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium!.copyWith(
            color: selected
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        modalBackgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.xl),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        circularTrackColor: scheme.surfaceContainerHigh,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 1,
        focusElevation: 2,
        hoverElevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.onPrimary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.surfaceContainerHigh;
        }),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(BorderSide side) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        borderSide: side,
      );
}
