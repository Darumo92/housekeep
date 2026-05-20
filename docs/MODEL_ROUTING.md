# HouseKeep — Model Routing / Uso de modelos

Guia operativa para elegir modelo y variante de razonamiento en Codex/OpenCode durante el desarrollo de HouseKeep.

## Inventario de modelos detectados

Deteccion realizada el 2026-05-20 usando:

- `~/.codex/models_cache.json` para modelos Codex/OpenAI disponibles en Codex.
- `opencode models opencode-go` para modelos OpenCode Go.
- Configuracion actual de Codex: modelo activo `gpt-5.5`, razonamiento `medium`.

### OpenAI / Codex disponibles

| Modelo | Nombre visible | Variantes detectadas | Uso recomendado |
|--------|----------------|----------------------|-----------------|
| `gpt-5.5` | GPT-5.5 | `low`, `medium`, `high`, `xhigh` | Arquitectura, revisiones, migraciones, pagos, notificaciones, widgets nativos, bugs dificiles |
| `gpt-5.4` | gpt-5.4 | `low`, `medium`, `high`, `xhigh` | Modelo diario para implementacion Flutter/Riverpod/Drift con buen equilibrio calidad-coste |
| `gpt-5.4-mini` | GPT-5.4-Mini | `low`, `medium`, `high`, `xhigh` | Cambios mecanicos, lint, tests repetitivos, copy, traducciones, UI local simple |
| `gpt-5.3-codex` | gpt-5.3-codex | `low`, `medium`, `high`, `xhigh` | Fallback coding si `gpt-5.4` no esta disponible; reemplazado preferentemente por `gpt-5.4` |
| `gpt-5.2` | gpt-5.2 | `low`, `medium`, `high`, `xhigh` | Fallback para sesiones largas; no usar como primera opcion si `gpt-5.4`/`gpt-5.5` estan disponibles |
| `codex-auto-review` | Codex Auto Review | `low`, `medium`, `high`, `xhigh` | Modelo oculto de revision automatica; no usar como perfil manual |

### OpenCode Go disponibles

`opencode models opencode-go` detecto estos modelos:

| Modelo | Variantes de razonamiento detectadas | Uso recomendado |
|--------|--------------------------------------|-----------------|
| `opencode-go/deepseek-v4-flash` | No expuestas por el CLI | Volumen barato, fixes pequenos, busqueda, resumen, cambios mecanicos |
| `opencode-go/deepseek-v4-pro` | No expuestas por el CLI | Implementacion no critica, refactors localizados, segunda opinion barata |
| `opencode-go/glm-5` | No expuestas por el CLI | Analisis general de bajo riesgo |
| `opencode-go/glm-5.1` | No expuestas por el CLI | Analisis general de bajo riesgo |
| `opencode-go/kimi-k2.5` | No expuestas por el CLI | Lectura de contexto largo no critico, resumen de docs/diffs |
| `opencode-go/kimi-k2.6` | No expuestas por el CLI | Lectura de contexto largo no critico, resumen de docs/diffs |
| `opencode-go/mimo-v2.5` | No expuestas por el CLI | Cambios pequenos, copy, tareas repetitivas |
| `opencode-go/mimo-v2.5-pro` | No expuestas por el CLI | Implementacion simple no critica |
| `opencode-go/minimax-m2.5` | No expuestas por el CLI | Copy, ASO, textos, prompts, documentacion ligera |
| `opencode-go/minimax-m2.7` | No expuestas por el CLI | Copy, ASO, textos, prompts, documentacion ligera |
| `opencode-go/qwen3.5-plus` | No expuestas por el CLI | UI simple, componentes locales, tests repetitivos |
| `opencode-go/qwen3.6-plus` | No expuestas por el CLI | UI simple, implementacion media no critica, exploracion de alternativas |

Nota: OpenCode Go no expuso `low`/`medium`/`high`/`xhigh` en el listado CLI. Para esos modelos, la columna de variante se considera `n/a`; la intensidad se controla limitando el alcance del ticket y usando prompts mas o menos estrictos. Las fases criticas deben usar Codex/OpenAI aunque haya modelos Go disponibles.

## Resumen ejecutivo

