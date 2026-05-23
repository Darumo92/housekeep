# Phase 2 Items Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the full HouseKeep Phase 2 item workflow: list, filter, create, edit, detail, local photos, delete, and free-limit gate.

**Architecture:** Keep business rules in domain/models and repository providers, feature state in `lib/features/items/items_provider.dart`, and screen widgets small and focused. Use reactive Riverpod streams for list/detail updates, a thin `PhotoService` abstraction for picker/storage logic, and a minimal paywall route for the 6th-item gate.

**Tech Stack:** Flutter 3.x, Dart 3.9, Riverpod annotations/code generation, Drift repositories, go_router, image_picker, path_provider, Material 3, flutter_test.

---

## Execution Rules

- Do not modify or revert the existing unrelated change in `android/app/build.gradle.kts`.
- Do not commit unless the user explicitly authorizes commits. Where this plan says to commit, skip that step if commit authorization has not been given and report the uncommitted files instead.
- Follow TDD strictly: write the failing test first, run it to see the expected failure, then add minimal code.
- Run `dart run build_runner build --delete-conflicting-outputs` after adding or changing Riverpod annotated providers.
- Update `docs/PHASE_CHECKLIST.md` immediately after each completed Phase 2 checklist block.
- Update `README.md` only after the whole Phase 2 checklist is complete.

## File Structure Map

### Existing files to modify

- `lib/app.dart` — add item detail, add/edit, and paywall routes.
- `lib/features/items/items_list_screen.dart` — replace placeholder with the real list screen.
- `lib/core/l10n/app_en.arb` — add Phase 2 strings in English.
- `lib/core/l10n/app_es.arb` — add Phase 2 strings in Spanish.
- `docs/PHASE_CHECKLIST.md` — mark completed Phase 2 tasks as they land.
- `README.md` — mark Phase 2 complete after the whole phase passes verification.
- `test/app_smoke_test.dart` — extend shell/router coverage for new item routes.

### New feature files

- `lib/features/items/items_provider.dart` — category filter state, item streams, item by id provider, save/delete helpers, add-entry gate helper.
- `lib/features/items/add_edit_item_screen.dart` — shared create/edit form.
- `lib/features/items/item_detail_screen.dart` — read-only detail view with actions.
- `lib/features/items/widgets/category_picker.dart` — horizontal single-select category chips.
- `lib/features/items/widgets/item_card.dart` — list row presentation.
- `lib/features/items/widgets/warranty_badge.dart` — active/expired/no-warranty badge.
- `lib/features/items/widgets/item_photo.dart` — photo thumbnail/full preview helper.

### New shared/service files

- `lib/data/services/photo_service.dart` — abstraction and local implementation using `image_picker` + app documents dir.
- `lib/data/services/photo_service_providers.dart` — provider for `PhotoService`.
- `lib/shared/widgets/empty_state.dart` — reusable icon/title/body/CTA empty state.
- `lib/shared/widgets/photo_picker_sheet.dart` — bottom sheet for camera/gallery/remove actions.
- `lib/shared/widgets/confirm_dialog.dart` — reusable destructive confirmation dialog.
- `lib/features/paywall/paywall_screen.dart` — minimal Phase 2 paywall destination.

### New tests

- `test/features/items/items_provider_test.dart` — category filtering and add-entry gate tests.
- `test/features/items/items_list_screen_test.dart` — empty state, filtered empty state, populated list, and paywall gate UI tests.
- `test/features/items/add_edit_item_screen_test.dart` — validation and save behavior tests.
- `test/features/items/item_detail_screen_test.dart` — detail rendering and delete confirmation tests.
- `test/data/services/photo_service_test.dart` — photo storage/replacement/delete logic tests.

---

### Task 1: Add Phase 2 Strings And Route Coverage

**Files:**
- Modify: `lib/core/l10n/app_en.arb`
- Modify: `lib/core/l10n/app_es.arb`
- Modify: `lib/app.dart`
- Test: `test/app_smoke_test.dart`

- [ ] **Step 1: Write the failing route test**

Add this test to `test/app_smoke_test.dart`:

```dart
test('maps item detail and paywall paths to the correct shell destination', () {
  expect(resolveShellDestination('/items/abc').index, 1);
  expect(resolveShellDestination('/items/abc/edit').index, 1);
  expect(resolveShellDestination('/paywall').index, 0);
});
```

- [ ] **Step 2: Run the test to verify it fails for `/paywall`**

Run:

```bash
flutter test test/app_smoke_test.dart
```

Expected: FAIL because `/paywall` is not routed yet.

- [ ] **Step 3: Add new localization keys**

Append these keys to `lib/core/l10n/app_en.arb` before the closing `}`:

