# Fase 3 — Onboarding

> **Esfuerzo estimado:** 1 día. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:** `lib/features/onboarding/onboarding_screen.dart` (rediseño).
> **Referencia visual:** `reference/Housekeep.html` → Tweaks → Jump to screen → `Onboarding`.

## Objetivo

Sustituir el onboarding actual por un flujo de **3 páginas swipeables** con composiciones abstractas (no ilustraciones complejas), copy emocional corto y un CTA progresivo (Next/Next/Get started).

## Layout general

`Scaffold(backgroundColor: AppColors.bg)` con:

```
┌───────────────────────────────────────┐
│                              Saltar   │ ← top, derecha, color textMuted, fontSize 14
│                                       │
│                                       │
│        [ ART AREA — 280×280 ]         │ ← centrada, custom widget por página
│                                       │
│                                       │
│             • • —                     │ ← page dots, 6×6 inactive, 24×6 active, primary
│                                       │
│   Tu casa tiene memoria.              │ ← H1: 28px (Editorial: Serif 40px), w600
│                                       │
│   Cuándo cambiar el filtro…           │ ← body 16px, lineHeight 1.5, textMuted
│                                       │
│   [ ←   ] [ Siguiente →           ]   │ ← outline back (hidden en pág 0) + primary CTA
└───────────────────────────────────────┘
```

Padding lateral: 24. Padding vertical: 24 top / 36 bottom.

## Páginas

| # | Título (ES / EN) | Subtítulo | Arte | Icono CTA |
|---|------------------|-----------|------|-----------|
| 0 | "Tu casa tiene memoria." / "Your house has memory." | "Cuándo cambiar el filtro, cuándo caduca el seguro, cuándo toca revisión. Demasiado para recordar." | Home cluster (ver §Arte) | `arrow_forward` |
| 1 | "HouseKeep recuerda por ti." / "HouseKeep remembers for you." | "Avisos a tiempo, plantillas listas y un historial de todo lo que has hecho." | Bell stack (ver §Arte) | `arrow_forward` |
| 2 | "Empieza con una sola cosa." / "Start with one thing." | "La caldera, la lavadora, el seguro del coche. Lo que más te preocupe." | Sparkle item card (ver §Arte) | `arrow_forward` |

En la última página, el CTA principal pasa a "Empezar / Get started" y al pulsar va a `home_screen` + persiste `onboarding_seen = true` (ya existe esa lógica en `onboarding_provider`).

## Arte de cada página (composiciones simples)

### `OnboardingArt.homeCluster`

`SizedBox(width: 280, height: 280)` con stack:
- Tile grande central (180×160) a `(60, 80)`: `primarySoft` bg, `home_rounded` 92px `primary`, radio `card * 1.4` (28).
- 4 mini-tiles 60×60 en las esquinas-ish con iconos `cat-kitchen` (28°), `cat-laundry` (260°), `cat-garden` (140°), `cat-bath` (210°). Cada uno levemente rotado (±6°), con `cardShadow` y los colores del `HkCategoryTile` correspondiente.

### `OnboardingArt.bellStack`

Stack de 3 cards "fake notification" escaladas: cada una 220×70, offset 8px right + 16px down respecto a la anterior, opacity 1 / 0.82 / 0.64.

Cada card: icono 40×40 con `dangerSoft`/`warnSoft`/`okSoft` y bell rounded → label en `surfaceAlt` (rectángulos de 8px y 6px simulando texto).

Bell hero abajo-derecha (100×100, círculo perfecto, `accent`, icono `notifications_rounded` 48px, shadow fuerte).

### `OnboardingArt.sparkleItem`

Un `HkCard` simulado (220px ancho, padding 18) con:
- Row top: `HkCategoryTile` `bath` 48 + 2 placeholders rectangulares simulando título y subtítulo.
- `HkPhotoSlot` 70px alto, label "appliance photo".
- Row bottom: `HkStatusPill` con un texto fake "•••" tone soon + placeholder lineal.
- **Sparkle** flotando en top-right (-14, -14): `auto_awesome_rounded` 44px en `accent`, fill puro.

## Interacción

- **Swipe lateral:** `PageView`.
- **Indicador:** `AnimatedContainer` para el dot activo (ancho 6→24, duration 250ms).
- **Botón Saltar:** en páginas 0 y 1, top-right. Tap → cierra onboarding y va a `home`.
- **Botón ←:** aparece desde la página 1. Outline variant, solo icono.
- **CTA principal:** lg, full width (lo que quede tras el back button), icono `arrow_forward` (o `auto_awesome_rounded` en el último).

## Strings nuevos (ARB)

```json
// app_es.arb
"onboarding_skip": "Saltar",
"onboarding_next": "Siguiente",
"onboarding_start": "Empezar",
"onboarding_1_title": "Tu casa tiene memoria.",
"onboarding_1_sub": "Cuándo cambiar el filtro, cuándo caduca el seguro, cuándo toca revisión. Demasiado para recordar.",
"onboarding_2_title": "HouseKeep recuerda por ti.",
"onboarding_2_sub": "Avisos a tiempo, plantillas listas y un historial de todo lo que has hecho.",
"onboarding_3_title": "Empieza con una sola cosa.",
"onboarding_3_sub": "La caldera, la lavadora, el seguro del coche. Lo que más te preocupe."
```

(Equivalentes en `app_en.arb` con las versiones inglesas — ver `reference/ui.jsx` constante `STRINGS.en`.)

## Criterios de aceptación

- [ ] 3 páginas con swipe lateral fluido.
- [ ] Dots animados (6 ↔ 24).
- [ ] Saltar funciona en páginas 0 y 1, oculto en 2.
- [ ] Back button visible en páginas 1 y 2, oculto en 0.
- [ ] El arte de cada página se ve a 280×280 sin recortes en pantallas pequeñas (verifica en 360×640).
- [ ] Tap en "Empezar" persiste flag y navega a `home`.
- [ ] Strings ES + EN.
- [ ] Soporta safe area top + bottom.
