import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../core/utils/date_calculations.dart';
import '../../domain/enums/urgency_level.dart';
import '../../domain/models/upcoming_event.dart';
import 'widget_data.dart';

class WidgetStrings {
  const WidgetStrings({
    required this.allClear,
    required this.upgradeTitle,
    required this.upgradeSubtitle,
    required this.dueToday,
    required this.dueTomorrow,
    required this.inDaysSingular,
    required this.inDaysPlural,
    required this.overdueSingular,
    required this.overduePlural,
  });

  final String allClear;
  final String upgradeTitle;
  final String upgradeSubtitle;
  final String dueToday;
  final String dueTomorrow;
  final String inDaysSingular;
  final String inDaysPlural;
  final String overdueSingular;
  final String overduePlural;

  String dueInDays(int days) {
    final template = days == 1 ? inDaysSingular : inDaysPlural;
    return template.replaceAll('{n}', '$days');
  }

  String overdueBy(int days) {
    final template = days == 1 ? overdueSingular : overduePlural;
    return template.replaceAll('{n}', '$days');
  }
}

WidgetStrings widgetStringsFor(String localeCode) {
  if (localeCode.startsWith('en')) {
    return const WidgetStrings(
      allClear: 'All clear ✓',
      upgradeTitle: 'Go PRO',
      upgradeSubtitle: 'Unlock the widget and unlimited items',
      dueToday: 'Today',
      dueTomorrow: 'Tomorrow',
      inDaysSingular: 'In {n} day',
      inDaysPlural: 'In {n} days',
      overdueSingular: 'Overdue by {n} day',
      overduePlural: 'Overdue by {n} days',
    );
  }
  return const WidgetStrings(
    allClear: 'Todo al día ✓',
    upgradeTitle: 'Hazte PRO',
    upgradeSubtitle: 'Desbloquea el widget e items ilimitados',
    dueToday: 'Hoy',
    dueTomorrow: 'Mañana',
    inDaysSingular: 'En {n} día',
    inDaysPlural: 'En {n} días',
    overdueSingular: 'Retrasado {n} día',
    overduePlural: 'Retrasado {n} días',
  );
}

class WidgetSnapshotBuilder {
  const WidgetSnapshotBuilder({this.maxEvents = 3});

  final int maxEvents;

  WidgetSnapshot build({
    required bool isPro,
    required List<UpcomingEvent> events,
    required String localeCode,
    required WidgetStrings strings,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final filtered = events
        .where((e) => e.urgency != UrgencyLevel.ok)
        .take(maxEvents)
        .map((e) => WidgetEvent(
              title: e.title,
              subtitle: e.subtitle,
              dueText: _formatDue(e.dueDate, reference, localeCode, strings),
              urgency: e.urgency,
              route: routeForEvent(e),
            ))
        .toList(growable: false);

    return WidgetSnapshot(
      isPro: isPro,
      events: filtered,
      allClearText: strings.allClear,
      upgradeTitle: strings.upgradeTitle,
      upgradeSubtitle: strings.upgradeSubtitle,
    );
  }

  String _formatDue(
    DateTime due,
    DateTime now,
    String localeCode,
    WidgetStrings strings,
  ) {
    final days = DateCalculations.calendarDaysUntil(due, now);
    if (days < 0) return strings.overdueBy(-days);
    if (days == 0) return strings.dueToday;
    if (days == 1) return strings.dueTomorrow;
    if (days <= 30) return strings.dueInDays(days);
    return DateFormat.yMMMd(localeCode).format(due);
  }
}

class WidgetService {
  WidgetService({this.maxEvents = 3});

  static const androidProviderName = 'HouseKeepWidgetProvider';
  static const iosWidgetName = 'HouseKeepWidget';
  static const appGroupId = 'group.com.housekeep.app.widget';

  final int maxEvents;
  WidgetSnapshot? _lastSnapshot;

  Future<void> ensureAppGroup() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (e) {
      debugPrint('[WidgetService] setAppGroupId failed: $e');
    }
  }

  Future<void> publish(WidgetSnapshot snapshot) async {
    if (_isSameSnapshot(snapshot)) return;
    _lastSnapshot = snapshot;

    try {
      await HomeWidget.saveWidgetData<bool>('is_pro', snapshot.isPro);
      await HomeWidget.saveWidgetData<int>(
        'event_count',
        snapshot.events.length,
      );
      await HomeWidget.saveWidgetData<String>(
        'all_clear_text',
        snapshot.allClearText,
      );
      await HomeWidget.saveWidgetData<String>(
        'upgrade_title',
        snapshot.upgradeTitle,
      );
      await HomeWidget.saveWidgetData<String>(
        'upgrade_subtitle',
        snapshot.upgradeSubtitle,
      );

      for (var i = 0; i < maxEvents; i++) {
        if (i < snapshot.events.length) {
          final event = snapshot.events[i];
          await HomeWidget.saveWidgetData<bool>('event_${i}_visible', true);
          await HomeWidget.saveWidgetData<String>(
            'event_${i}_title',
            event.title,
          );
          await HomeWidget.saveWidgetData<String>(
            'event_${i}_subtitle',
            event.subtitle,
          );
          await HomeWidget.saveWidgetData<String>(
            'event_${i}_due',
            event.dueText,
          );
          await HomeWidget.saveWidgetData<String>(
            'event_${i}_urgency',
            event.urgency.dbValue,
          );
          await HomeWidget.saveWidgetData<String>(
            'event_${i}_route',
            event.route,
          );
        } else {
          await HomeWidget.saveWidgetData<bool>('event_${i}_visible', false);
          await HomeWidget.saveWidgetData<String>('event_${i}_title', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_subtitle', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_due', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_urgency', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_route', '');
        }
      }

      await HomeWidget.updateWidget(
        androidName: androidProviderName,
        iOSName: iosWidgetName,
      );
    } catch (e, st) {
      debugPrint('[WidgetService] publish failed: $e\n$st');
    }
  }

  bool _isSameSnapshot(WidgetSnapshot snapshot) {
    final prev = _lastSnapshot;
    if (prev == null) return false;
    if (prev.isPro != snapshot.isPro) return false;
    if (prev.events.length != snapshot.events.length) return false;
    for (var i = 0; i < snapshot.events.length; i++) {
      final a = prev.events[i];
      final b = snapshot.events[i];
      if (a.title != b.title ||
          a.subtitle != b.subtitle ||
          a.dueText != b.dueText ||
          a.urgency != b.urgency ||
          a.route != b.route) {
        return false;
      }
    }
    return prev.allClearText == snapshot.allClearText &&
        prev.upgradeTitle == snapshot.upgradeTitle &&
        prev.upgradeSubtitle == snapshot.upgradeSubtitle;
  }

  @visibleForTesting
  void resetCache() => _lastSnapshot = null;
}
