import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../enums/document_type.dart';
import '../enums/urgency_level.dart';

class Document {
  const Document({
    required this.id,
    required this.name,
    required this.type,
    required this.expiryDate,
    required this.notifyDaysBefore,
    required this.photoPath,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final DocumentType type;
  final DateTime expiryDate;
  final int notifyDaysBefore;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Document.fromDb(DocumentRow row) {
    return Document(
      id: row.id,
      name: row.name,
      type: DocumentType.fromDb(row.type),
      expiryDate: row.expiryDate,
      notifyDaysBefore: row.notifyDaysBefore,
      photoPath: row.photoPath,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  DocumentsTableCompanion toCompanion() {
    return DocumentsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type.dbValue),
      expiryDate: Value(expiryDate),
      notifyDaysBefore: Value(notifyDaysBefore),
      photoPath: Value(photoPath),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  UrgencyLevel urgencyLevel({DateTime? now}) {
    return UrgencyLevel.forDocumentExpiryDate(expiryDate, now: now);
  }
}
