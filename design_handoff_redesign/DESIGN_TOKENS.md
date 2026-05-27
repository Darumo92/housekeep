# Design Tokens

Toda la capa visual está parametrizada. Estos son los valores. **Importante:** todo lo que aparece aquí debe vivir en `core/theme/`, nunca hardcodeado en widgets.

---

## 1. Paleta de colores

### Dirección "Cozy" (recomendada por defecto)

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Surfaces
  static const bg            = Color(0xFFF6F1E9); // fondo principal cálido
  static const surface       = Color(0xFFFFFFFF); // cards
  static const surfaceAlt    = Color(0xFFFBF6EE); // inputs / chips inactivos
  static const border        = Color(0x1A2E7D6F); // 10% del primary
  
  // Texto
  static const text          = Color(0xFF1F2624);
  static const textMuted     = Color(0xFF6B7270);
  static const textFaint     = Color(0xFFA4A8A4);
  
  // Primary (teal cálido)
  static const primary       = Color(0xFF2E7D6F);
  static const primarySoft   = Color(0xFFDBEAE5);
  static const onPrimary     = Color(0xFFFFFFFF);
  
  // Accent (ámbar)
  static const accent        = Color(0xFFE0913A);
  static const accentSoft    = Color(0xFFFBE9D2);
  
  // Semantic (semáforo)
  static const ok            = Color(0xFF3F9C5C);
  static const warn          = Color(0xFFD4A017);
  static const danger        = Color(0xFFC8513C);
  static const okSoft        = Color(0xFFDCEFD6);
  static const warnSoft      = Color(0xFFFCEFC8);
  static const dangerSoft    = Color(0xFFF6DAD0);
  
  // Stripe del placeholder de fotos
  static const placeholderStripe = Color(0x0F2E7D6F); // 6% del primary
}
```

### Dirección "Editorial" (alternativa minimal-serif)

| Token | Hex |
|-------|-----|
| `bg` | `#F4F1EC` |
| `surface` | `#FFFFFF` |
| `surfaceAlt` | `#EBE6DD` |
| `border` | `#00000014` (8% black) |
| `text` | `#15140F` |
| `textMuted` | `#65615A` |
| `textFaint` | `#A09A90` |
| `primary` | `#15140F` (near-black) |
| `primarySoft` | `#E4DFD6` |
| `onPrimary` | `#FDFBF6` |
| `accent` | `#C34B2A` (terracotta) |
| `accentSoft` | `#F3D8CE` |
| `ok` | `#3F6B3A` |
| `warn` | `#B88216` |
| `danger` | `#A23217` |

### Dirección "Vibrant" (alternativa enérgica)

| Token | Hex |
|-------|-----|
| `bg` | `#EEF2E6` |
| `surface` | `#FFFFFF` |
| `surfaceAlt` | `#DFE9D0` |
| `border` | `#0000000F` (6% black) |
| `text` | `#0F1A14` |
| `textMuted` | `#5B6B5E` |
| `textFaint` | `#9AA498` |
| `primary` | `#1E6B3A` (verde fresco) |
| `primarySoft` | `#CCE5CE` |
| `accent` | `#E85A3C` (coral) |
| `accentSoft` | `#FBD8CE` |

### Modo oscuro (overlay sobre cualquier dirección)

```dart
class AppColorsDark {
  static const bg          = Color(0xFF13110D);
  static const surface     = Color(0xFF1E1C17);
  static const surfaceAlt  = Color(0xFF26231D);
  static const border      = Color(0x14FFFFFF); // 8% white
  static const text        = Color(0xFFF3EFE8);
  static const textMuted   = Color(0xFFA39E94);
  static const textFaint   = Color(0xFF6D6960);
  // primary, accent, ok/warn/danger se mantienen iguales que en claro
  // Las versiones "soft" se vuelven semitransparentes:
  static const primarySoft = Color(0x2E2E7D6F); // 18% primary
  static const accentSoft  = Color(0x2EE0913A); // 18% accent
}
```

---

## 2. Tipografía

### Stack (Cozy)

```dart
// lib/core/theme/app_typography.dart
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Body + display: Inter
  static TextTheme build(ColorScheme cs) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      // Display — usado en H1 (greeting, screen titles)
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 28, fontWeight: FontWeight.w600, height: 1.05,
        letterSpacing: -0.4, color: cs.onSurface,
      ),
      // Headlines — H2 sección
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18, fontWeight: FontWeight.w600, height: 1.2,
        letterSpacing: -0.2, color: cs.onSurface,
      ),
      // Titles — Card titles, item names
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 15.5, fontWeight: FontWeight.w600, height: 1.3,
        color: cs.onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14, fontWeight: FontWeight.w600, height: 1.35,
      ),
      // Body
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 15, fontWeight: FontWeight.w400, height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.45,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12.5, fontWeight: FontWeight.w400, height: 1.4,
      ),
      // Labels — pills, chips, eyebrows
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 13, fontWeight: FontWeight.w600, height: 1.2,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12, fontWeight: FontWeight.w600, height: 1.2,
        letterSpacing: 0.2,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.2,
        letterSpacing: 0.3,
      ),
    );
  }

  // Mono — para fechas, números técnicos, contadores tipo "3/5"
  static TextStyle mono(double size, Color color) =>
    GoogleFonts.jetBrainsMono(fontSize: size, color: color, height: 1.3);
}
```

### Variaciones por dirección

