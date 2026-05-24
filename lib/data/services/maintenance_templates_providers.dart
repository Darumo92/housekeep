import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/enums/item_category.dart';
import '../../domain/models/maintenance_template.dart';
import 'maintenance_templates_service.dart';

part 'maintenance_templates_providers.g.dart';

@Riverpod(keepAlive: true)
MaintenanceTemplatesService maintenanceTemplatesService(
  MaintenanceTemplatesServiceRef ref,
) {
  return AssetMaintenanceTemplatesService();
}

@riverpod
Future<List<MaintenanceTemplate>> maintenanceTemplates(
  MaintenanceTemplatesRef ref,
) {
  return ref.watch(maintenanceTemplatesServiceProvider).loadAll();
}

@riverpod
Future<List<MaintenanceTemplate>> maintenanceTemplatesByCategory(
  MaintenanceTemplatesByCategoryRef ref,
  ItemCategory category,
) {
  return ref
      .watch(maintenanceTemplatesServiceProvider)
      .loadForCategory(category);
}
