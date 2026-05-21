import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';

enum ItemCategory {
  kitchen('kitchen'),
  bathroom('bathroom'),
  laundry('laundry'),
  living('living'),
  bedroom('bedroom'),
  garden('garden'),
  garage('garage'),
  plumbing('plumbing'),
  electrical('electrical'),
  security('security'),
  general('general');

  const ItemCategory(this.dbValue);

  final String dbValue;

  static ItemCategory fromDb(String value) {
    return ItemCategory.values.firstWhere(
      (category) => category.dbValue == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown item category'),
    );
  }

  String label(AppLocalizations l10n) {
    return switch (this) {
      ItemCategory.kitchen => l10n.itemCategoryKitchen,
      ItemCategory.bathroom => l10n.itemCategoryBathroom,
      ItemCategory.laundry => l10n.itemCategoryLaundry,
      ItemCategory.living => l10n.itemCategoryLiving,
      ItemCategory.bedroom => l10n.itemCategoryBedroom,
      ItemCategory.garden => l10n.itemCategoryGarden,
      ItemCategory.garage => l10n.itemCategoryGarage,
      ItemCategory.plumbing => l10n.itemCategoryPlumbing,
      ItemCategory.electrical => l10n.itemCategoryElectrical,
      ItemCategory.security => l10n.itemCategorySecurity,
      ItemCategory.general => l10n.itemCategoryGeneral,
    };
  }

  IconData get icon {
    return switch (this) {
      ItemCategory.kitchen => Icons.kitchen_rounded,
      ItemCategory.bathroom => Icons.bathtub_rounded,
      ItemCategory.laundry => Icons.local_laundry_service_rounded,
      ItemCategory.living => Icons.weekend_rounded,
      ItemCategory.bedroom => Icons.bed_rounded,
      ItemCategory.garden => Icons.yard_rounded,
      ItemCategory.garage => Icons.garage_rounded,
      ItemCategory.plumbing => Icons.plumbing_rounded,
      ItemCategory.electrical => Icons.electrical_services_rounded,
      ItemCategory.security => Icons.security_rounded,
      ItemCategory.general => Icons.home_repair_service_rounded,
    };
  }
}
