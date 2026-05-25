# HouseKeep — Checklist por Fases

Marca cada tarea con [x] cuando esté completada.

---

## Fase 0: Setup del proyecto

### Flutter SDK
- [x] Instalar Flutter SDK (stable channel)
- [x] Verificar `flutter doctor` sin errores (Chrome/web falta, no bloquea)
- [x] Configurar Android SDK (API 34+)
- [x] Verificar Xcode + CocoaPods (si desarrollas en macOS)

### Creación del proyecto
- [x] `flutter create --org com.housekeep --project-name housekeep`
- [x] Verificar que compila en Android y Linux desktop
- [x] Configurar `.gitignore` apropiado
- [x] `git init` + primer commit

### Dependencias
- [x] Añadir todas las dependencias a `pubspec.yaml` — Firebase packages incluidos
- [x] `flutter pub get` sin errores
- [x] Configurar `analysis_options.yaml` con riverpod_lint

### Estructura de carpetas
- [x] Crear estructura completa de `/lib` según ARCHITECTURE.md
- [x] Crear carpeta `assets/templates/`
- [x] Crear carpeta `assets/images/`
- [x] Registrar assets en `pubspec.yaml`

### Tema y diseño
- [x] Crear `app_colors.dart` con paleta completa
- [x] Crear `app_typography.dart`
- [x] Crear `app_theme.dart` con ThemeData M3
- [x] Verificar tema en pantalla de test

### Internacionalización
- [x] Configurar `l10n.yaml`
- [x] Crear `app_en.arb` con strings iniciales
- [x] Crear `app_es.arb` con strings iniciales
- [x] Verificar que `flutter gen-l10n` funciona
- [x] Configurar MaterialApp con `localizationsDelegates`

### Base de datos (drift)
- [x] Crear tablas en archivos separados
- [x] Crear `app_database.dart`
- [x] Ejecutar `dart run build_runner build`
- [x] Verificar que genera sin errores

### Navegación
- [x] Configurar `go_router` con rutas iniciales
- [x] Crear BottomNavigationBar con 4 tabs (Home, Items, Documents, Settings)
- [x] Verificar navegación básica

### Firebase
- [x] Crear proyecto en Firebase Console — proyecto `housekeep-8715e`
- [x] Registrar app Android (com.housekeep.app) — **hecho en Firebase Console**
- [x] Registrar app iOS (com.housekeep.app) — **hecho en Firebase Console**
- [x] Descargar y colocar archivos de configuración — `google-services.json` → `android/app/`, `GoogleService-Info.plist` → `ios/Runner/`
- [x] Instalar FlutterFire CLI — `dart pub global activate flutterfire_cli`
- [x] Ejecutar `flutterfire configure` — generado `lib/firebase_options.dart` con credenciales reales
- [x] Inicializar Firebase en `main.dart` — funciona con config real + try/catch
- [x] Añadir `firebase_core`, `firebase_analytics`, `firebase_crashlytics` a `pubspec.yaml`
- [x] Verificar `flutter analyze` sin errores con código Firebase presente
- [x] Verificar que Analytics registra eventos — **requiere dispositivo/emulador real**

---

## Fase 1: Data Layer

### Modelos de dominio
- [x] Crear `Item` model (con factory fromDb / toCompanion)
- [x] Crear `Maintenance` model
- [x] Crear `Document` model
- [x] Crear `MaintenanceTemplate` model
- [x] Crear `UpcomingEvent` model (unificado para timeline)

### Enums
- [x] Crear `ItemCategory` enum con iconos y labels i18n
- [x] Crear `DocumentType` enum con labels i18n
- [x] Crear `UrgencyLevel` enum con colores
- [x] Crear `HomeType` enum (para plantillas)

### DAOs
- [x] Implementar `ItemsDao` (CRUD + count + watch)
- [x] Implementar `MaintenancesDao` (CRUD + markDone + watchUpcoming)
- [x] Implementar `DocumentsDao` (CRUD + count + watchExpiring)
- [x] Regenerar código con build_runner

### Repositories
- [x] Implementar `ItemsRepository`
- [x] Implementar `MaintenancesRepository`
- [x] Implementar `DocumentsRepository`
- [x] Implementar `PurchaseRepository` (interface)

### Providers (Riverpod)
- [x] Provider para AppDatabase (singleton)
- [x] Provider para cada DAO
- [x] Provider para cada Repository
- [x] Provider `isProProvider` (estado de compra)
- [x] Provider `canAddItemProvider` (check límite free)
- [x] Provider `canAddDocumentProvider`

