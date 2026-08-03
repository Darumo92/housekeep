// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentOfferingHash() => r'ba7c03346ff43ceebd8149996c5c98717562b883';

/// See also [currentOffering].
@ProviderFor(currentOffering)
final currentOfferingProvider =
    AutoDisposeFutureProvider<PurchaseOffering?>.internal(
  currentOffering,
  name: r'currentOfferingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentOfferingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentOfferingRef = AutoDisposeFutureProviderRef<PurchaseOffering?>;
String _$purchaseControllerHash() =>
    r'38e7f07cb1548cd82c03898168db97d82b213a7b';

/// See also [PurchaseController].
@ProviderFor(PurchaseController)
final purchaseControllerProvider = AutoDisposeNotifierProvider<
    PurchaseController, PurchaseControllerState>.internal(
  PurchaseController.new,
  name: r'purchaseControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$purchaseControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PurchaseController = AutoDisposeNotifier<PurchaseControllerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
