# Fase 9 — Settings

> **Esfuerzo estimado:** 1 día. **Depende de:** Fases 1, 2.
> **Pantallas afectadas:** `lib/features/settings/settings_screen.dart`.
> **Referencia visual:** prototipo → screen `settings`.

## Objetivo

Pantalla de ajustes con secciones agrupadas en cards, plan card destacada al top, y controles inline (toggle, language switcher) sin abrir sub-pantallas para los cambios simples.

## Layout

```
┌───────────────────────────────────────┐
│ Ajustes                               │ ← H1
│                                       │
│ ┌─ HkCard (especial) ───────────────┐ │
│ │ [✨] Plan gratuito         [Pasar │ │
│ │      5 cosas · 3 documentos a Pro]│ │
│ └───────────────────────────────────┘ │
│   - O si Pro -                        │
│ ┌─ gradient card ───────────────────┐ │
│ │ [✨] HouseKeep Pro          [Activo│ │
│ │      Todas las funciones desbloq…]│ │
│ └───────────────────────────────────┘ │
│                                       │
│ AVISOS                                │
│ ┌─ HkCard ──────────────────────────┐ │
│ │ [🔔] Notificaciones        [● on] │ │
│ │ [📅] Días de antelación 30 · 7 · 1│ │
│ └───────────────────────────────────┘ │
│                                       │
│ PREFERENCIAS                          │
│ ┌─ HkCard ──────────────────────────┐ │
│ │ [🌐] Idioma            [ES] [en]  │ │
│ │ [☀️] Tema                  [● off]│ │
│ └───────────────────────────────────┘ │
│                                       │
│ INFORMACIÓN                           │
│ ┌─ HkCard ──────────────────────────┐ │
│ │ [📄] Sobre la app           v1.0  │ │
│ │ [🔒] Política de privacidad     › │ │
│ │ [⇗] Contacto                    › │ │
│ └───────────────────────────────────┘ │
│                                       │
│ HOUSEKEEP · MADE WITH CARE            │ ← footer mono 11 textFaint
└───────────────────────────────────────┘
```

`Scaffold` con `HkTabBar` (current: `settings`). **Sin** FAB. ListView con bottom padding 100.

## Componentes

### Plan card (free)

```dart
HkCard(
  padding: EdgeInsets.all(18),
  child: Row(children: [
    Container(  // sparkle in soft circle
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadii.card * 0.5),
      ),
      child: Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
    ),
    SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Plan gratuito', style: titleMedium.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
      SizedBox(height: 2),
      Text('5 cosas · 3 documentos', style: bodySmall.copyWith(color: AppColors.textMuted)),
    ])),
    HkButton(
      label: 'Pasar a Pro',
      variant: HkButtonVariant.accent,
      size: HkButtonSize.sm,
      onPressed: () => context.push('/paywall'),
    ),
  ]),
)
```

### Plan card (Pro)

Mismo layout pero `Container` con gradient en lugar de `HkCard`:

```dart
Container(
  padding: EdgeInsets.all(18),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.accent],
    ),
    borderRadius: BorderRadius.circular(AppRadii.card),
  ),
  child: Row(children: [
    // mismo icono pero bg = white.withOpacity(0.18), fg white
    // textos en blanco / blanco@0.85
    // chip "Activo" bg white@0.25 text white
  ]),
)
```

### Section header

```dart
Padding(
  padding: EdgeInsets.fromLTRB(22, 6, 22, 6),
  child: Text(label.toUpperCase(), style: labelSmall.copyWith(
    fontSize: 11.5, fontWeight: FontWeight.w700,
    color: AppColors.textMuted, letterSpacing: 0.7,
  )),
)
```

### Settings row

```dart
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool chevron;
  final VoidCallback? onTap;
  
  // Row con:
  // - container 32×32 primarySoft con icon 16 primary
  // - label flex bodyLarge fontSize 14.5 w500
  // - trailing custom
  // - chevron rounded textFaint si chevron=true
  // - padding 16 14, bottom border 1px border (excepto última)
}
```

Las rows van **dentro de un HkCard con `padding: 0`**. Cada row tiene su propia border-bottom de `Divider(color: border, height: 1)` (excepto la última).

### Idioma switcher inline

Pildora con 2 segmentos:

