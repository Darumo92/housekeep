import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:housekeep/app.dart';
import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/maintenances_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/domain/models/maintenance.dart';
import 'package:housekeep/features/items/item_detail_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shows item details and maintenance placeholder', (tester) async {
    final item = _item(
      id: 'item-1',
      name: 'Fridge',
      category: ItemCategory.kitchen,
      purchaseDate: DateTime(2026, 1, 10),
      warrantyMonths: 24,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            _FakeItemsRepository(item: item),
          ),
          maintenancesRepositoryProvider.overrideWithValue(
            _FakeMaintenancesRepository(),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/items/item-1'),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    expect(find.text('Fridge'), findsOneWidget);
    expect(find.text(l10n.itemWarrantyActive), findsOneWidget);
    expect(find.text(l10n.itemMaintenanceSectionTitle), findsOneWidget);
    expect(find.text(l10n.itemMaintenanceSectionEmpty), findsOneWidget);
  });

  testWidgets('shows delete confirmation dialog when delete is tapped', (
    tester,
  ) async {
    final item = _item(
      id: 'item-1',
      name: 'Fridge',
      category: ItemCategory.kitchen,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(
            _FakeItemsRepository(item: item),
          ),
          maintenancesRepositoryProvider.overrideWithValue(
            _FakeMaintenancesRepository(),
          ),
        ],
        child: const HouseKeepApp(initialLocation: '/items/item-1'),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.itemDelete));
    await tester.pumpAndSettle();

    expect(find.text(l10n.itemDeleteTitle), findsOneWidget);
    expect(find.text(l10n.itemDeleteBody), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(l10n.itemDeleteConfirm),
      ),
      findsOneWidget,
    );
  });

  testWidgets('confirming delete deletes and pops the detail screen', (
    tester,
  ) async {
    final repository = _FakeItemsRepository(
      item: _item(id: 'item-1', name: 'Fridge', category: ItemCategory.kitchen),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
          maintenancesRepositoryProvider.overrideWithValue(
            _FakeMaintenancesRepository(),
          ),
        ],
        child: const _DetailRouteTestApp(),
      ),
    );
    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.itemDelete));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(l10n.itemDeleteConfirm),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.deletedItemIds, ['item-1']);
    expect(find.byType(ItemDetailScreen), findsNothing);
    expect(find.text('Open detail'), findsOneWidget);
  });

  testWidgets('cancelling delete does not delete or pop the detail screen', (
    tester,
  ) async {
    final repository = _FakeItemsRepository(
      item: _item(id: 'item-1', name: 'Fridge', category: ItemCategory.kitchen),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
          maintenancesRepositoryProvider.overrideWithValue(
            _FakeMaintenancesRepository(),
          ),
        ],
        child: const _DetailRouteTestApp(),
      ),
    );
    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.itemDelete));
    await tester.pumpAndSettle();
    final cancelLabel = MaterialLocalizations.of(
      tester.element(find.byType(AlertDialog)),
    ).cancelButtonLabel;
    await tester.tap(find.text(cancelLabel));
    await tester.pumpAndSettle();

    expect(repository.deletedItemIds, isEmpty);
    expect(find.byType(ItemDetailScreen), findsOneWidget);
    expect(find.text('Fridge'), findsOneWidget);
  });

  testWidgets(
    'failed delete shows feedback and does not pop the detail screen',
    (tester) async {
      final repository = _FakeItemsRepository(
        item: _item(
          id: 'item-1',
          name: 'Fridge',
          category: ItemCategory.kitchen,
        ),
        failOnDelete: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsRepositoryProvider.overrideWithValue(repository),
            maintenancesRepositoryProvider.overrideWithValue(
              _FakeMaintenancesRepository(),
            ),
          ],
          child: const _DetailRouteTestApp(),
        ),
      );
      await tester.tap(find.text('Open detail'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.itemDelete));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(l10n.itemDeleteConfirm),
        ),
      );
      await tester.pumpAndSettle();

      expect(repository.deletedItemIds, ['item-1']);
      expect(find.byType(ItemDetailScreen), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(l10n.itemDeleteFailed), findsOneWidget);
      expect(find.text('Exception: delete failed'), findsNothing);
    },
  );

  testWidgets('delete action is disabled while a delete is already in flight', (
    tester,
  ) async {
    final deleteCompleter = Completer<int>();
    final repository = _FakeItemsRepository(
      item: _item(id: 'item-1', name: 'Fridge', category: ItemCategory.kitchen),
      deleteCompleter: deleteCompleter,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
          maintenancesRepositoryProvider.overrideWithValue(
            _FakeMaintenancesRepository(),
          ),
        ],
        child: const _DetailRouteTestApp(),
      ),
    );
    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.itemDelete));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(l10n.itemDeleteConfirm),
      ),
    );
    await tester.pump();

    expect(repository.deletedItemIds, ['item-1']);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );

    deleteCompleter.complete(1);
    await tester.pumpAndSettle();

    expect(find.byType(ItemDetailScreen), findsNothing);
  });
}

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(Scaffold).first));
}

