import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../enums/urgency_level.dart';

class Maintenance {
  const Maintenance({
    required this.id,
    required this.itemId,
    required this.name,
    required this.description,
    required this.intervalMonths,
    required this.lastDoneAt,
    required this.nextDueAt,
    required this.notifyDaysBefore,
    required this.isFromTemplate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String itemId;
  final String name;
  final String? description;
  final int intervalMonths;
  final DateTime? lastDoneAt;
  final DateTime nextDueAt;
  final int notifyDaysBefore;
  final bool isFromTemplate;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Maintenance.fromDb(MaintenanceRow row) {
    return Maintenance(
      id: row.id,
      itemId: row.itemId,
      name: row.name,
      description: row.description,
      intervalMonths: row.intervalMonths,
      lastDoneAt: row.lastDoneAt,
      nextDueAt: row.nextDueAt,
      notifyDaysBefore: row.notifyDaysBefore,
      isFromTemplate: row.isFromTemplate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  MaintenancesTableCompanion toCompanion() {
    return MaintenancesTableCompanion(
      id: Value(id),
      itemId: Value(itemId),
      name: Value(name),
      description: Value(description),
      intervalMonths: Value(intervalMonths),
      lastDoneAt: Value(lastDoneAt),
      nextDueAt: Value(nextDueAt),
      notifyDaysBefore: Value(notifyDaysBefore),
      isFromTemplate: Value(isFromTemplate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  UrgencyLevel urgencyLevel({DateTime? now}) {
    return UrgencyLevel.forMaintenanceDueDate(nextDueAt, now: now);
  }
}
