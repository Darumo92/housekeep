import '../../domain/models/maintenance.dart';
import '../database/daos/maintenances_dao.dart';

abstract class MaintenancesRepository {
  Future<void> saveMaintenance(Maintenance maintenance);
  Future<int> deleteMaintenance(String id);
  Future<int> deleteMaintenancesForItem(String itemId);
  Future<Maintenance?> getMaintenance(String id);
  Stream<List<Maintenance>> watchMaintenancesForItem(String itemId);
  Stream<List<Maintenance>> watchAllMaintenances();
  Stream<List<Maintenance>> watchUpcomingMaintenances({int limit});
  Future<void> markAsDone(String id, {DateTime? doneAt});
}

class DriftMaintenancesRepository implements MaintenancesRepository {
  const DriftMaintenancesRepository(this._dao);

  final MaintenancesDao _dao;

  @override
  Future<void> saveMaintenance(Maintenance maintenance) {
    return _dao.upsertMaintenance(maintenance.toCompanion());
  }

  @override
  Future<int> deleteMaintenance(String id) {
    return _dao.deleteMaintenance(id);
  }

  @override
  Future<int> deleteMaintenancesForItem(String itemId) {
    return _dao.deleteMaintenancesForItem(itemId);
  }

  @override
  Future<Maintenance?> getMaintenance(String id) async {
    final row = await _dao.getMaintenance(id);
    return row == null ? null : Maintenance.fromDb(row);
  }

  @override
  Stream<List<Maintenance>> watchMaintenancesForItem(String itemId) {
    return _dao
        .watchMaintenancesForItem(itemId)
        .map((rows) => rows.map(Maintenance.fromDb).toList());
  }

  @override
  Stream<List<Maintenance>> watchAllMaintenances() {
    return _dao
        .watchAllMaintenances()
        .map((rows) => rows.map(Maintenance.fromDb).toList());
  }

  @override
  Stream<List<Maintenance>> watchUpcomingMaintenances({int limit = 15}) {
    return _dao
        .watchUpcomingMaintenances(limit: limit)
        .map((rows) => rows.map(Maintenance.fromDb).toList());
  }

  @override
  Future<void> markAsDone(String id, {DateTime? doneAt}) {
    return _dao.markAsDone(id, doneAt: doneAt);
  }
}
