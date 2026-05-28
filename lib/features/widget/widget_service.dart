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
    required this.brand,
    required this.pendingLabel,
    required this.soonLabel,
    required this.thingsPendingLabel,
    required this.thisWeekLabel,
    required this.nextLabel,
    required this.untilDateTemplate,
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
  final String brand;
  final String pendingLabel;
  final String soonLabel;
  final String thingsPendingLabel;
  final String thisWeekLabel;
  final String nextLabel;
  final String untilDateTemplate;

  String untilDate(String date) => untilDateTemplate.replaceAll('{d}', date);

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
      brand: 'HouseKeep',
      pendingLabel: 'pending',
      soonLabel: 'soon',
      thingsPendingLabel: 'things to do',
      thisWeekLabel: 'this week',
      nextLabel: 'NEXT',
      untilDateTemplate: 'until {d}',
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
    brand: 'HouseKeep',
    pendingLabel: 'pendientes',
    soonLabel: 'pronto',
    thingsPendingLabel: 'cosas pendientes',
    thisWeekLabel: 'esta semana',
    nextLabel: 'PRÓXIMO',
    untilDateTemplate: 'hasta el {d}',
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
    final pending = events
        .where((e) =>
            e.urgency == UrgencyLevel.overdue ||
            e.urgency == UrgencyLevel.urgent)
        .length;
    final soon =
        events.where((e) => e.urgency == UrgencyLevel.upcoming).length;
    final week = events.where((e) {
      final days = DateCalculations.calendarDaysUntil(e.dueDate, reference);
      return days >= 0 && days <= 7;
    }).length;
    final filtered = events
        .where((e) => e.urgency != UrgencyLevel.ok)
        .take(maxEvents)
        .map((e) => WidgetEvent(
              title: e.title,
              subtitle: e.subtitle.isNotEmpty
                  ? e.subtitle
                  : strings.untilDate(DateFormat('yyyy-MM-dd').format(e.dueDate)),
              dueText: _formatDue(e.dueDate, reference, localeCode, strings),
              urgency: e.urgency,
              route: routeForEvent(e),
              iconKey: iconKeyForEvent(e),
            ))
        .toList(growable: false);

    return WidgetSnapshot(
      isPro: isPro,
      events: filtered,
      allClearText: strings.allClear,
      upgradeTitle: strings.upgradeTitle,
      upgradeSubtitle: strings.upgradeSubtitle,
      pendingCount: pending,
      soonCount: soon,
      weekCount: week,
      brand: strings.brand,
      pendingLabel: strings.pendingLabel,
      soonLabel: strings.soonLabel,
      thingsPendingLabel: strings.thingsPendingLabel,
      thisWeekLabel: strings.thisWeekLabel,
      nextLabel: strings.nextLabel,
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
  static const androidCountProviderName = 'HouseKeepCountWidgetProvider';
  static const androidNextProviderName = 'HouseKeepNextWidgetProvider';
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
      await HomeWidget.saveWidgetData<int>(
        'pending_count',
        snapshot.pendingCount,
      );
      await HomeWidget.saveWidgetData<int>('soon_count', snapshot.soonCount);
      await HomeWidget.saveWidgetData<int>('week_count', snapshot.weekCount);
      await HomeWidget.saveWidgetData<String>('label_brand', snapshot.brand);
      await HomeWidget.saveWidgetData<String>(
        'label_pending',
        snapshot.pendingLabel,
      );
      await HomeWidget.saveWidgetData<String>('label_soon', snapshot.soonLabel);
      await HomeWidget.saveWidgetData<String>(
        'label_things',
        snapshot.thingsPendingLabel,
      );
      await HomeWidget.saveWidgetData<String>(
        'label_week',
        snapshot.thisWeekLabel,
      );
      await HomeWidget.saveWidgetData<String>('label_next', snapshot.nextLabel);

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
          await HomeWidget.saveWidgetData<String>(
            'event_${i}_icon',
            event.iconKey,
          );
        } else {
          await HomeWidget.saveWidgetData<bool>('event_${i}_visible', false);
          await HomeWidget.saveWidgetData<String>('event_${i}_title', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_subtitle', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_due', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_urgency', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_route', '');
          await HomeWidget.saveWidgetData<String>('event_${i}_icon', '');
        }
      }

      await HomeWidget.updateWidget(
        androidName: androidProviderName,
        iOSName: iosWidgetName,
      );
      await HomeWidget.updateWidget(androidName: androidCountProviderName);
      await HomeWidget.updateWidget(androidName: androidNextProviderName);
    } catch (e, st) {
      debugPrint('[WidgetService] publish failed: $e\n$st');
    }
  }

  bool _isSameSnapshot(WidgetSnapshot snapshot) {
    final prev = _lastSnapshot;
    if (prev == null) return false;
    if (prev.isPro != snapshot.isPro) return false;
    if (prev.pendingCount != snapshot.pendingCount) return false;
    if (prev.soonCount != snapshot.soonCount) return false;
    if (prev.weekCount != snapshot.weekCount) return false;
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
