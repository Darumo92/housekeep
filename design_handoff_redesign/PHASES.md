# Roadmap de implementación

> Las fases se ejecutan después de elegir una dirección visual. Por defecto: **Cozy**.

## Decisión inicial: dirección visual

| Dirección | Carácter | Cuándo elegirla |
|-----------|----------|-----------------|
| **Cozy** *(recomendada)* | Verde azulado cálido + ámbar, cards rounded 20px, sombras suaves, Inter | Alinea con la documentación existente y con la promesa "cálido, rounded, minimal" de `ARCHITECTURE.md`. Mantiene el código Material 3 más limpio. |
| Editorial | Monocromo + terracota, cards 6px, sin sombras, serif Instrument para títulos | Si quieres una vibe revista/editorial, más diferenciada. Requiere añadir fuente serif. |
| Vibrant | Verde fresco + coral, cards 28px, botones pill 999px, Space Grotesk | Si quieres una vibe joven y enérgica, más cercano a apps lifestyle. Requiere añadir Space Grotesk. |

**Toda la documentación de fases asume Cozy.** Para usar otra dirección, los valores hex/radios/fuentes están todos en `DESIGN_TOKENS.md` bajo cada bloque "Editorial" y "Vibrant" — basta con cambiar los tokens en `app_colors.dart` y `app_radii.dart`.

---

## Las 9 fases

### Bloque A — Cimientos (obligatorios primero, en orden)

| Fase | Nombre | Archivo de spec | Esfuerzo | Salida |
|------|--------|-----------------|----------|--------|
| 1 | Tokens y tema | `phases/phase_1_tokens_and_theme.md` | ~1d | `core/theme/` reescrito, ThemeData M3 nuevo aplicado |
| 2 | Componentes compartidos | `phases/phase_2_shared_components.md` | ~2d | `shared/widgets/hk_*.dart` listos y testeados |

### Bloque B — Pantallas (independientes, paralelizables)

| Fase | Nombre | Archivo de spec | Esfuerzo | Pantallas afectadas |
|------|--------|-----------------|----------|---------------------|
| 3 | Onboarding | `phases/phase_3_onboarding.md` | ~1d | `onboarding_screen.dart` |
| 4 | Home dashboard | `phases/phase_4_home_dashboard.md` | ~2d | `home_screen.dart` + sus widgets |
| 5 | Items (lista, detalle, formulario) | `phases/phase_5_items.md` | ~3d | `items_list_screen.dart`, `item_detail_screen.dart`, `add_edit_item_screen.dart` |
| 6 | Documentos | `phases/phase_6_documents.md` | ~1d | `documents_list_screen.dart` |
| 7 | Mark-done sheet | `phases/phase_7_maintenance_done.md` | ~1d | `maintenance/mark_done_sheet.dart` (nuevo) + integración en item detail |
| 8 | Paywall | `phases/phase_8_paywall.md` | ~1d | `paywall_screen.dart` |
| 9 | Settings | `phases/phase_9_settings.md` | ~1d | `settings_screen.dart` |

**Total estimado: ~13 días-persona.**

---

## Reglas que aplican a todas las fases

1. **No toques la capa de datos.** Si un widget necesita información que el provider actual no expone, **añade** un selector, no reformes el provider.
2. **Centraliza el visual.** Cualquier color, radio, fontSize o spacing nuevo va a `core/theme/`, no inline.
3. **Strings al ARB.** Todo texto visible se añade a `core/l10n/app_es.arb` y `app_en.arb`. Los textos completos están en `reference/ui.jsx`.
4. **Material 3 sigue.** Usa los componentes M3 existentes como base y extiende con los tokens nuevos. No tires de Cupertino.
5. **Accessibility.** Usa `Semantics` para iconos sin label visible, asegúrate que el contraste cumple WCAG AA con los tokens. Los píxeles mínimos de hit target son 44.
6. **Tests.** Antes de cerrar cada fase: verifica en emulador Android y compara con el prototipo. Los widget tests existentes pueden romperse — adáptalos, no los borres.

---

## Cómo verificar cada fase

Abre `reference/Housekeep.html` en un navegador. En el panel **Tweaks**:
- Selecciona dirección visual = la elegida (probablemente **Cozy**).
- Usa **Jump to screen** para abrir la pantalla que estás implementando.
- Alterna **Library = populated / empty** para ver ambos estados.
- Alterna **Plan = free / pro** para ver la lógica de gates.
- Alterna **Dark mode** si vas a soportar tema oscuro (opcional MVP).

Compara lado a lado en el emulador. Cualquier diferencia mayor a 2px o discrepancia de color, ajusta.
