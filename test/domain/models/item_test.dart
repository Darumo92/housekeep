import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';

void main() {
  Item buildItem({DateTime? purchaseDate, int? warrantyMonths}) {
    return Item(
      id: 'item-1',
      name: 'Washer',
      category: ItemCategory.laundry,
      brand: 'Bosch',
      model: 'W1',
      purchaseDate: purchaseDate,
      warrantyMonths: warrantyMonths,
      photoPath: null,
      notes: null,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  test('warrantyExpiryDate adds warranty months to purchase date', () {
    final item = buildItem(
      purchaseDate: DateTime(2026, 1, 31),
      warrantyMonths: 1,
    );

    expect(item.warrantyExpiryDate, DateTime(2026, 2, 28));
  });

  test(
    'warrantyExpiryDate is null without purchase date or warranty months',
    () {
      expect(buildItem(warrantyMonths: 12).warrantyExpiryDate, isNull);
      expect(
        buildItem(purchaseDate: DateTime(2026, 1, 1)).warrantyExpiryDate,
        isNull,
      );
    },
  );

  test('isWarrantyActive returns true when warranty expires after now', () {
    final item = buildItem(
      purchaseDate: DateTime(2026, 1, 1),
      warrantyMonths: 12,
    );

    expect(item.isWarrantyActive(now: DateTime(2026, 6, 1)), isTrue);
  });

  test('isWarrantyActive returns false when warranty has expired', () {
    final item = buildItem(
      purchaseDate: DateTime(2026, 1, 1),
      warrantyMonths: 1,
    );

    expect(item.isWarrantyActive(now: DateTime(2026, 3, 1)), isFalse);
  });

  test('warrantyDaysRemaining returns whole calendar days', () {
    final item = buildItem(
      purchaseDate: DateTime(2026, 1, 1),
      warrantyMonths: 1,
    );

    expect(item.warrantyDaysRemaining(now: DateTime(2026, 1, 20, 12)), 12);
  });
}