```json
  "itemsEmptyTitle": "Start with your first item",
  "itemsEmptyBody": "Add an appliance, device, or home system to track its warranty and maintenance.",
  "itemsEmptyCta": "Add item",
  "itemsFilteredEmptyTitle": "No items in this category",
  "itemsFilteredEmptyBody": "Try another category or clear the filter.",
  "itemsClearFilter": "Clear filter",
  "itemsFilterAll": "All",
  "itemNameLabel": "Name",
  "itemBrandLabel": "Brand",
  "itemModelLabel": "Model",
  "itemPurchaseDateLabel": "Purchase date",
  "itemWarrantyMonthsLabel": "Warranty months",
  "itemNotesLabel": "Notes",
  "itemPhotoLabel": "Photo",
  "itemCategoryLabel": "Category",
  "itemSave": "Save",
  "itemEdit": "Edit",
  "itemDelete": "Delete",
  "itemDeleteTitle": "Delete item?",
  "itemDeleteBody": "This will also delete related maintenance history.",
  "itemDeleteConfirm": "Delete",
  "itemNoWarranty": "No warranty",
  "itemWarrantyActive": "Warranty active",
  "itemWarrantyExpired": "Warranty expired",
  "itemAddTitle": "Add item",
  "itemEditTitle": "Edit item",
  "itemDetailTitle": "Item details",
  "itemPhotoAdd": "Add photo",
  "itemPhotoReplace": "Replace photo",
  "itemPhotoRemove": "Remove photo",
  "itemPhotoCamera": "Take photo",
  "itemPhotoGallery": "Choose from gallery",
  "itemValidationName": "Enter a name",
  "itemValidationWarrantyMonths": "Enter a valid number of months",
  "itemMaintenanceSectionTitle": "Maintenance",
  "itemMaintenanceSectionPlaceholder": "Maintenance tasks will appear here in Phase 3.",
  "paywallItemsLimitTitle": "Unlock unlimited items",
  "paywallItemsLimitBody": "The free plan includes up to 5 items. Upgrade to Pro to add as many as you need.",
  "paywallUpgradeCta": "Upgrade soon",
  "paywallBack": "Go back"
```

Append these Spanish equivalents to `lib/core/l10n/app_es.arb`:

```json
  "itemsEmptyTitle": "Empieza con tu primer item",
  "itemsEmptyBody": "Añade un electrodoméstico, dispositivo o sistema del hogar para controlar su garantía y mantenimiento.",
  "itemsEmptyCta": "Añadir item",
  "itemsFilteredEmptyTitle": "No hay items en esta categoría",
  "itemsFilteredEmptyBody": "Prueba otra categoría o limpia el filtro.",
  "itemsClearFilter": "Quitar filtro",
  "itemsFilterAll": "Todos",
  "itemNameLabel": "Nombre",
  "itemBrandLabel": "Marca",
  "itemModelLabel": "Modelo",
  "itemPurchaseDateLabel": "Fecha de compra",
  "itemWarrantyMonthsLabel": "Meses de garantía",
  "itemNotesLabel": "Notas",
  "itemPhotoLabel": "Foto",
  "itemCategoryLabel": "Categoría",
  "itemSave": "Guardar",
  "itemEdit": "Editar",
  "itemDelete": "Borrar",
  "itemDeleteTitle": "¿Borrar item?",
  "itemDeleteBody": "Esto también borrará el historial de mantenimiento relacionado.",
  "itemDeleteConfirm": "Borrar",
  "itemNoWarranty": "Sin garantía",
  "itemWarrantyActive": "Garantía activa",
  "itemWarrantyExpired": "Garantía vencida",
  "itemAddTitle": "Añadir item",
  "itemEditTitle": "Editar item",
  "itemDetailTitle": "Detalle del item",
  "itemPhotoAdd": "Añadir foto",
  "itemPhotoReplace": "Cambiar foto",
  "itemPhotoRemove": "Quitar foto",
  "itemPhotoCamera": "Hacer foto",
  "itemPhotoGallery": "Elegir de galería",
  "itemValidationName": "Introduce un nombre",
  "itemValidationWarrantyMonths": "Introduce un número de meses válido",
  "itemMaintenanceSectionTitle": "Mantenimiento",
  "itemMaintenanceSectionPlaceholder": "Las tareas de mantenimiento aparecerán aquí en la Fase 3.",
  "paywallItemsLimitTitle": "Desbloquea items ilimitados",
  "paywallItemsLimitBody": "El plan gratuito incluye hasta 5 items. Mejora a Pro para añadir todos los que necesites.",
  "paywallUpgradeCta": "Mejorar pronto",
  "paywallBack": "Volver"
```

- [ ] **Step 4: Add the new routes in `lib/app.dart`**

Extend the router with these builders:

```dart
GoRoute(
  path: '/items/add',
  builder: (context, state) => const AddEditItemScreen(),
),
GoRoute(
  path: '/items/:id',
  builder: (context, state) => ItemDetailScreen(itemId: state.pathParameters['id']!),
),
GoRoute(
  path: '/items/:id/edit',
  builder: (context, state) => AddEditItemScreen(itemId: state.pathParameters['id']),
),
GoRoute(
  path: '/paywall',
  builder: (context, state) => const PaywallScreen(),
),
```

