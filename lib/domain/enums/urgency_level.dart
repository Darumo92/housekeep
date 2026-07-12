import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_calculations.dart';

enum UrgencyLevel {
  ok('ok'),
  upcoming('upcoming'),
  urgent('urgent'),
  overdue('overdue');

  const UrgencyLevel(this.dbValue);

  final String dbValue;

  static UrgencyLevel fromDb(String value) {
    return UrgencyLevel.values.firstWhere(
      (level) => level.dbValue == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown urgency level'),
    );
  }

  static UrgencyLevel forMaintenanceDueDate(DateTime dueDate, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final daysUntilDue = DateCalculations.calendarDaysUntil(dueDate, reference);

    if (dueDate.isBefore(reference)) return UrgencyLevel.overdue;
    if (daysUntilDue <= 7) return UrgencyLevel.urgent;
    if (daysUntilDue <= 30) return UrgencyLevel.upcoming;
    return UrgencyLevel.ok;
  }

  static UrgencyLevel forDocumentExpiryDate(
    DateTime expiryDate, {
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final daysUntilExpiry = DateCalculations.calendarDaysUntil(
      expiryDate,
      reference,
    );

    if (expiryDate.isBefore(reference)) return UrgencyLevel.overdue;
    if (daysUntilExpiry <= 30) return UrgencyLevel.urgent;
    if (daysUntilExpiry <= 90) return UrgencyLevel.upcoming;
    return UrgencyLevel.ok;
  }

  String label(AppLocalizations l10n) {
    return switch (this) {
      UrgencyLevel.ok => l10n.urgencyOk,
      UrgencyLevel.upcoming => l10n.urgencyUpcoming,
      UrgencyLevel.urgent => l10n.urgencyUrgent,
      UrgencyLevel.overdue => l10n.urgencyOverdue,
    };
  }

  Color color(BuildContext context) {
    return switch (this) {
      UrgencyLevel.ok => context.hkc.success,
      UrgencyLevel.upcoming => context.hkc.warning,
      UrgencyLevel.urgent => context.hkc.error,
      UrgencyLevel.overdue => context.hkc.error,
    };
  }
}
