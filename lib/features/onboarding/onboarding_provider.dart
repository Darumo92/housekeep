import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/enums/home_type.dart';

part 'onboarding_provider.g.dart';

const _kOnboardingCompletedKey = 'onboarding.completed';
const _kHomeTypeKey = 'onboarding.home_type';

@immutable
class OnboardingState {
  const OnboardingState({required this.completed, required this.homeType});

  final bool completed;
  final HomeType? homeType;

  OnboardingState copyWith({bool? completed, HomeType? homeType}) {
    return OnboardingState(
      completed: completed ?? this.completed,
      homeType: homeType ?? this.homeType,
    );
  }
}

@Riverpod(keepAlive: true)
SharedPreferencesAsync sharedPreferencesAsync(SharedPreferencesAsyncRef ref) {
  return SharedPreferencesAsync();
}

@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  @override
  Future<OnboardingState> build() async {
    final prefs = ref.watch(sharedPreferencesAsyncProvider);
    final completed = await prefs.getBool(_kOnboardingCompletedKey) ?? false;
    final homeTypeRaw = await prefs.getString(_kHomeTypeKey);
    HomeType? homeType;
    if (homeTypeRaw != null) {
      try {
        homeType = HomeType.fromDb(homeTypeRaw);
      } catch (_) {
        homeType = null;
      }
    }
    return OnboardingState(completed: completed, homeType: homeType);
  }

  Future<void> setHomeType(HomeType type) async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    await prefs.setString(_kHomeTypeKey, type.dbValue);
    final current = await future;
    state = AsyncData(current.copyWith(homeType: type));
  }

  Future<void> complete({HomeType? homeType}) async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    await prefs.setBool(_kOnboardingCompletedKey, true);
    if (homeType != null) {
      await prefs.setString(_kHomeTypeKey, homeType.dbValue);
    }
    final current = await future;
    state = AsyncData(
      current.copyWith(completed: true, homeType: homeType ?? current.homeType),
    );
  }

  Future<void> reset() async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    await prefs.remove(_kOnboardingCompletedKey);
    await prefs.remove(_kHomeTypeKey);
    state = const AsyncData(OnboardingState(completed: false, homeType: null));
  }
}
