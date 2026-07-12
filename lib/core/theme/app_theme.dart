import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

/// Material 3 theme for the Cozy redesign.
class AppTheme {
  const AppTheme._();

  static ThemeData light() =>
      _build(_lightScheme, HkColors.light, Brightness.light);

  static ThemeData dark() =>
      _build(_darkScheme, HkColors.dark, Brightness.dark);

  static ThemeData _build(
    ColorScheme scheme,
    HkColors palette,
    Brightness brightness,
  ) {
    final tt = AppTypography.build(scheme);

    final overlay = brightness == Brightness.light
        ? SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: palette.bg,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent,
          )
        : SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: palette.bg,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: Colors.transparent,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: tt,
      scaffoldBackgroundColor: palette.bg,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: [palette],

      appBarTheme: AppBarTheme(
        backgroundColor: palette.bg,
        foregroundColor: palette.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: tt.headlineSmall,
        iconTheme: IconThemeData(color: palette.text),
        systemOverlayStyle: overlay,
      ),

      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          textStyle: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          textStyle: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.text,
          side: BorderSide(color: palette.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          textStyle: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: _inputBorder(BorderSide(color: palette.border, width: 1)),
        enabledBorder: _inputBorder(BorderSide(color: palette.border, width: 1)),
        focusedBorder: _inputBorder(
          BorderSide(color: palette.primary, width: 1.5),
        ),
        errorBorder: _inputBorder(BorderSide(color: palette.danger, width: 1)),
        focusedErrorBorder: _inputBorder(
          BorderSide(color: palette.danger, width: 1.5),
        ),
        labelStyle: tt.bodyMedium?.copyWith(color: palette.textMuted),
        hintStyle: tt.bodyMedium?.copyWith(color: palette.textFaint),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceAlt,
        selectedColor: palette.primarySoft,
        secondarySelectedColor: palette.primarySoft,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: tt.labelMedium,
        shape: const StadiumBorder(),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        modalBackgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        titleTextStyle: tt.headlineSmall,
        contentTextStyle: tt.bodyMedium?.copyWith(color: palette.textMuted),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.text,
        contentTextStyle: tt.bodyMedium?.copyWith(color: palette.bg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.btn),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const StadiumBorder(),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.primarySoft,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return tt.labelSmall!.copyWith(
            color: selected ? palette.primary : palette.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? palette.primary : palette.textMuted,
            size: 22,
          );
        }),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: palette.textMuted,
        textColor: palette.text,
        titleTextStyle: tt.bodyLarge,
        subtitleTextStyle: tt.bodyMedium?.copyWith(color: palette.textMuted),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.onPrimary;
          return palette.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.primary;
          return palette.surfaceAlt;
        }),
        trackOutlineColor: WidgetStateProperty.all(palette.border),
      ),

      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(color: palette.text, size: 22),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.surfaceAlt,
        circularTrackColor: palette.surfaceAlt,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(BorderSide side) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.btn),
        borderSide: side,
      );
}

const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primarySoft,
  onPrimaryContainer: AppColors.primary,
  secondary: AppColors.accent,
  onSecondary: Colors.white,
  secondaryContainer: AppColors.accentSoft,
  onSecondaryContainer: AppColors.accent,
  tertiary: AppColors.ok,
  onTertiary: Colors.white,
  error: AppColors.danger,
  onError: Colors.white,
  errorContainer: AppColors.dangerSoft,
  onErrorContainer: AppColors.danger,
  surface: AppColors.surface,
  onSurface: AppColors.text,
  onSurfaceVariant: AppColors.textMuted,
  surfaceContainerLowest: AppColors.surface,
  surfaceContainerLow: AppColors.surfaceAlt,
  surfaceContainer: AppColors.surfaceAlt,
  surfaceContainerHigh: AppColors.surfaceAlt,
  surfaceContainerHighest: AppColors.surfaceAlt,
  outline: AppColors.border,
  outlineVariant: AppColors.border,
);

const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColorsDark.primary,
  onPrimary: AppColorsDark.onPrimary,
  primaryContainer: AppColorsDark.primarySoft,
  onPrimaryContainer: AppColorsDark.primary,
  secondary: AppColorsDark.accent,
  onSecondary: AppColorsDark.onAccent,
  secondaryContainer: AppColorsDark.accentSoft,
  onSecondaryContainer: AppColorsDark.accent,
  tertiary: AppColorsDark.ok,
  onTertiary: AppColorsDark.onPrimary,
  error: AppColorsDark.danger,
  onError: Color(0xFF3E120A),
  errorContainer: AppColorsDark.dangerSoft,
  onErrorContainer: AppColorsDark.danger,
  surface: AppColorsDark.surface,
  onSurface: AppColorsDark.text,
  onSurfaceVariant: AppColorsDark.textMuted,
  surfaceContainerLowest: AppColorsDark.bg,
  surfaceContainerLow: AppColorsDark.surface,
  surfaceContainer: AppColorsDark.surfaceAlt,
  surfaceContainerHigh: AppColorsDark.surfaceAlt,
  surfaceContainerHighest: AppColorsDark.surfaceAlt,
  outline: AppColorsDark.border,
  outlineVariant: AppColorsDark.border,
);
