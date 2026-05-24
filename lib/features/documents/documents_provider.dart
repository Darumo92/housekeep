import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/models/document.dart';

part 'documents_provider.g.dart';

@riverpod
class SelectedDocumentType extends _$SelectedDocumentType {
  @override
  DocumentType? build() => null;

  void select(DocumentType type) {
    state = type;
  }

  void clear() {
    state = null;
  }
}

@riverpod
Stream<List<Document>> filteredDocuments(FilteredDocumentsRef ref) {
  final repository = ref.watch(documentsRepositoryProvider);
  final type = ref.watch(selectedDocumentTypeProvider);

  return type == null
      ? repository.watchDocuments()
      : repository.watchDocumentsByType(type);
}

@riverpod
Future<String> addDocumentDestination(AddDocumentDestinationRef ref) async {
  final canAddDocument = await ref.watch(canAddDocumentProvider.future);
  return canAddDocument ? '/documents/add' : '/paywall';
}

@riverpod
Future<Document?> documentById(DocumentByIdRef ref, String id) {
  return ref.watch(documentsRepositoryProvider).getDocument(id);
}

@riverpod
class SaveDocument extends _$SaveDocument {
  @override
  FutureOr<void> build() {}

  Future<void> save(Document document) async {
    state = const AsyncLoading();
    try {
      await ref.read(documentsRepositoryProvider).saveDocument(document);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

@riverpod
class DeleteDocument extends _$DeleteDocument {
  @override
  FutureOr<void> build() {}

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(documentsRepositoryProvider).deleteDocument(id);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
