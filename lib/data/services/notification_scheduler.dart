import '../../domain/models/document.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import 'notification_service.dart';
import 'notification_strings.dart';

class NotificationScheduler {
  NotificationScheduler({
    required NotificationService service,
    DateTime Function()? now,
  }) : _service = service,
       _now = now ?? DateTime.now;

  static const List<int> proTiers = [90, 30, 7];
  static const int warrantyDefaultLeadDays = 30;

  final NotificationService _service;
  final DateTime Function() _now;

  String maintenancePayloadPrefix(String maintenanceId) =>
      'hk:m:$maintenanceId:';
  String documentPayloadPrefix(String documentId) => 'hk:d:$documentId:';
  String warrantyPayloadPrefix(String itemId) => 'hk:w:$itemId:';

  int notificationIdFor(String payload) => payload.hashCode & 0x7FFFFFFF;

  static const int _notifyHour = 9;

  DateTime _atNineAm(DateTime day) =>
      DateTime(day.year, day.month, day.day, _notifyHour);

  DateTime _nextNineAm(DateTime now) {
    final today = _atNineAm(now);
    return today.isAfter(now) ? today : today.add(const Duration(days: 1));
  }

  /// Schedules the tier, recovery and expired notifications for a single
  /// entity sharing [prefix]. [reference] is the expiry/due date.
  Future<void> _scheduleEntity({
    required String prefix,
    required DateTime reference,
    required List<int> tiers,
    required String tierTitle,
    required String Function(int days) tierBody,
    required String expiredTitle,
    required String expiredBody,
  }) async {
    await _service.cancelByPayloadPrefix(prefix);

    final now = _now();
    var anyTierScheduled = false;
    for (final days in tiers) {
      if (days < 0) continue;
      final when = _atNineAm(reference.subtract(Duration(days: days)));
      if (!when.isAfter(now)) continue;
      final payload = '$prefix$days';
      await _service.schedule(
        id: notificationIdFor(payload),
        title: tierTitle,
        body: tierBody(days),
        when: when,
        payload: payload,
      );
      anyTierScheduled = true;
    }

    // Recovery: every tier fell in the past but the entity is still valid.
    // Fire a single catch-up at the next 09:00 with the real days remaining.
    if (!anyTierScheduled && reference.isAfter(now)) {
      final payload = '${prefix}soon';
      final remaining = reference.difference(now).inDays;
      await _service.schedule(
        id: notificationIdFor(payload),
        title: tierTitle,
        body: tierBody(remaining),
        when: _nextNineAm(now),
        payload: payload,
      );
    }

    // Expired/overdue: a single notification once the reference date arrives.
    var expiredWhen = _atNineAm(reference);
    if (!expiredWhen.isAfter(now)) expiredWhen = _nextNineAm(now);
    final expiredPayload = '${prefix}expired';
    await _service.schedule(
      id: notificationIdFor(expiredPayload),
      title: expiredTitle,
      body: expiredBody,
      when: expiredWhen,
      payload: expiredPayload,
    );
  }

  List<int> _maintenanceTiers(Maintenance m, {required bool isPro}) {
    if (isPro) return proTiers;
    return [m.notifyDaysBefore];
  }

  List<int> _documentTiers(Document d, {required bool isPro}) {
    if (isPro) return proTiers;
    return [d.notifyDaysBefore];
  }

  List<int> _warrantyTiers({required bool isPro}) {
    if (isPro) return proTiers;
    return [warrantyDefaultLeadDays];
  }

  Future<void> rescheduleMaintenance({
    required Maintenance maintenance,
    required Item item,
    required bool isPro,
    required NotificationTexts texts,
  }) async {
    await _scheduleEntity(
      prefix: maintenancePayloadPrefix(maintenance.id),
      reference: maintenance.nextDueAt,
      tiers: _maintenanceTiers(maintenance, isPro: isPro),
      tierTitle: texts.maintenanceTitle,
      tierBody: (days) =>
          texts.maintenanceBody(item.name, maintenance.name, days),
      expiredTitle: texts.maintenanceOverdueTitle,
      expiredBody: texts.maintenanceOverdueBody(item.name, maintenance.name),
    );
  }

  Future<void> cancelMaintenance(String maintenanceId) {
    return _service.cancelByPayloadPrefix(
      maintenancePayloadPrefix(maintenanceId),
    );
  }

  Future<void> rescheduleDocument({
    required Document document,
    required bool isPro,
    required NotificationTexts texts,
  }) async {
    await _scheduleEntity(
      prefix: documentPayloadPrefix(document.id),
      reference: document.expiryDate,
      tiers: _documentTiers(document, isPro: isPro),
      tierTitle: texts.documentTitle,
      tierBody: (days) => texts.documentBody(document.name, days),
      expiredTitle: texts.documentExpiredTitle,
      expiredBody: texts.documentExpiredBody(document.name),
    );
  }

  Future<void> cancelDocument(String documentId) {
    return _service.cancelByPayloadPrefix(documentPayloadPrefix(documentId));
  }

  Future<void> rescheduleWarranty({
    required Item item,
    required bool isPro,
    required NotificationTexts texts,
  }) async {
    final expiry = item.warrantyExpiryDate;
    if (expiry == null) {
      await _service.cancelByPayloadPrefix(warrantyPayloadPrefix(item.id));
      return;
    }

    await _scheduleEntity(
      prefix: warrantyPayloadPrefix(item.id),
      reference: expiry,
      tiers: _warrantyTiers(isPro: isPro),
      tierTitle: texts.warrantyTitle,
      tierBody: (days) => texts.warrantyBody(item.name, days),
      expiredTitle: texts.warrantyExpiredTitle,
      expiredBody: texts.warrantyExpiredBody(item.name),
    );
  }

  Future<void> cancelWarranty(String itemId) {
    return _service.cancelByPayloadPrefix(warrantyPayloadPrefix(itemId));
  }

  Future<void> rescheduleAll({
    required List<Item> items,
    required List<Maintenance> maintenances,
    required List<Document> documents,
    required bool isPro,
    required NotificationTexts texts,
  }) async {
    final itemsById = {for (final item in items) item.id: item};
    for (final item in items) {
      await rescheduleWarranty(item: item, isPro: isPro, texts: texts);
    }
    for (final maintenance in maintenances) {
      final item = itemsById[maintenance.itemId];
      if (item == null) continue;
      await rescheduleMaintenance(
        maintenance: maintenance,
        item: item,
        isPro: isPro,
        texts: texts,
      );
    }
    for (final document in documents) {
      await rescheduleDocument(document: document, isPro: isPro, texts: texts);
    }
  }

  Future<void> cancelAllForItem({
    required String itemId,
    required Iterable<String> maintenanceIds,
  }) async {
    await cancelWarranty(itemId);
    for (final id in maintenanceIds) {
      await cancelMaintenance(id);
    }
  }
}
