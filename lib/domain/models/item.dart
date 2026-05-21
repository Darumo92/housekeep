import 'package:drift/drift.dart';

import '../../core/utils/date_calculations.dart';
import '../../data/database/app_database.dart';
import '../enums/item_category.dart';

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.model,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.photoPath,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final ItemCategory category;
  final String? brand;
  final String? model;
  final DateTime? purchaseDate;
  final int? warrantyMonths;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Item.fromDb(ItemRow row) {
    return Item(
      id: row.id,
      name: row.name,
      category: ItemCategory.fromDb(row.category),
      brand: row.brand,
      model: row.model,
      purchaseDate: row.purchaseDate,
      warrantyMonths: row.warrantyMonths,
      photoPath: row.photoPath,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ItemsTableCompanion toCompanion() {
    return ItemsTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category.dbValue),
      brand: Value(brand),
      model: Value(model),
      purchaseDate: Value(purchaseDate),
      warrantyMonths: Value(warrantyMonths),
      photoPath: Value(photoPath),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  DateTime? get warrantyExpiryDate {
    final purchase = purchaseDate;
    final months = warrantyMonths;
    if (purchase == null || months == null || months <= 0) return null;
    return DateCalculations.addMonths(purchase, months);
  }

  bool isWarrantyActive({DateTime? now}) {
    final expiry = warrantyExpiryDate;
    if (expiry == null) return false;
    return expiry.isAfter(now ?? DateTime.now());
  }

  int? warrantyDaysRemaining({DateTime? now}) {
    final expiry = warrantyExpiryDate;
    if (expiry == null) return null;
    return DateCalculations.calendarDaysUntil(expiry, now ?? DateTime.now());
  }
}
