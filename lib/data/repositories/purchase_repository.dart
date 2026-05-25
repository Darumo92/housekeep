import 'dart:async';

enum PurchaseStatus { success, cancelled, error, pending }

class PurchaseResult {
  const PurchaseResult({required this.status, this.errorMessage});

  final PurchaseStatus status;
  final String? errorMessage;

  bool get isSuccess => status == PurchaseStatus.success;
}

class PurchasePackage {
  const PurchasePackage({
    required this.identifier,
    required this.productId,
    required this.priceString,
    required this.title,
    required this.description,
  });

  final String identifier;
  final String productId;
  final String priceString;
  final String title;
  final String description;
}

class PurchaseOffering {
  const PurchaseOffering({
    required this.identifier,
    required this.packages,
  });

  final String identifier;
  final List<PurchasePackage> packages;

  PurchasePackage? get primaryPackage =>
      packages.isEmpty ? null : packages.first;
}

abstract class PurchaseRepository {
  Future<void> init();
  Future<bool> get isPro;
  Stream<bool> watchIsPro();
  Future<PurchaseOffering?> getCurrentOffering();
  Future<PurchaseResult> purchasePackage(PurchasePackage package);
  Future<PurchaseResult> restorePurchases();
}

class MockPurchaseRepository implements PurchaseRepository {
  MockPurchaseRepository({
    bool initialIsPro = false,
    PurchaseOffering? offering,
  }) : _isProController = StreamController<bool>.broadcast(),
       _offering = offering,
       _isProValue = initialIsPro {
    _isProController.onListen = () {
      scheduleMicrotask(() {
        if (!_isProController.isClosed) {
          _isProController.add(_isProValue);
        }
      });
    };
  }

  final StreamController<bool> _isProController;
  PurchaseOffering? _offering;
  bool _isProValue;

  void setOffering(PurchaseOffering? offering) {
    _offering = offering;
  }

  void setPro(bool value) {
    if (_isProValue == value) return;
    _isProValue = value;
    _isProController.add(value);
  }

  @override
  Future<void> init() async {}

  @override
  Future<bool> get isPro async => _isProValue;

  @override
  Stream<bool> watchIsPro() => _isProController.stream;

  @override
  Future<PurchaseOffering?> getCurrentOffering() async => _offering;

  @override
  Future<PurchaseResult> purchasePackage(PurchasePackage package) async {
    setPro(true);
    return const PurchaseResult(status: PurchaseStatus.success);
  }

  @override
  Future<PurchaseResult> restorePurchases() async {
    return PurchaseResult(
      status: _isProValue ? PurchaseStatus.success : PurchaseStatus.error,
      errorMessage: _isProValue ? null : 'Nothing to restore',
    );
  }
}
