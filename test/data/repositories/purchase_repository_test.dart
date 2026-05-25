import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/repositories/purchase_repository.dart';

void main() {
  group('MockPurchaseRepository', () {
    test('emits initial isPro value to new listeners', () async {
      final repo = MockPurchaseRepository(initialIsPro: false);
      final firstValue = await repo.watchIsPro().first;
      expect(firstValue, isFalse);
    });

    test('purchasePackage flips isPro to true and emits update', () async {
      final repo = MockPurchaseRepository();
      final received = <bool>[];
      final sub = repo.watchIsPro().listen(received.add);

      await Future<void>.delayed(Duration.zero);

      const pkg = PurchasePackage(
        identifier: 'lifetime',
        productId: 'pro',
        priceString: '€5.99',
        title: 'Pro',
        description: 'Lifetime access',
      );
      final result = await repo.purchasePackage(pkg);

      expect(result.status, PurchaseStatus.success);
      expect(await repo.isPro, isTrue);

      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(received, contains(true));
    });

    test('restorePurchases returns error when nothing to restore', () async {
      final repo = MockPurchaseRepository();
      final result = await repo.restorePurchases();
      expect(result.status, PurchaseStatus.error);
    });

    test('restorePurchases returns success when already pro', () async {
      final repo = MockPurchaseRepository(initialIsPro: true);
      final result = await repo.restorePurchases();
      expect(result.status, PurchaseStatus.success);
    });

    test('getCurrentOffering returns configured offering', () async {
      const offering = PurchaseOffering(
        identifier: 'default',
        packages: [
          PurchasePackage(
            identifier: 'lifetime',
            productId: 'pro',
            priceString: '€5.99',
            title: 'Pro',
            description: 'Lifetime',
          ),
        ],
      );
      final repo = MockPurchaseRepository(offering: offering);
      final result = await repo.getCurrentOffering();
      expect(result, isNotNull);
      expect(result!.primaryPackage?.priceString, '€5.99');
    });
  });

  group('PurchaseResult helpers', () {
    test('PurchaseStatus.success isSuccess true', () {
      const r = PurchaseResult(status: PurchaseStatus.success);
      expect(r.isSuccess, isTrue);
    });

    test('PurchaseStatus.cancelled isSuccess false', () {
      const r = PurchaseResult(status: PurchaseStatus.cancelled);
      expect(r.isSuccess, isFalse);
    });
  });
}
