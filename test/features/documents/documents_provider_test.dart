import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/repositories/documents_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/document_type.dart';
import 'package:housekeep/domain/models/document.dart';
import 'package:housekeep/features/documents/documents_provider.dart';

void main() {
  group('filteredDocumentsProvider', () {
    test('returns all documents when no type is selected', () async {
      final passport = _document(id: '1', type: DocumentType.passport);
      final lease = _document(id: '2', type: DocumentType.lease);
      final container = ProviderContainer(
        overrides: [
          documentsRepositoryProvider.overrideWithValue(
            _FakeDocumentsRepository(
              all: [passport, lease],
              byType: {
                DocumentType.passport: [passport],
                DocumentType.lease: [lease],
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final documents = await container.read(filteredDocumentsProvider.future);

      expect(documents, [passport, lease]);
    });

    test('returns filtered documents when a type is selected', () async {
      final passport = _document(id: '1', type: DocumentType.passport);
      final lease = _document(id: '2', type: DocumentType.lease);
      final container = ProviderContainer(
        overrides: [
          documentsRepositoryProvider.overrideWithValue(
            _FakeDocumentsRepository(
              all: [passport, lease],
              byType: {
                DocumentType.passport: [passport],
                DocumentType.lease: [lease],
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      container
          .read(selectedDocumentTypeProvider.notifier)
          .select(DocumentType.passport);

      final documents = await container.read(filteredDocumentsProvider.future);

      expect(documents, [passport]);
    });
  });

  test(
    'addDocumentDestinationProvider returns /paywall when cannot add documents',
    () async {
      final container = ProviderContainer(
        overrides: [
          canAddDocumentProvider.overrideWith((ref) async => false),
        ],
      );
      addTearDown(container.dispose);

      final destination =
          await container.read(addDocumentDestinationProvider.future);

      expect(destination, '/paywall?gate=true');
    },
  );

  test(
    'addDocumentDestinationProvider returns /documents/add when can add',
    () async {
      final container = ProviderContainer(
        overrides: [
          canAddDocumentProvider.overrideWith((ref) async => true),
        ],
      );
      addTearDown(container.dispose);

      final destination =
          await container.read(addDocumentDestinationProvider.future);

      expect(destination, '/documents/add');
    },
  );

  test('documentByIdProvider forwards to repository', () async {
    final passport = _document(id: '1', type: DocumentType.passport);
    final container = ProviderContainer(
      overrides: [
        documentsRepositoryProvider.overrideWithValue(
          _FakeDocumentsRepository(
            all: [passport],
            byType: const {},
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final document = await container.read(documentByIdProvider('1').future);

    expect(document, passport);
  });
}

Document _document({required String id, required DocumentType type}) {
  final timestamp = DateTime(2026, 1, 1);
  return Document(
    id: id,
    name: 'Document $id',
    type: type,
    expiryDate: DateTime(2027, 1, 1),
    notifyDaysBefore: 30,
    photoPath: null,
    notes: null,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

class _FakeDocumentsRepository implements DocumentsRepository {
  const _FakeDocumentsRepository({required this.all, required this.byType});

  final List<Document> all;
  final Map<DocumentType, List<Document>> byType;

  @override
  Future<int> countDocuments() async => all.length;

  @override
  Future<int> deleteDocument(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Document?> getDocument(String id) async {
    for (final document in all) {
      if (document.id == id) return document;
    }
    return null;
  }

  @override
  Future<void> saveDocument(Document document) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Document>> watchDocuments() => Stream.value(all);

  @override
  Stream<List<Document>> watchDocumentsByType(DocumentType type) =>
      Stream.value(byType[type] ?? const []);

  @override
  Stream<List<Document>> watchExpiringDocuments({int limit = 15}) =>
      Stream.value(all);
}
