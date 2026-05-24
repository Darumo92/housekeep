import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/features/maintenance/maintenances_provider.dart';

void main() {
  group('computeNextDueAt', () {
    test('uses lastDoneAt as reference when provided', () {
      final next = computeNextDueAt(
        lastDoneAt: DateTime(2026, 1, 15),
        intervalMonths: 6,
        now: DateTime(2026, 5, 1),
      );
      expect(next, DateTime(2026, 7, 15));
    });

    test('uses now when lastDoneAt is null', () {
      final next = computeNextDueAt(
        lastDoneAt: null,
        intervalMonths: 3,
        now: DateTime(2026, 5, 10),
      );
      expect(next, DateTime(2026, 8, 10));
    });

    test('handles month rollover at year boundary', () {
      final next = computeNextDueAt(
        lastDoneAt: DateTime(2026, 11, 20),
        intervalMonths: 3,
        now: DateTime(2026, 12, 1),
      );
      expect(next.year, 2027);
      expect(next.month, 2);
      expect(next.day, 20);
    });
  });
}
