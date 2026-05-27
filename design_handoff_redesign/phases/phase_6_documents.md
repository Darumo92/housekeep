# Fase 6 — Documentos

> **Esfuerzo estimado:** 1 día. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:** `lib/features/documents/documents_list_screen.dart` + `add_edit_document_screen.dart`.
> **Referencia visual:** prototipo → screen `docs`.

## Objetivo

Lista de documentos agrupados por urgencia (Caducados / Caducan pronto / En vigor), con semáforo visual en cada card.

## Layout

```
┌───────────────────────────────────────┐
│ Documentos                  4/3       │ ← H1 + contador (mostrar rojo si excedido)
│                                       │
│ ● CADUCADOS                       1   │ ← section header, pill rojo
│ ┌─ HkCard ──────────────────────────┐ │
│ │ [📄] Seguro del hogar    [● 36d]  │ │
│ │      2026-04-20                   │ │
│ └───────────────────────────────────┘ │
│                                       │
│ ● CADUCAN PRONTO                  1   │ ← section header, dot warn
│ [docs cards...]                       │
│                                       │
│ ● EN VIGOR                        2   │ ← section header, dot ok
│ [docs cards...]                       │
└───────────────────────────────────────┘
```

`Scaffold` con `HkTabBar` (current: `docs`) y `HkFab` (`add_rounded`) → `/documents/add`.

ListView padding bottom: 100.

## Componentes

### Section header

```dart
Padding(
  padding: EdgeInsets.fromLTRB(22, 8, 22, 8),
  child: Row(children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(
      color: tone.color, shape: BoxShape.circle,
    )),
    SizedBox(width: 8),
    Text(label.toUpperCase(), style: labelSmall.copyWith(
      color: AppColors.textMuted, letterSpacing: 0.6,
    )),
    SizedBox(width: 8),
    Text('$count', style: AppTypography.mono(12, AppColors.textFaint)),
  ]),
)
```

Solo renderiza la sección si hay al menos 1 documento del tipo.

### Doc card

```
┌──────────────────────────────────────┐
│ [icon 48]  Seguro del coche  [● 9d] │
│            2026-06-04                │
└──────────────────────────────────────┘
```

- HkCard padding 14, gap 14.
- Leading: container 48×48 `primarySoft` radius `card * 0.5` (10) con icono según tipo:
  - `id_card`, `passport`, `drivers_license` → `badge_rounded`
  - `insurance_home` → `home_work_rounded`
  - `insurance_car`, `insurance_life`, `itv` → `directions_car_rounded`
  - `other` → `description_rounded`
- Centro: nombre 15 w600 display + fecha 12.5 mono `textMuted`.
- Trailing: `HkStatusPill` con días.

### Estado vacío

Igual a items list (HkCard centrada con icono `description_rounded` 48 primary + título + sub + CTA).

## Lógica de agrupado

```dart
final expired = docs.where((d) => d.daysUntilExpiry < 0).toList();
final soon = docs.where((d) => d.daysUntilExpiry >= 0 && d.daysUntilExpiry <= 90).toList();
final ok = docs.where((d) => d.daysUntilExpiry > 90).toList();
```

(El umbral de "soon" lo decide el usuario en Settings → notifications lead. Por defecto 90 días.)

Dentro de cada grupo, ordena por `daysUntilExpiry` ascendente (los más urgentes arriba).

## Add/Edit document form

Mismo patrón que add item (Fase 5C), con campos:
- Tipo (dropdown o `Wrap` de pills con icono):
  - `dni`, `pasaporte`, `carnet`, `itv`, `seguro_hogar`, `seguro_coche`, `seguro_vida`, `otro` (ES)
- Nombre
- Fecha de caducidad (date picker, **obligatoria**)
- Foto (PhotoSlot 86×86)
- Notas

Save bar idéntico.

## Strings nuevos (ARB)

```json
"docs_title": "Documentos",
"docs_empty_title": "Sin documentos guardados",
"docs_empty_sub": "DNI, ITV, seguros… te avisamos un mes antes.",
"docs_add": "Añadir documento",
"docs_section_expired": "Caducados",
"docs_section_soon": "Caducan pronto",
"docs_section_ok": "En vigor",
"docs_count_free": "{n}/3"
```

## Criterios de aceptación

- [ ] Las 3 secciones aparecen/desaparecen según contenido.
- [ ] Orden cronológico ascendente dentro de cada sección.
- [ ] `HkStatusPill` muestra "hace 36d" para vencidos, "en 9d" para futuros.
- [ ] Contador rojo si `docs.length > 3` en plan Free (`color: AppColors.danger`).
- [ ] Tap en card → navega a `/documents/{id}/edit`.
- [ ] Gate Free: 4º documento → paywall.
- [ ] Formulario crea + edita correctamente vía el repository existente.
