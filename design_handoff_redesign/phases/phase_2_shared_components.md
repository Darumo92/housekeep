# Fase 2 — Componentes compartidos

> **Esfuerzo estimado:** 2 días. **Depende de:** Fase 1.

## Objetivo

Construir un kit de widgets reutilizables que cada pantalla consumirá. Después de esta fase, **ningún color/radio/sombra** debería repetirse en código de pantalla — todo viene de un widget compartido.

Ubicación: `lib/shared/widgets/`.

Convención de nombre: prefijo `Hk` (HouseKeep) para evitar colisiones con widgets de Material.

## Componentes a construir

### 2.1 `HkCard`

Card base con la sombra suave del tema.

```dart
class HkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? radius;
  final Color? color;
  final VoidCallback? onTap;

  const HkCard({
    super.key, required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius, this.color, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = radius ?? AppRadii.card;
    final body = Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(r),
        boxShadow: AppShadows.card,
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r),
        child: body,
      ),
    );
  }
}
```

### 2.2 `HkButton`

Variantes: `primary`, `accent`, `soft`, `outline`, `ghost`. Tamaños: `sm`, `md`, `lg`. Icono opcional a la izquierda. Booleano `full` (ancho total).

```dart
enum HkButtonVariant { primary, accent, soft, outline, ghost }
enum HkButtonSize { sm, md, lg }

class HkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final HkButtonVariant variant;
  final HkButtonSize size;
  final bool full;
  // ...
}
```

**Spec por variante** (background / foreground):
- `primary` → `primary` / `onPrimary`
- `accent`  → `accent` / `white`
- `soft`    → `primarySoft` / `primary`
- `outline` → `transparent` (border 1px `border`) / `text`
- `ghost`   → `transparent` / `text`

**Padding por tamaño:**
- `sm` → 14×8, fontSize 13
- `md` → 18×13, fontSize 14.5
- `lg` → 22×16, fontSize 16

**Radio:** `AppRadii.btn` (14 en Cozy, 999 pill en Vibrant).

### 2.3 `HkChip`

Chip de filtro o píldora de estado.

```dart
class HkChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final HkTone tone; // primary | accent | ok | warn | danger
}

enum HkTone { primary, accent, ok, warn, danger }
```

- Inactivo: background `*Soft`, foreground `tone`.
- Activo: background `tone`, foreground `onPrimary`/white.
- Padding `12×6`, fontSize 12.5, fontWeight 600, radius `AppRadii.chip` (999).

### 2.4 `HkStatusPill`

Píldora del semáforo con punto coloreado a la izquierda.

```dart
class HkStatusPill extends StatelessWidget {
  final HkStatus status; // overdue | due | soon | ok
  final String label;
}

enum HkStatus { overdue, due, soon, ok }
```

- `overdue/due` → `dangerSoft` bg + `danger` fg.
- `soon` → `warnSoft` bg + `warn` fg.
- `ok` → `okSoft` bg + `ok` fg.
- Padding `9×4`, fontSize 11.5, fontWeight 700, letterSpacing 0.3.
- Punto a la izquierda: 6px, mismo color que el foreground.

### 2.5 `HkCategoryTile`

Tile cuadrado con icono de categoría. Cada categoría tiene su hue (en `oklch`, pero Flutter no tiene oklch nativo — pre-calcula los hex; ver tabla).

```dart
class HkCategoryTile extends StatelessWidget {
  final ItemCategory category;
  final double size; // 44, 56, 60, 64
}
```

**Mapa categoría → bg/fg** (Cozy):

| Categoría | BG | FG | Icono Material |
|-----------|------|------|----------------|
| kitchen | `#FCE9D8` | `#8A5728` | `kitchen_rounded` |
| bath | `#D7E7F3` | `#28567F` | `bathtub_rounded` |
| laundry | `#E2D9F1` | `#4B3A82` | `local_laundry_service_rounded` |
| living | `#D6EBE6` | `#1F6A5E` | `chair_rounded` |
| garden | `#D9ECCE` | `#3D7128` | `local_florist_rounded` |
| garage | `#FBE6BA` | `#7A5613` | `garage_rounded` |
| general | `#F1D7E4` | `#7C2D58` | `widgets_rounded` |

