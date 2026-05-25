import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../home/home_provider.dart';
import '../settings/settings_provider.dart';
import 'widget_service.dart';

part 'widget_sync_provider.g.dart';

@Riverpod(keepAlive: true)
WidgetService widgetService(WidgetServiceRef ref) {
  final service = WidgetService();
  if (Platform.isAndroid || Platform.isIOS) {
    service.ensureAppGroup();
  }
  return service;
}

@Riverpod(keepAlive: true)
WidgetSnapshotBuilder widgetSnapshotBuilder(WidgetSnapshotBuilderRef ref) {
  return const WidgetSnapshotBuilder();
}

@Riverpod(keepAlive: true)
Object? widgetSync(WidgetSyncRef ref) {
  if (!Platform.isAndroid && !Platform.isIOS) return null;

  final service = ref.watch(widgetServiceProvider);
  final builder = ref.watch(widgetSnapshotBuilderProvider);

  final eventsAsync = ref.watch(upcomingEventsProvider());
  final isProAsync = ref.watch(isProProvider);
  final settingsAsync = ref.watch(settingsControllerProvider);

  final events = eventsAsync.valueOrNull;
  if (events == null) return null;

  final isPro = isProAsync.valueOrNull ?? false;
  final localeCode = settingsAsync
          .maybeWhen(
            data: (s) => s.localePreference.code,
            orElse: () => null,
          ) ??
      'es';

  final strings = widgetStringsFor(localeCode);
  final snapshot = builder.build(
    isPro: isPro,
    events: events,
    localeCode: localeCode,
    strings: strings,
  );

  service.publish(snapshot).catchError((e) {
    debugPrint('[widgetSync] publish error: $e');
  });

  return snapshot;
}