| Perfil | Modelo | Variante | Uso |
|--------|--------|----------|-----|
| Diario por defecto | `gpt-5.4` | `medium` | Implementacion normal Flutter, CRUD, UI, providers sencillos |
| Barato para volumen | `gpt-5.4-mini` | `low` | Lint, tests repetitivos, traducciones, copy, cambios localizados |
| Barato fuera de Codex | `opencode-go/deepseek-v4-flash` | `n/a` | Tareas mecanicas sin riesgo arquitectonico |
| UI | `gpt-5.4` | `medium` | Pantallas, formularios, widgets Flutter con estado limitado |
| Revision | `gpt-5.5` | `high` | Revision multiarchivo, diffs antes de merge, bugs sutiles |
| Fases criticas | `gpt-5.5` | `high` | Drift, notificaciones, RevenueCat, widgets nativos, release |
| Emergencia | `gpt-5.5` | `xhigh` | Bugs dificiles, pagos, migraciones, problemas iOS/Android cruzados |

Usar Codex/OpenAI cuando importe el razonamiento, la seguridad arquitectonica, el entendimiento multiarchivo o el comportamiento dificil de revertir. Usar OpenCode Go o `gpt-5.4-mini` para volumen barato, tareas mecanicas, redaccion, tests repetitivos y cambios con bajo radio de impacto.

## Tabla por fase

| Fase | Riesgo | Modelo principal recomendado | Variante principal | Modelo secundario o revisor | Variante del revisor | Subtareas con modelo barato | Subtareas reservadas para Codex/OpenAI fuerte | Motivo |
|------|--------|------------------------------|--------------------|-----------------------------|----------------------|-----------------------------|----------------------------------------------|--------|
| 0 Setup | Alto | `gpt-5.4` | `high` | `gpt-5.5` | `high` | Estructura de carpetas, ARB iniciales, `.gitignore`, assets | Firebase, drift setup, bundle IDs, iOS/Android config, build inicial | Errores de setup se arrastran a todo el proyecto y mezclan plataforma, tooling y arquitectura |
| 1 Data Layer | Alto | `gpt-5.5` | `high` | `gpt-5.5` | `high` | Labels de enums, factories simples, tests repetitivos | Esquema Drift, DAOs, repositories, calculos de fechas, providers base | Base persistente y queries afectan todas las features; bugs de fechas son sutiles |
| 2 Items | Medio | `gpt-5.4` | `medium` | `gpt-5.5` | `high` | Cards, empty states, formularios simples, filtros visuales | Photo storage, compresion, borrado con cascada, gate free de 6to item | CRUD normal, pero fotos y limites freemium cruzan UI, data y servicios |
| 3 Mantenimiento | Alto | `gpt-5.5` | `high` | `gpt-5.5` | `high` | UI de listas, copy de plantillas, tests parametrizados | Recalculo `nextDueAt`, historial, plantillas PRO, parsing JSON, urgencia | La logica de recurrencia y plantillas es central para el valor de la app |
| 4 Documentos | Medio | `gpt-5.4` | `high` | `gpt-5.5` | `high` | Lista, empty state, selector de tipo, textos | Semaforo de caducidad, photo/scan, gate free de 4to documento | Menor complejidad que mantenimiento, pero fecha y limites deben ser correctos |
| 5 Home Dashboard | Alto | `gpt-5.4` | `high` | `gpt-5.5` | `high` | Cards visuales, iconos, FAB simple | Query unificada, timeline, Riverpod combinado, navegacion desde eventos | Agrega mantenimientos, documentos y garantias; alto riesgo de estados inconsistentes |
| 6 Notificaciones | Critico | `gpt-5.5` | `high` | `gpt-5.5` | `xhigh` | Copy de mensajes, pantallas explicativas de permisos | Scheduling iOS/Android, timezone, permisos, cancelacion/reprogramacion, reboot receiver | Los fallos son dificiles de reproducir y afectan confianza del usuario |
| 7 Paywall y Premium | Critico | `gpt-5.5` | `high` | `gpt-5.5` | `xhigh` | Paywall UI, comparativa visual, microcopy | `PurchaseService`, RevenueCat, entitlement, restore, gates, precio dinamico | Pagos mal implementados causan perdida directa de ingresos y rechazos de store |
| 8 Onboarding + Settings | Medio | `gpt-5.4` | `medium` | `gpt-5.4` | `high` | Onboarding visual, copy, settings estaticos | Settings que toquen compra, notificaciones, idioma persistente | Mayormente UI, pero settings puede tocar servicios sensibles |
| 9 Widget pantalla inicio | Critico | `gpt-5.5` | `high` | `gpt-5.5` | `xhigh` | Diseno visual simple del widget, copy, iconos | WidgetKit, Glance, deep links, sincronizacion de datos, actualizacion periodica | Cruza Flutter, iOS, Android, datos compartidos y estado PRO |
| 10 Pulido + QA | Alto | `gpt-5.5` | `high` | `gpt-5.5` | `xhigh` | Fixes de lint, labels de accesibilidad repetitivos, ajustes visuales locales | Auditoria final, performance, accesibilidad, regresiones, tests E2E | El coste de detectar tarde una regresion es alto antes de release |
| 11 Store Prep + Submit | Critico | `gpt-5.5` | `high` | `gpt-5.5` | `xhigh` | Metadata ASO, screenshots copy, release notes | IAP real, signing, data safety, app privacy, RevenueCat produccion, submit | Rechazos de tienda y configuracion IAP incorrecta cuestan dias o semanas |

