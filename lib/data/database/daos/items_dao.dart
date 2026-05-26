import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/items_table.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [ItemsTable])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(super.db);

  Future<void> upsertItem(ItemsTableCompanion item) {
    return into(itemsTable).insertOnConflictUpdate(item);
  }

  Future<int> deleteItem(String id) {
    return (delete(itemsTable)..where((item) => item.id.equals(id))).go();
  }

  Future<ItemRow?> getItem(String id) {
    return (select(
      itemsTable,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
  }

  Stream<ItemRow?> watchItem(String id) {
    return (select(
      itemsTable,
    )..where((item) => item.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<ItemRow>> watchItems() {
    return (select(
      itemsTable,
    )..orderBy([(item) => OrderingTerm.desc(item.createdAt)])).watch();
  }

  Stream<List<ItemRow>> watchItemsByCategory(String category) {
    return (select(itemsTable)
          ..where((item) => item.category.equals(category))
          ..orderBy([(item) => OrderingTerm.desc(item.createdAt)]))
        .watch();
  }

  Future<int> countItems() async {
    final countExpression = itemsTable.id.count();
    final query = selectOnly(itemsTable)..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }
}
