import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';
import 'daos/documents_dao.dart';
import 'daos/items_dao.dart';
import 'daos/maintenances_dao.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}

@riverpod
ItemsDao itemsDao(ItemsDaoRef ref) {
  return ref.watch(appDatabaseProvider).itemsDao;
}

@riverpod
MaintenancesDao maintenancesDao(MaintenancesDaoRef ref) {
  return ref.watch(appDatabaseProvider).maintenancesDao;
}

@riverpod
DocumentsDao documentsDao(DocumentsDaoRef ref) {
  return ref.watch(appDatabaseProvider).documentsDao;
}