## Tabla por tipo de tarea

| Tipo de tarea | Modelo recomendado | Variante | Alternativa barata | Cuando subir de variante | Cuando bajar de variante |
|---------------|--------------------|----------|--------------------|--------------------------|--------------------------|
| Disenar un ticket | `gpt-5.5` | `high` | `gpt-5.4 medium` | Si toca pagos, migraciones, notificaciones o nativo | Si es pantalla aislada sin servicios |
| CRUD normal | `gpt-5.4` | `medium` | `gpt-5.4-mini medium` | Si toca mas de 5 archivos o repos/providers complejos | Si solo cambia formulario o UI local |
| UI local simple | `gpt-5.4-mini` | `medium` | `opencode-go/qwen3.6-plus n/a` | Si incluye navegacion, estado compartido o accesibilidad compleja | Si solo cambia estilos/copy |
| Formularios con validacion | `gpt-5.4` | `medium` | `gpt-5.4-mini medium` | Si guarda en DB o cruza limites freemium | Si es solo layout |
| Drift schema / migrations | `gpt-5.5` | `high` | Ninguna para trabajo principal | Subir a `xhigh` si cambia datos existentes o version de DB | Bajar solo para tests repetitivos despues del diseno |
| DAOs y queries | `gpt-5.5` | `high` | `gpt-5.4 high` | Si combina varias tablas o streams | Si es CRUD trivial ya cubierto por patron |
| Riverpod complejo | `gpt-5.5` | `high` | `gpt-5.4 high` | Si hay invalidacion, streams, caches o providers derivados | Si es provider simple de repository |
| Logica de fechas/urgencia | `gpt-5.5` | `high` | `gpt-5.4 high` | Si afecta notificaciones o dashboard | Si solo se anaden tests parametrizados |
| Fotos/storage local | `gpt-5.4` | `high` | `gpt-5.4 medium` | Si toca permisos, compresion o borrado cascada | Si solo muestra thumbnails |
| Notificaciones | `gpt-5.5` | `high` | Ninguna para trabajo principal | Subir a `xhigh` para permisos, timezone, reboot, bugs reales | Bajar solo para copy o UI explicativa |
| RevenueCat / entitlement | `gpt-5.5` | `xhigh` | Ninguna para diseno/revision | Mantener `xhigh` si toca productos reales o restore | Bajar a `high` para implementar despues de plan claro |
| Widget iOS/Android | `gpt-5.5` | `high` | Ninguna para integracion | Subir a `xhigh` si falla deep link, actualizacion o datos compartidos | Bajar para copy o layout visual no nativo |
| `flutter analyze` / lint | `gpt-5.4-mini` | `low` | `opencode-go/deepseek-v4-flash n/a` | Si el fix requiere cambiar arquitectura o APIs publicas | Mantener `low` si son imports, formatting, casts simples |
| Tests repetitivos | `gpt-5.4-mini` | `low` | `opencode-go/qwen3.5-plus n/a` | Si el test define comportamiento nuevo de negocio | Bajar si solo duplica patron existente |
| Revision de diff | `gpt-5.5` | `high` | `gpt-5.4 high` | Subir a `xhigh` antes de merge de fases criticas | Bajar si el diff es copy/documentacion |
| Bug dificil | `gpt-5.5` | `xhigh` | Ninguna para diagnostico principal | Mantener `xhigh` si no hay reproduccion clara | Bajar a `high` cuando la causa ya este aislada |
| ASO / store copy | `opencode-go/minimax-m2.7` | `n/a` | `gpt-5.4-mini low` | Subir a `gpt-5.5 high` si toca privacy, data safety o IAP | Bajar si solo reescribe textos |

