import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/features/items/items_provider.dart';

void main() {
  group('filteredItemsProvider', () {
    test('returns all items when selected category is null', () async {
      final kitchenItem = _item(id: '1', category: ItemCategory.kitchen);
      final bathroomItem = _item(id: '2', category: ItemCategory.bathroom);
      final container = ProviderContainer(
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
      );
      addTearDown(container.dispose);

      final items = await container.read(filteredItemsProvider.future);

      expect(items, [kitchenItem, bathroomItem]);
    });

    test('returns filtered items when a category is selected', () async {
      final kitchenItem = _item(id: '1', category: ItemCategory.kitchen);
      final bathroomItem = _item(id: '2', category: ItemCategory.bathroom);
      final container = ProviderContainer(
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
      );
      addTearDown(container.dispose);

      container
          .read(selectedItemCategoryProvider.notifier)
          .select(ItemCategory.kitchen);

      final items = await container.read(filteredItemsProvider.future);

      expect(items, [kitchenItem]);
    });

    test('returns all items again after clearing selected category', () async {
      final kitchenItem = _item(id: '1', category: ItemCategory.kitchen);
      final bathroomItem = _item(id: '2', category: ItemCategory.bathroom);
      final container = ProviderContainer(
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
      );
      addTearDown(container.dispose);

      final notifier = container.read(selectedItemCategoryProvider.notifier);
      notifier.select(ItemCategory.kitchen);
      await container.read(filteredItemsProvider.future);

      notifier.clear();
      final items = await container.read(filteredItemsProvider.future);

      expect(items, [kitchenItem, bathroomItem]);
    });
  });

  test('addItemDestinationProvider returns /paywall when cannot add items', () async {
    final container = ProviderContainer(
      overrides: [
        canAddItemProvider.overrideWith((ref) async => false),
      ],
    );
    addTearDown(container.dispose);

    final destination = await container.read(addItemDestinationProvider.future);

    expect(destination, '/paywall?gate=true');
  });

  test('itemByIdProvider forwards lookup to items repository', () async {
    final kitchenItem = _item(id: '1', category: ItemCategory.kitchen);
    final container = ProviderContainer(
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
    );
    addTearDown(container.dispose);

    final item = await container.read(itemByIdProvider('1').future);

    expect(item, kitchenItem);
  });
}

Item _item({required String id, required ItemCategory category}) {
  final timestamp = DateTime(2024, 1, 1);
  return Item(
    id: id,
    name: 'Item $id',
    category: category,
    brand: null,
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
  Future<Item?> getItem(String id) async {
    for (final item in allItems) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Stream<Item?> watchItem(String id) {
    for (final item in allItems) {
      if (item.id == id) return Stream.value(item);
    }
    return Stream.value(null);
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
