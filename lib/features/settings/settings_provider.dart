import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../onboarding/onboarding_provider.dart';

part 'settings_provider.g.dart';

const _kLocaleKey = 'settings.locale';
const _kThemeModeKey = 'settings.theme_mode';
const kNotificationsEnabledPrefKey = 'settings.notifications_enabled';

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

/// Persisted theme preference. Maps 1:1 to Flutter's [ThemeMode].
enum ThemePreference {
  system('system', ThemeMode.system),
  light('light', ThemeMode.light),
  dark('dark', ThemeMode.dark);

  const ThemePreference(this.code, this.mode);

  final String code;
  final ThemeMode mode;

  static ThemePreference fromCode(String? code) {
    if (code == null) return ThemePreference.system;
    return ThemePreference.values.firstWhere(
      (p) => p.code == code,
      orElse: () => ThemePreference.system,
    );
  }
}

@immutable
class SettingsState {
  const SettingsState({
    required this.localePreference,
    required this.themePreference,
    required this.notificationsEnabled,
  });

  final LocalePreference localePreference;
  final ThemePreference themePreference;
  final bool notificationsEnabled;

  SettingsState copyWith({
    LocalePreference? localePreference,
    ThemePreference? themePreference,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      localePreference: localePreference ?? this.localePreference,
      themePreference: themePreference ?? this.themePreference,
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
    final themeCode = await prefs.getString(_kThemeModeKey);
    final notificationsEnabled =
        await prefs.getBool(kNotificationsEnabledPrefKey) ?? true;
    ref.read(notificationServiceProvider).enabled = notificationsEnabled;
    return SettingsState(
      localePreference: LocalePreference.fromCode(localeCode),
      themePreference: ThemePreference.fromCode(themeCode),
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

  Future<void> setThemePreference(ThemePreference pref) async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    await prefs.setString(_kThemeModeKey, pref.code);
    final current = await future;
    state = AsyncData(current.copyWith(themePreference: pref));
  }

  Future<void> setNotificationsEnabled(
    bool enabled, {
    NotificationTexts? texts,
  }) async {
    final prefs = ref.read(sharedPreferencesAsyncProvider);
    await prefs.setBool(kNotificationsEnabledPrefKey, enabled);

    final service = ref.read(notificationServiceProvider);
    service.enabled = enabled;
    if (!enabled) {
      await service.cancelAll();
    } else if (texts != null) {
      await _rescheduleAll(texts);
    }

    final current = await future;
    state = AsyncData(current.copyWith(notificationsEnabled: enabled));
  }

  Future<void> _rescheduleAll(NotificationTexts texts) async {
    final isPro = ref.read(isProProvider).valueOrNull ?? false;
    final scheduler = ref.read(notificationSchedulerProvider);
    final items = await ref.read(itemsRepositoryProvider).watchItems().first;
    final maintenances = await ref
        .read(maintenancesRepositoryProvider)
        .watchAllMaintenances()
        .first;
    final documents = await ref
        .read(documentsRepositoryProvider)
        .watchDocuments()
        .first;
    await scheduler.rescheduleAll(
      items: items,
      maintenances: maintenances,
      documents: documents,
      isPro: isPro,
      texts: texts,
    );
  }
}