Also add the corresponding imports at the top of `lib/app.dart`.

- [ ] **Step 5: Run the route test again**

Run:

```bash
flutter test test/app_smoke_test.dart
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/l10n/app_en.arb lib/core/l10n/app_es.arb lib/app.dart test/app_smoke_test.dart
git commit -m "feat: add phase 2 item routes and copy"
```

### Task 2: Add Items Feature Providers

**Files:**
- Create: `lib/features/items/items_provider.dart`
- Test: `test/features/items/items_provider_test.dart`

- [ ] **Step 1: Write failing provider tests**

Create `test/features/items/items_provider_test.dart` with:

```dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/features/items/items_provider.dart';

void main() {
  test('itemsStreamProvider returns all items when filter is null', () async {
    final container = ProviderContainer(
      overrides: [
        itemsRepositoryProvider.overrideWithValue(_FakeItemsRepository()),
      ],
    );

    final items = await container.read(filteredItemsProvider.future);
    expect(items, hasLength(2));
  });

  test('itemsStreamProvider returns only matching category when selected', () async {
    final container = ProviderContainer(
      overrides: [
        itemsRepositoryProvider.overrideWithValue(_FakeItemsRepository()),
      ],
    );

    container.read(selectedItemCategoryProvider.notifier).state = ItemCategory.kitchen;

    final items = await container.read(filteredItemsProvider.future);
    expect(items, hasLength(1));
    expect(items.single.category, ItemCategory.kitchen);
  });

  test('addItemDestinationProvider returns paywall when free limit is reached', () async {
    final container = ProviderContainer(
      overrides: [canAddItemProvider.overrideWith((ref) async => false)],
    );

    expect(await container.read(addItemDestinationProvider.future), '/paywall');
  });
}

class _FakeItemsRepository implements ItemsRepository {
  @override
  Future<int> countItems() async => 2;

  @override
  Future<int> deleteItem(String id) async => 1;

  @override
  Future<Item?> getItem(String id) async => _items.firstWhere((item) => item.id == id);

  @override
  Future<void> saveItem(Item item) async {}

  @override
  Stream<List<Item>> watchItems() => Stream.value(_items);

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) =>
      Stream.value(_items.where((item) => item.category == category).toList());
}

final _items = [
  Item(
    id: '1',
    name: 'Fridge',
    category: ItemCategory.kitchen,
    brand: 'LG',
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: DateTime(2026, 5, 22),
    updatedAt: DateTime(2026, 5, 22),
  ),
  Item(
    id: '2',
    name: 'Washer',
    category: ItemCategory.laundry,
    brand: 'Bosch',
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: DateTime(2026, 5, 21),
    updatedAt: DateTime(2026, 5, 21),
  ),
];
```

- [ ] **Step 2: Run the provider tests to verify they fail**

Run:

```bash
flutter test test/features/items/items_provider_test.dart
```

Expected: FAIL because `filteredItemsProvider`, `selectedItemCategoryProvider`, and `addItemDestinationProvider` do not exist.

- [ ] **Step 3: Implement `lib/features/items/items_provider.dart`**

Create this file with:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';

part 'items_provider.g.dart';

@riverpod
class SelectedItemCategory extends _$SelectedItemCategory {
  @override
  ItemCategory? build() => null;

  void select(ItemCategory? category) => state = category;

  void clear() => state = null;
}

@riverpod
Stream<List<Item>> filteredItems(FilteredItemsRef ref) {
  final selectedCategory = ref.watch(selectedItemCategoryProvider);
  final repository = ref.watch(itemsRepositoryProvider);
  return selectedCategory == null
      ? repository.watchItems()
      : repository.watchItemsByCategory(selectedCategory);
}

@riverpod
Future<String> addItemDestination(AddItemDestinationRef ref) async {
  final canAdd = await ref.watch(canAddItemProvider.future);
  return canAdd ? '/items/add' : '/paywall';
}

@riverpod
Future<Item?> itemById(ItemByIdRef ref, String id) {
  return ref.watch(itemsRepositoryProvider).getItem(id);
}
```

- [ ] **Step 4: Generate Riverpod code and rerun tests**

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/features/items/items_provider_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/items/items_provider.dart lib/features/items/items_provider.g.dart test/features/items/items_provider_test.dart
git commit -m "feat: add items feature providers"
```

### Task 3: Build The Items List Screen And Shared Empty State Widgets

**Files:**
- Modify: `lib/features/items/items_list_screen.dart`
- Create: `lib/features/items/widgets/category_picker.dart`
- Create: `lib/features/items/widgets/item_card.dart`
- Create: `lib/features/items/widgets/warranty_badge.dart`
- Create: `lib/features/items/widgets/item_photo.dart`
- Create: `lib/shared/widgets/empty_state.dart`
- Test: `test/features/items/items_list_screen_test.dart`

