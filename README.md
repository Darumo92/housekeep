# HouseKeep

App móvil freemium (iOS + Android) para gestión del mantenimiento del hogar, control de garantías y alertas de caducidad de documentos.

## Quick Context para nuevas sesiones

**Qué es:** App de utilidad del hogar con modelo de pago único (4,99 € lifetime unlock).

**Estado actual:** Fases 0-10 completadas. Fase 11 (Store prep) en curso: legales, metadata, assets, landing y screenshots Android listos; listing, formularios Play y release de producción pendientes. La cuenta Play parece antigua; confirmar en Play Console si exige prueba cerrada 12 testers/14 días.

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
| 2 | Items/Electrodomésticos (CRUD + fotos) | Completada |
| 3 | Mantenimiento (CRUD + plantillas) | Completada |
| 4 | Documentos (CRUD + semáforo) | Completada |
| 5 | Home Dashboard (timeline + resumen) | Completada |
| 6 | Notificaciones locales | Completada |
| 7 | Paywall + Premium (gates items/docs/widget/export PDF) | Completada |
| 8 | Onboarding + Settings | Completada |
| 9 | Widget pantalla inicio (Android; iOS pendiente Mac) | Completada (Android) |
| 10 | Pulido + QA (animaciones, accesibilidad, profile, memory) | Completada |
| 11 | Store prep + submit | En curso (legales + metadata + screenshots Android listos; submit pendiente) |

## Cómo continuar

Al iniciar una nueva sesión, decir algo como:
- "Continuamos con HouseKeep, estamos en la Fase X"
- El agente debe leer `docs/PHASE_CHECKLIST.md` para ver qué tareas faltan
- Y `docs/ARCHITECTURE.md` para la estructura y convenciones
- Para elegir modelo y variante, consultar `docs/MODEL_ROUTING.md`
