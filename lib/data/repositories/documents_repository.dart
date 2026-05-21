import '../../domain/enums/document_type.dart';
import '../../domain/models/document.dart';
import '../database/daos/documents_dao.dart';

abstract class DocumentsRepository {
  Future<void> saveDocument(Document document);
  Future<int> deleteDocument(String id);
  Future<Document?> getDocument(String id);
  Stream<List<Document>> watchDocuments();
  Stream<List<Document>> watchDocumentsByType(DocumentType type);
  Stream<List<Document>> watchExpiringDocuments({int limit});
  Future<int> countDocuments();
}

class DriftDocumentsRepository implements DocumentsRepository {
  const DriftDocumentsRepository(this._dao);

  final DocumentsDao _dao;

  @override
  Future<void> saveDocument(Document document) {
    return _dao.upsertDocument(document.toCompanion());
  }

  @override
  Future<int> deleteDocument(String id) {
    return _dao.deleteDocument(id);
  }

  @override
  Future<Document?> getDocument(String id) async {
    final row = await _dao.getDocument(id);
    return row == null ? null : Document.fromDb(row);
  }

  @override
  Stream<List<Document>> watchDocuments() {
    return _dao.watchDocuments().map(
      (rows) => rows.map(Document.fromDb).toList(),
    );
  }

  @override
  Stream<List<Document>> watchDocumentsByType(DocumentType type) {
    return _dao
        .watchDocumentsByType(type.dbValue)
        .map((rows) => rows.map(Document.fromDb).toList());
  }

  @override
  Stream<List<Document>> watchExpiringDocuments({int limit = 15}) {
    return _dao
        .watchExpiringDocuments(limit: limit)
        .map((rows) => rows.map(Document.fromDb).toList());
  }

  @override
  Future<int> countDocuments() {
    return _dao.countDocuments();
  }
}
