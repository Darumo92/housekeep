# Fase 1 — Tokens y tema

> **Esfuerzo estimado:** 1 día. **Bloquea:** todas las demás fases.

## Objetivo

Reescribir `core/theme/` para que **todos los widgets** de la app puedan leer los nuevos tokens visuales desde un único punto. Después de esta fase, la app debería **seguir funcionando** (los widgets viejos heredan la paleta nueva vía `ThemeData`), aunque algunos se verán "casi bien" hasta que las fases siguientes los rediseñen.

## Entregables

1. `lib/core/theme/app_colors.dart` — reemplazado con la paleta de `DESIGN_TOKENS.md` §1 (Cozy por defecto).
2. `lib/core/theme/app_typography.dart` — `TextTheme` derivada de Inter via `google_fonts`. Spec en `DESIGN_TOKENS.md` §2.
3. `lib/core/theme/app_radii.dart` — **nuevo** archivo con la escala de `DESIGN_TOKENS.md` §3.
4. `lib/core/theme/app_shadows.dart` — **nuevo** archivo con `BoxShadow` listas (`DESIGN_TOKENS.md` §4).
5. `lib/core/theme/app_theme.dart` — `ThemeData` M3 que consume los anteriores.

## Pasos

### 1. Añadir dependencia (si no existe)

```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.2.1
```

Y deja registradas las familias `Inter` y `JetBrains Mono` (la primera para todo, la segunda para fechas/contadores).

### 2. Reescribir `app_colors.dart`

Copia el bloque Dart entero de `DESIGN_TOKENS.md` §1. Importante: **conserva el nombre `AppColors`** y los campos `primary`, `secondary`, `background`, `surface`, `success`, `warning`, `error`, `textPrimary`, `textSecondary`, `textTertiary` como **aliases retro-compatibles** apuntando a los nuevos:

```dart
// Retrocompat — los widgets viejos no se rompen
static const background    = bg;
static const secondary     = accent;
static const secondaryLight= accentSoft;
static const success       = ok;
static const warning       = warn;
static const error         = danger;
static const textPrimary   = text;
static const textSecondary = textMuted;
static const textTertiary  = textFaint;
static const primaryLight  = primarySoft;
static const primaryDark   = Color(0xFF1B5E50);
static const surfaceVariant = surfaceAlt;
```

### 3. Construir `app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData light() {
    final cs = _lightScheme;
    final tt = AppTypography.build(cs);
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: tt,
      scaffoldBackgroundColor: AppColors.bg,
      
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          textStyle: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.btn),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.btn),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.btn),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        labelStyle: tt.bodyMedium?.copyWith(color: AppColors.textMuted),
        hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textFaint),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: tt.headlineSmall,
      ),
      
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      
      iconTheme: const IconThemeData(color: AppColors.text, size: 22),
      
      // Quitar el splash agresivo
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData dark() {
    // TODO: implementar usando AppColorsDark (DESIGN_TOKENS §1)
    // Opcional para MVP.
    return light();
  }
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
  surfaceContainerHighest: AppColors.surfaceAlt,
  outline: AppColors.border,
  outlineVariant: AppColors.border,
);
```

### 4. Aplicar el tema

En `lib/app.dart` (donde se construye `MaterialApp.router`):

```dart
theme: AppTheme.light(),
darkTheme: AppTheme.dark(),
themeMode: ThemeMode.system, // o ThemeMode.light si no soportas dark en MVP
```

## Criterios de aceptación

- [ ] `flutter run` arranca sin errores.
- [ ] La pantalla Home (sin rediseñar todavía) muestra el fondo cream `#F6F1E9` y los textos en `#1F2624`.
- [ ] Cualquier botón `FilledButton.tonal` toma `primarySoft` automáticamente.
- [ ] Los inputs muestran borde de 1px en `border` y radio 14.
- [ ] No queda ningún `Color(0xFF…)` hardcodeado en archivos fuera de `core/theme/` (busca `Color(0x` en grep).
- [ ] La fuente Inter se aplica globalmente (verificar en headers).
- [ ] Compila tanto en Android como en iOS (no dependencias específicas de plataforma).

## Trampas conocidas

- `cardTheme` en Flutter 3.27+ pasó a `CardThemeData`. Si usas Flutter ≤3.26 usa `CardTheme`.
- `google_fonts` requiere conexión la primera vez. Para builds offline, descarga las fuentes y bundle-éalas en `assets/fonts/`.
- Si la versión actual del proyecto define un `ColorScheme.fromSeed`, **reemplázalo** por el `ColorScheme` explícito de arriba — el `fromSeed` regenera tonos y no respeta nuestros tokens semánticos.

## Tests a actualizar

- Cualquier snapshot test que use `pumpWidget(MaterialApp(theme: ...))` ahora carga la fuente Google Fonts → puede hacer flakey los goldens. Usa `GoogleFonts.config.allowRuntimeFetching = false` y registra Inter via `loadGoogleFonts` en `flutter_test_config.dart`, o sustituye por una fuente test.