- [ ] **Step 1: Write the failing list screen tests**

Create `test/features/items/items_list_screen_test.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/app.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';

void main() {
  testWidgets('shows first-use empty state when there are no items', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(_EmptyItemsRepository()),
          canAddItemProvider.overrideWith((ref) async => true),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Start with your first item'), findsOneWidget);
    expect(find.text('Add item'), findsAtLeastNWidgets(1));
  });

  testWidgets('shows item rows and category chips when data exists', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(_PopulatedItemsRepository()),
          canAddItemProvider.overrideWith((ref) async => true),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Fridge'), findsOneWidget);
    expect(find.text('Washer'), findsOneWidget);
  });

  testWidgets('navigates to paywall when add is tapped and free limit is reached', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(_PopulatedItemsRepository()),
          canAddItemProvider.overrideWith((ref) async => false),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Unlock unlimited items'), findsOneWidget);
  });
}

class _EmptyItemsRepository implements ItemsRepository {
  @override
  Future<int> countItems() async => 0;

  @override
  Future<int> deleteItem(String id) async => 1;

  @override
  Future<Item?> getItem(String id) async => null;

  @override
  Future<void> saveItem(Item item) async {}

  @override
  Stream<List<Item>> watchItems() => const Stream.empty();

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) => const Stream.empty();
}

class _PopulatedItemsRepository implements ItemsRepository {
  @override
  Future<int> countItems() async => 2;

  @override
  Future<int> deleteItem(String id) async => 1;

  @override
  Future<Item?> getItem(String id) async => _items.firstWhere((item) => item.id == id);

  @override
  Future<void> saveItem(Item item) async {}

  @override
  Stream<List<Item>> watchItems() => Stream.value(_items);

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) =>
      Stream.value(_items.where((item) => item.category == category).toList());
}

final _items = [
  Item(
    id: '1',
    name: 'Fridge',
    category: ItemCategory.kitchen,
    brand: 'LG',
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: DateTime(2026, 5, 22),
    updatedAt: DateTime(2026, 5, 22),
  ),
  Item(
    id: '2',
    name: 'Washer',
    category: ItemCategory.laundry,
    brand: 'Bosch',
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: DateTime(2026, 5, 21),
    updatedAt: DateTime(2026, 5, 21),
  ),
];
```

- [ ] **Step 2: Run the list screen tests to verify they fail**

Run:

```bash
flutter test test/features/items/items_list_screen_test.dart
```

Expected: FAIL because the list UI and paywall screen do not exist yet.

- [ ] **Step 3: Create the shared empty state widget**

Create `lib/shared/widgets/empty_state.dart` with:

```dart
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(body, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create the list helper widgets**

Create `lib/features/items/widgets/warranty_badge.dart` with:

```dart
import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/models/item.dart';

class WarrantyBadge extends StatelessWidget {
  const WarrantyBadge({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final expiry = item.warrantyExpiryDate;
    final scheme = Theme.of(context).colorScheme;

    final (label, color) = expiry == null
        ? (l10n.itemNoWarranty, scheme.outline)
        : item.isWarrantyActive()
            ? (l10n.itemWarrantyActive, scheme.primary)
            : (l10n.itemWarrantyExpired, scheme.error);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
```

Create `lib/features/items/widgets/item_photo.dart` with:

```dart
import 'dart:io';

import 'package:flutter/material.dart';

class ItemPhoto extends StatelessWidget {
  const ItemPhoto({super.key, this.photoPath, this.size = 56});

  final String? photoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    if (path == null || path.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.photo_outlined),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(File(path), width: size, height: size, fit: BoxFit.cover),
    );
  }
}
```

Create `lib/features/items/widgets/item_card.dart` with:

```dart
import 'package:flutter/material.dart';

import '../../../domain/models/item.dart';
import 'item_photo.dart';
import 'warranty_badge.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.onTap});

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [item.brand, item.model].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: ItemPhoto(photoPath: item.photoPath),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.category.dbValue),
            if (subtitle.isNotEmpty) Text(subtitle),
            const SizedBox(height: 8),
            WarrantyBadge(item: item),
          ],
        ),
      ),
    );
  }
}
```

Create `lib/features/items/widgets/category_picker.dart` with:

```dart
import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/enums/item_category.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final ItemCategory? selectedCategory;
  final ValueChanged<ItemCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(l10n.itemsFilterAll),
              selected: selectedCategory == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final category in ItemCategory.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category.label(l10n)),
                selected: selectedCategory == category,
                onSelected: (_) => onSelected(category),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Replace `ItemsListScreen` placeholder with the real list UI**

