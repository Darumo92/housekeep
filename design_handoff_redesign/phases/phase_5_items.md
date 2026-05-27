# Fase 5 — Items (lista, detalle, formulario)

> **Esfuerzo estimado:** 3 días. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:**
> - `lib/features/items/items_list_screen.dart`
> - `lib/features/items/item_detail_screen.dart`
> - `lib/features/items/add_edit_item_screen.dart`
> - widgets en `lib/features/items/widgets/`
> **Referencia visual:** prototipo → screens `items`, `detail`, `add`.

## 5A. Lista de items

### Layout

```
┌───────────────────────────────────────┐
│ Mis cosas                   3/5       │ ← H1 + contador mono (3/5 si free, n si pro)
│                                       │
│ [Todo] [Cocina] [Baño] [Lavandería].. │ ← chips scroll horizontal, 7px gap
│                                       │
│ [ ITEM CARD ]                         │
│ [ ITEM CARD ]                         │ ← 10px gap entre cards
│ ...                                   │
└───────────────────────────────────────┘
```

Padding lateral: 22 título, 22 chips, **18 cards** (las cards usan padding interno 14 para que su contenido alinee con el resto).

### Chips de filtro

`SingleChildScrollView(scrollDirection: Axis.horizontal)` con `HkChip`s:
- `Todo / All`
- `Cocina / Kitchen`
- `Baño / Bath`
- `Lavandería / Laundry`
- `Salón / Living`
- `Garaje / Garage`
- `Jardín / Garden`

Estado seleccionado activo = `HkTone.primary` (background `primary`, foreground `onPrimary`). Inactivo = `primarySoft + primary`.

### Item card

```
┌─────────────────────────────────────────┐
│ [tile 60]  Caldera de gas            ›  │
│            Vaillant ecoTEC              │
│            [● hace 3d]  🔒 Garantía…    │
└─────────────────────────────────────────┘
```

- HkCard onTap → `/items/{id}` con `Hero(tag: 'item-${id}')` envolviendo el tile.
- Row con `HkCategoryTile(size: 60)` + Column expandida + `chevron_right` 18px `textFaint`.
- Title: 15.5 w600 con elipsis, **fontFamily display** (igual que el resto en Cozy = Inter).
- Brand: 13 textMuted.
- Bottom row: `HkStatusPill` con días + opcional warranty badge (icon `lock_outline` 11 + label 11.5).

### Estado vacío

`HkCard` centrada con icon `inventory_2_rounded` 48px `primary`, título 17 w600, sub 13 textMuted, CTA `HkButton(icon: add, label: 'Añadir cosa')`.

### Contador

Top-right del header:
- Free: `${items.length}/5` en JetBrains Mono 13px `textMuted`.
- Pro: `${items.length} elementos` / `${items.length} items` en Inter 13 textMuted.

## 5B. Item detail

### Layout

```
┌───────────────────────────────────────┐
│ [photo hero 220px, full bleed]        │
│ [←]                              [⋯]  │ ← back + more circulares blanco@0.92
│                                       │
│              [tile 64] ←── overlap -22│
├───────────────────────────────────────┤
│ Caldera de gas                        │ ← H1 24 (Editorial: serif 32)
│ Vaillant ecoTEC                       │ ← textMuted 14
│                                       │
│ ┌─ HkCard ─────────────────────────┐  │
│ │ WARRANTY                  [pill] │  │
│ │ 84 meses             → 2028-09-14│  │
│ │ Comprado el 2021-09-14           │  │
│ │ ▓▓▓▓░░░░░░░░░░░░░░░             │  │ ← progress 6px primary
│ └──────────────────────────────────┘  │
│                                       │
│ Mantenimientos              + Añadir  │
│ ┌─ HkCard ─────────────────────────┐  │
│ │ [📅] Revisión anual    [● hace 3d]│ │
│ │      cada 12 meses · Próximo…    │  │
│ │      [✓ Marcar como hecho]       │  │
│ └──────────────────────────────────┘  │
│ ...                                   │
│                                       │
│ Historial                             │
│ 2025-09-14  Revisión anual       [✓]  │
│ ──────────────────────────────────    │
│ 2025-03-02  Limpieza profunda    [✓]  │
└───────────────────────────────────────┘
```

