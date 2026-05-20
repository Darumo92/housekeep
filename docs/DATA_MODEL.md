# HouseKeep — Modelo de Datos

## Diagrama de relaciones

```
┌─────────────┐       ┌──────────────────┐
│    Items     │ 1───N │  Maintenances    │
└─────────────┘       └──────────────────┘

┌──────────────────┐
│    Documents     │  (independiente)
└──────────────────┘
```

---

## Tabla: Items

Registra electrodomésticos, aparatos, instalaciones y servicios del hogar.

| Campo | Tipo SQL | Dart Type | Nullable | Descripción |
|-------|----------|-----------|----------|-------------|
| id | TEXT | String | No | UUID v4, PK |
| name | TEXT | String | No | Nombre del item ("Lavadora", "Caldera") |
| category | TEXT | ItemCategory | No | Enum serializado: kitchen, bathroom, laundry, living, bedroom, garden, garage, general |
| brand | TEXT | String? | Sí | Marca (Samsung, Bosch...) |
| model | TEXT | String? | Sí | Modelo |
| purchase_date | INTEGER | DateTime? | Sí | Fecha de compra (epoch ms) |
| warranty_months | INTEGER | int? | Sí | Duración garantía en meses (null = sin garantía) |
| photo_path | TEXT | String? | Sí | Ruta local a foto del item |
| notes | TEXT | String? | Sí | Notas libres del usuario |
| created_at | INTEGER | DateTime | No | Timestamp de creación (epoch ms) |
| updated_at | INTEGER | DateTime | No | Timestamp de última modificación |

### Campos calculados (no en DB, en modelo)
- `warrantyExpiryDate`: purchaseDate + warrantyMonths
- `isWarrantyActive`: warrantyExpiryDate > now
- `warrantyDaysRemaining`: warrantyExpiryDate - now (en días)

### Índices
- PK: `id`
- Índice en `category` (para filtrar por categoría)
- Índice en `created_at` (para ordenar)

---

## Tabla: Maintenances

Tareas de mantenimiento periódico asociadas a un item.

| Campo | Tipo SQL | Dart Type | Nullable | Descripción |
|-------|----------|-----------|----------|-------------|
| id | TEXT | String | No | UUID v4, PK |
| item_id | TEXT | String | No | FK → Items.id |
| name | TEXT | String | No | Nombre de la tarea ("Cambio de filtro", "Revisión anual") |
| description | TEXT | String? | Sí | Descripción adicional |
| interval_months | INTEGER | int | No | Cada cuántos meses se debe realizar |
| last_done_at | INTEGER | DateTime? | Sí | Última vez que se realizó (epoch ms) |
| next_due_at | INTEGER | DateTime | No | Próxima fecha programada (epoch ms) |
| notify_days_before | INTEGER | int | No | Días de antelación para notificar (default: 7) |
| is_from_template | INTEGER | bool | No | Si se creó desde una plantilla (para analytics) |
| created_at | INTEGER | DateTime | No | Timestamp de creación |
| updated_at | INTEGER | DateTime | No | Timestamp de última modificación |

### Lógica de negocio
- Al marcar como realizado: `lastDoneAt = now`, `nextDueAt = now + intervalMonths`
- Urgency level:
  - `ok`: nextDueAt > now + 30 días
  - `upcoming`: nextDueAt entre now y now + 30 días
  - `urgent`: nextDueAt entre now y now + 7 días
  - `overdue`: nextDueAt < now

### Índices
- PK: `id`
- FK + índice: `item_id`
- Índice en `next_due_at` (para ordenar timeline)

---

## Tabla: Documents

Documentos personales o del hogar con fecha de caducidad.

| Campo | Tipo SQL | Dart Type | Nullable | Descripción |
|-------|----------|-----------|----------|-------------|
| id | TEXT | String | No | UUID v4, PK |
| name | TEXT | String | No | Nombre ("Pasaporte Juan", "Seguro hogar AXA") |
| type | TEXT | DocumentType | No | Enum: passport, id_card, drivers_license, vehicle_inspection, insurance_home, insurance_car, insurance_life, insurance_health, lease, warranty_doc, other |
| expiry_date | INTEGER | DateTime | No | Fecha de caducidad (epoch ms) |
| notify_days_before | INTEGER | int | No | Días de antelación para notificar (default: 30) |
| photo_path | TEXT | String? | Sí | Foto/scan del documento |
| notes | TEXT | String? | Sí | Notas libres |
| created_at | INTEGER | DateTime | No | Timestamp de creación |
| updated_at | INTEGER | DateTime | No | Timestamp de última modificación |

