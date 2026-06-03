import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/purchase_repository.dart';
import '../../data/repositories/repository_providers.dart';

part 'paywall_provider.g.dart';

@riverpod
Future<PurchaseOffering?> currentOffering(CurrentOfferingRef ref) {
  return ref.watch(purchaseRepositoryProvider).getCurrentOffering();
}

@riverpod
class PurchaseController extends _$PurchaseController {
  @override
  PurchaseControllerState build() {
    return const PurchaseControllerState.idle();
  }

  Future<void> buy(PurchasePackage package) async {
    state = const PurchaseControllerState.loading();
    final repo = ref.read(purchaseRepositoryProvider);
    final result = await repo.purchasePackage(package);
    if (result.status == PurchaseStatus.success) {
      ref.invalidate(isProProvider);
    }
    state = PurchaseControllerState.fromResult(result);
  }

  Future<void> restore() async {
    state = const PurchaseControllerState.loading();
    final repo = ref.read(purchaseRepositoryProvider);
    final result = await repo.restorePurchases();
    if (result.status == PurchaseStatus.success) {
      // Re-read isPro from the repository so the success screen and every
      // gated widget reflect the restored entitlement immediately.
      ref.invalidate(isProProvider);
    }
    state = PurchaseControllerState.fromResult(result);
  }

  void reset() {
    state = const PurchaseControllerState.idle();
  }
}

enum PurchaseUiStatus { idle, loading, success, cancelled, error }

class PurchaseControllerState {
  const PurchaseControllerState._({required this.status, this.errorMessage});

  const PurchaseControllerState.idle() : this._(status: PurchaseUiStatus.idle);

  const PurchaseControllerState.loading()
    : this._(status: PurchaseUiStatus.loading);

  factory PurchaseControllerState.fromResult(PurchaseResult result) {
    switch (result.status) {
      case PurchaseStatus.success:
        return const PurchaseControllerState._(
          status: PurchaseUiStatus.success,
        );
      case PurchaseStatus.cancelled:
        return const PurchaseControllerState._(
          status: PurchaseUiStatus.cancelled,
        );
      case PurchaseStatus.pending:
        return const PurchaseControllerState._(
          status: PurchaseUiStatus.loading,
        );
      case PurchaseStatus.error:
        return PurchaseControllerState._(
          status: PurchaseUiStatus.error,
          errorMessage: result.errorMessage,
        );
    }
  }

  final PurchaseUiStatus status;
  final String? errorMessage;

  bool get isIdle => status == PurchaseUiStatus.idle;
  bool get isLoading => status == PurchaseUiStatus.loading;
  bool get isSuccess => status == PurchaseUiStatus.success;
  bool get isError => status == PurchaseUiStatus.error;
  bool get isCancelled => status == PurchaseUiStatus.cancelled;
}