### Hero photo

- Container 220px full width.
- Si hay `item.photoPath`, `Image.file(File(item.photoPath), fit: BoxFit.cover)`. Si no, `HkPhotoSlot` con label "appliance photo".
- Back/more buttons: `Positioned(top: 14, left/right: 14)`, 40×40 circle, bg `white.withOpacity(0.92)`, blur 8 vía `BackdropFilter`.
- Category tile overlap: `Stack` con `Positioned(left: 18, bottom: -22)` para `HkCategoryTile(size: 64)`.

### Title block

Padding top 32 (para el overlap) padding lateral 22. Title `displaySmall.copyWith(fontSize: 24)`, sub `bodyLarge.copyWith(color: textMuted)`.

### Warranty card

`HkCard` con dos columnas:
- Izquierda: eyebrow uppercase "GARANTÍA" `labelMedium`, valor grande `titleMedium` (18 w700 display font), `Comprado el …` `bodySmall textMuted`.
- Derecha: `HkStatusPill(ok, 'Activa')` arriba, `→ 2028-09-14` mono 11.5 `textFaint` abajo.

Progress bar:
- Container 6px alto, radius 99, bg `surfaceAlt`.
- Inner container width % calculada como `monthsElapsed / warrantyM`, bg `primary`.

### Maintenances section

- Header: H2 17 w600 + link `+ Añadir` primary 13 w600 (icon `add` size 14).
- Cada maintenance card: `HkCard` con:
  - Icon `calendar_today_rounded` en container 38×38 `primarySoft` radius `card * 0.4`.
  - Center: nombre 14.5 w600 + sub "cada 12 meses · Próximo en 4d" 12.5 textMuted.
  - CTA inline: `HkButton(variant: soft, size: sm, icon: check, label: 'Marcar como hecho')` → abre `MarkDoneSheet` (Fase 7).
  - Trailing: `HkStatusPill`.

### History section

`Column` con rows manuales separadas por `Divider(color: border)`:
- Fecha mono 11.5 textMuted ancho 78px.
- Centro: título 14 w500 + "por Marta" 12 textMuted.
- Trailing: `check_circle_rounded` 18 `ok`.

## 5C. Add/Edit item form

### Layout

```
┌───────────────────────────────────────┐
│ [←]  Nuevo elemento                   │ ← header pequeño
│                                       │
│ [photo 86] [Cámara]                   │ ← row: PhotoSlot 86×86 + 2 botones stack
│            [Galería]                  │
│                                       │
│ NOMBRE                                │
│ [ Caldera, lavadora, coche… ]         │
│                                       │
│ MARCA Y MODELO                        │
│ [ Vaillant ecoTEC plus      ]         │
│                                       │
│ CATEGORÍA                             │
│ [🍳 Cocina] [🛁 Baño] [👕 Lavan.]…    │ ← chips con icono, flex-wrap
│                                       │
│ [FECHA COMPRA]  [GARANTÍA (MESES)]    │ ← grid 2 cols
│ [📅 YYYY-MM-DD] [        24      ]    │
│                                       │
│ NOTAS                                 │
│ [textarea 2 rows…………………]              │
│                                       │
│ ────── (sticky save bar) ──────       │
│ [Cancelar]  [✓ Guardar]               │
└───────────────────────────────────────┘
```

### Header

Row simple:
```dart
Row(children: [
  IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
  Text('Nuevo elemento', style: titleLarge(21 w600)),
])
```

### Form fields

Usa `HkFormField(label: ...)` para envolver cada input. Label uppercase (Cozy: NO uppercase, sí en Editorial). Spacing 14px entre fields.

Inputs: `TextField` con la `inputDecorationTheme` del tema (sale bien por defecto).

### Category picker