| Dirección | Display | Body | Mono |
|-----------|---------|------|------|
| Cozy | Inter 600 | Inter 400 | JetBrains Mono |
| Editorial | Instrument Serif 400 (40px H1) | Inter 400 | JetBrains Mono |
| Vibrant | Space Grotesk 700 | Space Grotesk 500 | JetBrains Mono |

Para añadir fuentes: usa `google_fonts: ^6.x` (ya está conceptualmente alineado; verifica `pubspec.yaml`).

---

## 3. Radios

```dart
// lib/core/theme/app_radii.dart
class AppRadii {
  // Cozy
  static const card  = 20.0;  // cards principales
  static const btn   = 14.0;  // botones, inputs
  static const chip  = 999.0; // chips/pills
  static const tile  = 14.0;  // category tile
  static const sheet = 28.0;  // top-corners del bottom sheet
}
```

| Token | Cozy | Editorial | Vibrant |
|-------|------|-----------|---------|
| card | 20 | 6 | 28 |
| btn | 14 | 6 | 999 (pill) |
| chip | 999 | 4 | 999 |
| tile | 14 | 4 | 18 |
| sheet | 28 | 12 | 32 |

---

## 4. Sombras

```dart
// lib/core/theme/app_shadows.dart
class AppShadows {
  // Cozy: sombra suave, tonalizada
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x05000000), offset: Offset(0, 1), blurRadius: 0),
    BoxShadow(color: Color(0x0F2E7D6F), offset: Offset(0, 2), blurRadius: 8),
  ];

  static const fab = <BoxShadow>[
    BoxShadow(color: Color(0x2E000000), offset: Offset(0, 8), blurRadius: 24),
  ];

  // Editorial: sin sombra. Usar `border: 1px solid border` en su lugar.
  // Vibrant: card más fuerte
  // static const cardVibrant = <BoxShadow>[
  //   BoxShadow(color: Color(0x1A1E6B3A), offset: Offset(0, 8), blurRadius: 24),
  // ];
}
```

---

## 5. Spacing scale

Reusa la escala estándar de Flutter. Los valores recurrentes:

| Token sugerido | Valor | Uso |
|----------------|-------|-----|
| `xs` | 4 | gap interno mini |
| `sm` | 8 | gap entre íconos y label |
| `md` | 12 | gap entre cards |
| `lg` | 16 | padding interno de card |
| `xl` | 22 | padding lateral de pantalla |
| `xxl` | 32 | padding vertical entre secciones |

---

## 6. Iconografía

El prototipo usa **iconos custom inline SVG**. En Flutter, recomendado:

- **Material Symbols Rounded** (incluido en `material_symbols_icons` o vía `Icons.*_rounded`).
- Stroke-based, 1.75-2.0 effective stroke (no usar variantes "filled" excepto en estados activos).

Mapeo (HTML → Material Symbols):

| HTML icon | Material Icons |
|-----------|----------------|
| home | `home_rounded` |
| box | `inventory_2_rounded` |
| file | `description_rounded` |
| gear | `settings_rounded` |
| plus | `add_rounded` |
| chevron-right | `chevron_right_rounded` |
| check | `check_rounded` |
| check-circle | `check_circle_rounded` |
| bell | `notifications_rounded` |
| calendar | `calendar_today_rounded` |
| camera | `photo_camera_rounded` |
| sparkle | `auto_awesome_rounded` |
| arrow-right | `arrow_forward_rounded` |
| arrow-left | `arrow_back_rounded` |
| search | `search_rounded` |
| more | `more_horiz_rounded` |
| edit | `edit_rounded` |
| trash | `delete_outline_rounded` |
| history | `history_rounded` |
| lock | `lock_outline_rounded` |
| share | `share_rounded` |
| globe | `language_rounded` |
| sun | `light_mode_rounded` |
| moon | `dark_mode_rounded` |
| cat-kitchen | `kitchen_rounded` |
| cat-bath | `bathtub_rounded` |
| cat-laundry | `local_laundry_service_rounded` |
| cat-living | `chair_rounded` |
| cat-garden | `local_florist_rounded` |
| cat-garage | `garage_rounded` |
| cat-general | `widgets_rounded` |
| doc-id | `badge_rounded` |
| doc-car | `directions_car_rounded` |
| doc-house | `home_work_rounded` |

Tamaños recomendados:
- En píldoras / chips: 11-14
- En tab bar: 22
- En iconos categoría 44px tile: 22
- En iconos categoría 60px tile: 30

---

## 7. ColorScheme M3 derivado

```dart
// Para llenar el ColorScheme de ThemeData (Cozy claro)
final lightScheme = ColorScheme(
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

---

## 8. Resumen "lo que cambia respecto al diseño actual"

Según `docs/ARCHITECTURE.md` el código actual tiene primary `#2E7D6F` y secondary `#F5A623`. La paleta nueva:
- **Primary se mantiene** (`#2E7D6F`).
- **Secondary/accent ajustado** a `#E0913A` (un punto más cálido y menos saturado, mejor para fondos cream).
- **Añadidos:** capas `surfaceAlt`, `primarySoft`, `accentSoft`, `border` translúcido tintado, y la trinidad `okSoft/warnSoft/dangerSoft` para los pills del semáforo.
- **bg cambia** de `#FAFAF8` (casi blanco) a `#F6F1E9` (cream cálido) — esto da más identidad y separa más las cards.

Si quieres mantener exactamente el bg actual `#FAFAF8`, sustitúyelo y todo lo demás funciona. Las cards seguirán destacando gracias a las sombras.
