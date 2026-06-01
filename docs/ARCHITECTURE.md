# HouseKeep — Arquitectura Técnica

## Stack tecnológico

```
┌──────────────────────────────────────────────┐
│                  UI Layer                      │
│  Flutter Widgets + Material 3 Custom Theme    │
│  go_router (navigation)                       │
├──────────────────────────────────────────────┤
│              State Management                  │
│  Riverpod (providers, notifiers)              │
│  riverpod_annotation (code generation)        │
├──────────────────────────────────────────────┤
│              Domain Layer                      │
│  Models, Enums, Business Logic                │
├──────────────────────────────────────────────┤
│              Data Layer                        │
│  Repositories → DAOs → Drift (SQLite)        │
│  Services (Notifications, Photos, Purchases)  │
├──────────────────────────────────────────────┤
│              Platform Layer                    │
│  flutter_local_notifications                  │
│  image_picker                                 │
│  purchases_flutter (RevenueCat)               │
│  home_widget (Widget iOS/Android)             │
│  firebase_core/analytics/crashlytics          │
└──────────────────────────────────────────────┘
```

---

## Estructura de carpetas

```
lib/
├── main.dart                           # Entry point, inicialización
├── app.dart                            # MaterialApp, tema, go_router
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart              # ThemeData M3 customizado
│   │   ├── app_colors.dart             # Paleta semántica
│   │   └── app_typography.dart         # TextStyles del proyecto
│   ├── constants/
│   │   ├── app_constants.dart          # Límites free (5 items, 3 docs), etc.
│   │   └── asset_paths.dart            # Rutas a assets
│   ├── extensions/
│   │   ├── date_extensions.dart        # daysUntil, isExpired, urgencyLevel
│   │   ├── context_extensions.dart     # Theme shortcuts
│   │   └── string_extensions.dart
│   ├── l10n/
│   │   ├── app_en.arb                  # Strings en inglés
│   │   └── app_es.arb                  # Strings en español
│   └── utils/
│       ├── date_utils.dart             # Helpers de fecha
│       ├── image_utils.dart            # Compresión, paths
│       └── id_generator.dart           # UUID helper
│
├── data/
│   ├── database/
│   │   ├── app_database.dart           # @DriftDatabase definition
│   │   ├── app_database.g.dart         # Generado por build_runner
│   │   ├── tables/
│   │   │   ├── items_table.dart        # Tabla de items/electrodomésticos
│   │   │   ├── maintenances_table.dart # Tabla de mantenimientos
│   │   │   └── documents_table.dart    # Tabla de documentos
│   │   └── daos/
│   │       ├── items_dao.dart          # CRUD items
│   │       ├── maintenances_dao.dart   # CRUD mantenimientos
│   │       └── documents_dao.dart      # CRUD documentos
│   ├── repositories/
│   │   ├── items_repository.dart       # Interfaz + implementación
│   │   ├── maintenances_repository.dart
│   │   ├── documents_repository.dart
│   │   └── purchase_repository.dart    # Estado de entitlement
│   └── services/
│       ├── notification_service.dart   # Programar/cancelar notificaciones
│       ├── purchase_service.dart       # Interfaz abstracta
│       ├── purchase_service_rc.dart    # Implementación RevenueCat
│       ├── purchase_service_mock.dart  # Mock para desarrollo
│       └── photo_service.dart          # Captura, compresión, storage
│
├── domain/
│   ├── models/
│   │   ├── item.dart                   # Item del hogar (freezed o manual)
│   │   ├── maintenance.dart            # Tarea de mantenimiento
│   │   ├── document.dart               # Documento con caducidad
│   │   ├── maintenance_template.dart   # Plantilla predefinida
│   │   └── upcoming_event.dart         # Unión de maint + docs para timeline
│   └── enums/
│       ├── item_category.dart          # kitchen, bathroom, laundry, living, garden, garage, general
│       ├── document_type.dart          # passport, id_card, drivers_license, insurance_home, insurance_car, itv, other
│       ├── urgency_level.dart          # ok, upcoming, urgent, expired
│       └── home_type.dart              # apartment, house, villa (para plantillas)
│
├── features/
│   ├── home/
│   │   ├── home_screen.dart            # Dashboard con timeline
│   │   ├── home_provider.dart          # Provider de datos del dashboard
│   │   └── widgets/
│   │       ├── upcoming_timeline.dart  # Lista cronológica
│   │       ├── status_summary_card.dart # Contadores con semáforo
│   │       └── quick_add_fab.dart      # FAB expandible
│   │
│   ├── items/
│   │   ├── items_list_screen.dart      # Grid/lista de items
│   │   ├── item_detail_screen.dart     # Detalle con mantenimientos
│   │   ├── add_edit_item_screen.dart   # Formulario crear/editar
│   │   ├── items_provider.dart         # Provider CRUD + watch
│   │   └── widgets/
│   │       ├── item_card.dart          # Card en la lista
│   │       ├── category_picker.dart    # Selector de categoría
│   │       ├── warranty_badge.dart     # Indicador de garantía
│   │       └── item_photo.dart         # Preview de foto
│   │
│   ├── maintenance/
│   │   ├── maintenance_list_screen.dart     # Lista de mantenimientos de un item
│   │   ├── add_edit_maintenance_screen.dart  # Formulario
│   │   ├── maintenance_provider.dart
│   │   ├── templates_provider.dart          # Carga plantillas JSON
│   │   └── widgets/
│   │       ├── maintenance_card.dart
│   │       ├── template_picker.dart         # Selector de plantilla
│   │       └── mark_done_button.dart
│   │
│   ├── documents/
│   │   ├── documents_list_screen.dart
│   │   ├── add_edit_document_screen.dart
│   │   ├── documents_provider.dart
│   │   └── widgets/
│   │       ├── document_card.dart
│   │       ├── expiry_badge.dart            # Semáforo verde/amarillo/rojo
│   │       └── document_type_picker.dart
│   │
│   ├── onboarding/
│   │   ├── onboarding_screen.dart           # PageView 3 pantallas
│   │   ├── onboarding_provider.dart         # Estado visto/no visto
│   │   └── widgets/
│   │       └── onboarding_page.dart
│   │
│   ├── settings/
│   │   ├── settings_screen.dart
│   │   └── settings_provider.dart           # Preferencias
│   │
│   └── paywall/
│       ├── paywall_screen.dart              # Pantalla de venta
│       ├── paywall_provider.dart
│       └── widgets/
│           ├── feature_comparison.dart      # Free vs Pro
│           └── purchase_button.dart
│
└── shared/
    └── widgets/
        ├── app_card.dart                    # Card base del proyecto
        ├── empty_state.dart                 # Estado vacío reutilizable
        ├── photo_picker_sheet.dart          # Bottom sheet cámara/galería
        ├── category_icon.dart               # Icono por categoría
        ├── confirm_dialog.dart              # Diálogo de confirmación
        └── section_header.dart              # Header de sección
```

