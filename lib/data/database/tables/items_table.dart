import 'package:drift/drift.dart';

import '../type_converters.dart';

@DataClassName('ItemRow')
@TableIndex(name: 'items_category_idx', columns: {#category})
@TableIndex(name: 'items_created_at_idx', columns: {#createdAt})
class ItemsTable extends Table {
  @override
  String get tableName => 'items';

  TextColumn get id => text()();

  TextColumn get name => text().named('name')();

  TextColumn get category => text().named('category')();

  TextColumn get brand => text().named('brand').nullable()();

  TextColumn get model => text().named('model').nullable()();

  IntColumn get purchaseDate => integer()
      .named('purchase_date')
      .map(const DateTimeMillisecondsConverter())
      .nullable()();

  IntColumn get warrantyMonths => integer().named('warranty_months').nullable()();

  TextColumn get photoPath => text().named('photo_path').nullable()();

  TextColumn get notes => text().named('notes').nullable()();

  IntColumn get createdAt => integer()
      .named('created_at')
      .map(const DateTimeMillisecondsConverter())();

  IntColumn get updatedAt => integer()
      .named('updated_at')
      .map(const DateTimeMillisecondsConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
