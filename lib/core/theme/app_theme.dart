import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const double cardRadius = 20;
    const double controlRadius = 16;
    const double buttonRadius = 14;
    const double inputBorderWidth = 1;
    const double focusedBorderWidth = 1.5;
    const double minTouchTarget = 44;
    const double buttonHeight = 52;
    const double navigationHeight = 76;
    const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    );
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 14,
    );
    const EdgeInsets chipPadding = EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 10,
    );

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.surfaceVariant,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryLight,
          onSecondaryContainer: AppColors.onSecondary,
          error: AppColors.error,
          surface: AppColors.surface,
          surfaceContainerHighest: AppColors.surfaceVariant,
          onSurface: AppColors.textPrimary,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.outline,
          shadow: AppColors.shadow,
        );

    final textTheme = AppTypography.textTheme(AppColors.textPrimary);
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: const CardThemeData(
        elevation: 1,
        color: AppColors.surface,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.shadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        space: 1,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: inputContentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: const BorderSide(
            color: AppColors.outline,
            width: inputBorderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: focusedBorderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: inputBorderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: focusedBorderWidth,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(minTouchTarget, buttonHeight),
          padding: buttonPadding,
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(minTouchTarget, buttonHeight),
          padding: buttonPadding,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(minTouchTarget, buttonHeight),
          padding: buttonPadding,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.outline),
        padding: chipPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        labelStyle: textTheme.labelMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        height: navigationHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textSecondary;

          return IconThemeData(color: color, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textSecondary;

          return textTheme.labelMedium!.copyWith(color: color);
        }),
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
      ),
    );
  }
}
