# Fase 4 — Home dashboard

> **Esfuerzo estimado:** 2 días. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:** `lib/features/home/home_screen.dart` + widgets en `lib/features/home/widgets/`.
> **Referencia visual:** `reference/Housekeep.html` → screen `home` (populated y empty).

## Objetivo

Rediseñar el dashboard para que sea la pantalla más informativa de un vistazo: greeting, triplete de stats con semáforo, timeline cronológico de los próximos 6 eventos, y card de upsell Pro (solo si plan == free).

## Estructura

`Scaffold` con `HkTabBar` en bottom y `HkFab` (icono `add_rounded` → ruta `/items/add`).

Body en `ListView` (no Column con scroll, importa el bottom-padding para que el FAB no tape contenido):

```
┌───────────────────────────────────────┐
│ HEADER (padding 12 22 18)             │
│  Buenas tardes,           [ M ]       │ ← saludo + avatar 44 circulo primarySoft
│  Marta                                │ ← H1 (28, w600, Inter)
│  Esto es lo que pide atención         │ ← bodyMedium textMuted
├───────────────────────────────────────┤
│ SUMMARY TRIPLET (padding 0 18, gap 10)│
│  [stat]  [stat]  [stat]               │ ← 3× HkSummaryStat en GridView (3 col)
├───────────────────────────────────────┤
│ Próximos eventos          Ver todo →  │ ← H2 + link primary
│                                       │
│ [timeline card]                       │ ← lista de 6 TimelineRow
│ [timeline card]                       │
│ ...                                   │
├───────────────────────────────────────┤
│ UPSELL CARD (si plan == free)         │ ← gradient primary→accent
│  [✨] Pásate a Pro por €5,99   [Ver]  │
└───────────────────────────────────────┘
```

Bottom padding del ListView: 100 (para no tapar el FAB).

## Componentes específicos

### `_GreetingHeader`

```dart
Row(children: [
  Expanded(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${l10n.home_greeting},', style: bodySmall.copyWith(color: AppColors.textMuted)),
      Text(userName, style: displaySmall), // 28px w600, lineHeight 1.05
    ],
  )),
  Container( // avatar
    width: 44, height: 44,
    decoration: BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
    alignment: Alignment.center,
    child: Text(userName[0], style: titleMedium.copyWith(color: AppColors.primary)),
  ),
]),
```

El `userName` viene de un provider nuevo (o `Settings.userName ?? 'Hola'`). Si no hay aún, usa "Hola".

### `_SummaryTriplet`

Tres `HkSummaryStat` en row con `Expanded` o `GridView.count(crossAxisCount: 3)`:

| Stat | N | Label | Tone |
|------|---|-------|------|
| 1 | `upcoming.where(overdue/due).count` | "Pendientes" / "Due" | danger |
| 2 | `upcoming.where(soon).count` | "Esta semana" / "This week" | warn |
| 3 | `total - due - soon` (clamped ≥0) | "Al día" / "On track" | ok |

### `_TimelineSection`

Header con título "Próximos eventos" + link "Ver todo →" (color `primary`, fontSize 13, w600) que navega a `/items`.

Lista (sin separators, solo `gap 10`):

```dart
ListView.separated(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(), // hereda del ListView padre
  separatorBuilder: (_, __) => const SizedBox(height: 10),
  itemBuilder: (context, i) => _TimelineRow(item: upcoming[i]),
)
```

### `_TimelineRow`

```
┌─────────────────────────────────────┐
│ [icon 44] Revisión anual    [pill]  │
│           Caldera de gas            │
└─────────────────────────────────────┘
```

- HkCard con onTap.
- Leading: `HkCategoryTile(size: 44, category: item.cat)` si es mantenimiento; o un container `primarySoft` 44×44 radio 12 con icono de documento si es doc.
- Centro: título 14.5 w600 + sub 12.5 textMuted (con elipsis).
- Trailing: `HkStatusPill` con label calculada por días (`hoy`, `mañana`, `en 4d`, `hace 3d`, etc.).

