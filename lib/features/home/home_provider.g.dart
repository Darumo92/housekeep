// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeItemsHash() => r'35ed2a0d3a8f02710a34f2ca2c9e7f561cab4c0e';

/// See also [homeItems].
@ProviderFor(homeItems)
final homeItemsProvider = AutoDisposeStreamProvider<List<Item>>.internal(
  homeItems,
  name: r'homeItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HomeItemsRef = AutoDisposeStreamProviderRef<List<Item>>;
String _$homeUpcomingMaintenancesHash() =>
    r'3f0a7df8e5c6a97475ef2afd2f75e5f8ec4a4fa3';

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

/// See also [homeUpcomingMaintenances].
@ProviderFor(homeUpcomingMaintenances)
const homeUpcomingMaintenancesProvider = HomeUpcomingMaintenancesFamily();

/// See also [homeUpcomingMaintenances].
class HomeUpcomingMaintenancesFamily
    extends Family<AsyncValue<List<Maintenance>>> {
  /// See also [homeUpcomingMaintenances].
  const HomeUpcomingMaintenancesFamily();

  /// See also [homeUpcomingMaintenances].
  HomeUpcomingMaintenancesProvider call({
    int limit = 200,
  }) {
    return HomeUpcomingMaintenancesProvider(
      limit: limit,
    );
  }

  @override
  HomeUpcomingMaintenancesProvider getProviderOverride(
    covariant HomeUpcomingMaintenancesProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'homeUpcomingMaintenancesProvider';
}

/// See also [homeUpcomingMaintenances].
class HomeUpcomingMaintenancesProvider
    extends AutoDisposeStreamProvider<List<Maintenance>> {
  /// See also [homeUpcomingMaintenances].
  HomeUpcomingMaintenancesProvider({
    int limit = 200,
  }) : this._internal(
          (ref) => homeUpcomingMaintenances(
            ref as HomeUpcomingMaintenancesRef,
            limit: limit,
          ),
          from: homeUpcomingMaintenancesProvider,
          name: r'homeUpcomingMaintenancesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeUpcomingMaintenancesHash,
          dependencies: HomeUpcomingMaintenancesFamily._dependencies,
          allTransitiveDependencies:
              HomeUpcomingMaintenancesFamily._allTransitiveDependencies,
          limit: limit,
        );

  HomeUpcomingMaintenancesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<Maintenance>> Function(HomeUpcomingMaintenancesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HomeUpcomingMaintenancesProvider._internal(
        (ref) => create(ref as HomeUpcomingMaintenancesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Maintenance>> createElement() {
    return _HomeUpcomingMaintenancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeUpcomingMaintenancesProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HomeUpcomingMaintenancesRef
    on AutoDisposeStreamProviderRef<List<Maintenance>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _HomeUpcomingMaintenancesProviderElement
    extends AutoDisposeStreamProviderElement<List<Maintenance>>
    with HomeUpcomingMaintenancesRef {
  _HomeUpcomingMaintenancesProviderElement(super.provider);

  @override
  int get limit => (origin as HomeUpcomingMaintenancesProvider).limit;
}

String _$homeExpiringDocumentsHash() =>
    r'd4a204801e57d4a93c8a447a558a6747cd0b384f';

/// See also [homeExpiringDocuments].
@ProviderFor(homeExpiringDocuments)
const homeExpiringDocumentsProvider = HomeExpiringDocumentsFamily();

/// See also [homeExpiringDocuments].
class HomeExpiringDocumentsFamily extends Family<AsyncValue<List<Document>>> {
  /// See also [homeExpiringDocuments].
  const HomeExpiringDocumentsFamily();

  /// See also [homeExpiringDocuments].
  HomeExpiringDocumentsProvider call({
    int limit = 200,
  }) {
    return HomeExpiringDocumentsProvider(
      limit: limit,
    );
  }

  @override
  HomeExpiringDocumentsProvider getProviderOverride(
    covariant HomeExpiringDocumentsProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'homeExpiringDocumentsProvider';
}

/// See also [homeExpiringDocuments].
class HomeExpiringDocumentsProvider
    extends AutoDisposeStreamProvider<List<Document>> {
  /// See also [homeExpiringDocuments].
  HomeExpiringDocumentsProvider({
    int limit = 200,
  }) : this._internal(
          (ref) => homeExpiringDocuments(
            ref as HomeExpiringDocumentsRef,
            limit: limit,
          ),
          from: homeExpiringDocumentsProvider,
          name: r'homeExpiringDocumentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeExpiringDocumentsHash,
          dependencies: HomeExpiringDocumentsFamily._dependencies,
          allTransitiveDependencies:
              HomeExpiringDocumentsFamily._allTransitiveDependencies,
          limit: limit,
        );

  HomeExpiringDocumentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<Document>> Function(HomeExpiringDocumentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HomeExpiringDocumentsProvider._internal(
        (ref) => create(ref as HomeExpiringDocumentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Document>> createElement() {
    return _HomeExpiringDocumentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeExpiringDocumentsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HomeExpiringDocumentsRef on AutoDisposeStreamProviderRef<List<Document>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _HomeExpiringDocumentsProviderElement
    extends AutoDisposeStreamProviderElement<List<Document>>
    with HomeExpiringDocumentsRef {
  _HomeExpiringDocumentsProviderElement(super.provider);

  @override
  int get limit => (origin as HomeExpiringDocumentsProvider).limit;
}

String _$upcomingEventsHash() => r'3d9e351034beb13f6dca4e55d5a94a74fbfe7a9f';

/// See also [upcomingEvents].
@ProviderFor(upcomingEvents)
const upcomingEventsProvider = UpcomingEventsFamily();

/// See also [upcomingEvents].
class UpcomingEventsFamily extends Family<AsyncValue<List<UpcomingEvent>>> {
  /// See also [upcomingEvents].
  const UpcomingEventsFamily();

  /// See also [upcomingEvents].
  UpcomingEventsProvider call({
    int limit = 15,
  }) {
    return UpcomingEventsProvider(
      limit: limit,
    );
  }

  @override
  UpcomingEventsProvider getProviderOverride(
    covariant UpcomingEventsProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'upcomingEventsProvider';
}

/// See also [upcomingEvents].
class UpcomingEventsProvider
    extends AutoDisposeProvider<AsyncValue<List<UpcomingEvent>>> {
  /// See also [upcomingEvents].
  UpcomingEventsProvider({
    int limit = 15,
  }) : this._internal(
          (ref) => upcomingEvents(
            ref as UpcomingEventsRef,
            limit: limit,
          ),
          from: upcomingEventsProvider,
          name: r'upcomingEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upcomingEventsHash,
          dependencies: UpcomingEventsFamily._dependencies,
          allTransitiveDependencies:
              UpcomingEventsFamily._allTransitiveDependencies,
          limit: limit,
        );

  UpcomingEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    AsyncValue<List<UpcomingEvent>> Function(UpcomingEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpcomingEventsProvider._internal(
        (ref) => create(ref as UpcomingEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AsyncValue<List<UpcomingEvent>>> createElement() {
    return _UpcomingEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingEventsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpcomingEventsRef
    on AutoDisposeProviderRef<AsyncValue<List<UpcomingEvent>>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _UpcomingEventsProviderElement
    extends AutoDisposeProviderElement<AsyncValue<List<UpcomingEvent>>>
    with UpcomingEventsRef {
  _UpcomingEventsProviderElement(super.provider);

  @override
  int get limit => (origin as UpcomingEventsProvider).limit;
}

String _$homeSummaryHash() => r'b0e8bea32f9807970da03f429a3bde42477e1cf8';

/// See also [homeSummary].
@ProviderFor(homeSummary)
final homeSummaryProvider =
    AutoDisposeProvider<AsyncValue<HomeSummary>>.internal(
  homeSummary,
  name: r'homeSummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HomeSummaryRef = AutoDisposeProviderRef<AsyncValue<HomeSummary>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
