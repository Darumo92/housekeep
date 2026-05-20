import 'package:drift/drift.dart';

import '../type_converters.dart';
import 'items_table.dart';

@DataClassName('MaintenanceRow')
@TableIndex(name: 'maintenances_item_id_idx', columns: {#itemId})
@TableIndex(name: 'maintenances_next_due_at_idx', columns: {#nextDueAt})
class MaintenancesTable extends Table {
  @override
  String get tableName => 'maintenances';

  TextColumn get id => text()();

  TextColumn get itemId => text()
      .named('item_id')
      .references(ItemsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text().named('name')();

  TextColumn get description => text().named('description').nullable()();

  IntColumn get intervalMonths => integer().named('interval_months')();

  IntColumn get lastDoneAt => integer()
      .named('last_done_at')
      .map(const DateTimeMillisecondsConverter())
      .nullable()();

  IntColumn get nextDueAt => integer()
      .named('next_due_at')
      .map(const DateTimeMillisecondsConverter())();

  IntColumn get notifyDaysBefore => integer().named('notify_days_before').withDefault(const Constant(7))();

  BoolColumn get isFromTemplate => boolean().named('is_from_template').withDefault(const Constant(false))();

  IntColumn get createdAt => integer()
      .named('created_at')
      .map(const DateTimeMillisecondsConverter())();

  IntColumn get updatedAt => integer()
      .named('updated_at')
      .map(const DateTimeMillisecondsConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