`Wrap(spacing: 8, runSpacing: 8, children: ...)` con buttons custom:
- Activo: bg `primary`, fg `onPrimary`.
- Inactivo: bg `surfaceAlt`, fg `text`.
- Padding 12×8, radius `chip` (999), fontSize 13 w500.
- Icon 16px + label en row.

### Fecha + Garantía grid

```dart
Row(children: [
  Expanded(child: HkFormField(label: 'FECHA COMPRA', child: dateButton)),
  SizedBox(width: 10),
  Expanded(child: HkFormField(label: 'GARANTÍA (MESES)', child: warrantyInput)),
])
```

`dateButton`: contenedor con `inputDecorationTheme` styling, ícon calendar + texto "YYYY-MM-DD" mono. onTap → `showDatePicker` con tema custom (locale ES).

`warrantyInput`: TextField numérico, textAlign center, font JetBrains Mono.

### Save bar (sticky)

`PositionedFooter` o `BottomAppBar` con `LinearGradient(transparent→bg)` por encima (efecto fade):

```dart
Container(
  padding: EdgeInsets.fromLTRB(22, 14, 22, 22),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [AppColors.bg.withOpacity(0), AppColors.bg],
      stops: [0, 0.6],
    ),
  ),
  child: Row(children: [
    Expanded(child: HkButton(variant: ghost, label: 'Cancelar', onPressed: () => context.pop())),
    SizedBox(width: 10),
    Expanded(child: HkButton(icon: check, label: 'Guardar', onPressed: _save)),
  ]),
)
```

### Lógica de gate (Free plan)

Antes de mostrar `add`, el provider de paywall (`isProProvider`) decide:

```dart
if (!isPro && items.length >= 5) {
  context.push('/paywall'); // gate state
  return;
}
```

(Ya existe esta lógica en el código actual — verifica que sigue funcionando.)

### Validación

- `name` requerido (mínimo 1 char).
- `warrantyM` opcional, debe ser entero ≥ 0.
- Si validación falla, muestra `SnackBar` con `colorScheme.error` y los strings de error.

## Strings nuevos (ARB)

```json
"items_title": "Mis cosas",
"items_count": "{n} elementos",
"items_count_free": "{n}/5",
"items_empty_title": "Aún no hay nada por aquí",
"items_empty_sub": "Tu caldera, la lavadora, el coche… cualquier cosa con un mantenimiento o garantía.",
"items_add": "Añadir cosa",
"items_filter_all": "Todo",
"items_warranty_active": "Garantía activa",
"item_detail_warranty": "Garantía",
"item_detail_purchased_on": "Comprado el {date}",
"item_detail_until": "hasta el {date}",
"item_detail_maintenances": "Mantenimientos",
"item_detail_history": "Historial",
"item_detail_mark_done": "Marcar como hecho",
"item_detail_add_maint": "Añadir",
"add_item_title": "Nuevo elemento",
"edit_item_title": "Editar",
"add_field_name": "Nombre",
"add_field_brand": "Marca y modelo",
"add_field_category": "Categoría",
"add_field_purchased": "Fecha de compra",
"add_field_warranty": "Garantía (meses)",
"add_field_notes": "Notas",
"add_save": "Guardar",
"add_cancel": "Cancelar",
"add_photo_camera": "Cámara",
"add_photo_gallery": "Galería"
```

## Criterios de aceptación

- [ ] Lista: filtros funcionan, cards navegan, contador correcto Free vs Pro.
- [ ] Detail: hero photo a full bleed, category tile overlapping bien (no clipped), warranty progress correcto.
- [ ] Mark-done CTA en cada maintenance card → abre el sheet (Fase 7).
- [ ] Add form: validación pasa, datos llegan al repository, navegación tras guardar regresa a lista con la card nueva visible.
- [ ] Gate Free: al intentar añadir 6º item, redirige a `/paywall` con state `gate`.
- [ ] Date picker abre en español si locale = es.
- [ ] Photo picker: cámara + galería funcionan (la lógica ya existe; solo verifica wiring).