## Reglas practicas

- Si toca Drift schema, migraciones o `app_database.dart`, usar `gpt-5.5 high`; usar `gpt-5.5 xhigh` si ya hay datos persistidos o versionado de migracion.
- Si toca RevenueCat, entitlement `housekeep_pro`, restore purchases, productos IAP o gates de pago, usar `gpt-5.5 high` para build y `gpt-5.5 xhigh` para plan/review.
- Si solo corrige `flutter analyze`, imports, formatting, nombres o warnings localizados, usar `gpt-5.4-mini low`.
- Si el cambio toca mas de 5 archivos, subir al menos a `high` aunque parezca CRUD.
- Si afecta iOS y Android, usar `gpt-5.5 high`; subir a `xhigh` si tambien toca permisos, deep links, signing, pagos o notificaciones.
- Si es solo UI local sin servicios, usar `gpt-5.4-mini medium` o `opencode-go/qwen3.6-plus`.
- Si combina UI, Riverpod y data layer, usar `gpt-5.4 high` como minimo.
- Si cambia calculos de fechas, recurrencia, caducidad, urgencia o notificaciones, usar `gpt-5.5 high`.
- Si es revision final antes de merge o fase cerrada, usar `gpt-5.5 high`.
- Si el bug no se reproduce, afecta estado global o hay comportamiento diferente entre plataformas, usar `gpt-5.5 xhigh`.
- No usar modelos baratos para pagos, migraciones, notificaciones, widgets nativos, release signing, App Store Connect o Google Play Console.

## Workflow recomendado por ticket

| Paso | Modo | Modelo | Variante | Reglas |
|------|------|--------|----------|--------|
| 1 | `plan` | `gpt-5.5` | `high` | Sin editar archivos de app; leer docs, definir alcance, riesgos, archivos y pruebas |
| 2 | `build` | `gpt-5.4` | `medium` | Implementacion controlada para tickets normales; subir a `high` si toca varias capas |
| 3 | `fixes` | `gpt-5.4-mini` | `low` | Solo lint, imports, tests repetitivos, copy o fallos mecanicos |
| 4 | `review` | `gpt-5.5` | `high` | Revision de diff, riesgos, tests faltantes y regresiones |
| 5 | `critical-review` | `gpt-5.5` | `xhigh` | Solo para pagos, notificaciones, widgets nativos, migraciones, release y bugs dificiles |

Flujo estandar:

1. `plan`: convertir la tarea en checklist tecnico pequeno y decidir modelo de build.
2. `build`: implementar el cambio minimo correcto.
3. `fixes`: resolver errores mecanicos de analyze/tests sin reabrir decisiones grandes.
4. `review`: revisar diff completo con foco en bugs, regresiones y tests.
5. `critical-review`: usar solo cuando el coste de equivocarse sea alto.

## Prompts reutilizables

### Disenar un ticket

```text
Actua en modo plan. Lee README.md, docs/PLAN.md, docs/ARCHITECTURE.md y docs/PHASE_CHECKLIST.md. Disena el ticket para [OBJETIVO] sin modificar codigo. Devuelve alcance, archivos probables, riesgos, tests y modelo recomendado segun docs/MODEL_ROUTING.md.
```

### Implementar un ticket

