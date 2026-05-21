import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/database/app_database.dart';
import 'package:housekeep/domain/enums/document_type.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'inserts, reads, watches, counts, updates, and deletes documents',
    () async {
      final createdAt = DateTime(2026, 5, 21);
      final companion = DocumentsTableCompanion.insert(
        id: 'document-1',
        name: 'Passport',
        type: DocumentType.passport.dbValue,
        expiryDate: DateTime(2027, 5, 21),
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      await database.documentsDao.upsertDocument(companion);

      expect(await database.documentsDao.countDocuments(), 1);
      expect(
        (await database.documentsDao.getDocument('document-1'))?.name,
        'Passport',
      );
      expect(await database.documentsDao.watchDocuments().first, hasLength(1));

      await database.documentsDao.upsertDocument(
        companion.copyWith(name: const Value('Passport updated')),
      );

      expect(
        (await database.documentsDao.getDocument('document-1'))?.name,
        'Passport updated',
      );

      await database.documentsDao.deleteDocument('document-1');

      expect(await database.documentsDao.countDocuments(), 0);
    },
  );
}