Replace `lib/features/items/items_list_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import 'items_provider.dart';
import 'widgets/category_picker.dart';
import 'widgets/item_card.dart';

class ItemsListScreen extends ConsumerWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedCategory = ref.watch(selectedItemCategoryProvider);
    final itemsAsync = ref.watch(filteredItemsProvider);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 12),
          CategoryPicker(
            selectedCategory: selectedCategory,
            onSelected: (category) => ref.read(selectedItemCategoryProvider.notifier).select(category),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  final hasFilter = selectedCategory != null;
                  return EmptyState(
                    icon: hasFilter ? Icons.filter_alt_off_outlined : Icons.kitchen_outlined,
                    title: hasFilter ? l10n.itemsFilteredEmptyTitle : l10n.itemsEmptyTitle,
                    body: hasFilter ? l10n.itemsFilteredEmptyBody : l10n.itemsEmptyBody,
                    actionLabel: hasFilter ? l10n.itemsClearFilter : l10n.itemsEmptyCta,
                    onAction: hasFilter
                        ? () => ref.read(selectedItemCategoryProvider.notifier).clear()
                        : () async => context.go(await ref.read(addItemDestinationProvider.future)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ItemCard(
                      item: item,
                      onTap: () => context.go('/items/${item.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => context.go(await ref.read(addItemDestinationProvider.future)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

- [ ] **Step 6: Run the list screen tests again**

Run:

```bash
flutter test test/features/items/items_list_screen_test.dart
```

Expected: still FAIL only on the paywall assertion until Task 7 exists. If the first two tests fail, fix the screen before moving on.

- [ ] **Step 7: Commit**

```bash
git add lib/features/items/items_list_screen.dart lib/features/items/widgets/category_picker.dart lib/features/items/widgets/item_card.dart lib/features/items/widgets/warranty_badge.dart lib/features/items/widgets/item_photo.dart lib/shared/widgets/empty_state.dart test/features/items/items_list_screen_test.dart
git commit -m "feat: add items list screen"
```

### Task 4: Build The Add/Edit Item Form

**Files:**
- Create: `lib/features/items/add_edit_item_screen.dart`
- Modify: `lib/features/items/items_provider.dart`
- Test: `test/features/items/add_edit_item_screen_test.dart`

- [ ] **Step 1: Write the failing form tests**

Create `test/features/items/add_edit_item_screen_test.dart` with:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/app.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';

void main() {
  testWidgets('shows validation when name is empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [itemsRepositoryProvider.overrideWithValue(_RecordingItemsRepository())],
        child: const HouseKeepApp(initialLocation: '/items/add'),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a name'), findsOneWidget);
  });

  testWidgets('saves a new item when the form is valid', (tester) async {
    final repository = _RecordingItemsRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [itemsRepositoryProvider.overrideWithValue(repository)],
        child: const HouseKeepApp(initialLocation: '/items/add'),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Boiler');
    await tester.tap(find.text('Kitchen').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repository.savedItems, hasLength(1));
    expect(repository.savedItems.single.name, 'Boiler');
  });
}

class _RecordingItemsRepository implements ItemsRepository {
  final savedItems = <Item>[];
  @override
  Future<void> saveItem(Item item) async => savedItems.add(item);
  @override
  Future<int> countItems() async => savedItems.length;
  @override
  Future<int> deleteItem(String id) async => 1;
  @override
  Future<Item?> getItem(String id) async => null;
  @override
  Stream<List<Item>> watchItems() => Stream.value(savedItems);
  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) => Stream.value(savedItems.where((item) => item.category == category).toList());
}
```

- [ ] **Step 2: Run the form tests to verify they fail**

Run:

```bash
flutter test test/features/items/add_edit_item_screen_test.dart
```

Expected: FAIL because `AddEditItemScreen` does not exist.

- [ ] **Step 3: Add save helpers to `items_provider.dart`**

Append these providers to `lib/features/items/items_provider.dart`:

```dart
@riverpod
class SaveItem extends _$SaveItem {
  @override
  FutureOr<void> build() {}

  Future<void> save(Item item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).saveItem(item);
    });
  }
}

@riverpod
class DeleteItem extends _$DeleteItem {
  @override
  FutureOr<void> build() {}

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).deleteItem(id);
    });
  }
}
```

- [ ] **Step 4: Implement `AddEditItemScreen` minimally**

