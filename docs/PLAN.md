# HouseKeep — Plan de Desarrollo

## Resumen del proyecto

**HouseKeep** es una app móvil freemium para iOS y Android que ayuda a los propietarios de vivienda a gestionar el mantenimiento del hogar, controlar garantías de electrodomésticos y recibir alertas antes de que caduquen sus documentos importantes.

### Propuesta de valor
"La app que cuida tu casa para que tú no tengas que recordar nada."

### Modelo de negocio
- **Freemium** con pago único de 4,99 € para desbloqueo completo (lifetime).
- Sin suscripciones.
- Entitlement único: `housekeep_pro` (non-consumable IAP).

### Público objetivo
- Propietarios de vivienda 28-55 años
- Familias
- Personas organizadas que quieren control de su hogar
- Mercado inicial: España + mercados de habla inglesa

---

## Decisiones técnicas confirmadas

| Aspecto | Decisión |
|---------|----------|
| Path del proyecto | `/home/darumo/Proyectos/housekeep` |
| Bundle ID | `com.housekeep.app` (iOS + Android) |
| Framework | Flutter 3.x |
| State management | Riverpod (riverpod + flutter_riverpod + riverpod_annotation) |
| Base de datos | SQLite via drift |
| Notificaciones | flutter_local_notifications + awesome_notifications |
| Pagos | RevenueCat abstraído tras PurchaseService + mock para desarrollo |
| Navegación | go_router |
| i18n | flutter_localizations + intl + ARB files (ES + EN) |
| Diseño | Material 3 custom: cálido, rounded, clean, minimal |
| Analytics | Firebase Analytics + Crashlytics |
| Fotos | image_picker + almacenamiento local |
| Widget | WidgetKit (iOS) + Glance (Android) — incluido en MVP |
| Plantillas | ~20 plantillas de mantenimiento preconfiguradas en JSON |
| Plataformas | iOS + Android simultáneo |
| Idiomas | Español + English desde v1.0 |

---

## Funciones gratuitas (Free)
- Hasta 5 items (electrodomésticos/servicios)
- Hasta 3 documentos
- Recordatorios básicos (1 alerta por item)
- 1 hogar
- Plantillas estándar (caldera, AC, filtro agua)

## Funciones premium (4,99 € lifetime)
- Items ilimitados
- Documentos ilimitados con fotos adjuntas
- Múltiples hogares
- Múltiples alertas por item (3 meses, 1 mes, 1 semana)
- Widget de pantalla de inicio
- Historial completo de mantenimientos realizados
- Exportación PDF
- Plantillas PRO (piscina, jardín, placas solares, etc.)
- Modo familia (compartir con pareja) — v1.2

## Model Routing / Uso de modelos

La matriz persistente de modelos y variantes por fase esta en `docs/MODEL_ROUTING.md`.

Resumen operativo:
- Modelo diario: `gpt-5.4 medium`.
- Volumen barato: `gpt-5.4-mini low` o `opencode-go/deepseek-v4-flash` para tareas no criticas.
- Revision: `gpt-5.5 high`.
- Fases criticas: `gpt-5.5 high`, con `gpt-5.5 xhigh` solo para pagos, notificaciones, widgets nativos, migraciones, release y bugs dificiles.

No usar modelos baratos para Drift/migrations, RevenueCat, notificaciones, widgets nativos, signing, IAP o revision final antes de submit.

---

## Fases de desarrollo

### Fase 0: Setup (Día 1-2)
- Instalar Flutter SDK
- Crear proyecto Flutter con `flutter create --org com.housekeep housekeep`
- Configurar estructura de carpetas
- Añadir todas las dependencias en `pubspec.yaml`
- Configurar tema Material 3 custom (colores, tipografía, shapes)
- Configurar i18n (ARB files ES + EN)
- Configurar drift (database, tablas, generación)
- Setup go_router con rutas iniciales
- Crear proyecto en Firebase Console
- Añadir Firebase a iOS y Android (google-services.json, GoogleService-Info.plist)
- Inicializar Firebase Analytics + Crashlytics

