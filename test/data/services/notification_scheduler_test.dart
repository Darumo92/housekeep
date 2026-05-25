import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/services/notification_scheduler.dart';
import 'package:housekeep/data/services/notification_service.dart';
import 'package:housekeep/data/services/notification_strings.dart';
import 'package:housekeep/domain/enums/document_type.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/document.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/domain/models/maintenance.dart';

class _ScheduledCall {
  _ScheduledCall(this.id, this.title, this.body, this.when, this.payload);
  final int id;
  final String title;
  final String body;
  final DateTime when;
  final String? payload;
}

class _FakeNotificationService extends NotificationService {
  _FakeNotificationService();

  final List<_ScheduledCall> scheduled = [];
  final List<String> cancelledPrefixes = [];

  @override
  Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    scheduled.add(_ScheduledCall(id, title, body, when, payload));
    return true;
  }

  @override
  Future<void> cancelByPayloadPrefix(String prefix) async {
    cancelledPrefixes.add(prefix);
  }

  @override
  Future<void> cancel(int id) async {}
}

NotificationTexts _texts() => NotificationTexts(
  maintenanceTitle: 'M',
  maintenanceBody: (i, t, d) => 'm:$i:$t:$d',
  documentTitle: 'D',
  documentBody: (n, d) => 'd:$n:$d',
  warrantyTitle: 'W',
  warrantyBody: (n, d) => 'w:$n:$d',
);

Maintenance _maintenance({
  String id = 'maint-1',
  String itemId = 'item-1',
  required DateTime nextDueAt,
  int notifyDaysBefore = 7,
}) => Maintenance(
  id: id,
  itemId: itemId,
  name: 'Filter',
  description: null,
  intervalMonths: 6,
  lastDoneAt: null,
  nextDueAt: nextDueAt,
  notifyDaysBefore: notifyDaysBefore,
  isFromTemplate: false,
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

Item _item({
  String id = 'item-1',
  DateTime? purchaseDate,
  int? warrantyMonths,
}) => Item(
  id: id,
  name: 'Fridge',
  category: ItemCategory.kitchen,
  brand: null,
  model: null,
  purchaseDate: purchaseDate,
  warrantyMonths: warrantyMonths,
  photoPath: null,
  notes: null,
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

Document _document({
  String id = 'doc-1',
  required DateTime expiryDate,
  int notifyDaysBefore = 30,
}) => Document(
  id: id,
  name: 'ID card',
  type: DocumentType.idCard,
  expiryDate: expiryDate,
  notifyDaysBefore: notifyDaysBefore,
  photoPath: null,
  notes: null,
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

void main() {
  group('NotificationScheduler.rescheduleMaintenance', () {
    test(
      'free tier schedules one notification at nextDue - notifyDaysBefore',
      () async {
        final now = DateTime(2026, 1, 1);
        final fake = _FakeNotificationService();
        final scheduler = NotificationScheduler(service: fake, now: () => now);
        final m = _maintenance(
          nextDueAt: DateTime(2026, 6, 1),
          notifyDaysBefore: 7,
        );

        await scheduler.rescheduleMaintenance(
          maintenance: m,
          item: _item(),
          isPro: false,
          texts: _texts(),
        );

        expect(fake.cancelledPrefixes, ['hk:m:maint-1:']);
        expect(fake.scheduled, hasLength(1));
        expect(fake.scheduled.first.when, DateTime(2026, 5, 25));
        expect(fake.scheduled.first.payload, 'hk:m:maint-1:7');
        expect(fake.scheduled.first.body, 'm:Fridge:Filter:7');
      },
    );

    test('pro tier schedules 90/30/7 day reminders', () async {
      final now = DateTime(2026, 1, 1);
      final fake = _FakeNotificationService();
      final scheduler = NotificationScheduler(service: fake, now: () => now);
      final m = _maintenance(nextDueAt: DateTime(2026, 12, 1));

      await scheduler.rescheduleMaintenance(
        maintenance: m,
        item: _item(),
        isPro: true,
        texts: _texts(),
      );

      final tiers = fake.scheduled.map((s) => s.payload).toList()..sort();
      expect(tiers, ['hk:m:maint-1:30', 'hk:m:maint-1:7', 'hk:m:maint-1:90']);
    });

    test('skips tiers that fall in the past', () async {
      final now = DateTime(2026, 1, 1);
      final fake = _FakeNotificationService();
      final scheduler = NotificationScheduler(service: fake, now: () => now);
      final m = _maintenance(nextDueAt: DateTime(2026, 1, 15));

      await scheduler.rescheduleMaintenance(
        maintenance: m,
        item: _item(),
        isPro: true,
        texts: _texts(),
      );

      expect(fake.scheduled, hasLength(1));
      expect(fake.scheduled.first.payload, 'hk:m:maint-1:7');
    });
  });

  group('NotificationScheduler.rescheduleDocument', () {
    test('free tier uses notifyDaysBefore', () async {
      final now = DateTime(2026, 1, 1);
      final fake = _FakeNotificationService();
      final scheduler = NotificationScheduler(service: fake, now: () => now);
      final d = _document(expiryDate: DateTime(2026, 6, 1));

      await scheduler.rescheduleDocument(
        document: d,
        isPro: false,
        texts: _texts(),
      );

      expect(fake.cancelledPrefixes, ['hk:d:doc-1:']);
      expect(fake.scheduled.first.when, DateTime(2026, 5, 2));
      expect(fake.scheduled.first.payload, 'hk:d:doc-1:30');
    });
  });

  group('NotificationScheduler.rescheduleWarranty', () {
    test('skips schedule when item has no warranty', () async {
      final now = DateTime(2026, 1, 1);
      final fake = _FakeNotificationService();
      final scheduler = NotificationScheduler(service: fake, now: () => now);

      await scheduler.rescheduleWarranty(
        item: _item(),
        isPro: false,
        texts: _texts(),
      );

      expect(fake.cancelledPrefixes, ['hk:w:item-1:']);
      expect(fake.scheduled, isEmpty);
    });

    test(
      'schedules default 30-day reminder when warranty exists (free)',
      () async {
        final now = DateTime(2026, 1, 1);
        final fake = _FakeNotificationService();
        final scheduler = NotificationScheduler(service: fake, now: () => now);
        final item = _item(
          purchaseDate: DateTime(2025, 1, 1),
          warrantyMonths: 24,
        );

        await scheduler.rescheduleWarranty(
          item: item,
          isPro: false,
          texts: _texts(),
        );

        expect(fake.scheduled, hasLength(1));
        expect(fake.scheduled.first.payload, 'hk:w:item-1:30');
      },
    );
  });

  group('NotificationScheduler cancel helpers', () {
    test(
      'cancelAllForItem cancels warranty + each maintenance prefix',
      () async {
        final fake = _FakeNotificationService();
        final scheduler = NotificationScheduler(service: fake);

        await scheduler.cancelAllForItem(
          itemId: 'item-9',
          maintenanceIds: ['a', 'b'],
        );

        expect(fake.cancelledPrefixes, [
          'hk:w:item-9:',
          'hk:m:a:',
          'hk:m:b:',
        ]);
      },
    );
  });
}