---

## Paleta de colores

```dart
// app_colors.dart
class AppColors {
  // Primary
  static const primary = Color(0xFF2E7D6F);       // Verde azulado cálido
  static const primaryLight = Color(0xFF4DA89A);
  static const primaryDark = Color(0xFF1B5E50);
  static const onPrimary = Color(0xFFFFFFFF);

  // Secondary
  static const secondary = Color(0xFFF5A623);      // Ámbar cálido
  static const secondaryLight = Color(0xFFFFBE45);
  static const onSecondary = Color(0xFF1A1A1A);

  // Surfaces
  static const background = Color(0xFFFAFAF8);    // Blanco cálido
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF5F5F3);

  // Semantic
  static const success = Color(0xFF388E3C);        // Todo al día
  static const warning = Color(0xFFF9A825);        // Próximo a vencer
  static const error = Color(0xFFD32F2F);          // Vencido / urgente

  // Text
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textTertiary = Color(0xFF9E9E9E);
}
```

---

## Principios de diseño

1. **Rounded everywhere**: BorderRadius.circular(16) para cards, 12 para buttons, 8 para inputs
2. **Soft shadows**: elevation baja (1-2), colores de sombra con opacidad baja
3. **Whitespace generoso**: padding 16-24, spacing entre cards 12-16
4. **Iconos simples**: Material Symbols Rounded o Lucide
5. **Tipografía clara**: SF Pro Display / Roboto, tamaños bien diferenciados
6. **Microinteracciones**: Animated badges, smooth page transitions
7. **Color con propósito**: Color solo para semáforo de urgencia y acciones primarias