### Fase 1: Data Layer (Días 3-5)
- Definir tablas drift (items, maintenances, documents)
- Crear DAOs con queries CRUD
- Definir modelos de dominio (Item, Maintenance, Document)
- Crear enums (ItemCategory, DocumentType, IntervalType)
- Crear repositories
- Configurar Riverpod providers para repositories
- Tests unitarios de base de datos y repositories

### Fase 2: Items / Electrodomésticos (Días 6-10)
- Pantalla lista de items (grid/list view)
- Empty state bonito
- Pantalla añadir item (formulario completo)
- Selector de categoría con iconos
- Foto picker (cámara + galería)
- Almacenamiento local de fotos comprimidas
- Pantalla detalle de item
- Edición y borrado con confirmación
- Indicador visual de garantía (activa/vencida/sin garantía)

### Fase 3: Mantenimiento (Días 11-15)
- Modelo de mantenimiento vinculado a items
- Pantalla de mantenimientos de un item
- Añadir mantenimiento (nombre, intervalo, fecha)
- Marcar mantenimiento como realizado (recalcula próximo)
- Historial de realizaciones
- Plantillas pre-configuradas (~20 desde JSON)
- Sugerencia de plantillas al crear item según categoría
- Carga y parsing de maintenance_templates.json

### Fase 4: Documentos (Días 16-19)
- Pantalla lista de documentos
- Añadir documento (tipo, nombre, fecha caducidad, foto)
- Semáforo visual: verde (>3 meses), amarillo (1-3 meses), rojo (<1 mes / vencido)
- Tipos predefinidos por país (ES: DNI, pasaporte, carnet conducir, ITV, seguro hogar, seguro coche, seguro vida)
- Edición y borrado

### Fase 5: Home Dashboard (Días 20-23)
- Timeline cronológico de próximos eventos (mantenimientos + vencimientos)
- Resumen visual con contadores (items totales, pendientes, urgentes)
- Cards tipo semáforo agrupadas por urgencia
- FAB con menú contextual (+ Item, + Mantenimiento, + Documento)
- Empty state para primer uso (guía hacia onboarding)
- Pull-to-refresh / actualización de estados

### Fase 6: Notificaciones (Días 24-27)
- Configurar flutter_local_notifications (iOS + Android)
- Crear canal de notificación dedicado (Android)
- Solicitar permisos (iOS + Android 13+)
- Programar notificación al crear/editar mantenimiento
- Programar notificación al crear/editar documento
- Reprogramar automáticamente al marcar como realizado
- Configuración: días de antelación por item/documento
- Premium: múltiples notificaciones (3 meses + 1 mes + 1 semana)
- Cancelar notificaciones al eliminar items/docs

### Fase 7: Paywall y Premium (Días 28-31)
- Definir interfaz PurchaseService abstracta
- Implementar PurchaseServiceMock (siempre free, toggle en dev)
- Implementar PurchaseServiceRevenueCat
- PurchaseRepository con estado de entitlement
- Riverpod provider `isProProvider`
- Pantalla paywall con lista de beneficios y CTA
- Lógica de gate: al intentar añadir 6to item o 4to documento → paywall
- Botón "Restaurar compra" en paywall y settings
- Configuración en RevenueCat Dashboard (cuando estén los productos)

### Fase 8: Onboarding + Settings (Días 32-35)
- Onboarding 3 pantallas:
  1. "Tu casa tiene muchas cosas que cuidar" (problema)
  2. "HouseKeep te avisa antes de que sea tarde" (solución)
  3. "Empieza añadiendo tu primer electrodoméstico" (acción)
