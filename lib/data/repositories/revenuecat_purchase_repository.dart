import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// Hide the SDK's own PurchaseResult: this repository exposes its own domain
// PurchaseResult (from purchase_repository.dart). We only ever read
// `.customerInfo` off the SDK result via type inference, never by name.
import 'package:purchases_flutter/purchases_flutter.dart' hide PurchaseResult;

import '../../core/constants/app_constants.dart';
import 'purchase_repository.dart';

class RevenueCatPurchaseRepository implements PurchaseRepository {
  RevenueCatPurchaseRepository({required this.apiKey})
    : _isProController = StreamController<bool>.broadcast();

  final String apiKey;

  final StreamController<bool> _isProController;
  bool _isProValue = false;
  bool _initialized = false;
  CustomerInfoUpdateListener? _listener;

  @override
  Future<void> init() async {
    if (_initialized) return;
    if (apiKey.isEmpty) {
      throw StateError('RevenueCat apiKey is empty');
    }

    await Purchases.setLogLevel(LogLevel.warn);
    await Purchases.configure(PurchasesConfiguration(apiKey));

    _listener = (info) {
      _updateFromCustomerInfo(info);
    };
    Purchases.addCustomerInfoUpdateListener(_listener!);

    try {
      // Force a fresh server fetch on startup. After a reinstall+restore the
      // purchase is transferred to a new anonymous App User ID; the locally
      // cached CustomerInfo can still reflect the pre-transfer (Free) state,
      // which would leave a genuinely entitled user stuck on Free until the
      // next cache refresh. Invalidating guarantees the entitlement shows.
      await Purchases.invalidateCustomerInfoCache();
    } catch (e) {
      debugPrint('[RevenueCat] invalidateCustomerInfoCache failed: $e');
    }

    try {
      final info = await Purchases.getCustomerInfo();
      _updateFromCustomerInfo(info);
    } catch (e) {
      debugPrint('[RevenueCat] getCustomerInfo failed: $e');
    }

    _initialized = true;
  }

  /// Maps a [CustomerInfo] to our Pro flag, pushes the value to listeners and
  /// returns the freshly-computed entitlement state. Returning the value (and
  /// always re-emitting it) avoids relying on the cached field, which could be
  /// mutated concurrently by the SDK's CustomerInfo listener.
  bool _updateFromCustomerInfo(CustomerInfo info) {
    final active = info.entitlements.active.containsKey(
      AppConstants.entitlementId,
    );
    debugPrint(
      '[RevenueCat] customerInfo update -> active=$active '
      'appUserId=${info.originalAppUserId} '
      'allEntitlements=${info.entitlements.all.keys.toList()} '
      'activeEntitlements=${info.entitlements.active.keys.toList()}',
    );
    _isProValue = active;
    _isProController.add(active);
    return active;
  }

  @override
  Future<bool> get isPro async => _isProValue;

  @override
  Stream<bool> watchIsPro() async* {
    // Seed every new subscriber with the current value, then forward updates.
    // The old broadcast `onListen`-add approach emitted the initial value
    // synchronously inside `listen()`, before Riverpod had wired its handler,
    // so a genuinely-Pro user could stay stuck on the Free UI on startup.
    yield _isProValue;
    yield* _isProController.stream;
  }

  @override
  Future<PurchaseOffering?> getCurrentOffering() async {
    if (!_initialized) return null;
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return null;
      return _mapOffering(current);
    } catch (e) {
      debugPrint('[RevenueCat] getOfferings failed: $e');
      return null;
    }
  }

  PurchaseOffering _mapOffering(Offering offering) {
    return PurchaseOffering(
      identifier: offering.identifier,
      packages: [for (final p in offering.availablePackages) _mapPackage(p)],
    );
  }

  PurchasePackage _mapPackage(Package package) {
    final product = package.storeProduct;
    return PurchasePackage(
      identifier: package.identifier,
      productId: product.identifier,
      priceString: product.priceString,
      title: product.title,
      description: product.description,
    );
  }

  @override
  Future<PurchaseResult> purchasePackage(PurchasePackage package) async {
    if (!_initialized) {
      return const PurchaseResult(
        status: PurchaseStatus.error,
        errorMessage: 'RevenueCat not initialized',
      );
    }
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) {
        return const PurchaseResult(
          status: PurchaseStatus.error,
          errorMessage: 'No current offering',
        );
      }
      Package? native;
      for (final p in current.availablePackages) {
        if (p.identifier == package.identifier) {
          native = p;
          break;
        }
      }
      if (native == null) {
        return const PurchaseResult(
          status: PurchaseStatus.error,
          errorMessage: 'Package not found',
        );
      }
      final result = await Purchases.purchase(PurchaseParams.package(native));
      final active = _updateFromCustomerInfo(result.customerInfo);
      return PurchaseResult(
        status: active ? PurchaseStatus.success : PurchaseStatus.pending,
      );
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return const PurchaseResult(status: PurchaseStatus.cancelled);
      }
      return PurchaseResult(
        status: PurchaseStatus.error,
        errorMessage: e.message ?? code.toString(),
      );
    } catch (e) {
      return PurchaseResult(
        status: PurchaseStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<PurchaseResult> restorePurchases() async {
    if (!_initialized) {
      return const PurchaseResult(
        status: PurchaseStatus.error,
        errorMessage: 'RevenueCat not initialized',
      );
    }
    try {
      final info = await Purchases.restorePurchases();
      final active = _updateFromCustomerInfo(info);
      debugPrint(
        '[RevenueCat] restorePurchases -> active=$active '
        'entitlements.active=${info.entitlements.active.keys.toList()} '
        'expected=${AppConstants.entitlementId}',
      );
      return PurchaseResult(
        status: active ? PurchaseStatus.success : PurchaseStatus.error,
        errorMessage: active ? null : 'No active entitlement to restore',
      );
    } catch (e) {
      debugPrint('[RevenueCat] restorePurchases failed: $e');
      return PurchaseResult(
        status: PurchaseStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
