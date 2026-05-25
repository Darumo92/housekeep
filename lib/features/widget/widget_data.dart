import '../../domain/enums/urgency_level.dart';
import '../../domain/models/upcoming_event.dart';

class WidgetEvent {
  const WidgetEvent({
    required this.title,
    required this.subtitle,
    required this.dueText,
    required this.urgency,
    required this.route,
  });

  final String title;
  final String subtitle;
  final String dueText;
  final UrgencyLevel urgency;
  final String route;
}

class WidgetSnapshot {
  const WidgetSnapshot({
    required this.isPro,
    required this.events,
    required this.allClearText,
    required this.upgradeTitle,
    required this.upgradeSubtitle,
  });

  final bool isPro;
  final List<WidgetEvent> events;
  final String allClearText;
  final String upgradeTitle;
  final String upgradeSubtitle;
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
