import 'package:drift/drift.dart';

import '../type_converters.dart';

@DataClassName('DocumentRow')
@TableIndex(name: 'documents_expiry_date_idx', columns: {#expiryDate})
@TableIndex(name: 'documents_type_idx', columns: {#type})
class DocumentsTable extends Table {
  @override
  String get tableName => 'documents';

  TextColumn get id => text()();

  TextColumn get name => text().named('name')();

  TextColumn get type => text().named('type')();

  IntColumn get expiryDate => integer()
      .named('expiry_date')
      .map(const DateTimeMillisecondsConverter())();

  IntColumn get notifyDaysBefore => integer().named('notify_days_before').withDefault(const Constant(30))();

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
