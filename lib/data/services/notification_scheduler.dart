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
    await _service.cancelByPayloadPrefix(
      maintenancePayloadPrefix(maintenance.id),
    );

    final tiers = _maintenanceTiers(maintenance, isPro: isPro);
    final now = _now();
    for (final days in tiers) {
      if (days < 0) continue;
      final when = maintenance.nextDueAt.subtract(Duration(days: days));
      if (!when.isAfter(now)) continue;
      final payload = '${maintenancePayloadPrefix(maintenance.id)}$days';
      await _service.schedule(
        id: notificationIdFor(payload),
        title: texts.maintenanceTitle,
        body: texts.maintenanceBody(item.name, maintenance.name, days),
        when: when,
        payload: payload,
      );
    }
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
    await _service.cancelByPayloadPrefix(documentPayloadPrefix(document.id));

    final tiers = _documentTiers(document, isPro: isPro);
    final now = _now();
    for (final days in tiers) {
      if (days < 0) continue;
      final when = document.expiryDate.subtract(Duration(days: days));
      if (!when.isAfter(now)) continue;
      final payload = '${documentPayloadPrefix(document.id)}$days';
      await _service.schedule(
        id: notificationIdFor(payload),
        title: texts.documentTitle,
        body: texts.documentBody(document.name, days),
        when: when,
        payload: payload,
      );
    }
  }

  Future<void> cancelDocument(String documentId) {
    return _service.cancelByPayloadPrefix(documentPayloadPrefix(documentId));
  }

  Future<void> rescheduleWarranty({
    required Item item,
    required bool isPro,
    required NotificationTexts texts,
  }) async {
    await _service.cancelByPayloadPrefix(warrantyPayloadPrefix(item.id));

    final expiry = item.warrantyExpiryDate;
    if (expiry == null) return;

    final tiers = _warrantyTiers(isPro: isPro);
    final now = _now();
    for (final days in tiers) {
      if (days < 0) continue;
      final when = expiry.subtract(Duration(days: days));
      if (!when.isAfter(now)) continue;
      final payload = '${warrantyPayloadPrefix(item.id)}$days';
      await _service.schedule(
        id: notificationIdFor(payload),
        title: texts.warrantyTitle,
        body: texts.warrantyBody(item.name, days),
        when: when,
        payload: payload,
      );
    }
  }

  Future<void> cancelWarranty(String itemId) {
    return _service.cancelByPayloadPrefix(warrantyPayloadPrefix(itemId));
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
