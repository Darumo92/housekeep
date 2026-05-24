import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/date_calculations.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/models/maintenance.dart';

part 'maintenances_provider.g.dart';

@riverpod
Stream<List<Maintenance>> maintenancesForItem(
  MaintenancesForItemRef ref,
  String itemId,
) {
  return ref
      .watch(maintenancesRepositoryProvider)
      .watchMaintenancesForItem(itemId);
}

@riverpod
Future<Maintenance?> maintenanceById(
  MaintenanceByIdRef ref,
  String id,
) {
  return ref.watch(maintenancesRepositoryProvider).getMaintenance(id);
}

@riverpod
class SaveMaintenance extends _$SaveMaintenance {
  @override
  FutureOr<void> build() {}

  Future<void> save(Maintenance maintenance) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(maintenancesRepositoryProvider)
          .saveMaintenance(maintenance);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

@riverpod
class DeleteMaintenance extends _$DeleteMaintenance {
  @override
  FutureOr<void> build() {}

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(maintenancesRepositoryProvider).deleteMaintenance(id);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

@riverpod
class MarkMaintenanceDone extends _$MarkMaintenanceDone {
  @override
  FutureOr<void> build() {}

  Future<void> markDone(String id, {DateTime? doneAt}) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(maintenancesRepositoryProvider)
          .markAsDone(id, doneAt: doneAt);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

DateTime computeNextDueAt({
  required DateTime? lastDoneAt,
  required int intervalMonths,
  DateTime? now,
}) {
  final reference = lastDoneAt ?? (now ?? DateTime.now());
  return DateCalculations.addMonths(reference, intervalMonths);
}
