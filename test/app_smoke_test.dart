import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:housekeep/app.dart';
import 'package:housekeep/data/repositories/items_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/features/documents/documents_list_screen.dart';
import 'package:housekeep/features/home/home_screen.dart';
import 'package:housekeep/features/items/add_edit_item_screen.dart';
import 'package:housekeep/features/items/item_detail_screen.dart';
import 'package:housekeep/features/items/items_list_screen.dart';
import 'package:housekeep/features/paywall/paywall_screen.dart';
import 'package:housekeep/features/settings/settings_screen.dart';

void main() {
  final fakeItemsRepository = _FakeItemsRepository(
    items: [_testItem],
    itemsById: {_testItem.id: _testItem},
  );

  test('maps nested paths to the correct shell destination', () {
    expect(resolveShellDestination('/').index, 0);
    expect(resolveShellDestination('/items').index, 1);
    expect(resolveShellDestination('/items/add').index, 1);
    expect(resolveShellDestination('/documents').index, 2);
    expect(resolveShellDestination('/documents/123/edit').index, 2);
    expect(resolveShellDestination('/settings').index, 3);
    expect(resolveShellDestination('/settings/profile').index, 3);
  });

  test('maps item detail and paywall paths to the correct shell destination', () {
    expect(resolveShellDestination('/items/abc').index, 1);
    expect(resolveShellDestination('/items/abc/edit').index, 1);
    expect(resolveShellDestination('/paywall').index, 0);
  });

  testWidgets('renders the paywall route outside the shell', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HouseKeepApp(initialLocation: '/paywall')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(AppBar), findsNothing);
  });

  testWidgets('supports the item add route inside the shell', (tester) async {
    await tester.pumpWidget(
      _buildApp(
        initialLocation: '/items/add',
        overrides: [
          itemsRepositoryProvider.overrideWithValue(fakeItemsRepository),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AddEditItemScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
  });

  testWidgets('supports the item detail route inside the shell', (tester) async {
    await tester.pumpWidget(
      _buildApp(
        initialLocation: '/items/abc',
        overrides: [
          itemsRepositoryProvider.overrideWithValue(fakeItemsRepository),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ItemDetailScreen), findsOneWidget);
    expect(find.text(_testItem.name), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
  });

  testWidgets('supports the item edit route inside the shell', (tester) async {
    await tester.pumpWidget(
      _buildApp(
        initialLocation: '/items/abc/edit',
        overrides: [
          itemsRepositoryProvider.overrideWithValue(fakeItemsRepository),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AddEditItemScreen), findsOneWidget);
    expect(find.text(_testItem.name), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
  });

  testWidgets('shows the home screen shell on launch', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HouseKeepApp()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ItemsListScreen), findsNothing);
    expect(find.byType(DocumentsListScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 0);
  });

  testWidgets('switches between the four shell tabs', (tester) async {
    await tester.pumpWidget(
      _buildApp(
        overrides: [
          itemsRepositoryProvider.overrideWithValue(fakeItemsRepository),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.kitchen_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(ItemsListScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);

    await tester.tap(find.byIcon(Icons.description_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(DocumentsListScreen), findsOneWidget);
    expect(find.byType(ItemsListScreen), findsNothing);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 2);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(DocumentsListScreen), findsNothing);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 3);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 0);
  });

  testWidgets('supports a Spanish locale override', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HouseKeepApp(localeOverride: Locale('es'))),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Tu casa de un vistazo'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
  });
}

Widget _buildApp({
  String initialLocation = '/',
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: HouseKeepApp(initialLocation: initialLocation),
  );
}

final _testItem = Item(
  id: 'abc',
  name: 'Test fridge',
  category: ItemCategory.kitchen,
  brand: null,
  model: null,
  purchaseDate: null,
  warrantyMonths: null,
  photoPath: null,
  notes: null,
  createdAt: _testTimestamp,
  updatedAt: _testTimestamp,
);

final _testTimestamp = DateTime(2024, 1, 1);

class _FakeItemsRepository implements ItemsRepository {
  const _FakeItemsRepository({
    required this.items,
    required this.itemsById,
  });

  final List<Item> items;
  final Map<String, Item> itemsById;

  @override
  Future<int> countItems() async => items.length;

  @override
  Future<int> deleteItem(String id) async => 1;

  @override
  Future<Item?> getItem(String id) async => itemsById[id];

  @override
  Future<void> saveItem(Item item) async {}

  @override
  Stream<List<Item>> watchItems() => Stream.value(items);

  @override
  Stream<List<Item>> watchItemsByCategory(ItemCategory category) {
    return Stream.value(
      items.where((item) => item.category == category).toList(growable: false),
    );
  }
}
