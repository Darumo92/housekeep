# HouseKeep

App móvil freemium (iOS + Android) para gestión del mantenimiento del hogar, control de garantías y alertas de caducidad de documentos.

## Quick Context para nuevas sesiones

**Qué es:** App de utilidad del hogar con modelo de pago único (€5.99 lifetime unlock).

**Estado actual:** Fase 1 completada. Siguiente paso: Fase 2 (Items/Electrodomésticos).

**Documentación completa en `/docs/`:**
- `docs/PLAN.md` — Plan de desarrollo, fases, stack, costes, roadmap
- `docs/ARCHITECTURE.md` — Estructura de carpetas, dependencias, tema, navegación, setup Firebase/RevenueCat
- `docs/DATA_MODEL.md` — Esquema de base de datos, modelos, enums, plantillas JSON
- `docs/ASO_STRATEGY.md` — Keywords, metadata stores, screenshots, localización
- `docs/PHASE_CHECKLIST.md` — Checklist detallado con todas las tareas por fase
- `docs/MODEL_ROUTING.md` — Qué modelo Codex/OpenCode y razonamiento usar por fase/tipo de tarea

## Stack

| Aspecto | Tecnología |
|---------|-----------|
| Framework | Flutter 3.x |
| State | Riverpod |
| DB | SQLite (drift) |
| Navegación | go_router |
| Pagos | RevenueCat (abstracted, mock en dev) |
| Notificaciones | flutter_local_notifications |
| i18n | ARB files (ES + EN) |
| Analytics | Firebase Analytics + Crashlytics |
| Widget | home_widget (WidgetKit + Glance) |

## Decisiones clave

- **Bundle ID:** `com.housekeep.app`
- **Entitlement:** `housekeep_pro` (non-consumable, lifetime)
- **Límite free:** 5 items + 3 documentos
- **Diseño:** Material 3 custom, cálido, rounded, minimal
- **Sin backend** hasta v2.0 (todo local)
- **Plantillas:** ~20 mantenimientos preconfigurados en JSON (12 free + 8 pro)

## Fases de desarrollo

| Fase | Contenido | Estado |
|------|-----------|--------|
| 0 | Setup Flutter, dependencias, tema, i18n, drift, Firebase | Completada |
| 1 | Data layer (tablas, DAOs, repos, providers) | Completada |
| 2 | Items/Electrodomésticos (CRUD + fotos) | Pendiente |
| 3 | Mantenimiento (CRUD + plantillas) | Pendiente |
| 4 | Documentos (CRUD + semáforo) | Pendiente |
| 5 | Home Dashboard (timeline + resumen) | Pendiente |
| 6 | Notificaciones locales | Pendiente |
| 7 | Paywall + Premium | Pendiente |
| 8 | Onboarding + Settings | Pendiente |
| 9 | Widget pantalla inicio | Pendiente |
| 10 | Pulido + QA | Pendiente |
| 11 | Store prep + submit | Pendiente |

## Cómo continuar

Al iniciar una nueva sesión, decir algo como:
- "Continuamos con HouseKeep, estamos en la Fase X"
- El agente debe leer `docs/PHASE_CHECKLIST.md` para ver qué tareas faltan
- Y `docs/ARCHITECTURE.md` para la estructura y convenciones
- Para elegir modelo y variante, consultar `docs/MODEL_ROUTING.md`
