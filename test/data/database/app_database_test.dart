import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:housekeep/data/database/app_database.dart';

void main() {
  test('keeps native database code out of main entrypoint', () {
    final mainFile = File('lib/main.dart').readAsStringSync();

    expect(mainFile, isNot(contains('data/database/app_database.dart')));
    expect(mainFile, isNot(contains('AppDatabase')));
  });

  test('constructs the phase 0 database schema', () {
    final database = AppDatabase.forTesting(NativeDatabase.memory());

    expect(database.schemaVersion, 1);
    expect(
      database.allTables.map((table) => table.actualTableName),
      containsAll(['items', 'maintenances', 'documents']),
    );

    database.close();
  });
}
