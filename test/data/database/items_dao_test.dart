import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/database/app_database.dart';
import 'package:housekeep/domain/enums/item_category.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('inserts, reads, watches, counts, updates, and deletes items', () async {
    final createdAt = DateTime(2026, 5, 21);
    final companion = ItemsTableCompanion.insert(
      id: 'item-1',
      name: 'Washer',
      category: ItemCategory.laundry.dbValue,
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    await database.itemsDao.upsertItem(companion);

    expect(await database.itemsDao.countItems(), 1);
    expect((await database.itemsDao.getItem('item-1'))?.name, 'Washer');
    expect(await database.itemsDao.watchItems().first, hasLength(1));

    await database.itemsDao.upsertItem(
      companion.copyWith(name: const Value('Washer updated')),
    );

    expect((await database.itemsDao.getItem('item-1'))?.name, 'Washer updated');

    await database.itemsDao.deleteItem('item-1');

    expect(await database.itemsDao.countItems(), 0);
    expect(await database.itemsDao.getItem('item-1'), isNull);
  });
}