### Tests
- [x] Unit test: ItemsDao CRUD
- [x] Unit test: MaintenancesDao markAsDone recalcula nextDueAt
- [x] Unit test: UrgencyLevel calculation
- [x] Unit test: Warranty expiry calculation

---

## Fase 2: Items (Electrodomésticos)

### Pantallas
- [x] `ItemsListScreen` con grid/list view
- [x] Empty state cuando no hay items
- [x] `AddEditItemScreen` formulario completo
- [x] `ItemDetailScreen` con info + mantenimientos

### Formulario de item
- [x] Campo: Nombre (obligatorio)
- [x] Campo: Categoría (selector con iconos)
- [x] Campo: Marca (opcional)
- [x] Campo: Modelo (opcional)
- [x] Campo: Fecha de compra (date picker)
- [x] Campo: Duración garantía en meses (número)
- [x] Campo: Foto (cámara / galería)
- [x] Campo: Notas (texto libre)
- [x] Validación de formulario
- [x] Guardar en base de datos

### Funcionalidad
- [x] Listar items ordenados por fecha de creación
- [x] Filtrar por categoría
- [x] Ver detalle de item
- [x] Editar item existente
- [x] Borrar item con confirmación (y sus mantenimientos)
- [x] Badge de garantía (activa/vencida/sin garantía)
- [x] Gate freemium: al intentar añadir 6to item → paywall

### Fotos
- [x] Image picker (cámara + galería)
- [x] Compresión de imagen antes de guardar
- [x] Guardar en app directory (path_provider)
- [x] Mostrar thumbnail en lista
- [x] Mostrar full en detalle
- [x] Borrar foto al borrar item

### Verificación
- [x] Resolver timeouts en `test/app_smoke_test.dart` para rutas/shell de items detectados al cerrar la Fase 2

---

## Fase 3: Mantenimiento

### Pantallas
- [x] `MaintenanceListScreen` (mantenimientos de un item)
- [x] `AddEditMaintenanceScreen` formulario
- [x] Sección de mantenimientos dentro de `ItemDetailScreen`

### Formulario
- [x] Campo: Nombre de la tarea
- [x] Campo: Descripción (opcional)
- [x] Campo: Intervalo en meses
- [x] Campo: Última vez realizado (date picker, opcional)
- [x] Campo: Días de antelación para notificación
- [x] Auto-cálculo de `nextDueAt`

### Plantillas
- [x] Crear `maintenance_templates.json` con ~20 plantillas
- [x] Parsear JSON al iniciar app
- [x] Pantalla/bottom sheet de selección de plantilla
- [x] Sugerir plantillas según categoría del item
- [x] Marcar plantillas PRO (solo accesibles con compra)
- [x] Auto-rellenar formulario desde plantilla

### Funcionalidad
- [x] Listar mantenimientos de un item
- [x] Añadir mantenimiento manual o desde plantilla
- [x] Marcar como realizado (recalcula próximo)
- [x] Editar mantenimiento
- [x] Borrar mantenimiento
- [x] Indicador visual de urgencia (semáforo)
- [x] Historial de realizaciones pasadas (campo `lastDoneAt` visible en tarjeta)

---

## Fase 4: Documentos

### Pantallas
- [x] `DocumentsListScreen` con lista y semáforo
- [x] `AddEditDocumentScreen` formulario
- [x] Empty state

### Formulario
- [x] Campo: Nombre (obligatorio)
- [x] Campo: Tipo de documento (selector)
- [x] Campo: Fecha de caducidad (date picker, obligatorio)
- [x] Campo: Días de antelación para notificación
- [x] Campo: Foto/scan (opcional)
- [x] Campo: Notas (opcional)
- [x] Validación

### Funcionalidad
- [x] Listar documentos ordenados por fecha de caducidad
- [x] Filtrar por tipo
- [x] Semáforo: verde (>90 días), amarillo (30-90), rojo (<30), vencido
- [x] Editar documento
- [x] Borrar documento con confirmación
- [x] Gate freemium: al intentar añadir 4to documento → paywall

---

## Fase 5: Home Dashboard

### Timeline
- [x] Query unificada: próximos mantenimientos + documentos que vencen
- [x] Ordenar cronológicamente
- [x] Mostrar los próximos 10-15 eventos
- [x] Card diferenciada para mantenimiento vs documento vs garantía
- [x] Tap en card → navegar al item/documento

### Resumen
- [x] Contadores: total items, mantenimientos pendientes, docs urgentes
- [x] Visual summary card con semáforo
- [x] "Todo al día" state cuando no hay nada urgente

### UX
- [x] FAB expandible (+Item, +Mantenimiento, +Documento)
- [x] Pull-to-refresh
- [x] Empty state para primer uso (call to action)
- [ ] Transición suave desde onboarding

