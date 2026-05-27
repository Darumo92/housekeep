# Fase 7 — Mark-done bottom sheet

> **Esfuerzo estimado:** 1 día. **Depende de:** Fases 1, 2, 5.
> **Pantallas afectadas:** nuevo `lib/features/maintenance/widgets/mark_done_sheet.dart` + integración en `item_detail_screen.dart`.
> **Referencia visual:** prototipo → desde Item detail, tap en "Marcar como hecho" (o usa Tweaks → "Show mark-done sheet").

## Objetivo

Modal bottom sheet con la confirmación de "marcar mantenimiento como hecho", incluyendo:
1. Selector "¿Cuándo lo hiciste?" (Hoy / Ayer / Otra fecha)
2. Notas opcionales
3. Banner del próximo aviso calculado
4. Confirmación con animación de éxito y cierre automático.

## Trigger

Desde `ItemDetailScreen`, al pulsar el botón `Marcar como hecho` en una maintenance card:

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: AppColors.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
  ),
  builder: (_) => MarkDoneSheet(maintenance: m),
).then((completed) {
  if (completed == true) ref.invalidate(itemDetailProvider(itemId));
});
```

## Layout

```
                  ─                              ← drag handle 40×4 border
┌───────────────────────────────────────┐
│ Marcar como hecho                     │ ← H2 22 w600 (Editorial: serif 28)
│ Revisión anual                        │ ← bodyMedium textMuted
│                                       │
│ ¿CUÁNDO LO HICISTE?                   │ ← label uppercase textMuted
│ [ Hoy ] [ Ayer ] [ Otra fecha ]       │ ← 3-segment, active=primary
│                                       │
│ NOTAS (OPCIONAL)                      │
│ [ p.ej. cambié pieza X    ………… ]      │ ← textarea 2 rows
│                                       │
│ ┌─ banner primarySoft ─────────────┐  │
│ │ 🔔 Próximo aviso: en 12 meses    │  │
│ └──────────────────────────────────┘  │
│                                       │
│ [ ✓ Confirmar ]                       │ ← full width lg
└───────────────────────────────────────┘
```

Padding: 8 top (drag handle) → 22 lateral → 26 bottom (deja safe area).

## Estados

### Estado 1 — Formulario (inicial)

```dart
class _State {
  WhenOption when = WhenOption.today;   // today | yesterday | other
  DateTime? otherDate;                   // si other, abre date picker
  String notes = '';
}
```

**Drag handle:** Container centrado 40×4 radius 99 bg `border`, marginBottom 14.

**Header:** Title H2 + subtitle del nombre del mantenimiento.

**When selector (3 segmentos):** Row con 3 buttons expandidos:

```dart
Row(children: [
  for (final opt in [today, yesterday, other])
    Expanded(child: Padding(
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => setState(() => when = opt),
        style: ElevatedButton.styleFrom(
          backgroundColor: when == opt ? AppColors.primary : AppColors.surfaceAlt,
          foregroundColor: when == opt ? AppColors.onPrimary : AppColors.text,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.btn),
            side: when == opt
              ? BorderSide.none
              : BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: Text(label, style: titleSmall),
      ),
    )),
])
```

Si `when == WhenOption.other`, lanza `showDatePicker` automáticamente al pulsar.

**Notes:** `TextField(maxLines: 2)` con placeholder localizado.

**Próximo aviso banner:**
```dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppColors.primarySoft,
    borderRadius: BorderRadius.circular(AppRadii.btn),
  ),
  child: Row(children: [
    Icon(Icons.notifications_rounded, size: 18, color: AppColors.primary),
    SizedBox(width: 10),
    Expanded(child: Text.rich(TextSpan(children: [
      TextSpan(text: 'Próximo aviso: ', style: TextStyle(fontWeight: FontWeight.w700)),
      TextSpan(text: 'en 12 meses'),
    ]), style: bodySmall.copyWith(color: AppColors.primary))),
  ]),
)
```

El "en 12 meses" se calcula como `intervalDays / 30` redondeado, o formato más legible si encaja con la lógica existente (`MaintenanceIntervalCalculator` en el dominio).

**Confirmar button:** `HkButton(variant: primary, size: lg, full: true, icon: check, label: 'Confirmar')`.

### Estado 2 — Confirmado (post-tap)

Sustituye el contenido del sheet por una vista de éxito:

```dart
Column(mainAxisSize: MainAxisSize.min, children: [
  SizedBox(height: 30),
  AnimatedScale(  // animación pop
    scale: confirmed ? 1.0 : 0.4,
    duration: Duration(milliseconds: 350),
    curve: Curves.easeOutBack,
    child: Container(
      width: 72, height: 72,
      decoration: BoxDecoration(
        color: AppColors.okSoft, shape: BoxShape.circle,
      ),
      child: Icon(Icons.check_rounded, size: 36, color: AppColors.ok),
    ),
  ),
  SizedBox(height: 18),
  Text('¡Hecho!', style: displaySmall.copyWith(fontSize: 22)),
  SizedBox(height: 8),
  Text('Próximo aviso en 365 días', style: bodyMedium.copyWith(color: AppColors.textMuted)),
  SizedBox(height: 30),
])
```

Después de 1200ms, llama `Navigator.pop(context, true)`.

## Lógica de confirmación

```dart
Future<void> _confirm() async {
  final completionDate = switch (when) {
    WhenOption.today => DateTime.now(),
    WhenOption.yesterday => DateTime.now().subtract(Duration(days: 1)),
    WhenOption.other => otherDate ?? DateTime.now(),
  };
  
  // Persiste vía repository (ya existe)
  await ref.read(maintenancesRepoProvider).markDone(
    maintenanceId: maintenance.id,
    completedAt: completionDate,
    notes: notes.trim().isEmpty ? null : notes.trim(),
  );
  
  // Reprograma notificación
  await ref.read(notificationServiceProvider).rescheduleForMaintenance(maintenance.id);
  
  setState(() => confirmed = true);
  
  // Cierra tras animación
  await Future.delayed(Duration(milliseconds: 1200));
  if (mounted) Navigator.pop(context, true);
}
```

## Strings nuevos (ARB)

```json
"maint_sheet_title": "Marcar como hecho",
"maint_sheet_when": "¿Cuándo lo hiciste?",
"maint_when_today": "Hoy",
"maint_when_yesterday": "Ayer",
"maint_when_other": "Otra fecha",
"maint_sheet_notes_opt": "Notas (opcional)",
"maint_sheet_notes_hint": "p.ej. cambié pieza X",
"maint_sheet_next_label": "Próximo aviso",
"maint_sheet_next_in": "en {duration}",
"maint_sheet_confirm": "Confirmar",
"maint_sheet_done_title": "¡Hecho!",
"maint_sheet_done_sub": "Próximo aviso en {days} días"
```

## Criterios de aceptación

- [ ] Bottom sheet se abre con animación slide-up estándar de Material.
- [ ] Drag handle visible en el top.
- [ ] Selector de "cuándo" funciona, "Otra fecha" abre date picker.
- [ ] Notas opcionales se guardan.
- [ ] Banner muestra el próximo aviso correctamente calculado.
- [ ] Tras Confirmar: aparece estado de éxito con animación pop, espera 1.2s, cierra.
- [ ] Tras cerrar: la lista de mantenimientos en `ItemDetailScreen` se refresca, el mantenimiento confirmado pasa a "historial" y se reprograma la notificación.
- [ ] Cancelar (tap fuera o swipe down) **no** hace cambios en la BD.
- [ ] Feedback háptico al confirmar (`HapticFeedback.mediumImpact()`).
