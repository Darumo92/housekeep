import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/documents_dao.dart';
import 'daos/items_dao.dart';
import 'daos/maintenances_dao.dart';
import 'tables/documents_table.dart';
import 'tables/items_table.dart';
import 'tables/maintenances_table.dart';
import 'type_converters.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [ItemsTable, MaintenancesTable, DocumentsTable],
  daos: [ItemsDao, MaintenancesDao, DocumentsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'housekeep.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
