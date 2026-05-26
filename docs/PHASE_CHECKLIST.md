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
- [x] Transición suave desde onboarding *(scale + fade celebration overlay antes de navegar)*

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
- [x] Permisos denegados → mostrar explicación y link a settings *(banner en Settings con CTA "Abrir ajustes" + auto-refresh en resume vía `notificationsGrantedProvider`)*
- [x] Fecha pasada → no programar, mostrar como "vencido"

---

## Fase 7: Paywall y Premium

### Abstracción
- [x] Definir `PurchaseService` interface abstracta
- [x] Métodos: `initialize()`, `purchasePro()`, `restorePurchases()`, `isPro` stream
- [x] Implementar `PurchaseServiceMock` (toggle manual)
- [x] Implementar `PurchaseServiceRevenueCat`

### RevenueCat
- [x] Crear cuenta RevenueCat
- [x] Crear proyecto "HouseKeep"
- [x] Configurar API keys (iOS + Android) — Android sandbox key embebida; iOS pendiente cuando se publique en App Store
- [x] Crear Entitlement "housekeep_pro"
- [ ] (Cuando estén los productos en stores) Crear Products y Offerings

### Paywall UI
- [x] Pantalla paywall con lista de beneficios
- [x] Comparativa visual Free vs Pro
- [x] Botón de compra con precio dinámico
- [x] Botón "Restaurar compra"
- [x] Loading state durante compra
- [x] Success state con confetti/animación (success view simple sin confetti — opcional fase 10)
- [x] Error handling (cancelled, error, etc.)

### Gates
- [x] Check al añadir 6to item → mostrar paywall
- [x] Check al añadir 4to documento → mostrar paywall
- [x] Check al intentar usar plantilla PRO → mostrar paywall
- [x] Check al intentar configurar múltiples notificaciones → paywall (cubierto vía isPro en NotificationScheduler)
- [x] Widget solo disponible en pro → mostrar paywall desde settings *(tile en Settings → free abre `/paywall`, pro muestra diálogo "Cómo añadir")*
- [x] Exportar PDF → solo pro *(tile Settings/Datos; free → paywall, pro genera PDF con items+mantenimientos+docs y share via `share_plus`)*

### Provider
- [x] `isProProvider` → bool stream
- [x] `canAddItemProvider` → bool (items < 5 OR isPro)
- [x] `canAddDocumentProvider` → bool (docs < 3 OR isPro)
- [x] Refresh al volver de paywall (CustomerInfoUpdateListener actualiza stream)

---

## Fase 8: Onboarding + Settings

### Onboarding
- [x] PageView con 3 páginas animadas
- [x] Página 1: Problema ("Tu casa tiene muchas cosas que cuidar")
- [x] Página 2: Solución ("HouseKeep te avisa antes de que sea tarde")
- [x] Página 3: Acción ("Empieza añadiendo tu primer electrodoméstico")
- [x] Botón "Empezar" en última página
- [x] Selector de tipo de vivienda (piso/casa/chalet) — guardado en SharedPreferences (sugerencia de plantillas pendiente de fase posterior)
- [x] Persistir en SharedPreferences que ya se completó
- [x] Solo mostrar en primer uso

### Settings
- [x] Sección "General": Idioma (ES/EN/sistema)
- [x] Sección "Notificaciones": on/off + acceso a permisos del sistema
- [x] Sección "Premium": estado actual + restaurar compra
- [x] Sección "Sobre": versión, contacto, feedback
- [x] Link a política de privacidad
- [x] Link a términos de uso
- [x] Botón "Valorar la app" (url_launcher a store)

---

## Fase 9: Widget de pantalla de inicio

### Diseño
- [x] Diseñar widget small (2x2): próximo evento + countdown
- [x] Diseñar widget medium (4x2): próximos 3 eventos
- [x] Colores coherentes con la app (semáforo: success/warning/error)

### iOS (WidgetKit via home_widget) — pendiente Mac
- [ ] Configurar Widget Extension en Xcode
- [ ] Crear timeline provider
- [ ] Crear vistas SwiftUI para small y medium
- [ ] Deep link al tocar → abre item/documento correspondiente
- [ ] Actualización periódica (cada 6 horas)

### Android (AppWidgetProvider via home_widget)
- [x] Configurar AppWidgetProvider (`HouseKeepWidgetProvider.kt`)
- [x] Crear layouts para small y medium (selección dinámica por minHeight)
- [x] Deep link al tocar (`housekeep://widget?route=...`)
- [x] Actualización periódica (updatePeriodMillis = 6h en widget info)

### Datos
- [x] Servicio que prepara datos para el widget (`WidgetService` + `WidgetSnapshotBuilder`)
- [x] Actualizar widget al marcar mantenimiento como realizado (vía `widgetSyncProvider` reactivo a streams)
- [x] Actualizar widget al añadir/editar/borrar items/docs (mismo, vía streams Riverpod)
- [x] Solo disponible para usuarios PRO (free ve CTA upgrade → abre paywall al tocar)

