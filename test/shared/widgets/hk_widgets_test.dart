import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/core/theme/app_theme.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/shared/widgets/hk_button.dart';
import 'package:housekeep/shared/widgets/hk_card.dart';
import 'package:housekeep/shared/widgets/hk_category_tile.dart';
import 'package:housekeep/shared/widgets/hk_chip.dart';
import 'package:housekeep/shared/widgets/hk_fab.dart';
import 'package:housekeep/shared/widgets/hk_form_field.dart';
import 'package:housekeep/shared/widgets/hk_photo_slot.dart';
import 'package:housekeep/shared/widgets/hk_status_pill.dart';
import 'package:housekeep/shared/widgets/hk_summary_stat.dart';
import 'package:housekeep/shared/widgets/hk_tab_bar.dart';
import 'package:housekeep/shared/widgets/hk_toggle.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    locale: const Locale('es'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('HkCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(const HkCard(child: Text('hi'))));
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(HkCard(
        onTap: () => taps++,
        child: const Text('tap me'),
      )));
      await tester.tap(find.text('tap me'));
      expect(taps, 1);
    });
  });

  group('HkButton', () {
    testWidgets('renders label and fires onPressed', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(_wrap(HkButton(
        label: 'Save',
        onPressed: () => pressed++,
      )));
      expect(find.text('Save'), findsOneWidget);
      await tester.tap(find.text('Save'));
      expect(pressed, 1);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(HkButton(
        label: 'Add',
        icon: Icons.add,
        onPressed: () {},
      )));
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('HkChip', () {
    testWidgets('renders and fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(HkChip(
        label: 'All',
        onTap: () => taps++,
      )));
      await tester.tap(find.text('All'));
      expect(taps, 1);
    });
  });

  group('HkStatusPill', () {
    testWidgets('renders label per status', (tester) async {
      await tester.pumpWidget(_wrap(const HkStatusPill(
        status: HkStatus.overdue,
        label: 'OVERDUE',
      )));
      expect(find.text('OVERDUE'), findsOneWidget);
    });
  });

  group('HkCategoryTile', () {
    testWidgets('renders category icon', (tester) async {
      await tester.pumpWidget(_wrap(const HkCategoryTile(
        category: ItemCategory.kitchen,
      )));
      expect(find.byIcon(Icons.kitchen_rounded), findsOneWidget);
    });
  });

  group('HkPhotoSlot', () {
    testWidgets('renders uppercase label', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 200,
        height: 100,
        child: HkPhotoSlot(label: 'add photo'),
      )));
      expect(find.text('ADD PHOTO'), findsOneWidget);
    });
  });

  group('HkFormField', () {
    testWidgets('renders uppercase label + child', (tester) async {
      await tester.pumpWidget(_wrap(const HkFormField(
        label: 'name',
        child: TextField(),
      )));
      expect(find.text('NAME'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('HkToggle', () {
    testWidgets('tap toggles value via callback', (tester) async {
      var value = false;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => HkToggle(
          value: value,
          onChanged: (v) => setState(() => value = v),
        ),
      )));
      await tester.tap(find.byType(HkToggle));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });
  });

  group('HkTabBar', () {
    testWidgets('renders all tabs and fires onChanged', (tester) async {
      HkTab? changed;
      await tester.pumpWidget(_wrap(
        HkTabBar(
          current: HkTab.home,
          onChanged: (tab) => changed = tab,
        ),
      ));
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Artículos'), findsOneWidget);
      await tester.tap(find.text('Artículos'));
      expect(changed, HkTab.items);
    });
  });

  group('HkFab', () {
    testWidgets('renders icon and fires onPressed', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(_wrap(HkFab(
        icon: Icons.add,
        onPressed: () => pressed++,
      )));
      await tester.tap(find.byIcon(Icons.add));
      expect(pressed, 1);
    });
  });

  group('HkSummaryStat', () {
    testWidgets('renders count and label', (tester) async {
      await tester.pumpWidget(_wrap(const HkSummaryStat(
        count: 7,
        label: 'Overdue',
        tone: HkTone.danger,
      )));
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
    });
  });
}
