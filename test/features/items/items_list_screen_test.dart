import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:housekeep/app.dart';
import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/features/items/item_detail_screen.dart';
import 'package:housekeep/features/items/items_provider.dart';
import 'package:housekeep/features/paywall/paywall_screen.dart';
import 'package:housekeep/shared/widgets/hk_card.dart';
import 'package:housekeep/shared/widgets/hk_chip.dart';
import 'package:housekeep/shared/widgets/hk_fab.dart';

void main() {
  testWidgets('shows first-use empty state when there are no items', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            const _FakeItemsRepository(allItems: [], itemsByCategory: {}),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    expect(find.text(l10n.itemsEmptyTitle), findsOneWidget);
    expect(find.text(l10n.itemsEmptyBody), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, l10n.itemsEmptyCta),
      findsNothing,
    );
    expect(find.byType(HkFab), findsOneWidget);
  });

  testWidgets('shows item rows and category chips when items exist', (
    tester,
  ) async {
    final kitchenItem = _item(
      id: '1',
      name: 'Fridge',
      category: ItemCategory.kitchen,
      brand: 'Bosch',
    );
    final bathroomItem = _item(
      id: '2',
      name: 'Heater',
      category: ItemCategory.bathroom,
      brand: 'Rowenta',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            _FakeItemsRepository(
              allItems: [kitchenItem, bathroomItem],
              itemsByCategory: {
                ItemCategory.kitchen: [kitchenItem],
                ItemCategory.bathroom: [bathroomItem],
              },
            ),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    expect(find.text(l10n.itemsFilterAll), findsOneWidget);
    expect(find.text(ItemCategory.kitchen.label(l10n)), findsOneWidget);
    expect(find.text(ItemCategory.bathroom.label(l10n)), findsOneWidget);
    expect(find.text('Fridge'), findsOneWidget);
    expect(find.text('Heater'), findsOneWidget);
    expect(
      find.byType(HkChip),
      findsAtLeastNWidgets(7),
    );
    expect(find.byType(HkCard), findsNWidgets(2));
  });

  testWidgets('opens item detail when an item card is tapped', (tester) async {
    final kitchenItem = _item(
      id: '1',
      name: 'Fridge',
      category: ItemCategory.kitchen,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            _FakeItemsRepository(
              allItems: [kitchenItem],
              itemsByCategory: {
                ItemCategory.kitchen: [kitchenItem],
              },
            ),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('item-card-1')));
    await tester.pumpAndSettle();

    expect(find.byType(ItemDetailScreen), findsOneWidget);
  });

  testWidgets('keeps category chips visible in filtered empty state', (
    tester,
  ) async {
    final bathroomItem = _item(
      id: '2',
      name: 'Heater',
      category: ItemCategory.bathroom,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            _FakeItemsRepository(
              allItems: [bathroomItem],
              itemsByCategory: {
                ItemCategory.kitchen: const [],
                ItemCategory.bathroom: [bathroomItem],
              },
            ),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.tap(find.text(ItemCategory.kitchen.label(l10n)));
    await tester.pumpAndSettle();

    expect(find.text(l10n.itemsFilteredEmptyTitle), findsOneWidget);
    expect(find.text(l10n.itemsFilterAll), findsOneWidget);
    expect(find.text(ItemCategory.kitchen.label(l10n)), findsOneWidget);
    expect(find.text(ItemCategory.bathroom.label(l10n)), findsOneWidget);
  });

  testWidgets(
    'shows paywall gate content when add is tapped and item limit is reached',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsRepositoryProvider.overrideWithValue(
              const _FakeItemsRepository(allItems: [], itemsByCategory: {}),
            ),
            canAddItemProvider.overrideWith((ref) async => false),
          ],
          child: const HouseKeepApp(initialLocation: '/items'),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);

      await tester.tap(find.byType(HkFab));
      await tester.pumpAndSettle();

      expect(find.byType(PaywallScreen), findsOneWidget);
      expect(find.text(l10n.paywallHeroTitle), findsOneWidget);
    },
  );

  testWidgets('keeps the paywall usable on smaller screens with larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: ProviderScope(
          child: HouseKeepApp(initialLocation: '/paywall'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.scrollUntilVisible(find.text(l10n.paywallHeroTitle), 100);

    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(find.text(l10n.paywallHeroTitle), findsOneWidget);
  });

  testWidgets('disables the fab while add navigation is in flight', (
    tester,
  ) async {
    final completer = Completer<String>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            const _FakeItemsRepository(allItems: [], itemsByCategory: {}),
          ),
          addItemDestinationProvider.overrideWith((ref) => completer.future),
        ],
        child: const HouseKeepApp(initialLocation: '/items'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(HkFab));
    await tester.pump();

    expect(
      tester
          .widget<HkFab>(find.byType(HkFab))
          .onPressed,
      isNull,
    );

    completer.complete('/paywall');
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
  });
}

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(Scaffold).first));
}

Item _item({
  required String id,
  required String name,
  required ItemCategory category,
  String? brand,
}) {
  final timestamp = DateTime(2024, 1, 1);
  return Item(
    id: id,
    name: name,
    category: category,
    brand: brand,
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

class _FakeItemsRepository implements ItemsRepository {
  const _FakeItemsRepository({
    required this.allItems,
    required this.itemsByCategory,
  });

  final List<Item> allItems;
  final Map<ItemCategory, List<Item>> itemsByCategory;

  @override
  Future<int> countItems() async => allItems.length;

  @override
  Future<int> deleteItem(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Item?> getItem(String id) {
    throw UnimplementedError();
  }

  @override
  Stream<Item?> watchItem(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveItem(Item item) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Item>> watchItems() {
    return Stream.value(allItems);
  }

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) {
    return Stream.value(itemsByCategory[category] ?? const []);
  }
}
