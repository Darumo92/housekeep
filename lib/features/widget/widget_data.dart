import '../../domain/enums/urgency_level.dart';
import '../../domain/models/upcoming_event.dart';

class WidgetEvent {
  const WidgetEvent({
    required this.title,
    required this.subtitle,
    required this.dueText,
    required this.urgency,
    required this.route,
    required this.iconKey,
  });

  final String title;
  final String subtitle;
  final String dueText;
  final UrgencyLevel urgency;
  final String route;

  /// "maintenance" | "warranty" | "document" — maps to the widget icon tile.
  final String iconKey;
}

String iconKeyForEvent(UpcomingEvent event) {
  return switch (event.type) {
    UpcomingEventType.maintenance => 'maintenance',
    UpcomingEventType.warranty => 'warranty',
    UpcomingEventType.document => 'document',
  };
}

class WidgetSnapshot {
  const WidgetSnapshot({
    required this.isPro,
    required this.events,
    required this.allClearText,
    required this.upgradeTitle,
    required this.upgradeSubtitle,
    required this.pendingCount,
    required this.soonCount,
    required this.weekCount,
    required this.brand,
    required this.pendingLabel,
    required this.soonLabel,
    required this.thingsPendingLabel,
    required this.thisWeekLabel,
    required this.nextLabel,
  });

  final bool isPro;
  final List<WidgetEvent> events;
  final String allClearText;
  final String upgradeTitle;
  final String upgradeSubtitle;

  /// Overdue + urgent events ("pendientes").
  final int pendingCount;

  /// Upcoming events ("pronto").
  final int soonCount;

  /// Events due within the next 7 days ("esta semana").
  final int weekCount;

  final String brand;
  final String pendingLabel;
  final String soonLabel;
  final String thingsPendingLabel;
  final String thisWeekLabel;
  final String nextLabel;
}

String routeForEvent(UpcomingEvent event) {
  return switch (event.type) {
    UpcomingEventType.maintenance => event.relatedItemId == null
        ? '/'
        : '/items/${event.relatedItemId}/maintenance',
    UpcomingEventType.warranty => event.relatedItemId == null
        ? '/'
        : '/items/${event.relatedItemId}',
    UpcomingEventType.document => '/documents',
  };
}
