# HouseKeep — Instrucciones para el agente

## Contexto del proyecto
Este es un proyecto Flutter para una app móvil freemium llamada HouseKeep.
Lee `README.md` para un resumen rápido y `/docs/` para la documentación completa.

## Archivos de referencia importantes
- `docs/PLAN.md` — Plan maestro con todas las decisiones
- `docs/ARCHITECTURE.md` — Estructura de carpetas, dependencias, convenciones de código, setup guides
- `docs/DATA_MODEL.md` — Esquema de DB, modelos, enums, plantillas JSON completas
- `docs/ASO_STRATEGY.md` — Store optimization (no relevante durante desarrollo)
- `docs/PHASE_CHECKLIST.md` — Tareas por fase. Úsalo para saber qué falta por hacer.

## Reglas de desarrollo

1. **Seguir la arquitectura definida:** No inventar nuevas carpetas o patrones. La estructura está en `docs/ARCHITECTURE.md`.
2. **Riverpod para todo el estado:** Providers con code generation (`@riverpod` annotation).
3. **Drift para la base de datos:** Tablas en archivos separados, DAOs, `build_runner`.
4. **i18n obligatorio:** Toda string visible al usuario va en ARB files (`core/l10n/`), nunca hardcoded.
5. **Tema centralizado:** Colores de `app_colors.dart`, nunca colores inline.
6. **PurchaseService abstracto:** Nunca importar RevenueCat directamente en features.
7. **Tests mínimos:** Unit tests para repositories y lógica de negocio (fechas, urgencia, límites).
8. **Commits atómicos:** Un commit por funcionalidad completada, no por archivo.

## Convenciones
- Archivos: `snake_case.dart`
- Clases: `PascalCase`
- Providers: `camelCaseProvider`
- Imports: relativos dentro del proyecto
- Null safety: strict, sin `!` innecesario

## Al empezar una sesión nueva
1. Lee este archivo
2. Lee `docs/PHASE_CHECKLIST.md` para ver qué fase está en progreso
3. Pregunta al usuario "¿Continuamos con la Fase X?" si no queda claro
4. Trabaja en las tareas de esa fase en orden
5. Marca las tareas completadas en `PHASE_CHECKLIST.md` al terminar cada tarea (no al final de la sesión, sino inmediatamente al completarla)

## Al terminar una sesión
1. **Actualizar `docs/PHASE_CHECKLIST.md`** con el progreso real (tareas completadas marcadas con [x])
2. Si surgieron tareas nuevas no previstas, añadirlas al checklist en la fase correspondiente
3. Si algo del plan cambió (nuevo campo en DB, nueva dependencia, decisión de diseño), actualizar el doc relevante en `/docs/`
4. Actualizar la tabla de "Estado" en `README.md` si se completó una fase entera
