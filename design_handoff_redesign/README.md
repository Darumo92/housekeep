# Handoff: Rediseño visual de HouseKeep

> Para Claude Code (u otro desarrollador): este paquete contiene **una nueva capa visual** para la app HouseKeep (Flutter). La lógica de negocio, datos, navegación y servicios **ya existen** (fases 0-10). Esta entrega rediseña la UI pantalla por pantalla; no toca la capa de datos.

## Qué hay en este paquete

```
design_handoff_redesign/
├── README.md                  ← estás aquí
├── DESIGN_TOKENS.md           ← colores, tipografía, radios, sombras (con código Dart listo)
├── PHASES.md                  ← roadmap resumido de las 9 fases
├── phases/
│   ├── phase_1_tokens_and_theme.md
│   ├── phase_2_shared_components.md
│   ├── phase_3_onboarding.md
│   ├── phase_4_home_dashboard.md
│   ├── phase_5_items.md
│   ├── phase_6_documents.md
│   ├── phase_7_maintenance_done.md
│   ├── phase_8_paywall.md
│   └── phase_9_settings.md
└── reference/                 ← prototipo HTML interactivo (clicable en navegador)
    ├── Housekeep.html
    ├── app.jsx
    ├── screens.jsx
    ├── ui.jsx
    ├── tweaks-panel.jsx
    └── android-frame.jsx
```

## Sobre los archivos de referencia

Los archivos HTML/JSX en `reference/` son **referencias visuales** — un prototipo interactivo que demuestra el look final y los comportamientos esperados. **No están pensados para copiar literalmente**: el desarrollador debe **recrear estos diseños en Flutter** usando los patrones existentes del codebase (Material 3, Riverpod, go_router, drift) **sin reescribir la capa de datos**.

Para ver el prototipo: abre `reference/Housekeep.html` en un navegador. Tiene un panel de Tweaks (esquina inferior derecha) para:
- Cambiar entre 3 direcciones visuales (Cozy / Editorial / Vibrant) — **el desarrollador debe implementar solo UNA** (ver decisión en `PHASES.md`)
- Alternar plan Free/Pro, idioma ES/EN, modo claro/oscuro
- Saltar a cualquier pantalla
- Disparar el sheet de "marcar como hecho"

## Fidelidad

**Alta fidelidad (hi-fi).** Colores, radios, tipografías, jerarquía y espaciado están definidos con precisión. Las pantallas deben implementarse pixel-perfect respetando los tokens de `DESIGN_TOKENS.md`. Las animaciones e interacciones están descritas explícitamente en cada fase.

## Decisión obligatoria antes de empezar

El prototipo muestra **3 direcciones visuales**. El usuario debe elegir UNA antes de la implementación. Por defecto, recomendamos **"Cozy"** porque alinea con la paleta y principios documentados en `docs/ARCHITECTURE.md` (verde azulado cálido + ámbar, rounded everywhere, soft shadows). Las otras dos (`Editorial`, `Vibrant`) son opciones alternativas más arriesgadas.

Esta decisión va al inicio de `PHASES.md` y se hereda en todas las fases siguientes.

## Filosofía del rediseño

1. **No reinventar la arquitectura.** Los repositories, DAOs, providers, plantillas JSON, lógica de notificaciones, gates de paywall y go_router se quedan tal cual.
2. **Sustituir widgets, no flujos.** Cada `*_screen.dart` mantiene su ruta, su provider y su contrato de datos. Lo que cambia son los widgets internos.
3. **Centralizar tokens.** Todo lo visual (colores, radios, sombras, tipografía) vive en `core/theme/`. Ningún widget hardcodea valores.
4. **Componentes reutilizables primero.** La Fase 2 construye un kit de widgets compartidos (`shared/widgets/`) que las pantallas consumen. Si te encuentras hardcodeando estilos en una pantalla, sube esa pieza al kit.
5. **Soporte i18n desde el principio.** Todos los strings nuevos pasan por los ARB files (`app_en.arb`, `app_es.arb`). El prototipo tiene los textos en ambos idiomas en `reference/ui.jsx` (constante `STRINGS`).

