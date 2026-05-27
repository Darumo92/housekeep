# Fase 8 — Paywall

> **Esfuerzo estimado:** 1 día. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:** `lib/features/paywall/paywall_screen.dart`.
> **Referencia visual:** prototipo → screen `paywall`, ambos estados (con y sin gate).

## Objetivo

Pantalla de venta clara, emocional, con price tag grande, lista de beneficios y CTA dominante. Soporta dos entradas:
1. **Directa** desde Settings → "Pasar a Pro" — sin gate banner.
2. **Gate** desde un intento bloqueado (6º item, 4º documento, exportar PDF…) — con banner explicativo.

## Layout

```
┌───────────────────────────────────────┐
│ HERO BAND (gradient primary → accent) │
│ [←]                            [PRO]  │ ← back + chip "PRO"
│                                       │
│ ┌─ banner gate (solo si gate=true) ─┐ │
│ │ 🔒 Has llegado al límite gratuito │ │
│ │ El plan gratuito incluye 5…       │ │
│ └───────────────────────────────────┘ │
│                                       │
│ Pasa a HouseKeep Pro                  │ ← H1 32 (Editorial: serif 42), w600
│ Un pago único. Para siempre.          │ ← opacity 0.85, 15
│                                       │
│ €5,99   · pago único                  │ ← 44 (Editorial: 52) w600 + sub
│                                       │
├───────────────────────────────────────┤  ← fin del hero band
│ BENEFITS (bg)                         │
│ [📦] Cosas y documentos ilimitados ✓  │ ← icono primarySoft + texto + check ok
│ [🔔] Múltiples avisos por elemento ✓  │
│ [✨] Widget de pantalla de inicio  ✓  │
│ [⇗] Exporta a PDF y comparte…      ✓  │
│ [🌿] Plantillas Pro: piscina…      ✓  │
├───────────────────────────────────────┤
│ STICKY CTA BAR                        │
│ [ ✨ Desbloquear Pro ]                │
│ Restaurar compra        Ahora no      │
└───────────────────────────────────────┘
```

`Scaffold(backgroundColor: AppColors.bg)`, **sin** `HkTabBar` ni `HkFab`.

## Hero band

```dart
Container(
  padding: EdgeInsets.fromLTRB(22, 18, 22, 36),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0, -1), end: Alignment(0.3, 1),
      colors: [AppColors.primary, AppColors.primary, AppColors.accent],
      stops: [0.0, 0.5, 1.0],
    ),
  ),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    // Top row
    Row(children: [
      IconButton(...back, bg: Colors.white.withOpacity(0.18)),
      Spacer(),
      Container(  // PRO chip
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text('PRO', style: labelSmall.copyWith(
          color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.5,
        )),
      ),
    ]),
    SizedBox(height: 22),
    
    // Gate banner (opcional)
    if (gate) GateBanner(),
    
    // Title
    Text('Pasa a HouseKeep Pro', style: displayLarge.copyWith(
      color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600, height: 1.05,
    )),
    SizedBox(height: 8),
    Text('Un pago único. Para siempre.', style: bodyLarge.copyWith(
      color: Colors.white.withOpacity(0.85),
    )),
    SizedBox(height: 22),
    
    // Price
    Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
      Text('€5,99', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Inter')),
      SizedBox(width: 8),
      Text('· pago único', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
    ]),
  ]),
)
```

**Importante:** el precio (`€5,99`) debe venir del paquete RevenueCat (`Package.storeProduct.priceString`), no hardcodeado. El hardcoded es solo placeholder. En producción usa:

```dart
final offering = ref.watch(currentOfferingProvider);
final priceString = offering?.lifetime?.storeProduct.priceString ?? '€5,99';
```

## Gate banner

```dart
Container(
  margin: EdgeInsets.only(bottom: 16),
  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: BorderRadius.circular(AppRadii.btn),
  ),
  child: Row(children: [
    Icon(Icons.lock_outline_rounded, size: 16, color: Colors.white),
    SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Has llegado al límite gratuito', style: titleSmall.copyWith(color: Colors.white)),
      SizedBox(height: 2),
      Text('El plan gratuito incluye 5 cosas y 3 documentos. Pasa a Pro para no tener límites.',
        style: bodySmall.copyWith(color: Colors.white.withOpacity(0.85), fontSize: 12)),
    ])),
  ]),
)
```

## Lista de beneficios

