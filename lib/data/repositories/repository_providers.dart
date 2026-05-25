import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../database/database_providers.dart';
import 'documents_repository.dart';
import 'items_repository.dart';
import 'maintenances_repository.dart';
import 'purchase_repository.dart';

part 'repository_providers.g.dart';

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

@riverpod
Stream<bool> isPro(IsProRef ref) {
  return ref.watch(purchaseRepositoryProvider).watchIsPro();
}

@riverpod
Future<bool> canAddItem(CanAddItemRef ref) async {
  final isPro = await ref.watch(isProProvider.future);
  if (isPro) return true;

  final count = await ref.watch(itemsRepositoryProvider).countItems();
  return count < AppConstants.freeItemsLimit;
}

@riverpod
Future<bool> canAddDocument(CanAddDocumentRef ref) async {
  final isPro = await ref.watch(isProProvider.future);
  if (isPro) return true;

  final count = await ref.watch(documentsRepositoryProvider).countDocuments();
  return count < AppConstants.freeDocumentsLimit;
}