### Lógica de negocio
- Urgency level (semáforo):
  - `ok` (verde): expiryDate > now + 90 días
  - `upcoming` (amarillo): expiryDate entre now + 30 días y now + 90 días
  - `urgent` (rojo): expiryDate entre now y now + 30 días
  - `expired` (rojo oscuro): expiryDate < now

### Índices
- PK: `id`
- Índice en `expiry_date` (para ordenar por urgencia)
- Índice en `type` (para filtrar)

---

## Enums

### ItemCategory
```dart
enum ItemCategory {
  kitchen,      // Cocina (nevera, horno, lavavajillas, microondas)
  bathroom,     // Baño (calentador, termo)
  laundry,      // Lavandería (lavadora, secadora)
  living,       // Salón (TV, aire acondicionado, calefacción)
  bedroom,      // Dormitorio
  garden,       // Jardín/exterior (cortacésped, piscina, riego)
  garage,       // Garaje (puerta automática, herramientas)
  plumbing,     // Fontanería (caldera, tuberías, descalcificador)
  electrical,   // Eléctrico (cuadro, placas solares, SAI)
  security,     // Seguridad (alarma, detectores humo, extintores)
  general,      // General / Otro
}
```

### DocumentType
```dart
enum DocumentType {
  passport,           // Pasaporte
  idCard,             // DNI / ID card
  driversLicense,     // Carnet de conducir
  vehicleInspection,  // ITV / MOT
  insuranceHome,      // Seguro del hogar
  insuranceCar,       // Seguro del coche
  insuranceLife,      // Seguro de vida
  insuranceHealth,    // Seguro de salud
  lease,              // Contrato de alquiler
  warrantyDoc,        // Documento de garantía extendida
  subscription,       // Suscripción con renovación
  other,              // Otro
}
```

### UrgencyLevel
```dart
enum UrgencyLevel {
  ok,        // Verde — todo bien
  upcoming,  // Amarillo — se acerca
  urgent,    // Rojo — muy próximo o vencido
  overdue,   // Rojo oscuro — ya pasó la fecha
}
```

---

## Modelo unificado para Timeline: UpcomingEvent

Para el dashboard, necesitamos un modelo que unifique mantenimientos y documentos:

```dart
class UpcomingEvent {
  final String id;
  final String title;          // Nombre del mantenimiento o documento
  final String subtitle;       // Nombre del item (maint) o tipo (doc)
  final DateTime dueDate;
  final UrgencyLevel urgency;
  final UpcomingEventType type; // maintenance | document | warranty
  final String? relatedItemId; // Para navegación

  // Calculado
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
}

enum UpcomingEventType { maintenance, document, warranty }
```

---

## Plantillas de mantenimiento (JSON)

Archivo: `assets/templates/maintenance_templates.json`