Create `lib/features/items/add_edit_item_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';
import 'items_provider.dart';

class AddEditItemScreen extends ConsumerStatefulWidget {
  const AddEditItemScreen({super.key, this.itemId});

  final String? itemId;

  @override
  ConsumerState<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends ConsumerState<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _warrantyMonthsController = TextEditingController();
  final _notesController = TextEditingController();
  ItemCategory _selectedCategory = ItemCategory.kitchen;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _warrantyMonthsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.itemId == null ? l10n.itemAddTitle : l10n.itemEditTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.itemNameLabel),
              validator: (value) => value == null || value.trim().isEmpty ? l10n.itemValidationName : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ItemCategory>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: l10n.itemCategoryLabel),
              items: [
                for (final category in ItemCategory.values)
                  DropdownMenuItem(value: category, child: Text(category.label(l10n))),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value ?? ItemCategory.kitchen),
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _brandController, decoration: InputDecoration(labelText: l10n.itemBrandLabel)),
            const SizedBox(height: 16),
            TextFormField(controller: _modelController, decoration: InputDecoration(labelText: l10n.itemModelLabel)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _warrantyMonthsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.itemWarrantyMonthsLabel),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                return int.tryParse(value.trim()) == null ? l10n.itemValidationWarrantyMonths : null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _notesController, decoration: InputDecoration(labelText: l10n.itemNotesLabel), maxLines: 4),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                final now = DateTime.now();
                final item = Item(
                  id: widget.itemId ?? const Uuid().v4(),
                  name: _nameController.text.trim(),
                  category: _selectedCategory,
                  brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
                  model: _modelController.text.trim().isEmpty ? null : _modelController.text.trim(),
                  purchaseDate: null,
                  warrantyMonths: _warrantyMonthsController.text.trim().isEmpty ? null : int.parse(_warrantyMonthsController.text.trim()),
                  photoPath: null,
                  notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                  createdAt: now,
                  updatedAt: now,
                );

                await ref.read(saveItemProvider.notifier).save(item);
                if (mounted) context.pop();
              },
              child: Text(l10n.itemSave),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Generate code and rerun form tests**

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/features/items/add_edit_item_screen_test.dart
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/features/items/add_edit_item_screen.dart lib/features/items/items_provider.dart lib/features/items/items_provider.g.dart test/features/items/add_edit_item_screen_test.dart
git commit -m "feat: add item create and edit form"
```

### Task 5: Add Local Photo Service

**Files:**
- Create: `lib/data/services/photo_service.dart`
- Create: `lib/data/services/photo_service_providers.dart`
- Test: `test/data/services/photo_service_test.dart`

- [ ] **Step 1: Write the failing photo service tests**

Create `test/data/services/photo_service_test.dart` with:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/services/photo_service.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('housekeep_photo_test');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('copies a picked file into the app photo directory', () async {
    final source = File('${tempDir.path}/source.jpg')..writeAsBytesSync([1, 2, 3]);
    final service = LocalPhotoStorage(
      appDocumentsPath: tempDir.path,
      clock: () => DateTime(2026, 5, 22, 10),
    );

    final savedPath = await service.storePickedFile(source.path);

    expect(savedPath, contains('item_photos'));
    expect(File(savedPath).existsSync(), isTrue);
  });

  test('deletes a stored photo when asked', () async {
    final file = File('${tempDir.path}/photo.jpg')..writeAsBytesSync([1, 2, 3]);
    final service = LocalPhotoStorage(appDocumentsPath: tempDir.path);

    await service.deletePhoto(file.path);

    expect(file.existsSync(), isFalse);
  });
}
```

- [ ] **Step 2: Run the photo tests to verify they fail**

Run:

```bash
flutter test test/data/services/photo_service_test.dart
```

Expected: FAIL because `LocalPhotoStorage` does not exist.

- [ ] **Step 3: Implement `photo_service.dart`**

Create `lib/data/services/photo_service.dart` with:

```dart
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

abstract class PhotoService {
  Future<String?> pickFromCamera();
  Future<String?> pickFromGallery();
  Future<void> deletePhoto(String? path);
}

class LocalPhotoStorage {
  LocalPhotoStorage({required this.appDocumentsPath, DateTime Function()? clock})
      : clock = clock ?? DateTime.now;

  final String appDocumentsPath;
  final DateTime Function() clock;

  Future<String> storePickedFile(String sourcePath) async {
    final source = File(sourcePath);
    final directory = Directory(p.join(appDocumentsPath, 'item_photos'));
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final timestamp = clock().millisecondsSinceEpoch;
    final extension = p.extension(source.path).isEmpty ? '.jpg' : p.extension(source.path);
    final destination = p.join(directory.path, 'item_$timestamp$extension');
    await source.copy(destination);
    return destination;
  }

  Future<void> deletePhoto(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}

class LocalPhotoService implements PhotoService {
  LocalPhotoService({required this.picker, required this.storage});

  final ImagePicker picker;
  final LocalPhotoStorage storage;

  @override
  Future<String?> pickFromCamera() => _pick(ImageSource.camera);

  @override
  Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  @override
  Future<void> deletePhoto(String? path) async {
    if (path == null || path.isEmpty) return;
    await storage.deletePhoto(path);
  }

