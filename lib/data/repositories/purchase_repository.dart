abstract class PurchaseRepository {
  Future<bool> get isPro;
  Stream<bool> watchIsPro();
}

class MockPurchaseRepository implements PurchaseRepository {
  const MockPurchaseRepository({bool isPro = false}) : _isPro = isPro;

  final bool _isPro;

  @override
  Future<bool> get isPro async => _isPro;

  @override
  Stream<bool> watchIsPro() {
    return Stream<bool>.value(_isPro);
  }
}
