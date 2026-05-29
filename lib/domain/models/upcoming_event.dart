import '../../core/utils/date_calculations.dart';
import '../enums/document_type.dart';
import '../enums/item_category.dart';
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
    this.category,
    this.documentType,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime dueDate;
  final UrgencyLevel urgency;
  final UpcomingEventType type;
  final String? relatedItemId;

  /// Category of the related item (for maintenance/warranty). Null for documents.
  final ItemCategory? category;

  /// Type of the related document. Null for maintenance and warranty events.
  final DocumentType? documentType;

  int daysUntilDue({DateTime? now}) {
    return DateCalculations.calendarDaysUntil(dueDate, now ?? DateTime.now());
  }
}
