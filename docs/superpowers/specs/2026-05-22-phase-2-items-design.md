# Phase 2 Items Design

## Context

HouseKeep has completed Phase 1: the data layer for items, maintenances, documents, repositories, and Riverpod providers is already in place.

The current implementation state for the items feature is minimal:

- `lib/features/items/items_list_screen.dart` is still a placeholder.
- Routing already includes the `/items` branch through `go_router`.
- Item domain model, DAO, repository, and free-limit provider already exist.

Phase 2 should turn the items area into the first fully usable product workflow in the app, while staying aligned with `docs/ARCHITECTURE.md`, `docs/PLAN.md`, and `docs/PHASE_CHECKLIST.md`.

There is an existing unrelated working tree change in `android/app/build.gradle.kts`. Phase 2 work must not modify or revert it.

## Scope

Phase 2 includes:

- A real `ItemsListScreen` with mobile-first list layout.
- Empty state for first use.
- Category filtering through visible horizontal chips.
- `AddEditItemScreen` with full item form and validation.
- `ItemDetailScreen` with item information, warranty state, and actions.
- Local photo picking, compression, storage, replacement, and deletion.
- Item create, update, delete, and read flows using the existing repository layer.
- Warranty state display: active, expired, or no warranty.
- Free-limit enforcement when attempting to create the 6th item.
- A minimal `PaywallScreen` entry flow used only as a gate destination for this phase.
- Tests for new non-trivial logic and key widget behavior.

Phase 2 does not include:

- Real purchase flow or RevenueCat integration.
- Maintenance CRUD implementation beyond reserving the detail-screen space and route compatibility.
- Dashboard integration, notifications, onboarding, or document UX.
- A grid/list toggle. The feature ships with list view only.

## Product Decisions

The following decisions were explicitly validated during brainstorming and should be treated as fixed for this phase:

- Default item browsing layout is `list`, not grid.
- Category filter is visible directly on the screen through horizontal chips, not hidden behind an app bar filter action.
- The add-item limit must be enforced now, with a minimal paywall destination, instead of postponing the real flow until Phase 7.

## Execution Approach

Implement Phase 2 in thin vertical slices, keeping the app runnable after each slice:

1. Items list state and visible list UI.
2. Category filter chips and empty states.
3. Add/edit form with validation and persistence.
4. Detail screen and delete flow.
5. Photo handling.
6. Freemium gate and minimal paywall route.
7. Tests and checklist updates.

Each completed checklist item should be marked in `docs/PHASE_CHECKLIST.md` immediately after the implementation for that task lands.

## Screen Architecture

Files should follow the existing project structure in `docs/ARCHITECTURE.md`.

Expected feature files:

- `lib/features/items/items_list_screen.dart`
- `lib/features/items/add_edit_item_screen.dart`
- `lib/features/items/item_detail_screen.dart`
- `lib/features/items/items_provider.dart`
- `lib/features/items/widgets/item_card.dart`
- `lib/features/items/widgets/category_picker.dart`
- `lib/features/items/widgets/warranty_badge.dart`
- `lib/features/items/widgets/item_photo.dart`

Expected shared or service files:

- `lib/data/services/photo_service.dart`
- `lib/shared/widgets/empty_state.dart`
- `lib/shared/widgets/photo_picker_sheet.dart`
- `lib/shared/widgets/confirm_dialog.dart`

If some shared widgets do not exist yet, create only the ones required to support this feature cleanly. Do not introduce broader abstractions than the current scope needs.

## Items List Screen

`ItemsListScreen` is the default entry point for the feature.

### Layout

- Use a vertical list as the only supported layout in this phase.
- Show horizontal category chips under the app bar.
- Include a `Todos` chip followed by all item categories.
- Make the chip row horizontally scrollable if needed.
- Show a FAB for adding a new item.

### Data and Ordering

- Default list shows all items ordered by `createdAt` descending, using the repository's item stream.
- When a category chip is selected, switch to the matching filtered stream.
- The filter state belongs to the feature provider layer, not to local mutable widget state scattered across the screen.

### Item Card Contents

Each item row should show, in order of importance:

- Thumbnail if a photo exists.
- Item name.
- Category label.
- Brand/model summary if present.
- Warranty badge.

Cards should be tappable and navigate to item detail.

### Empty States

Two empty states are needed:

- No items at all: onboarding-style CTA to create the first item.
- No items for selected category: lighter filtered-empty state with action to clear the filter.

## Category Filter UX

Use visible category chips instead of a filter menu.

Why this is the chosen pattern for HouseKeep:

- Category filtering is frequent and simple.
- Discoverability matters more than saving a small amount of vertical space.
- The app is mobile-first and utility-oriented, so reducing taps and hidden controls is more valuable than keeping the top area visually minimal.

Use `FilterChip`, `ChoiceChip`, or a segmented pattern that matches the existing Material 3 theme, but keep the interaction as a single-select horizontal filter.

## Add/Edit Item Screen

Use one shared screen for create and edit flows.

### Required Fields

- `name`: required.
- `category`: required.

### Optional Fields

- `brand`
- `model`
- `purchaseDate`
- `warrantyMonths`
- `photoPath`
- `notes`

