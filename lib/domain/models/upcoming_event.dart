import '../../core/utils/date_calculations.dart';
import '../enums/urgency_level.dart';

enum UpcomingEventType { maintenance, document, warranty }

class UpcomingEvent {
  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.urgency,
    required this.type,
    required this.relatedItemId,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime dueDate;
  final UrgencyLevel urgency;
  final UpcomingEventType type;
  final String? relatedItemId;

  int daysUntilDue({DateTime? now}) {
    return DateCalculations.calendarDaysUntil(dueDate, now ?? DateTime.now());
  }
}