---

## Fase 6: Notificaciones

### Setup
- [x] Configurar flutter_local_notifications (iOS + Android)
- [x] Crear canal de notificación "housekeep_reminders" (Android)
- [x] Solicitar permisos en iOS (provisional + alert)
- [x] Solicitar permisos en Android 13+ (POST_NOTIFICATIONS)
- [x] Configurar timezone para scheduled notifications

### Lógica
- [x] Al crear/editar mantenimiento → programar notificación
- [x] Al crear/editar documento → programar notificación
- [x] Al marcar mantenimiento como realizado → reprogramar
- [x] Al borrar item/mantenimiento/documento → cancelar notificación
- [x] Usar ID único derivado del UUID del item/doc
- [x] Free: 1 notificación por item (X días antes)
- [x] Pro: múltiples notificaciones (90d + 30d + 7d)

### Contenido de notificaciones
- [x] Mantenimiento: "🔧 [Nombre item]: [Nombre mantenimiento] en [X] días"
- [x] Documento: "📄 [Nombre documento] caduca en [X] días"
- [x] Garantía: "⚠️ La garantía de [Nombre item] vence en [X] días"

### Edge cases
- [x] Dispositivo reiniciado → reboot receiver (Android, RECEIVE_BOOT_COMPLETED + manifest del plugin)
- [ ] Permisos denegados → mostrar explicación y link a settings
- [x] Fecha pasada → no programar, mostrar como "vencido"

---

## Fase 7: Paywall y Premium

### Abstracción
- [ ] Definir `PurchaseService` interface abstracta
- [ ] Métodos: `initialize()`, `purchasePro()`, `restorePurchases()`, `isPro` stream
- [ ] Implementar `PurchaseServiceMock` (toggle manual)
- [ ] Implementar `PurchaseServiceRevenueCat`

### RevenueCat
- [ ] Crear cuenta RevenueCat
- [ ] Crear proyecto "HouseKeep"
- [ ] Configurar API keys (iOS + Android)
- [ ] Crear Entitlement "housekeep_pro"
- [ ] (Cuando estén los productos en stores) Crear Products y Offerings

### Paywall UI
- [ ] Pantalla paywall con lista de beneficios
- [ ] Comparativa visual Free vs Pro
- [ ] Botón de compra con precio dinámico
- [ ] Botón "Restaurar compra"
- [ ] Loading state durante compra
- [ ] Success state con confetti/animación
- [ ] Error handling (cancelled, error, etc.)

### Gates
- [ ] Check al añadir 6to item → mostrar paywall
- [ ] Check al añadir 4to documento → mostrar paywall
- [ ] Check al intentar usar plantilla PRO → mostrar paywall
- [ ] Check al intentar configurar múltiples notificaciones → paywall
- [ ] Widget solo disponible en pro → mostrar paywall desde settings
- [ ] Exportar PDF → solo pro

### Provider
- [ ] `isProProvider` → bool stream
- [ ] `canAddItemProvider` → bool (items < 5 OR isPro)
- [ ] `canAddDocumentProvider` → bool (docs < 3 OR isPro)
- [ ] Refresh al volver de paywall

---

## Fase 8: Onboarding + Settings

### Onboarding
- [ ] PageView con 3 páginas animadas
- [ ] Página 1: Problema ("Tu casa tiene muchas cosas que cuidar")
- [ ] Página 2: Solución ("HouseKeep te avisa antes de que sea tarde")
- [ ] Página 3: Acción ("Empieza añadiendo tu primer electrodoméstico")
- [ ] Botón "Empezar" en última página
- [ ] Selector de tipo de vivienda (piso/casa/chalet) → sugiere plantillas
- [ ] Persistir en SharedPreferences que ya se completó
- [ ] Solo mostrar en primer uso

### Settings
- [ ] Sección "General": Idioma (ES/EN)
- [ ] Sección "Notificaciones": on/off + defaults
- [ ] Sección "Premium": estado actual + restaurar compra
- [ ] Sección "Sobre": versión, contacto, feedback
- [ ] Link a política de privacidad
- [ ] Link a términos de uso
- [ ] Botón "Valorar la app" (url_launcher a store)

---

## Fase 9: Widget de pantalla de inicio

### Diseño
- [ ] Diseñar widget small (2x2): próximo evento + countdown
- [ ] Diseñar widget medium (4x2): próximos 3 eventos
- [ ] Colores coherentes con la app (semáforo)

