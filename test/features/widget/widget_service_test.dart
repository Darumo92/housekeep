import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/domain/enums/urgency_level.dart';
import 'package:housekeep/domain/models/upcoming_event.dart';
import 'package:housekeep/features/widget/widget_data.dart';
import 'package:housekeep/features/widget/widget_service.dart';

void main() {
  group('WidgetSnapshotBuilder', () {
    const builder = WidgetSnapshotBuilder();
    final now = DateTime(2026, 5, 25, 10);
    final stringsEs = widgetStringsFor('es');

    test('limits to max 3 events sorted by caller', () {
      final events = List.generate(
        5,
        (i) => UpcomingEvent(
          id: 'maintenance-$i',
          title: 'Filter $i',
          subtitle: 'Item $i',
          dueDate: now.add(Duration(days: i + 1)),
          urgency: UrgencyLevel.urgent,
          type: UpcomingEventType.maintenance,
          relatedItemId: 'item-$i',
        ),
      );

      final snapshot = builder.build(
        isPro: true,
        events: events,
        localeCode: 'es',
        strings: stringsEs,
        now: now,
      );

      expect(snapshot.events, hasLength(3));
      expect(snapshot.isPro, isTrue);
      expect(snapshot.events.first.title, 'Filter 0');
    });

    test('excludes ok urgency events', () {
      final events = [
        UpcomingEvent(
          id: 'm-1',
          title: 'Distant filter',
          subtitle: '',
          dueDate: now.add(const Duration(days: 365)),
          urgency: UrgencyLevel.ok,
          type: UpcomingEventType.maintenance,
          relatedItemId: 'item-1',
        ),
        UpcomingEvent(
          id: 'm-2',
          title: 'Urgent filter',
          subtitle: '',
          dueDate: now.add(const Duration(days: 2)),
          urgency: UrgencyLevel.urgent,
          type: UpcomingEventType.maintenance,
          relatedItemId: 'item-2',
        ),
      ];

      final snapshot = builder.build(
        isPro: true,
        events: events,
        localeCode: 'es',
        strings: stringsEs,
        now: now,
      );

      expect(snapshot.events, hasLength(1));
      expect(snapshot.events.first.title, 'Urgent filter');
    });

    test('formats due dates in spanish', () {
      final events = [
        UpcomingEvent(
          id: 'm-today',
          title: 'Today',
          subtitle: '',
          dueDate: now,
          urgency: UrgencyLevel.urgent,
          type: UpcomingEventType.maintenance,
          relatedItemId: 'i',
        ),
        UpcomingEvent(
          id: 'm-tomorrow',
          title: 'Tomorrow',
          subtitle: '',
          dueDate: now.add(const Duration(days: 1)),
          urgency: UrgencyLevel.urgent,
          type: UpcomingEventType.maintenance,
          relatedItemId: 'i',
        ),
        UpcomingEvent(
          id: 'm-overdue',
          title: 'Overdue',
          subtitle: '',
          dueDate: now.subtract(const Duration(days: 3)),
          urgency: UrgencyLevel.overdue,
          type: UpcomingEventType.maintenance,
          relatedItemId: 'i',
        ),
      ];

      final snapshot = builder.build(
        isPro: true,
        events: events,
        localeCode: 'es',
        strings: stringsEs,
        now: now,
      );

      expect(snapshot.events[0].dueText, 'Hoy');
      expect(snapshot.events[1].dueText, 'Mañana');
      expect(snapshot.events[2].dueText, 'Retrasado 3 días');
    });

    test('routes for event types', () {
      final maintenance = UpcomingEvent(
        id: 'm',
        title: '',
        subtitle: '',
        dueDate: now,
        urgency: UrgencyLevel.urgent,
        type: UpcomingEventType.maintenance,
        relatedItemId: 'item-123',
      );
      final warranty = UpcomingEvent(
        id: 'w',
        title: '',
        subtitle: '',
        dueDate: now,
        urgency: UrgencyLevel.urgent,
        type: UpcomingEventType.warranty,
        relatedItemId: 'item-123',
      );
      final document = UpcomingEvent(
        id: 'd',
        title: '',
        subtitle: '',
        dueDate: now,
        urgency: UrgencyLevel.urgent,
        type: UpcomingEventType.document,
        relatedItemId: 'doc-1',
      );

      expect(routeForEvent(maintenance), '/items/item-123/maintenance');
      expect(routeForEvent(warranty), '/items/item-123');
      expect(routeForEvent(document), '/documents');
    });
  });

  group('WidgetStrings', () {
    test('uses english locale strings', () {
      final s = widgetStringsFor('en');
      expect(s.dueToday, 'Today');
      expect(s.allClear, contains('All'));
      expect(s.dueInDays(3), 'In 3 days');
      expect(s.overdueBy(1), 'Overdue by 1 day');
    });

    test('uses spanish locale strings', () {
      final s = widgetStringsFor('es');
      expect(s.dueToday, 'Hoy');
      expect(s.dueInDays(2), 'En 2 días');
      expect(s.overdueBy(1), 'Retrasado 1 día');
    });
  });
}