- Sugerencia de plantillas según tipo de vivienda (piso, casa, chalet)
- Persistir que ya se vio el onboarding
- Settings:
  - Idioma (ES/EN)
  - Notificaciones (on/off + defaults)
  - Restaurar compra
  - Sobre la app (versión)
  - Contacto / feedback
  - Política de privacidad (link)

### Fase 9: Widget de pantalla de inicio (Días 36-39)
- iOS: WidgetKit con home_widget package
- Android: Glance (Jetpack) via home_widget
- Contenido: próximos 3 mantenimientos/vencimientos
- Diseño coherente con la app
- Actualización periódica del widget
- Deep link desde widget → pantalla relevante

### Fase 10: Pulido y QA (Días 40-43)
- Animaciones de transición entre pantallas
- Hero animations en fotos
- Haptic feedback en acciones importantes
- Responsive para tablets
- Edge cases: sin permisos foto, storage lleno, muchos items
- Tests de integración end-to-end
- Performance profiling (jank, memory)
- Accessibility (semantics labels, text scaling, contrast)
- App icon diseño final
- Splash screen con branding
- Dark mode (opcional si da tiempo)

### Fase 11: Store Prep (Días 44-48)
- Screenshots para ASO (6 capturas × 2 idiomas × 2 stores)
- Descripción optimizada ES + EN para ambas tiendas
- Feature graphic (Google Play)
- Privacy policy page (hosted)
- Crear app en App Store Connect
- Crear app en Google Play Console
- Crear productos IAP (non-consumable `housekeep_pro_lifetime`, 4,99 €)
- Conectar RevenueCat con ambas tiendas
- Configurar TestFlight (iOS beta)
- Configurar Internal Testing track (Android beta)
- Build release signed
- Submit para review en ambas tiendas

---

## Costes estimados

| Concepto | Coste |
|----------|-------|
| Apple Developer Account | €99/año |
| Google Play Console | €25 (una vez) |
| RevenueCat | Gratis hasta $2,500/mes revenue |
| Firebase (Spark plan) | Gratis |
| Dominio housekeep.app (o similar) | ~€15/año |
| Landing page (Carrd.co) | €9/año |
| **Total año 1** | **~€150** |

---

## Riesgos y mitigaciones

| Riesgo | Probabilidad | Mitigación |
|--------|-------------|------------|
| Baja frecuencia de uso diario | Alta | Widget + notificaciones útiles que traen de vuelta |
| Apple/Google integran funcionalidad | Baja (1-2 años) | La combinación 3-en-1 es difícil de replicar exactamente |
| Bundle ID no disponible | Baja | Alternativas: `com.housekeepapp.app`, `app.housekeep` |
| Dificultad de primeras descargas | Media | ASO desde día 1, contenido SEO, Reddit, Product Hunt |
| Reviews negativas por límite free | Media | Límite generoso (5 items cubre mayoría de hogares pequeños) |

---

## Validación previa (7 días, antes de desarrollo)

| Día | Acción |
|-----|--------|
| 1 | Landing page con email capture |
| 2 | Posts en Reddit (r/homeowners, r/homeimprovement, r/adulting) |
| 3 | Extraer reviews negativas de competidores |
| 4 | Google Ads test ($30): keywords exactas |
| 5 | Encuesta a 20 personas sobre el problema |
| 6 | Mockups de 3 pantallas clave, compartir en comunidades |
| 7 | Analizar resultados, decisión go/no-go |

**Criterio go:** ≥30 emails + CTR Ads >3% + ≥60% pagarían ≥€3

---

## Roadmap post-MVP

| Versión | Contenido |
|---------|-----------|
| v1.1 | Exportación PDF, mejoras UX basadas en feedback |
| v1.2 | Compartir hogar con pareja (modo familia), historial detallado |
| v2.0 | Backup en nube opcional, OCR de facturas, múltiples hogares |
| v2.1 | Dark mode, categorías personalizadas |
| v3.0 | Marketplace de profesionales (si hay tracción) — evaluar |