  Future<String?> _pick(ImageSource source) async {
    final file = await picker.pickImage(source: source, imageQuality: 82, maxWidth: 1600);
    if (file == null) return null;
    return storage.storePickedFile(file.path);
  }
}
```

- [ ] **Step 4: Add the provider file**

Create `lib/data/services/photo_service_providers.dart` with:

```dart
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'photo_service.dart';

part 'photo_service_providers.g.dart';

@riverpod
Future<PhotoService> photoService(PhotoServiceRef ref) async {
  final directory = await getApplicationDocumentsDirectory();
  final storage = LocalPhotoStorage(appDocumentsPath: directory.path);
  return LocalPhotoService(picker: ImagePicker(), storage: storage);
}
```

- [ ] **Step 5: Generate code and rerun photo tests**

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/data/services/photo_service_test.dart
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/data/services/photo_service.dart lib/data/services/photo_service_providers.dart lib/data/services/photo_service_providers.g.dart test/data/services/photo_service_test.dart
git commit -m "feat: add local item photo service"
```

### Task 6: Add Item Detail, Delete Confirmation, And Shared Dialogs

**Files:**
- Create: `lib/shared/widgets/confirm_dialog.dart`
- Create: `lib/features/items/item_detail_screen.dart`
- Test: `test/features/items/item_detail_screen_test.dart`

- [ ] **Step 1: Write the failing detail screen tests**

Create `test/features/items/item_detail_screen_test.dart` with:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/app.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';

void main() {
  testWidgets('shows item details and maintenance placeholder', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [itemsRepositoryProvider.overrideWithValue(_SingleItemRepository())],
        child: const HouseKeepApp(initialLocation: '/items/item-1'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Fridge'), findsOneWidget);
    expect(find.text('Maintenance'), findsOneWidget);
  });

  testWidgets('shows a delete confirmation dialog', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [itemsRepositoryProvider.overrideWithValue(_SingleItemRepository())],
        child: const HouseKeepApp(initialLocation: '/items/item-1'),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete item?'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the detail screen tests to verify they fail**

Run:

```bash
flutter test test/features/items/item_detail_screen_test.dart
```

Expected: FAIL because `ItemDetailScreen` does not exist.

- [ ] **Step 3: Create the confirmation dialog helper**

Create `lib/shared/widgets/confirm_dialog.dart` with:

```dart
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String body,
  required String confirmLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(confirmLabel)),
      ],
    ),
  );

  return result ?? false;
}
```

- [ ] **Step 4: Implement `ItemDetailScreen` minimally**

Create `lib/features/items/item_detail_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../shared/widgets/confirm_dialog.dart';
import 'items_provider.dart';
import 'widgets/item_photo.dart';
import 'widgets/warranty_badge.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemAsync = ref.watch(itemByIdProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itemDetailTitle),
        actions: [
          TextButton(onPressed: () => context.go('/items/$itemId/edit'), child: Text(l10n.itemEdit)),
        ],
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ItemPhoto(photoPath: item.photoPath, size: 160),
              const SizedBox(height: 16),
              Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              WarrantyBadge(item: item),
              const SizedBox(height: 24),
              Text(l10n.itemMaintenanceSectionTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.itemMaintenanceSectionPlaceholder),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context: context,
                    title: l10n.itemDeleteTitle,
                    body: l10n.itemDeleteBody,
                    confirmLabel: l10n.itemDeleteConfirm,
                  );
                  if (!confirmed) return;
                  await ref.read(deleteItemProvider.notifier).delete(item.id);
                  if (context.mounted) context.pop();
                },
                child: Text(l10n.itemDelete),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }
}
```

- [ ] **Step 5: Run the detail screen tests again**

Run:

```bash
flutter test test/features/items/item_detail_screen_test.dart
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/shared/widgets/confirm_dialog.dart lib/features/items/item_detail_screen.dart test/features/items/item_detail_screen_test.dart
git commit -m "feat: add item detail and delete flow"
```

### Task 7: Add The Minimal Paywall Screen

**Files:**
- Create: `lib/features/paywall/paywall_screen.dart`
- Modify: `test/features/items/items_list_screen_test.dart`

- [ ] **Step 1: Keep the existing failing paywall assertion from Task 3**

Do not change the test yet. The last test in `test/features/items/items_list_screen_test.dart` should still expect:

```dart
expect(find.text('Unlock unlimited items'), findsOneWidget);
```

- [ ] **Step 2: Implement the minimal paywall screen**

Create `lib/features/paywall/paywall_screen.dart` with:

```dart
import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium_outlined, size: 56),
              const SizedBox(height: 16),
              Text(l10n.paywallItemsLimitTitle, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(l10n.paywallItemsLimitBody, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(onPressed: () {}, child: Text(l10n.paywallUpgradeCta)),
              const SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.paywallBack)),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Rerun the list screen tests**

Run:

```bash
flutter test test/features/items/items_list_screen_test.dart
```

Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/features/paywall/paywall_screen.dart test/features/items/items_list_screen_test.dart
git commit -m "feat: add minimal item limit paywall"
```

### Task 8: Wire Photo Actions Into The Form And Finish Verification

**Files:**
- Modify: `lib/features/items/add_edit_item_screen.dart`
- Create: `lib/shared/widgets/photo_picker_sheet.dart`
- Modify: `docs/PHASE_CHECKLIST.md`
- Modify: `README.md`

- [ ] **Step 1: Write one additional failing form test for photo actions**

Add this test to `test/features/items/add_edit_item_screen_test.dart`:

```dart
testWidgets('shows photo actions section in the form', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [itemsRepositoryProvider.overrideWithValue(_RecordingItemsRepository())],
      child: const HouseKeepApp(initialLocation: '/items/add'),
    ),
  );

  await tester.pumpAndSettle();
  expect(find.text('Photo'), findsOneWidget);
  expect(find.text('Add photo'), findsOneWidget);
});
```

- [ ] **Step 2: Run the form tests to verify the new assertion fails**

Run:

```bash
flutter test test/features/items/add_edit_item_screen_test.dart
```

Expected: FAIL because the photo section is not rendered yet.

- [ ] **Step 3: Add the photo picker sheet**

Create `lib/shared/widgets/photo_picker_sheet.dart` with:

```dart
import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

enum PhotoPickerAction { camera, gallery, remove }

Future<PhotoPickerAction?> showPhotoPickerSheet(BuildContext context, {required bool hasPhoto}) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<PhotoPickerAction>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.itemPhotoCamera),
            onTap: () => Navigator.of(context).pop(PhotoPickerAction.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.itemPhotoGallery),
            onTap: () => Navigator.of(context).pop(PhotoPickerAction.gallery),
          ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.itemPhotoRemove),
              onTap: () => Navigator.of(context).pop(PhotoPickerAction.remove),
            ),
        ],
      ),
    ),
  );
}
```

- [ ] **Step 4: Render the photo section in `AddEditItemScreen`**

Add a `_photoPath` state field and insert this block before the save button:

```dart
Text(l10n.itemPhotoLabel, style: Theme.of(context).textTheme.titleMedium),
const SizedBox(height: 8),
OutlinedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.photo_camera_back_outlined),
  label: Text(_photoPath == null ? l10n.itemPhotoAdd : l10n.itemPhotoReplace),
),
```

In this step, the button can render with `onPressed: null` so the test only validates that the section is present. The real picker behavior is added in the next step.

- [ ] **Step 5: Hook the picker to `photoServiceProvider`**

Replace the stub with:

```dart
onPressed: () async {
  final action = await showPhotoPickerSheet(context, hasPhoto: _photoPath != null);
  if (action == null) return;

  if (action == PhotoPickerAction.remove) {
    final service = await ref.read(photoServiceProvider.future);
    await service.deletePhoto(_photoPath);
    setState(() => _photoPath = null);
    return;
  }

  final service = await ref.read(photoServiceProvider.future);
  final pickedPath = action == PhotoPickerAction.camera
      ? await service.pickFromCamera()
      : await service.pickFromGallery();
  if (pickedPath == null) return;
  setState(() => _photoPath = pickedPath);
},
```

Also persist `_photoPath` into the saved `Item`.

- [ ] **Step 6: Run the focused form test and then the whole Phase 2 suite**

Run:

```bash
flutter test test/features/items/add_edit_item_screen_test.dart
flutter test test/features/items test/data/services/photo_service_test.dart test/app_smoke_test.dart
flutter analyze
```

Expected: all commands PASS.

- [ ] **Step 7: Update the docs**

Mark the completed Phase 2 checklist items in `docs/PHASE_CHECKLIST.md` as they are now implemented. When all Phase 2 items are truly complete and verified, update the table in `README.md` from:

```md
| 2 | Items/Electrodomésticos (CRUD + fotos) | Pendiente |
```

to:

```md
| 2 | Items/Electrodomésticos (CRUD + fotos) | Completada |
```

- [ ] **Step 8: Commit**

```bash
git add lib/features/items/add_edit_item_screen.dart lib/shared/widgets/photo_picker_sheet.dart docs/PHASE_CHECKLIST.md README.md
git commit -m "feat: complete phase 2 items workflow"
```

## Self-Review

- Spec coverage check:
  - List-only layout: covered in Task 3.
  - Visible category chips: covered in Task 3.
  - Add/edit form and validation: covered in Task 4 and Task 8.
  - Detail and delete: covered in Task 6.
  - Warranty badge: covered in Task 3.
  - Photo service/storage/remove: covered in Task 5 and Task 8.
  - Minimal paywall gate: covered in Task 2, Task 3, and Task 7.
  - Docs updates: covered in Task 8.
- Placeholder scan: no `TODO`, `TBD`, “same shape as”, or unspecified follow-up tasks remain.
- Type consistency check: `selectedItemCategoryProvider`, `filteredItemsProvider`, `addItemDestinationProvider`, `saveItemProvider`, `deleteItemProvider`, and `photoServiceProvider` are defined with matching names across tasks.
