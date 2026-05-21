import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/documents_table.dart';

part 'documents_dao.g.dart';

@DriftAccessor(tables: [DocumentsTable])
class DocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentsDaoMixin {
  DocumentsDao(super.db);

  Future<void> upsertDocument(DocumentsTableCompanion document) {
    return into(documentsTable).insertOnConflictUpdate(document);
  }

  Future<int> deleteDocument(String id) {
    return (delete(
      documentsTable,
    )..where((document) => document.id.equals(id))).go();
  }

  Future<DocumentRow?> getDocument(String id) {
    return (select(
      documentsTable,
    )..where((document) => document.id.equals(id))).getSingleOrNull();
  }

  Stream<List<DocumentRow>> watchDocuments() {
    return (select(
      documentsTable,
    )..orderBy([(document) => OrderingTerm.asc(document.expiryDate)])).watch();
  }

  Stream<List<DocumentRow>> watchDocumentsByType(String type) {
    return (select(documentsTable)
          ..where((document) => document.type.equals(type))
          ..orderBy([(document) => OrderingTerm.asc(document.expiryDate)]))
        .watch();
  }

  Stream<List<DocumentRow>> watchExpiringDocuments({int limit = 15}) {
    return (select(documentsTable)
          ..orderBy([(document) => OrderingTerm.asc(document.expiryDate)])
          ..limit(limit))
        .watch();
  }

  Future<int> countDocuments() async {
    final countExpression = documentsTable.id.count();
    final query = selectOnly(documentsTable)..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }
}
