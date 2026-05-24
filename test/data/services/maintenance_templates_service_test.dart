import 'package:flutter_test/flutter_test.dart';
import 'package:housekeep/data/services/maintenance_templates_service.dart';
import 'package:housekeep/domain/enums/item_category.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AssetMaintenanceTemplatesService', () {
    test('loadAll parses every template from JSON', () async {
      final service = AssetMaintenanceTemplatesService();
      final templates = await service.loadAll();

      expect(templates, isNotEmpty);
      expect(templates.length, greaterThanOrEqualTo(20));
      expect(
        templates.map((t) => t.id).toSet().length,
        templates.length,
        reason: 'ids must be unique',
      );
    });

    test('loadForCategory filters by category', () async {
      final service = AssetMaintenanceTemplatesService();
      final kitchen = await service.loadForCategory(ItemCategory.kitchen);

      expect(kitchen, isNotEmpty);
      for (final template in kitchen) {
        expect(template.category, ItemCategory.kitchen);
      }
    });

    test('caches results between calls', () async {
      final service = AssetMaintenanceTemplatesService();
      final first = await service.loadAll();
      final second = await service.loadAll();
      expect(identical(first, second), isTrue);
    });
  });
}
