import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

    _isProController.onListen = () => _isProController.add(_isProValue);

    await Purchases.setLogLevel(LogLevel.warn);
    await Purchases.configure(PurchasesConfiguration(apiKey));

    _listener = (info) {
      _updateFromCustomerInfo(info);
    };
    Purchases.addCustomerInfoUpdateListener(_listener!);

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
    _isProValue = active;
    _isProController.add(active);
    return active;
  }

  @override
  Future<bool> get isPro async => _isProValue;

  @override
  Stream<bool> watchIsPro() => _isProController.stream;

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
      final info = await Purchases.purchasePackage(native);
      final active = _updateFromCustomerInfo(info);
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