```json
{
  "version": 1,
  "templates": [
    {
      "id": "boiler_annual",
      "name_en": "Annual boiler service",
      "name_es": "Revisión anual de caldera",
      "category": "plumbing",
      "interval_months": 12,
      "description_en": "Professional inspection and cleaning of boiler",
      "description_es": "Inspección profesional y limpieza de caldera",
      "notify_days_before": 30,
      "is_pro": false
    },
    {
      "id": "ac_filter",
      "name_en": "Clean/replace AC filter",
      "name_es": "Limpiar/cambiar filtro del aire acondicionado",
      "category": "living",
      "interval_months": 3,
      "description_en": "Clean or replace air conditioning filters",
      "description_es": "Limpiar o reemplazar filtros del aire acondicionado",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "water_filter",
      "name_en": "Replace water filter",
      "name_es": "Cambiar filtro de agua",
      "category": "kitchen",
      "interval_months": 6,
      "description_en": "Replace under-sink or fridge water filter",
      "description_es": "Cambiar filtro de agua del grifo o nevera",
      "notify_days_before": 14,
      "is_pro": false
    },
    {
      "id": "smoke_detector",
      "name_en": "Test smoke detectors",
      "name_es": "Comprobar detectores de humo",
      "category": "security",
      "interval_months": 6,
      "description_en": "Test all smoke and CO detectors, replace batteries if needed",
      "description_es": "Probar detectores de humo y CO, cambiar pilas si es necesario",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "gutters",
      "name_en": "Clean gutters",
      "name_es": "Limpiar canalones",
      "category": "garden",
      "interval_months": 6,
      "description_en": "Remove leaves and debris from gutters and downspouts",
      "description_es": "Retirar hojas y suciedad de canalones y bajantes",
      "notify_days_before": 14,
      "is_pro": true
    },
    {
      "id": "fridge_coils",
      "name_en": "Clean fridge coils",
      "name_es": "Limpiar serpentín de la nevera",
      "category": "kitchen",
      "interval_months": 12,
      "description_en": "Vacuum condenser coils behind/under refrigerator",
      "description_es": "Aspirar serpentín condensador detrás/debajo de la nevera",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "washing_machine_clean",
      "name_en": "Deep clean washing machine",
      "name_es": "Limpieza profunda lavadora",
      "category": "laundry",
      "interval_months": 3,
      "description_en": "Run empty hot cycle with cleaner, clean rubber seal and filter",
      "description_es": "Ciclo vacío en caliente con limpiador, limpiar goma y filtro",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "extinguisher_check",
      "name_en": "Check fire extinguisher",
      "name_es": "Revisar extintor",
      "category": "security",
      "interval_months": 12,
      "description_en": "Check pressure gauge, expiry date, and accessibility",
      "description_es": "Comprobar manómetro, fecha de caducidad y accesibilidad",
      "notify_days_before": 30,
      "is_pro": false
    },
    {
      "id": "pool_ph",
      "name_en": "Check pool water pH",
      "name_es": "Comprobar pH de la piscina",
      "category": "garden",
      "interval_months": 1,
      "description_en": "Test and adjust pool water pH and chlorine levels",
      "description_es": "Medir y ajustar pH y cloro del agua de la piscina",
      "notify_days_before": 3,
      "is_pro": true
    },
    {
      "id": "solar_panels",
      "name_en": "Clean solar panels",
      "name_es": "Limpiar placas solares",
      "category": "electrical",
      "interval_months": 6,
      "description_en": "Clean dust and debris from solar panels for optimal performance",
      "description_es": "Limpiar polvo y suciedad de placas solares para rendimiento óptimo",
      "notify_days_before": 14,
      "is_pro": true
    },
    {
      "id": "dishwasher_clean",
      "name_en": "Deep clean dishwasher",
      "name_es": "Limpieza profunda lavavajillas",
      "category": "kitchen",
      "interval_months": 3,
      "description_en": "Clean filter, spray arms, and run empty cycle with vinegar",
      "description_es": "Limpiar filtro, brazos aspersores y ciclo vacío con vinagre",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "dryer_vent",
      "name_en": "Clean dryer vent",
      "name_es": "Limpiar conducto de la secadora",
      "category": "laundry",
      "interval_months": 12,
      "description_en": "Clean lint from dryer vent duct to prevent fire hazard",
      "description_es": "Limpiar pelusa del conducto de ventilación de la secadora",
      "notify_days_before": 14,
      "is_pro": false
    },
    {
      "id": "heating_bleed",
      "name_en": "Bleed radiators",
      "name_es": "Purgar radiadores",
      "category": "plumbing",
      "interval_months": 12,
      "description_en": "Bleed air from radiators before heating season",
      "description_es": "Purgar aire de los radiadores antes de la temporada de calefacción",
      "notify_days_before": 14,
      "is_pro": false
    },
    {
      "id": "garage_door",
      "name_en": "Lubricate garage door",
      "name_es": "Lubricar puerta de garaje",
      "category": "garage",
      "interval_months": 6,
      "description_en": "Lubricate hinges, rollers, and springs of garage door",
      "description_es": "Lubricar bisagras, rodillos y muelles de puerta de garaje",
      "notify_days_before": 7,
      "is_pro": true
    },
    {
      "id": "lawn_mower",
      "name_en": "Service lawn mower",
      "name_es": "Mantenimiento cortacésped",
      "category": "garden",
      "interval_months": 12,
      "description_en": "Change oil, clean/replace air filter, sharpen blade",
      "description_es": "Cambiar aceite, limpiar/cambiar filtro aire, afilar cuchilla",
      "notify_days_before": 14,
      "is_pro": true
    },
    {
      "id": "water_heater_flush",
      "name_en": "Flush water heater",
      "name_es": "Vaciar y limpiar termo eléctrico",
      "category": "plumbing",
      "interval_months": 12,
      "description_en": "Drain sediment from water heater tank",
      "description_es": "Drenar sedimentos del depósito del termo",
      "notify_days_before": 14,
      "is_pro": false
    },
    {
      "id": "oven_clean",
      "name_en": "Deep clean oven",
      "name_es": "Limpieza profunda del horno",
      "category": "kitchen",
      "interval_months": 3,
      "description_en": "Run self-clean cycle or manual deep clean of oven interior",
      "description_es": "Ciclo de autolimpieza o limpieza manual a fondo del interior",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "descale_appliances",
      "name_en": "Descale kettle & coffee maker",
      "name_es": "Descalcificar hervidor y cafetera",
      "category": "kitchen",
      "interval_months": 2,
      "description_en": "Run descaling solution through kettle and coffee machine",
      "description_es": "Pasar solución descalcificadora por hervidor y cafetera",
      "notify_days_before": 7,
      "is_pro": false
    },
    {
      "id": "alarm_test",
      "name_en": "Test alarm system",
      "name_es": "Probar sistema de alarma",
      "category": "security",
      "interval_months": 3,
      "description_en": "Test all sensors, keypads, and communication with monitoring center",
      "description_es": "Probar sensores, teclados y comunicación con central de alarmas",
      "notify_days_before": 7,
      "is_pro": true
    },
    {
      "id": "septic_tank",
      "name_en": "Pump septic tank",
      "name_es": "Vaciar fosa séptica",
      "category": "plumbing",
      "interval_months": 36,
      "description_en": "Professional septic tank pumping and inspection",
      "description_es": "Vaciado profesional e inspección de fosa séptica",
      "notify_days_before": 60,
      "is_pro": true
    }
  ]
}
```

