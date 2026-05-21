import '../../domain/enums/item_category.dart';
import '../../domain/models/item.dart';
import '../database/daos/items_dao.dart';

abstract class ItemsRepository {
  Future<void> saveItem(Item item);
  Future<int> deleteItem(String id);
  Future<Item?> getItem(String id);
  Stream<List<Item>> watchItems();
  Stream<List<Item>> watchItemsByCategory(ItemCategory category);
  Future<int> countItems();
}

class DriftItemsRepository implements ItemsRepository {
  const DriftItemsRepository(this._dao);

  final ItemsDao _dao;

  @override
  Future<void> saveItem(Item item) {
    return _dao.upsertItem(item.toCompanion());
  }

  @override
  Future<int> deleteItem(String id) {
    return _dao.deleteItem(id);
  }

  @override
  Future<Item?> getItem(String id) async {
    final row = await _dao.getItem(id);
    return row == null ? null : Item.fromDb(row);
  }

  @override
  Stream<List<Item>> watchItems() {
    return _dao.watchItems().map((rows) => rows.map(Item.fromDb).toList());
  }

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) {
    return _dao
        .watchItemsByCategory(category.dbValue)
        .map((rows) => rows.map(Item.fromDb).toList());
  }

  @override
  Future<int> countItems() {
    return _dao.countItems();
  }
}
