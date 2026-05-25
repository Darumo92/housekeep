// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesAsyncHash() =>
    r'78d34d0dd92025667f0fdab3a519325ba686b48f';

/// See also [sharedPreferencesAsync].
@ProviderFor(sharedPreferencesAsync)
final sharedPreferencesAsyncProvider =
    Provider<SharedPreferencesAsync>.internal(
  sharedPreferencesAsync,
  name: r'sharedPreferencesAsyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesAsyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesAsyncRef = ProviderRef<SharedPreferencesAsync>;
String _$onboardingControllerHash() =>
    r'63641351243aa608cf665a0b284c12f5112ff5f6';

/// See also [OnboardingController].
@ProviderFor(OnboardingController)
final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingState>.internal(
  OnboardingController.new,
  name: r'onboardingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnboardingController = AsyncNotifier<OnboardingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
