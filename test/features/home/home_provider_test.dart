import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/repositories/documents_repository.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/maintenances_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/document_type.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/enums/urgency_level.dart';
import 'package:housekeep/domain/models/document.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/domain/models/maintenance.dart';
import 'package:housekeep/domain/models/upcoming_event.dart';
import 'package:housekeep/features/home/home_provider.dart';

void main() {
  ProviderContainer buildContainer({
    List<Item> items = const [],
    List<Maintenance> maintenances = const [],
    List<Document> documents = const [],
  }) {
    return ProviderContainer(
      overrides: [
        itemsRepositoryProvider.overrideWithValue(_FakeItems(items)),
        maintenancesRepositoryProvider
            .overrideWithValue(_FakeMaintenances(maintenances)),
        documentsRepositoryProvider
            .overrideWithValue(_FakeDocuments(documents)),
      ],
    );
  }

  group('homeSummaryProvider', () {
    test('returns counters and overall urgency', () async {
      final now = DateTime.now();
      final container = buildContainer(
        items: [_item(id: 'i1')],
        maintenances: [
          _maintenance(
            id: 'm1',
            itemId: 'i1',
            nextDueAt: now.subtract(const Duration(days: 2)),
          ),
        ],
        documents: [
          _document(id: 'd1', expiryDate: now.add(const Duration(days: 5))),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeItemsProvider.future);
      await container.read(homeUpcomingMaintenancesProvider().future);
      await container.read(homeExpiringDocumentsProvider().future);
      final result = container.read(homeSummaryProvider);
      final summary = result.value!;

      expect(summary.totalItems, 1);
      expect(summary.pendingMaintenances, 1);
      expect(summary.urgentDocuments, 1);
      expect(summary.overallUrgency, UrgencyLevel.overdue);
      expect(summary.isAllClear, isFalse);
    });

    test('isAllClear when no urgent events', () async {
      final container = buildContainer(items: [_item(id: 'i1')]);
      addTearDown(container.dispose);

      await container.read(homeItemsProvider.future);
      await container.read(homeUpcomingMaintenancesProvider().future);
      await container.read(homeExpiringDocumentsProvider().future);
      final result = container.read(homeSummaryProvider);

      expect(result.value!.isAllClear, isTrue);
    });
  });

  test('upcomingEventsProvider merges and sorts events', () async {
    final later = DateTime.now().add(const Duration(days: 60));
    final soon = DateTime.now().add(const Duration(days: 5));
    final container = buildContainer(
      items: const [],
      maintenances: [
        _maintenance(id: 'm1', itemId: 'i1', nextDueAt: later),
      ],
      documents: [
        _document(id: 'd1', expiryDate: soon),
      ],
    );
    addTearDown(container.dispose);

    await container.read(homeItemsProvider.future);
    await container.read(homeUpcomingMaintenancesProvider().future);
    await container.read(homeExpiringDocumentsProvider().future);
    final result = container.read(upcomingEventsProvider());
    final events = result.value!;

    expect(events, hasLength(2));
    expect(events.first.type, UpcomingEventType.document);
    expect(events.last.type, UpcomingEventType.maintenance);
  });
}

Item _item({required String id}) {
  final timestamp = DateTime(2025, 1, 1);
  return Item(
    id: id,
    name: 'Item $id',
    category: ItemCategory.general,
    brand: null,
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

Maintenance _maintenance({
  required String id,
  required String itemId,
  required DateTime nextDueAt,
}) {
  final timestamp = DateTime(2025, 1, 1);
  return Maintenance(
    id: id,
    itemId: itemId,
    name: 'Maintenance $id',
    description: null,
    intervalMonths: 6,
    lastDoneAt: null,
    nextDueAt: nextDueAt,
    notifyDaysBefore: 7,
    isFromTemplate: false,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

Document _document({required String id, required DateTime expiryDate}) {
  final timestamp = DateTime(2025, 1, 1);
  return Document(
    id: id,
    name: 'Document $id',
    type: DocumentType.passport,
    expiryDate: expiryDate,
    notifyDaysBefore: 30,
    photoPath: null,
    notes: null,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

class _FakeItems implements ItemsRepository {
  _FakeItems(this.items);
  final List<Item> items;

  @override
  Future<int> countItems() async => items.length;
  @override
  Future<int> deleteItem(String id) async => 0;
  @override
  Future<Item?> getItem(String id) async {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Stream<Item?> watchItem(String id) {
    for (final item in items) {
      if (item.id == id) return Stream.value(item);
    }
    return Stream.value(null);
  }

  @override
  Future<void> saveItem(Item item) async {}
  @override
  Stream<List<Item>> watchItems() => Stream.value(items);
  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) =>
      Stream.value(items.where((i) => i.category == category).toList());
}

class _FakeMaintenances implements MaintenancesRepository {
  _FakeMaintenances(this.list);
  final List<Maintenance> list;

  @override
  Future<int> deleteMaintenance(String id) async => 0;
  @override
  Future<int> deleteMaintenancesForItem(String itemId) async => 0;
  @override
  Future<Maintenance?> getMaintenance(String id) async => null;
  @override
  Future<void> markAsDone(String id, {DateTime? doneAt}) async {}
  @override
  Future<void> saveMaintenance(Maintenance maintenance) async {}
  @override
  Stream<List<Maintenance>> watchMaintenancesForItem(String itemId) =>
      Stream.value(list.where((m) => m.itemId == itemId).toList());
  @override
  Stream<List<Maintenance>> watchUpcomingMaintenances({int limit = 15}) =>
      Stream.value(list);
}

class _FakeDocuments implements DocumentsRepository {
  _FakeDocuments(this.list);
  final List<Document> list;

  @override
  Future<int> countDocuments() async => list.length;
  @override
  Future<int> deleteDocument(String id) async => 0;
  @override
  Future<Document?> getDocument(String id) async => null;
  @override
  Future<void> saveDocument(Document document) async {}
  @override
  Stream<List<Document>> watchDocuments() => Stream.value(list);
  @override
  Stream<List<Document>> watchDocumentsByType(DocumentType type) =>
      Stream.value(list.where((d) => d.type == type).toList());
  @override
  Stream<List<Document>> watchExpiringDocuments({int limit = 15}) =>
      Stream.value(list);
}
