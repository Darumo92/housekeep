# Fase 6 — Documentos

> **Esfuerzo estimado:** 1.5 días. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:** `lib/features/documents/documents_list_screen.dart` + `add_edit_document_screen.dart`.
> **Referencia visual:** prototipo → screens `docs` y `add-doc`.

## Objetivo

1. **Lista** de documentos agrupados por urgencia (Caducados / Caducan pronto / En vigor), con semáforo visual en cada card.
2. **Formulario** de añadir/editar documento (distinto del de items): tipo de documento + nombre + fecha de caducidad + ventana de aviso + notas.

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

**Distinto del formulario de items.** Reusa los mismos primitivos (`HkFormField`, `inputDecorationTheme`, save bar sticky) pero con campos específicos. Referencia: prototipo → screen `add-doc`.

### Header

Idéntico al de Add Item: back button + título "Nuevo documento" / "New document" (o "Editar" si edita).

### Campos (en orden)

#### 1. Foto/escaneo

Row con `HkPhotoSlot(width: 86, height: 86, label: 'escanear')` + dos botones stack vertical:
- `HkButton(variant: soft, icon: photo_camera, label: 'Escanear', size: sm)` → abre cámara para escanear.
- `HkButton(variant: outline, label: 'Galería', size: sm)` → abre la galería de imágenes.

Lógica implementada: el modelo existente dispone de `photoPath` y reusa `PhotoService` para imágenes. Adjuntar PDF queda fuera de esta fase porque requeriría ampliar persistencia y el servicio de archivos.

#### 2. Tipo de documento

`HkFormField(label: 'TIPO DE DOCUMENTO')` con `Wrap(spacing: 8, runSpacing: 8)` de pills con icono:

```dart
final docTypes = [
  ('dni', Icons.badge_rounded, 'DNI / Pasaporte'),
  ('coche', Icons.directions_car_rounded, 'Coche / ITV'),
  ('hogar', Icons.home_work_rounded, 'Hogar'),
  ('seguro_vida', Icons.favorite_rounded, 'Seguro de vida'),
  ('otro', Icons.description_rounded, 'Otro'),
];
```

Pill activo: bg `primary`, fg `onPrimary`. Inactivo: bg `surfaceAlt`, fg `text`. Padding 12×8, radius `chip` (999), fontSize 13.

Mapea el id al enum `DocumentType` existente.

#### 3. Nombre

`TextField` normal con placeholder "Seguro del coche, DNI…" / "Car insurance, ID…". **Requerido.**

#### 4. Fecha de caducidad

Date picker button (mismo patrón que en add item):

```dart
HkFormField(
  label: 'FECHA DE CADUCIDAD',
  child: GestureDetector(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 365 * 2)),
        lastDate: DateTime.now().add(Duration(days: 365 * 30)),
        initialDate: expiryDate ?? DateTime.now().add(Duration(days: 365)),
      );
      if (picked != null) setState(() => expiryDate = picked);
    },
    child: Container(
      decoration: inputDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textMuted),
        SizedBox(width: 8),
        Text(
          expiryDate == null ? 'YYYY-MM-DD' : DateFormat('yyyy-MM-dd').format(expiryDate!),
          style: AppTypography.mono(13, expiryDate == null ? AppColors.textMuted : AppColors.text),
        ),
      ]),
    ),
  ),
)
```

**Requerido.** Sin fecha no se puede guardar.

#### 5. Avisarme (ventana de notificaciones)

`HkFormField(label: 'AVISARME')` con `Wrap` de chips:

```dart
final leadOptions = [30, 15, 7, 1];
// Free: uno seleccionado, persistido en notifyDaysBefore.
// Pro: el scheduler existente aplica automáticamente [90, 30, 7].
```

Cada chip muestra "30 d. antes" / "30d before".

Visual:
- Seleccionado: bg `primarySoft`, fg `primary`, fontWeight 600.
- No seleccionado: bg `surfaceAlt`, fg `textMuted`, border 1px `border`.

**Para plan Free:** permite seleccionar un solo chip y muestra un texto pequeño "Hasta 1 aviso · [Pasar a Pro](paywall) para múltiples" debajo.

**Para plan Pro:** muestra los chips fijos 90, 30 y 7 activos junto a la explicación de avisos automáticos. No se incorpora multiselección persistida porque el esquema actual guarda un único `notifyDaysBefore`.

#### 6. Notas

`TextField(maxLines: 2)` opcional con placeholder "Número de póliza, contacto…" / "Policy number, contact…".

### Save bar (sticky)

Idéntica al de add item:
```
[ Cancelar (ghost) ]  [ ✓ Guardar (primary) ]
```

### Validación

- `name` requerido.
- `expiryDate` requerido.
- `docType` requerido (uno seleccionado por default).
- En Free siempre se conserva un lead time seleccionado; en Pro se usan los tiers automáticos existentes.

Si validación falla, muestra `SnackBar` con `colorScheme.error`.

### Lógica de gate

Antes de mostrar el form, si plan == free && docs.length >= 3, navega a `/paywall?gate=true`.

### Tras guardar

Vuelve a `/documents`. La lista se actualiza vía el provider existente. Free programa el aviso persistido; Pro conserva la programación automática existente a 90, 30 y 7 días.

---

## Strings nuevos completos (ARB)

```json
"docs_title": "Documentos",
"docs_empty_title": "Sin documentos guardados",
"docs_empty_sub": "DNI, ITV, seguros… te avisamos un mes antes.",
"docs_add": "Añadir documento",
"docs_section_expired": "Caducados",
"docs_section_soon": "Caducan pronto",
"docs_section_ok": "En vigor",
"docs_count_free": "{n}/3",
"add_doc_title": "Nuevo documento",
"edit_doc_title": "Editar documento",
"add_doc_type": "Tipo de documento",
"add_doc_type_id": "DNI / Pasaporte",
"add_doc_type_car": "Coche / ITV",
"add_doc_type_home": "Hogar",
"add_doc_type_life": "Seguro de vida",
"add_doc_type_other": "Otro",
"add_doc_name": "Nombre",
"add_doc_name_hint": "Seguro del coche, DNI…",
"add_doc_expiry": "Fecha de caducidad",
"add_doc_lead": "Avisarme",
"add_doc_lead_days_before": "{n} d. antes",
"add_doc_lead_free_limit": "Hasta 1 aviso · Pásate a Pro para múltiples",
"add_doc_notes": "Notas",
"add_doc_notes_hint": "Número de póliza, contacto…",
"add_doc_scan": "Escanear",
"add_doc_gallery": "Galería",
"add_doc_scan_placeholder": "escanear",
"add_doc_save": "Guardar",
"add_doc_cancel": "Cancelar"
```

## Criterios de aceptación

- [x] Las 3 secciones aparecen/desaparecen según contenido.
- [x] Orden cronológico ascendente dentro de cada sección.
- [x] `HkStatusPill` muestra "hace 36d" para vencidos, "en 9d" para futuros.
- [x] Contador rojo si `docs.length > 3` en plan Free (`color: AppColors.danger`).
- [x] Tap en card → navega a `/documents/{id}/edit`.
- [x] Gate Free: 4º documento → paywall.
- [x] Formulario crea + edita correctamente vía el repository existente.
