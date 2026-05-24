import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/asset_paths.dart';
import '../../domain/enums/item_category.dart';
import '../../domain/models/maintenance_template.dart';

abstract class MaintenanceTemplatesService {
  Future<List<MaintenanceTemplate>> loadAll();
  Future<List<MaintenanceTemplate>> loadForCategory(ItemCategory category);
}

class AssetMaintenanceTemplatesService implements MaintenanceTemplatesService {
  AssetMaintenanceTemplatesService({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  List<MaintenanceTemplate>? _cache;

  @override
  Future<List<MaintenanceTemplate>> loadAll() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await _bundle.loadString(AssetPaths.maintenanceTemplates);
    final decoded = json.decode(raw) as List<Object?>;
    final templates = decoded
        .cast<Map<String, Object?>>()
        .map(MaintenanceTemplate.fromJson)
        .toList(growable: false);
    _cache = templates;
    return templates;
  }

  @override
  Future<List<MaintenanceTemplate>> loadForCategory(
    ItemCategory category,
  ) async {
    final all = await loadAll();
    return all.where((template) => template.category == category).toList();
  }
}