Radio del tile: `AppRadii.tile` (14).

### 2.6 `HkPhotoSlot`

Placeholder para fotos pendientes. Rayas diagonales translúcidas + label monoespaciado.

```dart
class HkPhotoSlot extends StatelessWidget {
  final String label;
  final double? width;
  final double height;
  final double? radius;
}
```

Implementación de rayas: `CustomPaint` que pinta `repeating-linear-gradient` simulado con un `Path` que dibuja líneas paralelas a 135°. Color de la raya: `AppColors.placeholderStripe`. Borde discontinuo opcional con `DashedBorder` o `dotted_border` package.

Label: JetBrains Mono 11px, uppercase, letterSpacing 0.4, color `textFaint`.

### 2.7 `HkFormField`

Wrapper con label uppercase pequeño + child.

```dart
class HkFormField extends StatelessWidget {
  final String label;
  final Widget child;
}
```

Label: fontSize 12.5, fontWeight 600, color `textMuted`, letterSpacing 0.2. Spacing inferior 7px, spacing entre fields 14px.

### 2.8 `HkToggle`

Switch personalizado, 44×26, knob 20×20.

```dart
class HkToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
}
```

- Off: track `border`, knob blanco 3px del borde izquierdo.
- On: track `primary`, knob blanco 3px del borde derecho.
- AnimatedPositioned 200ms.

### 2.9 `HkTabBar`

Bottom navigation custom (no `BottomNavigationBar` de Material — el diseño tiene una píldora redondeada detrás del icono activo).

```dart
class HkTabBar extends StatelessWidget {
  final HkTab current;
  final ValueChanged<HkTab> onChanged;
}

enum HkTab { home, items, docs, settings }
```

Layout: row con 4 botones evenly-spaced. Cada uno: icon en píldora 16×4 padding + label debajo 11px. Icono activo: `primarySoft` background, `primary` foreground, stroke 2. Inactivo: transparente, `textMuted`, stroke 1.6.

Altura total: 64 + safeAreaBottom. Border top 1px `border`. Background `surface`.

### 2.10 `HkFab`

FAB cuadrado-redondeado con accent color.

```dart
class HkFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
}
```

56×56, radius `AppRadii.card * 0.9` (18), background `accent`, foreground white, shadow `AppShadows.fab`. Posición: bottom-right del Scaffold, 20px right, ABOVE del tab bar (offset bottom 88).

### 2.11 `HkSummaryStat`

Card del home con punto coloreado + número grande + label pequeña.

```dart
class HkSummaryStat extends StatelessWidget {
  final int count;
  final String label;
  final HkTone tone; // danger | warn | ok
}
```

Layout:
```
[•]                       ← punto 8px coloreado, marginBottom 10
28
[label fontSize 12]
```

Padding 14, radius `AppRadii.card * 0.8`.

## Criterios de aceptación

- [ ] Cada widget tiene su propio archivo `hk_*.dart` en `shared/widgets/`.
- [ ] Hay un `widgetbook` o pantalla `dev/components_screen.dart` que muestra los 11 componentes (esto es opcional pero ayuda al QA).
- [ ] **Ningún `Color(0xFF…)` literal** dentro de estos widgets — todos leen de `AppColors`.
- [ ] Hit targets ≥ 44px en los interactivos (`HkButton`, `HkChip`, `HkToggle`, `HkTabBar`).
- [ ] Los widgets aceptan modo oscuro vía `Theme.of(context).colorScheme` (puedes posponer si MVP solo es light).
- [ ] Test unitario por componente verificando: render sin errores + props básicas + tap callback dispara.

## Trampas conocidas

- `BottomNavigationBar` de Material no te deja meter una píldora detrás del icono — por eso construimos `HkTabBar` desde cero con un `Row` y `InkWell`s.
- Para las rayas del `HkPhotoSlot`, si te complicas con `CustomPaint`, una alternativa simpler es un `DecoratedBox` con un `LinearGradient` pequeño + `Transform.rotate(45°)` repetido vía `ImageRepeat.repeat` sobre un PNG de 16×16. La pureza no merece la pena.
- En Flutter, `letterSpacing` se mide en puntos absolutos (no em). Los valores del prototipo (0.2, 0.3, 0.4) son directamente trasladables.
