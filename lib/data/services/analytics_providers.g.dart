// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAnalyticsInstanceHash() =>
    r'b38f1a469b4924d01cf2bc72eba19a8d3e2ebad0';

/// Shared [FirebaseAnalytics] instance so [FirebaseAnalyticsService] and
/// the auto-generated observer use the same underlying client.
///
/// Copied from [firebaseAnalyticsInstance].
@ProviderFor(firebaseAnalyticsInstance)
final firebaseAnalyticsInstanceProvider = Provider<FirebaseAnalytics>.internal(
  firebaseAnalyticsInstance,
  name: r'firebaseAnalyticsInstanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAnalyticsInstanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseAnalyticsInstanceRef = ProviderRef<FirebaseAnalytics>;
String _$analyticsServiceHash() => r'eb6fd32fc00a6c2e9b116e5e522587b5e97b2fc0';

/// See also [analyticsService].
@ProviderFor(analyticsService)
final analyticsServiceProvider = Provider<AnalyticsService>.internal(
  analyticsService,
  name: r'analyticsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AnalyticsServiceRef = ProviderRef<AnalyticsService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