```dart
final benefits = [
  (Icons.inventory_2_rounded, 'Cosas y documentos ilimitados'),
  (Icons.notifications_rounded, 'Múltiples avisos por elemento'),
  (Icons.auto_awesome_rounded, 'Widget de pantalla de inicio'),
  (Icons.share_rounded, 'Exporta a PDF y comparte con tu pareja'),
  (Icons.local_florist_rounded, 'Plantillas Pro: piscina, jardín, placas solares'),
];

Padding(
  padding: EdgeInsets.fromLTRB(22, 22, 22, 8),
  child: Column(children: [
    for (final (icon, text) in benefits)
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadii.card * 0.45),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          SizedBox(width: 14),
          Expanded(child: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(text, style: bodyMedium.copyWith(
              fontWeight: FontWeight.w500, height: 1.4,
            )),
          )),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_rounded, size: 18, color: AppColors.ok),
          ),
        ]),
      ),
  ]),
)
```

## Sticky CTA bar

```dart
Container(
  padding: EdgeInsets.fromLTRB(22, 14, 22, 22 + MediaQuery.of(context).padding.bottom),
  decoration: BoxDecoration(
    color: AppColors.bg,
    border: Border(top: BorderSide(color: AppColors.border, width: 1)),
  ),
  child: Column(children: [
    HkButton(
      icon: Icons.auto_awesome_rounded,
      label: 'Desbloquear Pro',
      variant: HkButtonVariant.primary,
      size: HkButtonSize.lg,
      full: true,
      onPressed: _purchase,
    ),
    SizedBox(height: 10),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextButton(onPressed: _restore, child: Text('Restaurar compra',
          style: bodySmall.copyWith(color: AppColors.textMuted))),
        TextButton(onPressed: () => context.pop(), child: Text('Ahora no',
          style: bodySmall.copyWith(color: AppColors.textMuted))),
      ]),
    ),
  ]),
)
```

Estructura general del Scaffold:

```dart
Scaffold(
  body: Column(children: [
    Expanded(child: SingleChildScrollView(child: Column(children: [
      heroBand,
      benefitsList,
    ]))),
    stickyCTABar, // siempre visible
  ]),
)
```

## Lógica de compra

Toca `_purchase` → ya existe lógica con `purchase_service.dart`. Verifica que:

```dart
Future<void> _purchase() async {
  try {
    HapticFeedback.lightImpact();
    setState(() => loading = true);
    final success = await ref.read(purchaseServiceProvider).purchasePro();
    if (success && mounted) {
      // analytics
      ref.read(analyticsServiceProvider).logEvent('paywall_purchased', {'gate': widget.gate});
      context.go('/'); // vuelve a home, ahora es Pro
    }
  } catch (e) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No se pudo completar la compra. Inténtalo de nuevo.')),
    );
  } finally {
    setState(() => loading = false);
  }
}
```

Mientras `loading == true`, muestra `CircularProgressIndicator` blanco dentro del CTA en lugar del label.

## Strings nuevos (ARB)

```json
"paywall_title": "Pasa a HouseKeep Pro",
"paywall_subtitle": "Un pago único. Para siempre.",
"paywall_once": "pago único",
"paywall_cta": "Desbloquear Pro",
"paywall_restore": "Restaurar compra",
"paywall_skip": "Ahora no",
"paywall_gate_title": "Has llegado al límite gratuito",
"paywall_gate_sub": "El plan gratuito incluye 5 cosas y 3 documentos. Pasa a Pro para no tener límites.",
"paywall_benefit_unlimited": "Cosas y documentos ilimitados",
"paywall_benefit_multi_reminder": "Múltiples avisos por elemento",
"paywall_benefit_widget": "Widget de pantalla de inicio",
"paywall_benefit_pdf": "Exporta a PDF y comparte con tu pareja",
"paywall_benefit_templates": "Plantillas Pro: piscina, jardín, placas solares",
"paywall_purchase_error": "No se pudo completar la compra. Inténtalo de nuevo.",
"paywall_purchase_restored": "Compra restaurada"
```

## Criterios de aceptación

- [ ] Hero band con gradient primary→accent visible.
- [ ] Banner del gate solo cuando se entra con `gate=true`.
- [ ] Precio formato con la locale (`€5,99` en es, `€5.99` en en).
- [ ] Tap en CTA → llama a `purchaseServiceProvider.purchasePro()`, muestra loader y maneja success/error.
- [ ] Restaurar funcional.
- [ ] Status bar style ajustado (los iconos del status bar deben ser blancos sobre el hero gradient — usa `AnnotatedRegion<SystemUiOverlayStyle>` o setea `systemNavigationBarIconBrightness`).
- [ ] Tras compra exitosa: navega a `/` y la app muestra todos los gates desbloqueados.
- [ ] Analytics evento `paywall_viewed` y `paywall_purchased` (con/sin `gate`).
