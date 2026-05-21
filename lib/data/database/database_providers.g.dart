// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'8ab73ef1293e27f6de024928c2e888eefcb35e1d';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$itemsDaoHash() => r'd1a5048c5b2b8e27d6d79f1cf6ed9087d122a2a9';

/// See also [itemsDao].
@ProviderFor(itemsDao)
final itemsDaoProvider = AutoDisposeProvider<ItemsDao>.internal(
  itemsDao,
  name: r'itemsDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$itemsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ItemsDaoRef = AutoDisposeProviderRef<ItemsDao>;
String _$maintenancesDaoHash() => r'86d4f40f1135c43cae77ec3047be2b90e5ddd8f9';

/// See also [maintenancesDao].
@ProviderFor(maintenancesDao)
final maintenancesDaoProvider = AutoDisposeProvider<MaintenancesDao>.internal(
  maintenancesDao,
  name: r'maintenancesDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$maintenancesDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MaintenancesDaoRef = AutoDisposeProviderRef<MaintenancesDao>;
String _$documentsDaoHash() => r'78beb291ae7366683d7a9f31024cad88af07b13b';

/// See also [documentsDao].
@ProviderFor(documentsDao)
final documentsDaoProvider = AutoDisposeProvider<DocumentsDao>.internal(
  documentsDao,
  name: r'documentsDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$documentsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DocumentsDaoRef = AutoDisposeProviderRef<DocumentsDao>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
