// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentsHash() => r'0874ab9d37995a540244e019ce2dde324a0ef0a5';

/// See also [documents].
@ProviderFor(documents)
final documentsProvider = AutoDisposeStreamProvider<List<Document>>.internal(
  documents,
  name: r'documentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$documentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DocumentsRef = AutoDisposeStreamProviderRef<List<Document>>;
String _$filteredDocumentsHash() => r'960fbdfb97023427257bb8b09f9c3123c376c04f';

/// See also [filteredDocuments].
@ProviderFor(filteredDocuments)
final filteredDocumentsProvider =
    AutoDisposeStreamProvider<List<Document>>.internal(
  filteredDocuments,
  name: r'filteredDocumentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredDocumentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredDocumentsRef = AutoDisposeStreamProviderRef<List<Document>>;
String _$addDocumentDestinationHash() =>
    r'068335d21f93c74f9dec5f35c00e04a471514716';

/// See also [addDocumentDestination].
@ProviderFor(addDocumentDestination)
final addDocumentDestinationProvider =
    AutoDisposeFutureProvider<String>.internal(
  addDocumentDestination,
  name: r'addDocumentDestinationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addDocumentDestinationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddDocumentDestinationRef = AutoDisposeFutureProviderRef<String>;
String _$documentByIdHash() => r'1a3550dc829b0f96face9af38615028b3a1b9162';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [documentById].
@ProviderFor(documentById)
const documentByIdProvider = DocumentByIdFamily();

/// See also [documentById].
class DocumentByIdFamily extends Family<AsyncValue<Document?>> {
  /// See also [documentById].
  const DocumentByIdFamily();

  /// See also [documentById].
  DocumentByIdProvider call(
    String id,
  ) {
    return DocumentByIdProvider(
      id,
    );
  }

  @override
  DocumentByIdProvider getProviderOverride(
    covariant DocumentByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'documentByIdProvider';
}

/// See also [documentById].
class DocumentByIdProvider extends AutoDisposeFutureProvider<Document?> {
  /// See also [documentById].
  DocumentByIdProvider(
    String id,
  ) : this._internal(
          (ref) => documentById(
            ref as DocumentByIdRef,
            id,
          ),
          from: documentByIdProvider,
          name: r'documentByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$documentByIdHash,
          dependencies: DocumentByIdFamily._dependencies,
          allTransitiveDependencies:
              DocumentByIdFamily._allTransitiveDependencies,
          id: id,
        );

  DocumentByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Document?> Function(DocumentByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentByIdProvider._internal(
        (ref) => create(ref as DocumentByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Document?> createElement() {
    return _DocumentByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DocumentByIdRef on AutoDisposeFutureProviderRef<Document?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DocumentByIdProviderElement
    extends AutoDisposeFutureProviderElement<Document?> with DocumentByIdRef {
  _DocumentByIdProviderElement(super.provider);

  @override
  String get id => (origin as DocumentByIdProvider).id;
}

String _$selectedDocumentTypeHash() =>
    r'fe07a95f56b6cbd47dc10a3e63ad3694002cc8a3';

/// See also [SelectedDocumentType].
@ProviderFor(SelectedDocumentType)
final selectedDocumentTypeProvider =
    AutoDisposeNotifierProvider<SelectedDocumentType, DocumentType?>.internal(
  SelectedDocumentType.new,
  name: r'selectedDocumentTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDocumentTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDocumentType = AutoDisposeNotifier<DocumentType?>;
String _$saveDocumentHash() => r'7ec1ff3af91efdf9e1a812c075e7dabe1d5689bd';

/// See also [SaveDocument].
@ProviderFor(SaveDocument)
final saveDocumentProvider =
    AutoDisposeAsyncNotifierProvider<SaveDocument, void>.internal(
  SaveDocument.new,
  name: r'saveDocumentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$saveDocumentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveDocument = AutoDisposeAsyncNotifier<void>;
String _$deleteDocumentHash() => r'742d79666c4f4d44d5a5d42bbc82d1f7c52e517c';

/// See also [DeleteDocument].
@ProviderFor(DeleteDocument)
final deleteDocumentProvider =
    AutoDisposeAsyncNotifierProvider<DeleteDocument, void>.internal(
  DeleteDocument.new,
  name: r'deleteDocumentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteDocumentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeleteDocument = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