### Plantillas FREE vs PRO
- **FREE (12):** Mantenimientos básicos que aplican a la mayoría de hogares (caldera, AC, lavadora, horno, nevera, detectores humo, etc.)
- **PRO (8):** Mantenimientos específicos de casas grandes (piscina, jardín, garaje, placas solares, alarma, fosa séptica)

---

## Queries principales (DAOs)

### ItemsDAO
```
- watchAllItems() → Stream<List<Item>>
- watchItemById(id) → Stream<Item?>
- watchItemsByCategory(cat) → Stream<List<Item>>
- insertItem(item) → Future<void>
- updateItem(item) → Future<void>
- deleteItem(id) → Future<void>
- countItems() → Future<int>  // Para límite freemium
```

### MaintenancesDAO
```
- watchMaintenancesByItem(itemId) → Stream<List<Maintenance>>
- watchAllUpcoming(limit) → Stream<List<Maintenance>>  // Ordenados por nextDueAt
- watchOverdue() → Stream<List<Maintenance>>
- insertMaintenance(m) → Future<void>
- markAsDone(id) → Future<void>  // Actualiza lastDoneAt y recalcula nextDueAt
- updateMaintenance(m) → Future<void>
- deleteMaintenance(id) → Future<void>
- deleteByItem(itemId) → Future<void>  // Cascade al borrar item
```

### DocumentsDAO
```
- watchAllDocuments() → Stream<List<Document>>
- watchDocumentsByType(type) → Stream<List<Document>>
- watchExpiringSoon(days) → Stream<List<Document>>  // Vencen en X días
- insertDocument(doc) → Future<void>
- updateDocument(doc) → Future<void>
- deleteDocument(id) → Future<void>
- countDocuments() → Future<int>  // Para límite freemium
```