### Validation Rules

- Name must not be empty or whitespace-only.
- Warranty months, when present, must parse as a positive integer.
- Form submission must trim user-entered text where appropriate.
- Purchase date can be omitted; warranty logic must gracefully handle missing purchase date or missing warranty months.

### Save Behavior

- Create flow generates a new item id and timestamps through the existing project utilities/patterns.
- Edit flow preserves immutable identity and original `createdAt`, updates `updatedAt`, and replaces only changed fields.
- On success, return to the previous screen and refresh through reactive streams rather than manual list reloading.

## Photo Handling

Photo behavior belongs behind a service abstraction.

### Responsibilities of `PhotoService`

- Offer pick-from-camera and pick-from-gallery actions.
- Compress image before storing it locally.
- Save the final file under the app documents directory using a stable app-owned path.
- Return the stored file path for persistence in the item record.
- Delete orphaned photo files when an item is deleted or when a photo is replaced.

### UX Rules

- The form should let the user add, replace, preview, and remove a photo.
- The list uses a thumbnail-sized presentation.
- The detail screen can show a larger preview.
- Photo failures should not crash the form. Surface a user-facing error message and keep the current form state intact.

## Item Detail Screen

`ItemDetailScreen` should present a complete read view for a single item.

### Contents

- Header area with photo, item name, category, and warranty badge.
- Info rows for brand, model, purchase date, warranty duration, and notes.
- Action entry points for edit and delete.

### Maintenance Section

The architecture expects item detail to connect with future maintenance work. In Phase 2, the screen should reserve a clear section for maintenances, but the section can stay minimal:

- It may show a placeholder, a stub CTA, or a section header prepared for Phase 3.
- It should not implement maintenance CRUD yet.

This keeps the detail screen structurally ready without pulling Phase 3 scope forward.

## Delete Flow

Deleting an item must require explicit confirmation.

Requirements:

- Show a confirmation dialog before deletion.
- Use the existing DB cascade to remove related maintenances.
- Delete any stored photo associated with the item.
- After deletion, return to the appropriate screen without stale state.

## Warranty Badge

Show one of three visual states:

- Active warranty.
- Expired warranty.
- No warranty.

The badge should be derived from the domain model's existing warranty calculation helpers rather than duplicating date logic in the UI. Visible strings must come from ARB localization files.

## Freemium Gate

The gate is enforced when the user attempts to add an item.

Flow:

1. User taps the add FAB or equivalent entry point.
2. Read `canAddItemProvider`.
3. If true, navigate to create item.
4. If false, navigate to a minimal `PaywallScreen`.

The Phase 2 paywall is intentionally narrow:

- Explain that the free plan supports up to 5 items.
- Explain that Pro unlocks unlimited items.
- Provide a primary CTA placeholder for upgrade.
- Provide a secondary action to go back.

This screen is a navigation destination and UX gate, not the final monetization implementation.

## Routing

Extend the existing `go_router` setup with the routes already planned in `docs/ARCHITECTURE.md`:

- `/items/add`
- `/items/:id`
- `/items/:id/edit`
- `/paywall`

Use the existing `go_router` pattern already present in `lib/app.dart`. Do not introduce a different navigation mechanism inside this feature.

## Providers and State

`items_provider.dart` should centralize feature state and actions that are not purely presentational.

Expected responsibilities:

- Selected category filter state.
- Watching all items vs filtered items.
- Read helper for item detail by id.
- Actions for create, update, delete.
- Add-entry gate helper that decides between item creation and paywall.

Keep provider APIs small and explicit. Avoid introducing large controller classes if a few focused providers or notifiers are enough.

## Localization and Theme

All visible strings must go through ARB files in `lib/core/l10n/`.

All colors must come from the centralized theme and color system. No inline semantic colors for warranty states, chips, placeholders, or photo actions.

## Testing Strategy

Phase 2 should follow TDD for any new behavior change or non-trivial logic.

Minimum coverage for this phase:

- Provider tests for category filtering behavior.
- Provider or feature tests for freemium gate behavior.
- Unit tests for photo service logic that can be isolated from platform calls.
- Widget tests for:
  - empty state with zero items,
  - filtered-empty state,
  - populated list rendering,
  - add action routing to paywall when the limit is reached.

Keep tests deterministic. Filesystem and picker interactions should be abstracted enough that they can be tested without real device I/O.

## Verification

Run verification after implementation blocks as needed:

- `dart run build_runner build --delete-conflicting-outputs` if new Riverpod-generated files are added or updated.
- `flutter analyze`
- `flutter test`

If platform-specific image picker behavior cannot be fully exercised in tests, cover the decision logic and failure handling with unit or widget tests and leave real device behavior for manual validation.

## Documentation Updates

During implementation:

- Update `docs/PHASE_CHECKLIST.md` immediately as each Phase 2 task is completed.

After the whole phase is complete:

- Update `README.md` to mark Phase 2 as completed if all Phase 2 checklist items are done.

Update `docs/ARCHITECTURE.md` or `docs/DATA_MODEL.md` only if implementation reveals a real design change rather than a code-level detail.