## Estructura recomendada para añadir/modificar

```
lib/
├── core/
│   └── theme/
│       ├── app_theme.dart          ← MODIFICAR — ThemeData M3 con los tokens nuevos
│       ├── app_colors.dart         ← REEMPLAZAR — paleta nueva (Fase 1)
│       ├── app_typography.dart     ← MODIFICAR — Inter + opcional serif/grotesk
│       ├── app_radii.dart          ← AÑADIR — escala de radios
│       └── app_shadows.dart        ← AÑADIR — sombras suaves
│
├── shared/widgets/
│   ├── hk_card.dart                ← AÑADIR — Card base con la sombra suave
│   ├── hk_button.dart              ← AÑADIR — primary/accent/soft/outline/ghost
│   ├── hk_chip.dart                ← AÑADIR — chips de filtro + tone (danger/warn/ok)
│   ├── hk_status_pill.dart         ← AÑADIR — píldora con punto de color
│   ├── hk_category_tile.dart       ← AÑADIR — tile de categoría con icono
│   ├── hk_photo_slot.dart          ← AÑADIR — placeholder de foto (rayas + label mono)
│   ├── hk_form_field.dart          ← AÑADIR — label uppercase + input/textarea/date
│   ├── hk_toggle.dart              ← AÑADIR — switch personalizado
│   ├── hk_tab_bar.dart             ← AÑADIR — bottom nav con píldora redondeada
│   ├── hk_fab.dart                 ← AÑADIR — FAB con el accent color
│   └── hk_summary_stat.dart        ← AÑADIR — card de estadística para home
│
└── features/
    ├── onboarding/onboarding_screen.dart      ← REDISEÑAR (Fase 3)
    ├── home/home_screen.dart                  ← REDISEÑAR (Fase 4)
    ├── items/items_list_screen.dart           ← REDISEÑAR (Fase 5)
    ├── items/item_detail_screen.dart          ← REDISEÑAR (Fase 5)
    ├── items/add_edit_item_screen.dart        ← REDISEÑAR (Fase 5)
    ├── documents/documents_list_screen.dart   ← REDISEÑAR (Fase 6)
    ├── maintenance/mark_done_sheet.dart       ← AÑADIR (Fase 7)
    ├── paywall/paywall_screen.dart            ← REDISEÑAR (Fase 8)
    └── settings/settings_screen.dart          ← REDISEÑAR (Fase 9)
```

## Orden de ejecución

1. Lee `DESIGN_TOKENS.md` y `PHASES.md` completos antes de empezar.
2. Implementa **Fase 1 → Fase 2** en orden (son base para todo lo demás).
3. Las **Fases 3-9** son independientes entre sí: se pueden hacer en paralelo o en cualquier orden.
4. Tras cada fase, verifica visualmente comparando con `reference/Housekeep.html` (usa el selector "Jump to screen" del panel de Tweaks).

## Idiomas y copys

Todos los strings del rediseño están en `reference/ui.jsx` → constante `STRINGS` (`es` y `en`). Hay que portarlos a los ARB files. Mantén la voz: cercana, breve, sin tecnicismos ("Tu casa cuidada, sin recordar nada", "Marcar como hecho", "Pásate a Pro").

## Lo que **no** está en este paquete

- Imágenes finales (cualquier `<PhotoSlot>` del prototipo es un placeholder). Quedan abiertas para las capturas reales de ASO (Fase 11 del PLAN.md original).
- Iconos de marca/branding: usa los assets ya existentes en `assets/branding/`.
- Configuración de Firebase, RevenueCat, drift: nada cambia.
- Tests: deja los existentes tal cual; los snapshot tests visuales habrá que regenerarlos tras el rediseño.

## Próximo paso para el dev

Abre `PHASES.md` y empieza por la Fase 1.
