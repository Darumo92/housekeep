import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:housekeep/data/repositories/purchase_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

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

  group('ProDebugOverride', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('persists simulated pro state for the next app launch', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(proDebugOverrideProvider.notifier).set(true);

      final prefs = SharedPreferencesAsync();
      expect(await prefs.getBool(kProDebugOverridePrefKey), isTrue);
    });

    test('loads simulated pro state from shared preferences', () async {
      final prefs = SharedPreferencesAsync();
      await prefs.setBool(kProDebugOverridePrefKey, true);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(proDebugOverrideProvider.notifier).load();

      expect(container.read(proDebugOverrideProvider), isTrue);
    });
  });

  group('isProProvider override semantics', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('a real entitlement is honored when override is null', () async {
      final container = ProviderContainer(
        overrides: [
          purchaseRepositoryProvider.overrideWithValue(
            MockPurchaseRepository(initialIsPro: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(await container.read(isProProvider.future), isTrue);
    });

    test(
      'override=false must NOT mask a real active entitlement (restore bug)',
      () async {
        final container = ProviderContainer(
          overrides: [
            purchaseRepositoryProvider.overrideWithValue(
              MockPurchaseRepository(initialIsPro: true),
            ),
          ],
        );
        addTearDown(container.dispose);

        // A tester toggled "Simular PRO" off at some point -> stored false.
        await container.read(proDebugOverrideProvider.notifier).set(false);

        // The user then restored a real purchase: entitlement is active.
        // Pro must be reported as active despite the stale false override.
        expect(await container.read(isProProvider.future), isTrue);
      },
    );

    test('override=true forces pro even without a real entitlement', () async {
      final container = ProviderContainer(
        overrides: [
          purchaseRepositoryProvider.overrideWithValue(
            MockPurchaseRepository(initialIsPro: false),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(proDebugOverrideProvider.notifier).set(true);

      expect(await container.read(isProProvider.future), isTrue);
    });
  });
}
