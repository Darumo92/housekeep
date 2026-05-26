import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';

part 'items_provider.g.dart';

@riverpod
class SelectedItemCategory extends _$SelectedItemCategory {
  @override
  ItemCategory? build() => null;

  void select(ItemCategory category) {
    state = category;
  }

  void clear() {
    state = null;
  }
}

@riverpod
Stream<List<Item>> filteredItems(FilteredItemsRef ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  final category = ref.watch(selectedItemCategoryProvider);

  return category == null
      ? repository.watchItems()
      : repository.watchItemsByCategory(category);
}

@riverpod
Future<String> addItemDestination(AddItemDestinationRef ref) async {
  final canAddItem = await ref.watch(canAddItemProvider.future);
  return canAddItem ? '/items/add' : '/paywall';
}

@riverpod
Stream<Item?> itemById(ItemByIdRef ref, String id) {
  return ref.watch(itemsRepositoryProvider).watchItem(id);
}

@riverpod
class SaveItem extends _$SaveItem {
  @override
  FutureOr<void> build() {}

  Future<void> save(Item item) async {
    state = const AsyncLoading();
    try {
      await ref.read(itemsRepositoryProvider).saveItem(item);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

@riverpod
class DeleteItem extends _$DeleteItem {
  @override
  FutureOr<void> build() {}

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(itemsRepositoryProvider).deleteItem(id);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