**Lógica de cálculo de label de días** (ya existe en `date_extensions.dart`, pero verifica que devuelva los strings cortos del prototipo):

```
days == 0 → "hoy"
days == 1 → "mañana"
days > 1  → "en ${days}d"
days == -1 → "ayer"
days < -1 → "hace ${-days}d"
```

### `_ProUpsellCard`

Solo si `plan == free`. `HkCard` con decoración custom:

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85), AppColors.accent],
      stops: [0.0, 0.6, 1.0],
    ),
    borderRadius: BorderRadius.circular(AppRadii.card),
  ),
  padding: const EdgeInsets.all(16),
  child: Row(children: [
    Container(size 44, bg white@0.18, icon auto_awesome white),
    SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: start, children: [
      Text('Pásate a Pro por €5,99', white w700 14.5),
      SizedBox(height: 2),
      Text('Sin límites · pago único · para siempre', white@0.85 12.5),
    ])),
    HkButton(label: 'Ver', variant: HkButtonVariant.primary, size: HkButtonSize.sm,
      // override colors: bg white, fg primary
    ),
  ]),
)
```

## Estado vacío

Si `items.isEmpty && docs.isEmpty`, renderiza un layout completamente distinto:

```
┌───────────────────────────────────────┐
│                                       │
│         [ home cluster art ]          │ ← reusa OnboardingArt.homeCluster
│                                       │
│  Empieza por lo más importante        │ ← H1 centrado
│  Añade tu primer electrodoméstico…    │ ← body textMuted
│                                       │
│      [+ Añadir mi primera cosa]       │ ← HkButton lg
└───────────────────────────────────────┘
```

Padding lateral 28, vertical 40 top / 100 bottom.

## Datos / providers

El home ya tiene un provider (`homeProvider` o similar). Asegúrate de exponer:

```dart
class HomeData {
  final String greeting; // "Buenos días" / "Buenas tardes" según hora
  final String userName;
  final int dueCount, soonCount, okCount;
  final List<UpcomingEvent> upcoming; // limitado a 6
  final bool isPro;
  final bool isEmpty;
}
```

Si no expone `greeting` automático, calcula client-side:
```dart
final h = DateTime.now().hour;
final greeting = h < 12 ? 'Buenos días' : h < 20 ? 'Buenas tardes' : 'Buenas noches';
```

## Strings nuevos (ARB)

```json
"home_greeting_morning": "Buenos días",
"home_greeting_afternoon": "Buenas tardes",
"home_greeting_evening": "Buenas noches",
"home_subtitle": "Esto es lo que pide atención",
"home_summary_due": "Pendientes",
"home_summary_soon": "Esta semana",
"home_summary_ok": "Al día",
"home_upcoming_title": "Próximos eventos",
"home_see_all": "Ver todo",
"home_empty_title": "Empieza por lo más importante",
"home_empty_sub": "Añade tu primer electrodoméstico o documento y HouseKeep te avisará antes de que sea tarde.",
"home_empty_cta": "Añadir mi primera cosa",
"home_pro_upsell_title": "Pásate a Pro por €5,99",
"home_pro_upsell_sub": "Sin límites · pago único · para siempre",
"home_pro_upsell_cta": "Ver"
```

## Criterios de aceptación

- [ ] El FAB queda 88px del borde inferior (encima del tab bar).
- [ ] El triplete de stats nunca rebosa horizontalmente (verifica con números de 2 dígitos).
- [ ] La timeline acepta tap en cada row y navega a `/items/{id}` o `/documents`.
- [ ] La upsell card desaparece si `isPro == true`.
- [ ] Empty state aparece cuando no hay nada y ofrece CTA directo a `/items/add`.
- [ ] Pull-to-refresh implementado (`RefreshIndicator`) refresca el `homeProvider`.
- [ ] Greeting cambia según hora del día.
