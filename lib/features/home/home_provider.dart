import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/enums/urgency_level.dart';
import '../../domain/models/document.dart';
import '../../domain/models/item.dart';
import '../../domain/models/maintenance.dart';
import '../../domain/models/upcoming_event.dart';

part 'home_provider.g.dart';

class HomeSummary {
  const HomeSummary({
    required this.totalItems,
    required this.totalDocuments,
    required this.totalMaintenances,
    required this.pendingMaintenances,
    required this.urgentDocuments,
    required this.overallUrgency,
  });

  final int totalItems;
  final int totalDocuments;
  final int totalMaintenances;
  final int pendingMaintenances;
  final int urgentDocuments;
  final UrgencyLevel overallUrgency;

  bool get isAllClear =>
      pendingMaintenances == 0 && urgentDocuments == 0;
}

@riverpod
Stream<List<Item>> homeItems(HomeItemsRef ref) {
  return ref.watch(itemsRepositoryProvider).watchItems();
}

@riverpod
Stream<List<Maintenance>> homeUpcomingMaintenances(
  HomeUpcomingMaintenancesRef ref, {
  int limit = 200,
}) {
  return ref
      .watch(maintenancesRepositoryProvider)
      .watchUpcomingMaintenances(limit: limit);
}

@riverpod
Stream<List<Document>> homeExpiringDocuments(
  HomeExpiringDocumentsRef ref, {
  int limit = 200,
}) {
  return ref
      .watch(documentsRepositoryProvider)
      .watchExpiringDocuments(limit: limit);
}

@riverpod
AsyncValue<List<UpcomingEvent>> upcomingEvents(
  UpcomingEventsRef ref, {
  int limit = 15,
}) {
  final maintenancesAsync = ref.watch(homeUpcomingMaintenancesProvider());
  final documentsAsync = ref.watch(homeExpiringDocumentsProvider());
  final itemsAsync = ref.watch(homeItemsProvider);

  if (maintenancesAsync.isLoading ||
      documentsAsync.isLoading ||
      itemsAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final error = maintenancesAsync.error ??
      documentsAsync.error ??
      itemsAsync.error;
  if (error != null) {
    final stackTrace = maintenancesAsync.stackTrace ??
        documentsAsync.stackTrace ??
        itemsAsync.stackTrace ??
        StackTrace.current;
    return AsyncValue.error(error, stackTrace);
  }

  final maintenances = maintenancesAsync.value ?? const <Maintenance>[];
  final documents = documentsAsync.value ?? const <Document>[];
  final items = itemsAsync.value ?? const <Item>[];

  final now = DateTime.now();
  final itemsById = {for (final item in items) item.id: item};
  final events = <UpcomingEvent>[];

  for (final maintenance in maintenances) {
    final item = itemsById[maintenance.itemId];
    events.add(
      UpcomingEvent(
        id: 'maintenance-${maintenance.id}',
        title: maintenance.name,
        subtitle: item?.name ?? '',
        dueDate: maintenance.nextDueAt,
        urgency: maintenance.urgencyLevel(now: now),
        type: UpcomingEventType.maintenance,
        relatedItemId: maintenance.itemId,
        category: item?.category,
      ),
    );
  }

  for (final document in documents) {
    events.add(
      UpcomingEvent(
        id: 'document-${document.id}',
        title: document.name,
        subtitle: '',
        dueDate: document.expiryDate,
        urgency: document.urgencyLevel(now: now),
        type: UpcomingEventType.document,
        relatedItemId: document.id,
      ),
    );
  }

  for (final item in items) {
    final expiry = item.warrantyExpiryDate;
    if (expiry == null) continue;
    final urgency = UrgencyLevel.forDocumentExpiryDate(expiry, now: now);
    if (urgency == UrgencyLevel.ok) continue;
    events.add(
      UpcomingEvent(
        id: 'warranty-${item.id}',
        title: item.name,
        subtitle: '',
        dueDate: expiry,
        urgency: urgency,
        type: UpcomingEventType.warranty,
        relatedItemId: item.id,
        category: item.category,
      ),
    );
  }

  events.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return AsyncValue.data(events.take(limit).toList(growable: false));
}

@riverpod
AsyncValue<HomeSummary> homeSummary(HomeSummaryRef ref) {
  final maintenancesAsync = ref.watch(homeUpcomingMaintenancesProvider());
  final documentsAsync = ref.watch(homeExpiringDocumentsProvider());
  final itemsAsync = ref.watch(homeItemsProvider);

  if (maintenancesAsync.isLoading ||
      documentsAsync.isLoading ||
      itemsAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final error = maintenancesAsync.error ??
      documentsAsync.error ??
      itemsAsync.error;
  if (error != null) {
    final stackTrace = maintenancesAsync.stackTrace ??
        documentsAsync.stackTrace ??
        itemsAsync.stackTrace ??
        StackTrace.current;
    return AsyncValue.error(error, stackTrace);
  }

  final maintenances = maintenancesAsync.value ?? const <Maintenance>[];
  final documents = documentsAsync.value ?? const <Document>[];
  final items = itemsAsync.value ?? const <Item>[];

  final now = DateTime.now();
  final pendingMaintenances = maintenances.where((maintenance) {
    final urgency = maintenance.urgencyLevel(now: now);
    return urgency != UrgencyLevel.ok;
  }).length;
  final urgentDocuments = documents.where((document) {
    final urgency = document.urgencyLevel(now: now);
    return urgency == UrgencyLevel.urgent ||
        urgency == UrgencyLevel.overdue;
  }).length;

  final urgencies = <UrgencyLevel>[
    for (final maintenance in maintenances) maintenance.urgencyLevel(now: now),
    for (final document in documents) document.urgencyLevel(now: now),
  ];
  final overall = _highestUrgency(urgencies);

  return AsyncValue.data(
    HomeSummary(
      totalItems: items.length,
      totalDocuments: documents.length,
      totalMaintenances: maintenances.length,
      pendingMaintenances: pendingMaintenances,
      urgentDocuments: urgentDocuments,
      overallUrgency: overall,
    ),
  );
}

UrgencyLevel _highestUrgency(List<UrgencyLevel> urgencies) {
  var highest = UrgencyLevel.ok;
  for (final level in urgencies) {
    if (_severity(level) > _severity(highest)) {
      highest = level;
    }
  }
  return highest;
}

int _severity(UrgencyLevel level) {
  return switch (level) {
    UrgencyLevel.ok => 0,
    UrgencyLevel.upcoming => 1,
    UrgencyLevel.urgent => 2,
    UrgencyLevel.overdue => 3,
  };
}