Item _item({
  required String id,
  required String name,
  required ItemCategory category,
  DateTime? purchaseDate,
  int? warrantyMonths,
}) {
  final timestamp = DateTime(2024, 1, 1);
  return Item(
    id: id,
    name: name,
    category: category,
    brand: null,
    model: null,
    purchaseDate: purchaseDate,
    warrantyMonths: warrantyMonths,
    photoPath: null,
    notes: null,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

class _FakeItemsRepository implements ItemsRepository {
  _FakeItemsRepository({
    required this.item,
    this.failOnDelete = false,
    this.deleteCompleter,
  });

  final Item item;
  final bool failOnDelete;
  final Completer<int>? deleteCompleter;
  final List<String> deletedItemIds = [];

  @override
  Future<int> countItems() async => 1;

  @override
  Future<int> deleteItem(String id) async {
    deletedItemIds.add(id);
    final completer = deleteCompleter;
    if (completer != null) {
      return completer.future;
    }
    if (failOnDelete) {
      throw Exception('delete failed');
    }
    return 1;
  }

  @override
  Future<Item?> getItem(String id) async => id == item.id ? item : null;

  @override
  Stream<Item?> watchItem(String id) {
    return Stream.value(id == item.id ? item : null);
  }

  @override
  Future<void> saveItem(Item item) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Item>> watchItems() {
    return Stream.value([item]);
  }

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) {
    return Stream.value(item.category == category ? [item] : const <Item>[]);
  }
}

class _FakeMaintenancesRepository implements MaintenancesRepository {
  @override
  Future<int> deleteMaintenance(String id) async => 0;

  @override
  Future<int> deleteMaintenancesForItem(String itemId) async => 0;

  @override
  Future<Maintenance?> getMaintenance(String id) async => null;

  @override
  Future<void> markAsDone(String id, {DateTime? doneAt}) async {}

  @override
  Future<void> saveMaintenance(Maintenance maintenance) async {}

  @override
  Stream<List<Maintenance>> watchMaintenancesForItem(String itemId) {
    return Stream.value(const <Maintenance>[]);
  }

  @override
  Stream<List<Maintenance>> watchUpcomingMaintenances({int limit = 15}) {
    return Stream.value(const <Maintenance>[]);
  }

  @override
  Stream<List<Maintenance>> watchAllMaintenances() {
    return Stream.value(const <Maintenance>[]);
  }
}

class _DetailRouteTestApp extends StatelessWidget {
  const _DetailRouteTestApp();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.push('/items/item-1'),
                child: const Text('Open detail'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/items/:id',
          builder: (context, state) => Scaffold(
            body: ItemDetailScreen(itemId: state.pathParameters['id']!),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
