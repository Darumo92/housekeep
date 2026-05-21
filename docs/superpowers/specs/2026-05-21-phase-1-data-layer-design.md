# Phase 1 Data Layer Design

## Context

HouseKeep has completed Phase 0: Flutter setup, theme, i18n, initial Drift schema, navigation shell, and Firebase wiring. Phase 1 builds the local data layer that future feature screens will use.

The existing Drift tables are:

- `items`
- `maintenances`
- `documents`

The implementation must follow the project architecture in `docs/ARCHITECTURE.md`, the data model in `docs/DATA_MODEL.md`, and the task order in `docs/PHASE_CHECKLIST.md`.

There is an existing unrelated working tree change in `android/app/build.gradle.kts`. Phase 1 work will not modify or revert it.

## Scope

Phase 1 includes:

- Domain models for items, maintenances, documents, maintenance templates, and upcoming timeline events.
- Enums for item categories, document types, urgency levels, home types, and upcoming event types.
- Drift DAOs for items, maintenances, and documents.
- Repository classes and interfaces for items, maintenances, documents, and purchase state.
- Riverpod providers for the database, DAOs, repositories, purchase state, and free-limit checks.
- Unit tests for DAO CRUD, maintenance completion recalculation, urgency calculation, and warranty expiry calculation.

Phase 1 does not include UI screens, forms, image handling, notifications, RevenueCat integration, paywall UI, template JSON loading, or dashboard rendering. Those belong to later phases.

## Execution Approach

Implement Phase 1 in small blocks, in checklist order:

1. Models and enums.
2. DAOs and Drift code generation.
3. Repositories.
4. Riverpod providers and generated provider code.
5. Tests and checklist updates.

Each block should leave the app analyzable and testable. After completing each block, update `docs/PHASE_CHECKLIST.md` for the completed tasks.

## Domain Models

Use manual immutable Dart classes. Do not add `freezed` or other model-generation dependencies for this phase.

Models live under `lib/domain/models/`:

- `item.dart`
- `maintenance.dart`
- `document.dart`
- `maintenance_template.dart`
- `upcoming_event.dart`

Each DB-backed model should expose:

- A constructor with required fields matching the data model.
- A `fromDb` factory from the generated Drift row type.
- A `toCompanion` method for insert/update operations.

The model layer owns pure business calculations:

- `Item.warrantyExpiryDate`
- `Item.isWarrantyActive`
- `Item.warrantyDaysRemaining`
- `Maintenance.urgencyLevel`
- `Document.urgencyLevel`
- `UpcomingEvent.daysUntilDue`

Date-dependent calculations should accept an optional `DateTime now` where needed, so tests do not depend on wall-clock time.

## Enums

Enums live under `lib/domain/enums/`:

- `item_category.dart`
- `document_type.dart`
- `urgency_level.dart`
- `home_type.dart`

`upcoming_event.dart` may also define `UpcomingEventType` if it is only used by the timeline model.

Enum persistence uses stable string keys that match `docs/DATA_MODEL.md` and the current Drift schema. Parsing should fail clearly for unknown values rather than silently defaulting to `other`, except where the data model explicitly allows `other` as a user-selected value.

Labels visible to users must be localized through `AppLocalizations`. Enum label helpers can accept `AppLocalizations l10n` and return the correct string. This keeps visible copy out of Dart literals.

Urgency colors should reference centralized theme colors from `AppColors`, not inline color values.

`UrgencyLevel` should use the values from `docs/DATA_MODEL.md`: `ok`, `upcoming`, `urgent`, and `overdue`. Document expiry UI can label `overdue` as expired through i18n, but the internal enum value remains `overdue`.

## DAOs

DAOs live under `lib/data/database/daos/`:

- `items_dao.dart`
- `maintenances_dao.dart`
- `documents_dao.dart`

Add them to `@DriftDatabase` in `app_database.dart` and regenerate Drift output with `dart run build_runner build --delete-conflicting-outputs`.

`ItemsDao` responsibilities:

- Insert and update items.
- Delete item by id.
- Fetch item by id.
- Watch all items ordered by `createdAt` descending.
- Watch items by category.
- Count items.

`MaintenancesDao` responsibilities:

- Insert and update maintenances.
- Delete maintenance by id.
- Fetch maintenance by id.
- Watch maintenances for an item ordered by `nextDueAt` ascending.
- Watch upcoming maintenances ordered by `nextDueAt` ascending.
- Mark a maintenance as done by setting `lastDoneAt = now`, `nextDueAt = now + intervalMonths`, and `updatedAt = now`.

`DocumentsDao` responsibilities:

- Insert and update documents.
- Delete document by id.
- Fetch document by id.
- Watch all documents ordered by `expiryDate` ascending.
- Watch documents by type.
- Watch expiring documents ordered by `expiryDate` ascending.
- Count documents.

The existing FK cascade from items to maintenances remains the deletion behavior for item removal.

## Repositories

Repositories live under `lib/data/repositories/`:

- `items_repository.dart`
- `maintenances_repository.dart`
- `documents_repository.dart`
- `purchase_repository.dart`

Repositories are the public API for future feature screens. They should return domain models, not Drift rows, and accept domain models or explicit input fields for writes.

The repository layer should stay thin in Phase 1:

- Convert between Drift rows and domain models.
- Delegate persistence to DAOs.
- Expose streams for watched data.
- Expose count methods used by free-limit providers.

`PurchaseRepository` is an interface for entitlement state. Phase 1 should include a simple local/mock implementation that reports non-Pro by default, because real purchase integration is planned for Phase 7. It must not import RevenueCat directly.

## Riverpod Providers

Providers should use `riverpod_annotation` code generation and live close to the layer they expose, following the project architecture.

Required providers:

- `appDatabaseProvider`: singleton `AppDatabase`.
- DAO providers for items, maintenances, and documents.
- Repository providers for items, maintenances, documents, and purchase state.
- `isProProvider`: reads purchase state.
- `canAddItemProvider`: true for Pro users or when item count is below `AppConstants.freeItemsLimit`.
- `canAddDocumentProvider`: true for Pro users or when document count is below `AppConstants.freeDocumentsLimit`.

Generated provider files should be committed with source changes when commits are requested.

## Testing

Minimum tests for Phase 1:

- Items DAO CRUD using `NativeDatabase.memory()`.
- Maintenance `markAsDone` recalculates `lastDoneAt`, `nextDueAt`, and `updatedAt`.
- Urgency level calculation for ok, upcoming, urgent, and overdue boundaries.
- Warranty expiry calculation for active, expired, and no-warranty cases.

Tests should prefer deterministic fixed dates. Avoid assertions that depend on the current real time unless the implementation accepts an explicit `now`.

## Verification

Run verification after implementation blocks:

- `dart run build_runner build --delete-conflicting-outputs` after adding DAOs/providers.
- `flutter analyze` after each meaningful block.
- `flutter test` after tests are added or affected.

If generated files change, inspect them only enough to confirm code generation succeeded and imports are valid.

## Documentation Updates

Update `docs/PHASE_CHECKLIST.md` immediately when each Phase 1 task is completed.

Update `README.md` only if all Phase 1 tasks are completed. The phase table should move Phase 1 from `Pendiente` to `Completada` at that point.

Update `docs/DATA_MODEL.md` or `docs/ARCHITECTURE.md` only if implementation requires a real design change. Do not change those docs for mere code-location or naming details that already match the plan.
