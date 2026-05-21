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

  test('markAsDone updates lastDoneAt, nextDueAt, and updatedAt', () async {
    final createdAt = DateTime(2026, 1, 1);
    await database.itemsDao.upsertItem(
      ItemsTableCompanion.insert(
        id: 'item-1',
        name: 'Boiler',
        category: ItemCategory.plumbing.dbValue,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    await database.maintenancesDao.upsertMaintenance(
      MaintenancesTableCompanion.insert(
        id: 'maintenance-1',
        itemId: 'item-1',
        name: 'Annual service',
        intervalMonths: 12,
        nextDueAt: DateTime(2026, 5, 1),
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    final doneAt = DateTime(2026, 5, 21, 9);
    await database.maintenancesDao.markAsDone('maintenance-1', doneAt: doneAt);

    final row = await database.maintenancesDao.getMaintenance('maintenance-1');
    expect(row?.lastDoneAt, doneAt);
    expect(row?.nextDueAt, DateTime(2027, 5, 21, 9));
    expect(row?.updatedAt, doneAt);
  });

  test('markAsDone throws StateError when maintenance is missing', () {
    expect(
      () => database.maintenancesDao.markAsDone('missing'),
      throwsA(isA<StateError>()),
    );
  });
}