```text
Actua en modo build. Implementa [OBJETIVO] siguiendo docs/ARCHITECTURE.md, i18n en ARB, Riverpod con codegen y Drift segun corresponda. Haz el cambio minimo correcto, actualiza docs/PHASE_CHECKLIST.md si completas tareas y ejecuta las verificaciones relevantes.
```

### Revisar un diff

```text
Actua en modo review. Revisa el diff actual con foco en bugs, regresiones, seguridad de datos, i18n, Riverpod, Drift, pagos/notificaciones si aplica y tests faltantes. Ordena hallazgos por severidad con archivo y linea.
```

### Arreglar lint/tests

```text
Actua en modo fixes. Corrige solo errores de `flutter analyze` y tests fallidos. No refactorices, no cambies comportamiento salvo que sea necesario para restaurar la intencion del test. Si el fix requiere arquitectura, detente y pide subir de modelo.
```

### Auditar una fase critica

```text
Actua en modo critical-review. Audita la Fase [NOMBRE] completa contra docs/PLAN.md, docs/ARCHITECTURE.md, docs/DATA_MODEL.md y docs/PHASE_CHECKLIST.md. Prioriza errores dificiles de revertir, edge cases iOS/Android, persistencia, pagos, notificaciones, widgets nativos y store compliance.
```

### Decidir si subir o bajar de modelo

```text
Evalua esta tarea contra docs/MODEL_ROUTING.md: [TAREA]. Indica riesgo, capas afectadas, dificultad de rollback, probabilidad de bugs sutiles y modelo/variante minimo seguro. Si basta un modelo barato, explica por que. Si no, di exactamente que riesgo lo impide.
```

## Alertas: fases donde no ahorrar tokens

| Fase | No ahorrar porque |
|------|-------------------|
| Fase 0 Setup | Un error de bundle ID, Firebase, drift o estructura se propaga a todo el proyecto |
| Fase 1 Data Layer | Cambios de DB, DAOs y calculos de fechas son base de todas las features |
| Fase 3 Mantenimiento | Recurrencia, historial, plantillas y urgencia definen el valor principal de la app |
| Fase 6 Notificaciones | Fallos dependen de permisos, timezone, plataforma y lifecycle; son dificiles de reproducir |
| Fase 7 Paywall y Premium | Riesgo directo de ingresos, entitlement incorrecto y rechazo en tiendas |
| Fase 9 Widget pantalla inicio | Cruza Flutter, SwiftUI/WidgetKit, Android Glance, deep links y datos compartidos |
| Fase 10 Pulido + QA | Es la ultima barrera contra regresiones antes de release |
| Fase 11 Store Prep + Submit | IAP, signing, privacy y data safety pueden bloquear el lanzamiento |

## Configuracion sugerida: aliases mentales

| Alias | Modelo | Variante | Uso |
|-------|--------|----------|-----|
| `quick` | `gpt-5.4-mini` | `low` | Preguntas cortas, lint, copy, cambios pequenos |
| `cheap` | `opencode-go/deepseek-v4-flash` | `n/a` | Volumen barato fuera de tareas criticas |
| `daily` | `gpt-5.4` | `medium` | Implementacion normal del dia a dia |
| `ui` | `gpt-5.4` | `medium` | Pantallas Flutter, formularios, widgets locales |
| `review` | `gpt-5.5` | `high` | Revision multiarchivo, diffs antes de merge |
| `critical` | `gpt-5.5` | `high` | Fases de riesgo alto/critico, decisiones dificiles de revertir |
| `emergency` | `gpt-5.5` | `xhigh` | Bugs dificiles, pagos, notificaciones, nativo, release bloqueado |

## Politica de uso

- Empezar cada ticket con el alias `daily` salvo que la tabla indique otra cosa.
- Subir a `review` antes de cerrar cualquier ticket que toque data layer, pagos, notificaciones, widgets nativos o mas de 5 archivos.
- Subir a `critical` cuando haya cambios multi-capa o alto coste de rollback.
- Usar `emergency` solo cuando ya hay fallo dificil, bloqueo de release o riesgo financiero/store.
- Bajar a `quick` o `cheap` cuando el cambio sea mecanico, local, reversible y cubierto por tests.
- No mezclar implementacion critica y fixes baratos en la misma sesion sin una revision fuerte entre medias.
