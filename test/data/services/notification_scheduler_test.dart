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

extension _Find on List<_ScheduledCall> {
  _ScheduledCall byPayload(String payload) =>
      firstWhere((c) => c.payload == payload);
  bool hasPayload(String payload) => any((c) => c.payload == payload);
}

NotificationTexts _texts() => NotificationTexts(
  maintenanceTitle: 'M',
  maintenanceBody: (i, t, d) => 'm:$i:$t:$d',
  maintenanceOverdueTitle: 'MO',
  maintenanceOverdueBody: (i, t) => 'mo:$i:$t',
  documentTitle: 'D',
  documentBody: (n, d) => 'd:$n:$d',
  documentExpiredTitle: 'DE',
  documentExpiredBody: (n) => 'de:$n',
  warrantyTitle: 'W',
  warrantyBody: (n, d) => 'w:$n:$d',
  warrantyExpiredTitle: 'WE',
  warrantyExpiredBody: (n) => 'we:$n',
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
      'free tier schedules reminder at 09:00 plus overdue notification',
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
        final tier = fake.scheduled.byPayload('hk:m:maint-1:7');
        expect(tier.when, DateTime(2026, 5, 25, 9));
        expect(tier.body, 'm:Fridge:Filter:7');

        final overdue = fake.scheduled.byPayload('hk:m:maint-1:expired');
        expect(overdue.when, DateTime(2026, 6, 1, 9));
        expect(overdue.title, 'MO');
        expect(overdue.body, 'mo:Fridge:Filter');
        expect(fake.scheduled, hasLength(2));
      },
    );

    test('pro tier schedules 90/30/7 reminders plus overdue', () async {
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

      final payloads = fake.scheduled.map((s) => s.payload).toList()..sort();
      expect(payloads, [
        'hk:m:maint-1:30',
        'hk:m:maint-1:7',
        'hk:m:maint-1:90',
        'hk:m:maint-1:expired',
      ]);
    });

    test('skips past tiers but still schedules future tier + overdue', () async {
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

      expect(fake.scheduled, hasLength(2));
      expect(fake.scheduled.hasPayload('hk:m:maint-1:7'), isTrue);
      expect(fake.scheduled.hasPayload('hk:m:maint-1:expired'), isTrue);
    });
  });

  group('NotificationScheduler.rescheduleDocument', () {
    test('free tier at 09:00 plus expired notification', () async {
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
      final tier = fake.scheduled.byPayload('hk:d:doc-1:30');
      expect(tier.when, DateTime(2026, 5, 2, 9));

      final expired = fake.scheduled.byPayload('hk:d:doc-1:expired');
      expect(expired.when, DateTime(2026, 6, 1, 9));
      expect(expired.body, 'de:ID card');
    });

    test(
      'recovery: all tiers past but not yet expired fires one catch-up',
      () async {
        final now = DateTime(2026, 1, 1, 12);
        final fake = _FakeNotificationService();
        final scheduler = NotificationScheduler(service: fake, now: () => now);
        final d = _document(expiryDate: DateTime(2026, 1, 6));

        await scheduler.rescheduleDocument(
          document: d,
          isPro: true,
          texts: _texts(),
        );

        // No tier in the future.
        expect(fake.scheduled.hasPayload('hk:d:doc-1:90'), isFalse);
        expect(fake.scheduled.hasPayload('hk:d:doc-1:7'), isFalse);

        final soon = fake.scheduled.byPayload('hk:d:doc-1:soon');
        expect(soon.when, DateTime(2026, 1, 2, 9)); // next 09:00
        expect(soon.body, 'd:ID card:4'); // days remaining

        expect(fake.scheduled.hasPayload('hk:d:doc-1:expired'), isTrue);
        expect(fake.scheduled, hasLength(2));
      },
    );

    test(
      'already expired on save: only expired notification at next 09:00',
      () async {
        final now = DateTime(2026, 1, 1, 12);
        final fake = _FakeNotificationService();
        final scheduler = NotificationScheduler(service: fake, now: () => now);
        final d = _document(expiryDate: DateTime(2025, 12, 30));

        await scheduler.rescheduleDocument(
          document: d,
          isPro: false,
          texts: _texts(),
        );

        expect(fake.scheduled, hasLength(1));
        final expired = fake.scheduled.byPayload('hk:d:doc-1:expired');
        expect(expired.when, DateTime(2026, 1, 2, 9));
        expect(expired.body, 'de:ID card');
      },
    );
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
      'schedules default 30-day reminder + expired when warranty exists (free)',
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

        expect(fake.scheduled, hasLength(2));
        expect(fake.scheduled.hasPayload('hk:w:item-1:30'), isTrue);
        final expired = fake.scheduled.byPayload('hk:w:item-1:expired');
        expect(expired.body, 'we:Fridge');
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
