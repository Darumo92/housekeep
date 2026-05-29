import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/core/theme/app_theme.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/features/maintenance/add_edit_maintenance_screen.dart';

void main() {
  testWidgets('shows which item the maintenance belongs to', (tester) async {
    final item = _item(name: 'Lavadora');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(_FakeItemsRepository(item)),
        ],
        child: const _TestApp(home: AddEditMaintenanceScreen(itemId: 'item-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lavadora'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: home,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

Item _item({required String name}) {
  final now = DateTime(2026, 5, 28);
  return Item(
    id: 'item-1',
    name: name,
    category: ItemCategory.laundry,
    brand: 'Bosch',
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: now,
    updatedAt: now,
  );
}

class _FakeItemsRepository implements ItemsRepository {
  const _FakeItemsRepository(this.item);

  final Item item;

  @override
  Future<int> countItems() async => 1;

  @override
  Future<int> deleteItem(String id) async => 0;

  @override
  Future<Item?> getItem(String id) async => id == item.id ? item : null;

  @override
  Future<void> saveItem(Item item) async {}

  @override
  Stream<Item?> watchItem(String id) =>
      Stream.value(id == item.id ? item : null);

  @override
  Stream<List<Item>> watchItems() => Stream.value([item]);

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) {
    return Stream.value(item.category == category ? [item] : const []);
  }
}