---

## Navegación (go_router)

```
/                           → HomeScreen (dashboard)
/items                      → ItemsListScreen
/items/add                  → AddEditItemScreen (crear)
/items/:id                  → ItemDetailScreen
/items/:id/edit             → AddEditItemScreen (editar)
/items/:id/maintenance      → MaintenanceListScreen
/items/:id/maintenance/add  → AddEditMaintenanceScreen
/documents                  → DocumentsListScreen
/documents/add              → AddEditDocumentScreen
/documents/:id/edit         → AddEditDocumentScreen (editar)
/settings                   → SettingsScreen
/paywall                    → PaywallScreen
/onboarding                 → OnboardingScreen
```

**Bottom Navigation:** Home | Items | Documents | Settings

---

## Dependencias (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Navigation
  go_router: ^14.0.0

  # Database
  drift: ^2.16.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  path: ^1.9.0

  # Notifications
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.0

  # Purchases
  purchases_flutter: ^8.0.0

  # Firebase
  firebase_core: ^3.0.0
  firebase_analytics: ^11.0.0
  firebase_crashlytics: ^4.0.0

  # UI/UX
  intl: ^0.19.0
  uuid: ^4.3.0
  image_picker: ^1.0.0
  shared_preferences: ^2.2.0
  home_widget: ^0.6.0
  url_launcher: ^6.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  drift_dev: ^2.16.0
  riverpod_generator: ^2.4.0
  custom_lint: ^0.6.0
  riverpod_lint: ^2.3.0
  mocktail: ^1.0.0
  flutter_lints: ^4.0.0
```

---

## Convenciones de código

- **Archivos**: snake_case (`item_detail_screen.dart`)
- **Clases**: PascalCase (`ItemDetailScreen`)
- **Providers**: camelCase con sufijo Provider (`itemsListProvider`)
- **Constantes**: camelCase o SCREAMING_CASE para valores numéricos
- **Tests**: `*_test.dart` junto al archivo o en `/test/`
- **Imports**: relativos dentro del proyecto, absolutos para packages
- **Comentarios**: solo cuando el "por qué" no es obvio, no documentar lo evidente
- **Null safety**: strict, sin `!` a menos que esté garantizado

---

## Firebase Setup (Fase 0)

### Pasos:
1. Ir a https://console.firebase.google.com
2. Crear proyecto "HouseKeep" (o "housekeep-app")
3. Desactivar Google Analytics mejorado (usaremos el básico)
4. Registrar app Android:
   - Package name: `com.housekeep.app`
   - Descargar `google-services.json` → `android/app/`
5. Registrar app iOS:
   - Bundle ID: `com.housekeep.app`
   - Descargar `GoogleService-Info.plist` → `ios/Runner/`
6. Instalar FlutterFire CLI: `dart pub global activate flutterfire_cli`
7. Ejecutar `flutterfire configure` en el proyecto
8. Verificar que `firebase_options.dart` se genera correctamente
9. En `main.dart`:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
   ```

---

## RevenueCat Setup

### Desarrollo (Mock):
- Usar `PurchaseServiceMock` que siempre devuelve `isPro = false`
- Toggle manual en dev para simular estado pro

### Producción:
1. Crear cuenta en https://app.revenuecat.com
2. Crear proyecto "HouseKeep"
3. Conectar App Store Connect (Shared Secret)
4. Conectar Google Play (Service Account JSON)
5. Crear Entitlement: `housekeep_pro`
6. Crear Product:
   - iOS: pendiente/no configurado para v1 Android-only
   - Android: `housekeep_pro_lifetime` (one-time purchase, 4,99 €)
7. Crear Offering "default" con el producto
8. API Keys en `purchase_service_rc.dart` (por platform)

---

## Testing Strategy

| Tipo | Herramienta | Cobertura |
|------|-------------|-----------|
| Unit tests | flutter_test + mocktail | Repositories, providers, utils |
| Widget tests | flutter_test | Screens principales, forms |
| Integration tests | integration_test | Flujos completos (add item → ver en dashboard) |

**Mínimo para MVP**: Unit tests de repositories y lógica de negocio (fechas, urgencia, límites free).
