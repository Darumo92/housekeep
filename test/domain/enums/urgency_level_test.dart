import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/domain/enums/urgency_level.dart';

void main() {
  group('UrgencyLevel.forMaintenanceDueDate', () {
    final now = DateTime(2026, 5, 21, 12);

    test('returns overdue when the due date is on a previous day', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(DateTime(2026, 5, 20), now: now),
        UrgencyLevel.overdue,
      );
    });

    test('returns overdue when due earlier the same day', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(
          DateTime(2026, 5, 21, 11, 59),
          now: now,
        ),
        UrgencyLevel.overdue,
      );
    });

    test('returns urgent when due at the same exact time', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(DateTime(2026, 5, 21, 12), now: now),
        UrgencyLevel.urgent,
      );
    });

    test('returns urgent when due later the same day', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(
          DateTime(2026, 5, 21, 12, 1),
          now: now,
        ),
        UrgencyLevel.urgent,
      );
    });

    test('returns urgent when due in 7 calendar days', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(DateTime(2026, 5, 28), now: now),
        UrgencyLevel.urgent,
      );
    });

    test('returns upcoming when due in 8 calendar days', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(DateTime(2026, 5, 29), now: now),
        UrgencyLevel.upcoming,
      );
    });

    test('returns upcoming when due in 30 calendar days', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(DateTime(2026, 6, 20), now: now),
        UrgencyLevel.upcoming,
      );
    });

    test('returns ok when due in 31 calendar days', () {
      expect(
        UrgencyLevel.forMaintenanceDueDate(DateTime(2026, 6, 21), now: now),
        UrgencyLevel.ok,
      );
    });
  });

  group('UrgencyLevel.forDocumentExpiryDate', () {
    final now = DateTime(2026, 5, 21, 12);

    test('returns overdue when the expiry date is on a previous day', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(DateTime(2026, 5, 20), now: now),
        UrgencyLevel.overdue,
      );
    });

    test('returns overdue when expiring earlier the same day', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(
          DateTime(2026, 5, 21, 11, 59),
          now: now,
        ),
        UrgencyLevel.overdue,
      );
    });

    test('returns urgent when expiring at the same exact time', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(DateTime(2026, 5, 21, 12), now: now),
        UrgencyLevel.urgent,
      );
    });

    test('returns urgent when expiring later the same day', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(
          DateTime(2026, 5, 21, 12, 1),
          now: now,
        ),
        UrgencyLevel.urgent,
      );
    });

    test('returns urgent when expiring in 30 calendar days', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(DateTime(2026, 6, 20), now: now),
        UrgencyLevel.urgent,
      );
    });

    test('returns upcoming when expiring in 31 calendar days', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(DateTime(2026, 6, 21), now: now),
        UrgencyLevel.upcoming,
      );
    });

    test('returns upcoming when expiring in 90 calendar days', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(DateTime(2026, 8, 19), now: now),
        UrgencyLevel.upcoming,
      );
    });

    test('returns ok when expiring in 91 calendar days', () {
      expect(
        UrgencyLevel.forDocumentExpiryDate(DateTime(2026, 8, 20), now: now),
        UrgencyLevel.ok,
      );
    });
  });

  group('UrgencyLevel.fromDb', () {
    test('returns the matching urgency level for a known db value', () {
      expect(UrgencyLevel.fromDb('ok'), UrgencyLevel.ok);
      expect(UrgencyLevel.fromDb('upcoming'), UrgencyLevel.upcoming);
      expect(UrgencyLevel.fromDb('urgent'), UrgencyLevel.urgent);
      expect(UrgencyLevel.fromDb('overdue'), UrgencyLevel.overdue);
    });

    test('throws ArgumentError for an unknown db value', () {
      expect(
        () => UrgencyLevel.fromDb('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
