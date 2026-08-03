// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredItemsHash() => r'62fe1e55c9275976e0bf096f27fbc165c4b78dcd';

/// See also [filteredItems].
@ProviderFor(filteredItems)
final filteredItemsProvider = AutoDisposeStreamProvider<List<Item>>.internal(
  filteredItems,
  name: r'filteredItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredItemsRef = AutoDisposeStreamProviderRef<List<Item>>;
String _$addItemDestinationHash() =>
    r'3fd4c8575b24940b94242c18c3060d13774d3df6';

/// See also [addItemDestination].
@ProviderFor(addItemDestination)
final addItemDestinationProvider = AutoDisposeFutureProvider<String>.internal(
  addItemDestination,
  name: r'addItemDestinationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addItemDestinationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddItemDestinationRef = AutoDisposeFutureProviderRef<String>;
String _$itemByIdHash() => r'61adea7d57bb5a14440b918d993326b78625bffe';

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

/// See also [itemById].
@ProviderFor(itemById)
const itemByIdProvider = ItemByIdFamily();

/// See also [itemById].
class ItemByIdFamily extends Family<AsyncValue<Item?>> {
  /// See also [itemById].
  const ItemByIdFamily();

  /// See also [itemById].
  ItemByIdProvider call(
    String id,
  ) {
    return ItemByIdProvider(
      id,
    );
  }

  @override
  ItemByIdProvider getProviderOverride(
    covariant ItemByIdProvider provider,
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
  String? get name => r'itemByIdProvider';
}

/// See also [itemById].
class ItemByIdProvider extends AutoDisposeStreamProvider<Item?> {
  /// See also [itemById].
  ItemByIdProvider(
    String id,
  ) : this._internal(
          (ref) => itemById(
            ref as ItemByIdRef,
            id,
          ),
          from: itemByIdProvider,
          name: r'itemByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemByIdHash,
          dependencies: ItemByIdFamily._dependencies,
          allTransitiveDependencies: ItemByIdFamily._allTransitiveDependencies,
          id: id,
        );

  ItemByIdProvider._internal(
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
    Stream<Item?> Function(ItemByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemByIdProvider._internal(
        (ref) => create(ref as ItemByIdRef),
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
  AutoDisposeStreamProviderElement<Item?> createElement() {
    return _ItemByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ItemByIdRef on AutoDisposeStreamProviderRef<Item?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ItemByIdProviderElement extends AutoDisposeStreamProviderElement<Item?>
    with ItemByIdRef {
  _ItemByIdProviderElement(super.provider);

  @override
  String get id => (origin as ItemByIdProvider).id;
}

String _$selectedItemCategoryHash() =>
    r'4a3c7eb935ab434b0c8e036bfe5b8f7b62b6cb41';

/// See also [SelectedItemCategory].
@ProviderFor(SelectedItemCategory)
final selectedItemCategoryProvider =
    AutoDisposeNotifierProvider<SelectedItemCategory, ItemCategory?>.internal(
  SelectedItemCategory.new,
  name: r'selectedItemCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedItemCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedItemCategory = AutoDisposeNotifier<ItemCategory?>;
String _$saveItemHash() => r'4b82a917ed83ecd900bd321cd37c40e3c041dd7a';

/// See also [SaveItem].
@ProviderFor(SaveItem)
final saveItemProvider =
    AutoDisposeAsyncNotifierProvider<SaveItem, void>.internal(
  SaveItem.new,
  name: r'saveItemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$saveItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveItem = AutoDisposeAsyncNotifier<void>;
String _$deleteItemHash() => r'7fdeb3f40e50c20741aaa5aeace1ebf086339dde';

/// See also [DeleteItem].
@ProviderFor(DeleteItem)
final deleteItemProvider =
    AutoDisposeAsyncNotifierProvider<DeleteItem, void>.internal(
  DeleteItem.new,
  name: r'deleteItemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deleteItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeleteItem = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
