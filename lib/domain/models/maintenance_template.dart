import '../enums/item_category.dart';

class MaintenanceTemplate {
  const MaintenanceTemplate({
    required this.id,
    required this.nameEn,
    required this.nameEs,
    required this.category,
    required this.intervalMonths,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.notifyDaysBefore,
    required this.isPro,
  });

  final String id;
  final String nameEn;
  final String nameEs;
  final ItemCategory category;
  final int intervalMonths;
  final String descriptionEn;
  final String descriptionEs;
  final int notifyDaysBefore;
  final bool isPro;

  factory MaintenanceTemplate.fromJson(Map<String, Object?> json) {
    return MaintenanceTemplate(
      id: json['id']! as String,
      nameEn: json['name_en']! as String,
      nameEs: json['name_es']! as String,
      category: ItemCategory.fromDb(json['category']! as String),
      intervalMonths: json['interval_months']! as int,
      descriptionEn: json['description_en']! as String,
      descriptionEs: json['description_es']! as String,
      notifyDaysBefore: json['notify_days_before']! as int,
      isPro: json['is_pro']! as bool,
    );
  }
}