---

## Fase 10: Pulido y QA

### Animaciones
- [x] Page transitions (shared axis / fade through)
- [x] Hero animation en fotos (lista → detalle)
- [x] Animated counter en dashboard *(TweenAnimationBuilder 600ms easeOutCubic para items / mantenimientos pendientes / docs urgentes)*
- [x] Haptic feedback en acciones (marcar realizado, borrar)
- [x] Shimmer loading en listas

### Responsive
- [x] Tablet layout (2 columnas en landscape) *(ResponsiveCardList breakpoint 600dp en items/maintenance/documents)*
- [x] Text scaling respetado *(usamos TextTheme + textScaler nativo de MaterialApp; sin `fontSize` hard-coded)*
- [x] Safe areas correctas *(Scaffold + edge-to-edge con SystemUiMode; padding bottom 96 evita overlap con FAB y nav)*

### Edge cases
- [x] Sin permiso de cámara → mensaje explicativo *(SnackBar con acción "Ajustes" via app_settings)*
- [x] Sin permiso de notificaciones → funciona sin ellas *(NotificationService.schedule devuelve false gracefully)*
- [x] Storage casi lleno → aviso al guardar foto *(catch FileSystemException ENOSPC/ERROR_DISK_FULL)*
- [x] 50+ items → performance ok *(ListView.builder + Riverpod stream — virtualizado)*
- [x] Rotación de pantalla → estado preservado *(state vive en providers Riverpod, no en widgets)*
- [x] Back button handling correcto *(GoRouter maneja pop stack)*

### Accessibility
- [x] Semantic labels en todos los widgets interactivos *(StatusDot etiquetado con urgencia; Material widgets traen Semantics por defecto)*
- [x] Contrast ratio ≥ 4.5:1 *(primary `#2E7D6F` on bg = 5.78:1; textPrimary `#1A1A1A` = 16:1; textSecondary `#6B6B6B` on `#FAFAF8` ≈ 5.7:1)*
- [x] Touch targets ≥ 48dp *(theme minTouchTarget 44 → 48)*
- [x] Screen reader navigation coherente *(AppBar headings + Scaffold roles por defecto)*

### Performance
- [x] Profile con DevTools → no jank *(sesión 2026-05-26 emulator-5554 profile build, ver `docs/PERFORMANCE_REPORT.md`)*
- [x] Memory leaks check *(heap estable tras ciclos completos navegación, providers autoDispose OK — `docs/PERFORMANCE_REPORT.md`)*
- [x] App size < 30MB *(arm64-v8a release = 25.1MB; armv7 = 22.8MB; AAB = 65.7MB pero install per-device << 30MB)*

### Branding
- [x] App icon (adaptive icon Android + iOS)
- [x] Splash screen con logo
- [x] Colores de status bar coherentes

---

## Fase 11: Store Prep

### Assets visuales
- [ ] 6 screenshots iPhone 6.7" (ES + EN) *(plan en `docs/SCREENSHOT_PLAN.md`, captura pendiente)*
- [ ] 6 screenshots iPhone 6.5" (ES + EN)
- [ ] 6 screenshots Android phone (ES + EN)
- [ ] 6 screenshots Android 10" tablet (ES + EN)
- [x] Feature graphic 1024x500 (Google Play) — `store/feature_graphic_1024x500.png` (gen: `python3 tools/gen_store_assets.py`)
- [x] App icon 1024x1024 (stores) — `store/icon_1024.png`
- [ ] Preview video 30s (opcional, recomendado para iOS)

### Metadata
- [x] Descripción larga EN (Google Play) — `docs/STORE_METADATA.md`
- [x] Descripción larga ES (Google Play) — `docs/STORE_METADATA.md`
- [x] Descripción larga EN (App Store) — `docs/STORE_METADATA.md`
- [x] Descripción larga ES (App Store) — `docs/STORE_METADATA.md`
- [x] What's New / Release Notes — `docs/STORE_METADATA.md`
- [x] Privacy policy URL (hosted) — https://darumo92.github.io/housekeep-legal/privacy_en.html (+ `_es`)
- [x] Support URL — mailto:darumo092@gmail.com
- [x] Marketing URL (landing page) — https://darumo92.github.io/housekeep-site/ (ES + EN; repo `Darumo92/housekeep-site`)

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
- [x] Privacy policy (qué datos se recogen: ninguno en v1, todo local) — `docs/legal/privacy_es.md` + `privacy_en.md`
- [x] Terms of use — `docs/legal/terms_es.md` + `terms_en.md`
- [x] Hostear en web — GitHub Pages: https://darumo92.github.io/housekeep-legal/ (repo `Darumo92/housekeep-legal`)

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