```dart
Container(
  padding: EdgeInsets.all(4),
  decoration: BoxDecoration(
    color: AppColors.surfaceAlt,
    borderRadius: BorderRadius.circular(99),
  ),
  child: Row(mainAxisSize: MainAxisSize.min, children: [
    for (final locale in ['es', 'en'])
      GestureDetector(
        onTap: () => ref.read(localeProvider.notifier).set(locale),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: current == locale ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(locale.toUpperCase(), style: TextStyle(
            color: current == locale ? AppColors.onPrimary : AppColors.textMuted,
            fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.5,
          )),
        ),
      ),
  ]),
)
```

### Tema switcher (toggle)

`HkToggle` controlando `themeModeProvider`. Si toggle on → `ThemeMode.dark`, off → `ThemeMode.light`. **Para MVP es opcional**, puedes esconderlo si no implementas el modo oscuro completo.

### Días de antelación

Por ahora muestra valores hardcodeados separados por · (`30 · 7 · 1` para Pro, `30` para Free). Tap → futura pantalla de configuración (puedes hacer `chevron: true` y dejar el handler vacío con un TODO).

## Comportamiento de cada row

| Sección | Icono | Label | Trailing | Acción |
|---------|-------|-------|----------|--------|
| Avisos | `notifications` | "Notificaciones" | `HkToggle` | Cambia `notificationsEnabled` provider; si pasa a true pide permiso del sistema |
| Avisos | `calendar_today` | "Días de antelación" | "30 · 7 · 1" texto mono 13 | Tap → futura settings (TODO) |
| Preferencias | `language` | "Idioma" | Switcher ES/EN | Cambia locale, persiste en `SharedPreferences` |
| Preferencias | `light/dark_mode` | "Tema" | `HkToggle` | Cambia `themeMode` |
| Información | `description` | "Sobre la app" | "v1.0.0" mono 12 textFaint | Tap → about dialog |
| Información | `lock_outline` | "Política de privacidad" | chevron | Tap → abre URL en navegador |
| Información | `share` | "Contacto" | chevron | Tap → mailto: |

## Strings nuevos (ARB)

```json
"settings_title": "Ajustes",
"settings_plan_free": "Plan gratuito",
"settings_plan_pro": "HouseKeep Pro",
"settings_plan_free_sub": "5 cosas · 3 documentos",
"settings_plan_pro_sub": "Todas las funciones desbloqueadas",
"settings_upgrade": "Pasar a Pro",
"settings_pro_active": "Activo",
"settings_section_notifications": "Avisos",
"settings_section_preferences": "Preferencias",
"settings_section_info": "Información",
"settings_notifications": "Notificaciones",
"settings_lead_days": "Días de antelación",
"settings_language": "Idioma",
"settings_theme": "Tema",
"settings_about": "Sobre la app",
"settings_privacy": "Política de privacidad",
"settings_contact": "Contacto",
"settings_footer": "HOUSEKEEP · MADE WITH CARE"
```

## Criterios de aceptación

- [ ] Plan card cambia entre Free (HkCard normal con CTA accent) y Pro (gradient card con chip Activo).
- [ ] Toggle de notificaciones pide permisos al activarse (Android 13+, iOS).
- [ ] Idioma cambia instantáneamente todos los textos sin reiniciar.
- [ ] Toggle de tema oculto si MVP no soporta dark (deja TODO).
- [ ] "Política de privacidad" abre el URL definido en `app_constants.dart`.
- [ ] "Contacto" abre `mailto:hello@housekeep.app` o el correo definido.
- [ ] About dialog muestra version + build number (usar `package_info_plus`).
- [ ] Footer "HOUSEKEEP · MADE WITH CARE" en mono 11px `textFaint`, padding 24 bottom.

---

## Después de la Fase 9

Has terminado el rediseño. Próximos pasos opcionales:
1. **Tests de regresión visual:** regenera goldens, compara contra capturas del prototipo.
2. **Screenshots para stores:** vuelve a la Fase 11 del `docs/PLAN.md` original — ahora las capturas reales se ven mucho mejor.
3. **Dark mode pulido:** si lo dejaste para luego, completa `AppTheme.dark()` con la paleta `AppColorsDark` de `DESIGN_TOKENS.md`.
4. **Microanimaciones:** añade `AnimatedSwitcher` en los stat counters del home cuando cambia el número, `Hero` en las thumbnails de items, transiciones de página suaves vía `CustomTransitionPage` del go_router.
