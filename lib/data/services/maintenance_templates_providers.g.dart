// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_templates_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$maintenanceTemplatesServiceHash() =>
    r'8be6d6d384ae020d87b1ef514dc08226051ec84a';

/// See also [maintenanceTemplatesService].
@ProviderFor(maintenanceTemplatesService)
final maintenanceTemplatesServiceProvider =
    Provider<MaintenanceTemplatesService>.internal(
  maintenanceTemplatesService,
  name: r'maintenanceTemplatesServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$maintenanceTemplatesServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MaintenanceTemplatesServiceRef
    = ProviderRef<MaintenanceTemplatesService>;
String _$maintenanceTemplatesHash() =>
    r'b01f7d79489f0e68d8c49bbfc12143648e0e5673';

/// See also [maintenanceTemplates].
@ProviderFor(maintenanceTemplates)
final maintenanceTemplatesProvider =
    AutoDisposeFutureProvider<List<MaintenanceTemplate>>.internal(
  maintenanceTemplates,
  name: r'maintenanceTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$maintenanceTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MaintenanceTemplatesRef
    = AutoDisposeFutureProviderRef<List<MaintenanceTemplate>>;
String _$maintenanceTemplatesByCategoryHash() =>
    r'3d28cf06e6a1311ced680f987688c84f04097d39';

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

/// See also [maintenanceTemplatesByCategory].
@ProviderFor(maintenanceTemplatesByCategory)
const maintenanceTemplatesByCategoryProvider =
    MaintenanceTemplatesByCategoryFamily();

/// See also [maintenanceTemplatesByCategory].
class MaintenanceTemplatesByCategoryFamily
    extends Family<AsyncValue<List<MaintenanceTemplate>>> {
  /// See also [maintenanceTemplatesByCategory].
  const MaintenanceTemplatesByCategoryFamily();

  /// See also [maintenanceTemplatesByCategory].
  MaintenanceTemplatesByCategoryProvider call(
    ItemCategory category,
  ) {
    return MaintenanceTemplatesByCategoryProvider(
      category,
    );
  }

  @override
  MaintenanceTemplatesByCategoryProvider getProviderOverride(
    covariant MaintenanceTemplatesByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'maintenanceTemplatesByCategoryProvider';
}

/// See also [maintenanceTemplatesByCategory].
class MaintenanceTemplatesByCategoryProvider
    extends AutoDisposeFutureProvider<List<MaintenanceTemplate>> {
  /// See also [maintenanceTemplatesByCategory].
  MaintenanceTemplatesByCategoryProvider(
    ItemCategory category,
  ) : this._internal(
          (ref) => maintenanceTemplatesByCategory(
            ref as MaintenanceTemplatesByCategoryRef,
            category,
          ),
          from: maintenanceTemplatesByCategoryProvider,
          name: r'maintenanceTemplatesByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$maintenanceTemplatesByCategoryHash,
          dependencies: MaintenanceTemplatesByCategoryFamily._dependencies,
          allTransitiveDependencies:
              MaintenanceTemplatesByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  MaintenanceTemplatesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final ItemCategory category;

  @override
  Override overrideWith(
    FutureOr<List<MaintenanceTemplate>> Function(
            MaintenanceTemplatesByCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaintenanceTemplatesByCategoryProvider._internal(
        (ref) => create(ref as MaintenanceTemplatesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MaintenanceTemplate>> createElement() {
    return _MaintenanceTemplatesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaintenanceTemplatesByCategoryProvider &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MaintenanceTemplatesByCategoryRef
    on AutoDisposeFutureProviderRef<List<MaintenanceTemplate>> {
  /// The parameter `category` of this provider.
  ItemCategory get category;
}

class _MaintenanceTemplatesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<MaintenanceTemplate>>
    with MaintenanceTemplatesByCategoryRef {
  _MaintenanceTemplatesByCategoryProviderElement(super.provider);

  @override
  ItemCategory get category =>
      (origin as MaintenanceTemplatesByCategoryProvider).category;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
