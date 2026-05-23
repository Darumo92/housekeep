import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/features/items/add_edit_item_screen.dart';

void main() {
  testWidgets('shows validation when name is empty and save is tapped', (
    tester,
  ) async {
    final repository = _FakeItemsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const _TestApp(home: AddEditItemScreen()),
      ),
    );

    final l10n = _l10n(tester);

    await _scrollToSaveButton(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(find.text(l10n.itemValidationName), findsOneWidget);
    expect(repository.savedItems, isEmpty);
  });

  testWidgets('shows the photo section in the form', (tester) async {
    final repository = _FakeItemsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const _TestApp(home: AddEditItemScreen()),
      ),
    );

    final l10n = _l10n(tester);

    expect(find.text(l10n.itemPhotoAdd), findsOneWidget);
  });

  testWidgets('does not show camera action on linux desktop', (tester) async {
    final repository = _FakeItemsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const _TestApp(home: AddEditItemScreen()),
      ),
    );

    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.itemPhotoAdd));
    await tester.pumpAndSettle();

    expect(find.text(l10n.itemPhotoGallery), findsOneWidget);
    expect(find.text(l10n.itemPhotoCamera), findsNothing);
  });

  testWidgets('saves a new item when the form is valid', (tester) async {
    final repository = _FakeItemsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const _PushScreenApp(),
      ),
    );

    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(_nameFieldKey), 'Fridge');
    await _scrollToSaveButton(tester);
    await tester.tap(find.text(_l10n(tester).itemSave));
    await tester.pumpAndSettle();

    expect(repository.savedItems, hasLength(1));
    expect(repository.savedItems.single.name, 'Fridge');
    expect(repository.savedItems.single.category, ItemCategory.general);
    expect(repository.savedItems.single.id, isNotEmpty);
    expect(find.byType(AddEditItemScreen), findsNothing);
    expect(find.text('Open form'), findsOneWidget);
  });

  testWidgets('keeps the form open when saving fails', (tester) async {
    final repository = _FakeItemsRepository(failOnSave: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const _PushScreenApp(),
      ),
    );

    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(_nameFieldKey), 'Fridge');
    await _scrollToSaveButton(tester);
    await tester.tap(find.text(_l10n(tester).itemSave));
    await tester.pumpAndSettle();

    expect(repository.savedItems, isEmpty);
    expect(find.byType(AddEditItemScreen), findsOneWidget);
    expect(find.text('Open form'), findsNothing);
  });

  testWidgets(
    'loads an existing item and saves updates preserving id and createdAt',
    (tester) async {
      final existingItem = Item(
        id: 'item-1',
        name: 'Old fridge',
        category: ItemCategory.kitchen,
        brand: 'Bosch',
        model: 'A1',
        purchaseDate: null,
        warrantyMonths: 12,
        photoPath: null,
        notes: 'Original note',
        createdAt: DateTime(2024, 1, 2),
        updatedAt: DateTime(2024, 1, 3),
      );
      final repository = _FakeItemsRepository(seedItems: [existingItem]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsRepositoryProvider.overrideWithValue(repository),
          ],
          child: const _PushScreenApp(editItemId: 'item-1'),
        ),
      );

      await tester.tap(find.text('Open form'));
      await tester.pumpAndSettle();

      expect(find.text('Old fridge'), findsOneWidget);
      expect(find.text('Bosch'), findsOneWidget);

      await tester.enterText(find.byKey(_nameFieldKey), 'Updated fridge');
      await tester.enterText(find.byKey(_brandFieldKey), 'LG');
      await _scrollToText(tester, find.text('12'));
      expect(find.text('12'), findsOneWidget);
      await _scrollToSaveButton(tester);
      await tester.tap(find.text(_l10n(tester).itemSave));
      await tester.pumpAndSettle();

      expect(repository.savedItems, hasLength(1));
      final savedItem = repository.savedItems.single;
      expect(savedItem.id, existingItem.id);
      expect(savedItem.createdAt, existingItem.createdAt);
      expect(savedItem.name, 'Updated fridge');
      expect(savedItem.brand, 'LG');
      expect(find.byType(AddEditItemScreen), findsNothing);
    },
  );
}

const _nameFieldKey = ValueKey('item-form-name');
const _brandFieldKey = ValueKey('item-form-brand');

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(AddEditItemScreen)));
}

Future<void> _scrollToSaveButton(WidgetTester tester) {
  return _scrollToText(tester, find.text(_l10n(tester).itemSave));
}

Future<void> _scrollToText(
  WidgetTester tester,
  Finder finder, {
  double delta = 250,
}) {
  final listFinder = find.byType(ListView);

  return TestAsyncUtils.guard(() async {
    for (var attempt = 0; attempt < 6; attempt++) {
      if (finder.evaluate().isNotEmpty) {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        return;
      }

      await tester.drag(listFinder, Offset(0, -delta));
      await tester.pumpAndSettle();
    }

    expect(finder, findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class _PushScreenApp extends StatelessWidget {
  const _PushScreenApp({this.editItemId});

  final String? editItemId;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
                child: TextButton(
                onPressed: () => context.push(
                  editItemId == null ? '/add' : '/items/$editItemId/edit',
                ),
                child: const Text('Open form'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddEditItemScreen(),
        ),
        GoRoute(
          path: '/items/:id/edit',
          builder: (context, state) =>
              AddEditItemScreen(itemId: state.pathParameters['id']),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
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

class _FakeItemsRepository implements ItemsRepository {
  _FakeItemsRepository({
    this.failOnSave = false,
    List<Item> seedItems = const [],
  }) : _items = List<Item>.from(seedItems);

  final bool failOnSave;
  final List<Item> _items;
  final List<Item> savedItems = [];

  @override
  Future<int> countItems() async => _items.length;

  @override
  Future<int> deleteItem(String id) async => 0;

  @override
  Future<Item?> getItem(String id) async {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<void> saveItem(Item item) async {
    if (failOnSave) throw Exception('save failed');

    _items.removeWhere((existingItem) => existingItem.id == item.id);
    _items.add(item);
    savedItems.add(item);
  }

  @override
  Stream<List<Item>> watchItems() {
    return Stream.value(_items);
  }

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) {
    return Stream.value(
      _items.where((item) => item.category == category).toList(),
    );
  }
}
