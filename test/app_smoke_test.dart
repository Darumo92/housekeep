import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:housekeep/app.dart';
import 'package:housekeep/features/documents/documents_list_screen.dart';
import 'package:housekeep/features/home/home_screen.dart';
import 'package:housekeep/features/items/items_list_screen.dart';
import 'package:housekeep/features/settings/settings_screen.dart';

void main() {
  test('maps nested paths to the correct shell destination', () {
    expect(resolveShellDestination('/').index, 0);
    expect(resolveShellDestination('/items').index, 1);
    expect(resolveShellDestination('/items/add').index, 1);
    expect(resolveShellDestination('/documents').index, 2);
    expect(resolveShellDestination('/documents/123/edit').index, 2);
    expect(resolveShellDestination('/settings').index, 3);
    expect(resolveShellDestination('/settings/profile').index, 3);
  });

  testWidgets('shows the home screen shell on launch', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HouseKeepApp()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ItemsListScreen), findsNothing);
    expect(find.byType(DocumentsListScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.text('HouseKeep'), findsOneWidget);
    expect(find.text('Your home at a glance'), findsOneWidget);
  });

  testWidgets('switches between the four shell tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HouseKeepApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.kitchen_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(ItemsListScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.widgetWithText(AppBar, 'Items'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.description_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(DocumentsListScreen), findsOneWidget);
    expect(find.byType(ItemsListScreen), findsNothing);
    expect(find.widgetWithText(AppBar, 'Documents'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(DocumentsListScreen), findsNothing);
    expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.text('Your home at a glance'), findsOneWidget);
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
