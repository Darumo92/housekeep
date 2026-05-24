// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenances_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$maintenancesForItemHash() =>
    r'767a8ac841ccaf571e567571a41d88273cb5477b';

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

/// See also [maintenancesForItem].
@ProviderFor(maintenancesForItem)
const maintenancesForItemProvider = MaintenancesForItemFamily();

/// See also [maintenancesForItem].
class MaintenancesForItemFamily extends Family<AsyncValue<List<Maintenance>>> {
  /// See also [maintenancesForItem].
  const MaintenancesForItemFamily();

  /// See also [maintenancesForItem].
  MaintenancesForItemProvider call(
    String itemId,
  ) {
    return MaintenancesForItemProvider(
      itemId,
    );
  }

  @override
  MaintenancesForItemProvider getProviderOverride(
    covariant MaintenancesForItemProvider provider,
  ) {
    return call(
      provider.itemId,
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
  String? get name => r'maintenancesForItemProvider';
}

/// See also [maintenancesForItem].
class MaintenancesForItemProvider
    extends AutoDisposeStreamProvider<List<Maintenance>> {
  /// See also [maintenancesForItem].
  MaintenancesForItemProvider(
    String itemId,
  ) : this._internal(
          (ref) => maintenancesForItem(
            ref as MaintenancesForItemRef,
            itemId,
          ),
          from: maintenancesForItemProvider,
          name: r'maintenancesForItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$maintenancesForItemHash,
          dependencies: MaintenancesForItemFamily._dependencies,
          allTransitiveDependencies:
              MaintenancesForItemFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  MaintenancesForItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    Stream<List<Maintenance>> Function(MaintenancesForItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaintenancesForItemProvider._internal(
        (ref) => create(ref as MaintenancesForItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Maintenance>> createElement() {
    return _MaintenancesForItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaintenancesForItemProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MaintenancesForItemRef
    on AutoDisposeStreamProviderRef<List<Maintenance>> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _MaintenancesForItemProviderElement
    extends AutoDisposeStreamProviderElement<List<Maintenance>>
    with MaintenancesForItemRef {
  _MaintenancesForItemProviderElement(super.provider);

  @override
  String get itemId => (origin as MaintenancesForItemProvider).itemId;
}

String _$maintenanceByIdHash() => r'9cc03638dee523f5e7ad47190a41c6e7de496e47';

/// See also [maintenanceById].
@ProviderFor(maintenanceById)
const maintenanceByIdProvider = MaintenanceByIdFamily();

/// See also [maintenanceById].
class MaintenanceByIdFamily extends Family<AsyncValue<Maintenance?>> {
  /// See also [maintenanceById].
  const MaintenanceByIdFamily();

  /// See also [maintenanceById].
  MaintenanceByIdProvider call(
    String id,
  ) {
    return MaintenanceByIdProvider(
      id,
    );
  }

  @override
  MaintenanceByIdProvider getProviderOverride(
    covariant MaintenanceByIdProvider provider,
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
  String? get name => r'maintenanceByIdProvider';
}

/// See also [maintenanceById].
class MaintenanceByIdProvider extends AutoDisposeFutureProvider<Maintenance?> {
  /// See also [maintenanceById].
  MaintenanceByIdProvider(
    String id,
  ) : this._internal(
          (ref) => maintenanceById(
            ref as MaintenanceByIdRef,
            id,
          ),
          from: maintenanceByIdProvider,
          name: r'maintenanceByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$maintenanceByIdHash,
          dependencies: MaintenanceByIdFamily._dependencies,
          allTransitiveDependencies:
              MaintenanceByIdFamily._allTransitiveDependencies,
          id: id,
        );

  MaintenanceByIdProvider._internal(
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
    FutureOr<Maintenance?> Function(MaintenanceByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaintenanceByIdProvider._internal(
        (ref) => create(ref as MaintenanceByIdRef),
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
  AutoDisposeFutureProviderElement<Maintenance?> createElement() {
    return _MaintenanceByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaintenanceByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MaintenanceByIdRef on AutoDisposeFutureProviderRef<Maintenance?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MaintenanceByIdProviderElement
    extends AutoDisposeFutureProviderElement<Maintenance?>
    with MaintenanceByIdRef {
  _MaintenanceByIdProviderElement(super.provider);

  @override
  String get id => (origin as MaintenanceByIdProvider).id;
}

String _$saveMaintenanceHash() => r'99b0c7268affdb34a00d5c5f4d9cfb8c160bd9db';

/// See also [SaveMaintenance].
@ProviderFor(SaveMaintenance)
final saveMaintenanceProvider =
    AutoDisposeAsyncNotifierProvider<SaveMaintenance, void>.internal(
  SaveMaintenance.new,
  name: r'saveMaintenanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveMaintenanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveMaintenance = AutoDisposeAsyncNotifier<void>;
String _$deleteMaintenanceHash() => r'06f927f1f28c54678749131f68bd45cf81e741c9';

/// See also [DeleteMaintenance].
@ProviderFor(DeleteMaintenance)
final deleteMaintenanceProvider =
    AutoDisposeAsyncNotifierProvider<DeleteMaintenance, void>.internal(
  DeleteMaintenance.new,
  name: r'deleteMaintenanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteMaintenanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeleteMaintenance = AutoDisposeAsyncNotifier<void>;
String _$markMaintenanceDoneHash() =>
    r'23dd87b6da2aceb6fa8ac21b59afd6cb9fd4cc64';

/// See also [MarkMaintenanceDone].
@ProviderFor(MarkMaintenanceDone)
final markMaintenanceDoneProvider =
    AutoDisposeAsyncNotifierProvider<MarkMaintenanceDone, void>.internal(
  MarkMaintenanceDone.new,
  name: r'markMaintenanceDoneProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$markMaintenanceDoneHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarkMaintenanceDone = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
