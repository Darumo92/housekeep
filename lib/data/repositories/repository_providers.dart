import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../database/database_providers.dart';
import 'documents_repository.dart';
import 'items_repository.dart';
import 'maintenances_repository.dart';
import 'purchase_repository.dart';

part 'repository_providers.g.dart';

const kProDebugOverridePrefKey = 'debug.simulate_pro';

@riverpod
ItemsRepository itemsRepository(ItemsRepositoryRef ref) {
  return DriftItemsRepository(ref.watch(itemsDaoProvider));
}

@riverpod
MaintenancesRepository maintenancesRepository(MaintenancesRepositoryRef ref) {
  return DriftMaintenancesRepository(ref.watch(maintenancesDaoProvider));
}

@riverpod
DocumentsRepository documentsRepository(DocumentsRepositoryRef ref) {
  return DriftDocumentsRepository(ref.watch(documentsDaoProvider));
}

@Riverpod(keepAlive: true)
PurchaseRepository purchaseRepository(PurchaseRepositoryRef ref) {
  return MockPurchaseRepository();
}

@Riverpod(keepAlive: true)
class ProDebugOverride extends _$ProDebugOverride {
  @override
  bool? build() => null;

  Future<void> load() async {
    final prefs = SharedPreferencesAsync();
    state = await prefs.getBool(kProDebugOverridePrefKey);
  }

  Future<void> set(bool? value) async {
    state = value;
    final prefs = SharedPreferencesAsync();
    if (value == null) {
      await prefs.remove(kProDebugOverridePrefKey);
    } else {
      await prefs.setBool(kProDebugOverridePrefKey, value);
    }
  }
}

@riverpod
Stream<bool> isPro(IsProRef ref) {
  final override = ref.watch(proDebugOverrideProvider);
  // The debug "simulate PRO" override may only FORCE Pro on for testing. It
  // must never mask a real active entitlement: a stale stored `false` (left
  // behind after a tester flipped the switch off) used to override a genuine
  // purchase/restore, so the user saw "restore successful" yet stayed Free.
  // Real entitlements always win.
  if (override == true) {
    return Stream.value(true);
  }
  return ref.watch(purchaseRepositoryProvider).watchIsPro();
}

@riverpod
Future<bool> canAddItem(CanAddItemRef ref) async {
  final isPro = ref.watch(isProProvider).valueOrNull ?? false;
  if (isPro) return true;

  final count = await ref.watch(itemsRepositoryProvider).countItems();
  return count < AppConstants.freeItemsLimit;
}

@riverpod
Future<bool> canAddDocument(CanAddDocumentRef ref) async {
  final isPro = ref.watch(isProProvider).valueOrNull ?? false;
  if (isPro) return true;

  final count = await ref.watch(documentsRepositoryProvider).countDocuments();
  return count < AppConstants.freeDocumentsLimit;
}
