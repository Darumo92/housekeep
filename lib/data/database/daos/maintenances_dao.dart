import 'package:drift/drift.dart';

import '../../../core/utils/date_calculations.dart';
import '../app_database.dart';
import '../tables/maintenances_table.dart';

part 'maintenances_dao.g.dart';

@DriftAccessor(tables: [MaintenancesTable])
class MaintenancesDao extends DatabaseAccessor<AppDatabase>
    with _$MaintenancesDaoMixin {
  MaintenancesDao(super.db);

  Future<void> upsertMaintenance(MaintenancesTableCompanion maintenance) {
    return into(maintenancesTable).insertOnConflictUpdate(maintenance);
  }

  Future<int> deleteMaintenance(String id) {
    return (delete(
      maintenancesTable,
    )..where((maintenance) => maintenance.id.equals(id))).go();
  }

  Future<int> deleteMaintenancesForItem(String itemId) {
    return (delete(
      maintenancesTable,
    )..where((maintenance) => maintenance.itemId.equals(itemId))).go();
  }

  Future<MaintenanceRow?> getMaintenance(String id) {
    return (select(
      maintenancesTable,
    )..where((maintenance) => maintenance.id.equals(id))).getSingleOrNull();
  }

  Stream<List<MaintenanceRow>> watchMaintenancesForItem(String itemId) {
    return (select(maintenancesTable)
          ..where((maintenance) => maintenance.itemId.equals(itemId))
          ..orderBy([(maintenance) => OrderingTerm.asc(maintenance.nextDueAt)]))
        .watch();
  }

  Stream<List<MaintenanceRow>> watchAllMaintenances() {
    return (select(maintenancesTable)
          ..orderBy([(maintenance) => OrderingTerm.asc(maintenance.nextDueAt)]))
        .watch();
  }

  Stream<List<MaintenanceRow>> watchUpcomingMaintenances({int limit = 15}) {
    return (select(maintenancesTable)
          ..orderBy([(maintenance) => OrderingTerm.asc(maintenance.nextDueAt)])
          ..limit(limit))
        .watch();
  }

  Future<void> markAsDone(String id, {DateTime? doneAt}) async {
    final completedAt = doneAt ?? DateTime.now();
    final row = await getMaintenance(id);
    if (row == null) {
      throw StateError('Maintenance not found: $id');
    }

    await (update(
      maintenancesTable,
    )..where((maintenance) => maintenance.id.equals(id))).write(
      MaintenancesTableCompanion(
        lastDoneAt: Value(completedAt),
        nextDueAt: Value(
          DateCalculations.addMonths(completedAt, row.intervalMonths),
        ),
        updatedAt: Value(completedAt),
      ),
    );
  }
}