### iOS (WidgetKit via home_widget)
- [ ] Configurar Widget Extension en Xcode
- [ ] Crear timeline provider
- [ ] Crear vistas SwiftUI para small y medium
- [ ] Deep link al tocar → abre item/documento correspondiente
- [ ] Actualización periódica (cada 6 horas)

### Android (Glance via home_widget)
- [ ] Configurar AppWidgetProvider
- [ ] Crear layouts para small y medium
- [ ] Deep link al tocar
- [ ] Actualización periódica

### Datos
- [ ] Servicio que prepara datos para el widget
- [ ] Actualizar widget al marcar mantenimiento como realizado
- [ ] Actualizar widget al añadir/editar/borrar items/docs
- [ ] Solo disponible para usuarios PRO

---

## Fase 10: Pulido y QA

### Animaciones
- [ ] Page transitions (shared axis / fade through)
- [ ] Hero animation en fotos (lista → detalle)
- [ ] Animated counter en dashboard
- [ ] Haptic feedback en acciones (marcar realizado, borrar)
- [ ] Shimmer loading en listas

### Responsive
- [ ] Tablet layout (2 columnas en landscape)
- [ ] Text scaling respetado
- [ ] Safe areas correctas

### Edge cases
- [ ] Sin permiso de cámara → mensaje explicativo
- [ ] Sin permiso de notificaciones → funciona sin ellas
- [ ] Storage casi lleno → aviso al guardar foto
- [ ] 50+ items → performance ok
- [ ] Rotación de pantalla → estado preservado
- [ ] Back button handling correcto

### Accessibility
- [ ] Semantic labels en todos los widgets interactivos
- [ ] Contrast ratio ≥ 4.5:1
- [ ] Touch targets ≥ 48dp
- [ ] Screen reader navigation coherente

### Performance
- [ ] Profile con DevTools → no jank
- [ ] Memory leaks check
- [ ] App size < 30MB

### Branding
- [ ] App icon (adaptive icon Android + iOS)
- [ ] Splash screen con logo
- [ ] Colores de status bar coherentes

---

## Fase 11: Store Prep

### Assets visuales
- [ ] 6 screenshots iPhone 6.7" (ES + EN)
- [ ] 6 screenshots iPhone 6.5" (ES + EN)
- [ ] 6 screenshots Android phone (ES + EN)
- [ ] 6 screenshots Android 10" tablet (ES + EN)
- [ ] Feature graphic 1024x500 (Google Play)
- [ ] App icon 1024x1024 (stores)
- [ ] Preview video 30s (opcional, recomendado para iOS)

### Metadata
- [ ] Descripción larga EN (Google Play)
- [ ] Descripción larga ES (Google Play)
- [ ] Descripción larga EN (App Store)
- [ ] Descripción larga ES (App Store)
- [ ] What's New / Release Notes
- [ ] Privacy policy URL (hosted)
- [ ] Support URL
- [ ] Marketing URL (landing page)

### App Store Connect
- [ ] Crear app "HouseKeep"
- [ ] Configurar metadata ES + EN
- [ ] Subir screenshots
- [ ] Configurar precio: Free con IAP
- [ ] Crear producto IAP: `com.housekeep.app.pro` (non-consumable, €5.99)
- [ ] Configurar App Privacy (data collection disclosure)
- [ ] Configurar age rating
- [ ] Submit para review

### Google Play Console
- [ ] Crear app "HouseKeep"
- [ ] Completar store listing ES + EN
- [ ] Subir screenshots + feature graphic
- [ ] Configurar contenido (rating, data safety)
- [ ] Crear producto IAP: `housekeep_pro` (one-time, €5.99)
- [ ] Internal testing track → testear
- [ ] Production release → submit

### RevenueCat producción
- [ ] Conectar App Store Connect
- [ ] Conectar Google Play Console
- [ ] Crear Products apuntando a los IAP reales
- [ ] Crear Offering "default"
- [ ] Verificar sandbox purchases en ambas plataformas
- [ ] Cambiar de mock a real en `main.dart`

### Legal
- [ ] Privacy policy (qué datos se recogen: ninguno en v1, todo local)
- [ ] Terms of use
- [ ] Hostear en web (GitHub Pages o similar)

---

## Post-lanzamiento (semana 1-2)

- [ ] Monitorizar crash reports (Crashlytics)
- [ ] Responder a primeras reviews
- [ ] Analizar funnel: installs → items added → paywall views → purchases
- [ ] Optimizar conversion si < 3%
- [ ] Solicitar reviews a usuarios activos (SKStoreReviewController)
- [ ] Publicar en Product Hunt
- [ ] Publicar en Reddit (r/homeowners, r/apps)
- [ ] Crear contenido SEO para landing (blog posts)
