import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../onboarding/onboarding_provider.dart';

part 'settings_provider.g.dart';

const _kLocaleKey = 'settings.locale';
const _kNotificationsEnabledKey = 'settings.notifications_enabled';

enum LocalePreference {
  system(null),
  es('es'),
  en('en');

  const LocalePreference(this.code);

  final String? code;

  Locale? toLocale() => code == null ? null : Locale(code!);

  static LocalePreference fromCode(String? code) {
    if (code == null) return LocalePreference.system;
    return LocalePreference.values.firstWhere(
      (p) => p.code == code,
      orElse: () => LocalePreference.system,
    );
  }
}

@immutable
class SettingsState {
  const SettingsState({
    required this.localePreference,
    required this.notificationsEnabled,
  });

  final LocalePreference localePreference;
  final bool notificationsEnabled;

  SettingsState copyWith({
    LocalePreference? localePreference,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      localePreference: localePreference ?? this.localePreference,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsState> build() async {
    final prefs = ref.watch(sharedPreferencesAsyncProvider);
    final localeCode = await prefs.getString(_kLocaleKey);
    final notificationsEnabled =
        await prefs.getBool(_kNotificationsEnabledKey) ?? true;
    return SettingsState(
      localePreference: LocalePreference.fromCode(localeCode),
      notificationsEnabled: notificationsEnabled,
    );
  }

  Future<void> setLocalePreference(LocalePreference pref) async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    if (pref.code == null) {
      await prefs.remove(_kLocaleKey);
    } else {
      await prefs.setString(_kLocaleKey, pref.code!);
    }
    final current = await future;
    state = AsyncData(current.copyWith(localePreference: pref));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    await prefs.setBool(_kNotificationsEnabledKey, enabled);
    final current = await future;
    state = AsyncData(current.copyWith(notificationsEnabled: enabled));
  }
}
