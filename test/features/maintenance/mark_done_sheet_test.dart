import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:housekeep/core/l10n/generated/app_localizations.dart';
import 'package:housekeep/core/theme/app_theme.dart';
import 'package:housekeep/data/repositories/maintenances_repository.dart';
import 'package:housekeep/data/repositories/repository_providers.dart';
import 'package:housekeep/data/services/notification_providers.dart';
import 'package:housekeep/data/services/notification_scheduler.dart';
import 'package:housekeep/data/services/notification_service.dart';
import 'package:housekeep/domain/enums/item_category.dart';
import 'package:housekeep/domain/models/item.dart';
import 'package:housekeep/domain/models/maintenance.dart';
import 'package:housekeep/features/maintenance/widgets/mark_done_sheet.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('renders date choices and dismisses without completing', (
    tester,
  ) async {
    final repository = _FakeMaintenancesRepository();
    await _pumpSheetHost(tester, repository: repository);
    await _openSheet(tester);
    final l10n = _l10n(tester);

    expect(find.text(l10n.maintenanceMarkDoneSheetTitle), findsOneWidget);
    expect(
      find.text(l10n.maintenanceMarkDoneWhenLabel.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.maintenanceMarkDoneToday), findsOneWidget);
    expect(find.text(l10n.maintenanceMarkDoneYesterday), findsOneWidget);
    expect(find.text(l10n.maintenanceMarkDoneOtherDate), findsOneWidget);
    expect(
      find.textContaining(
        l10n.maintenanceMarkDoneNextInMonths(12),
        findRichText: true,
      ),
      findsOneWidget,
    );

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(repository.markedDoneCalls, isEmpty);
  });

  testWidgets('confirms yesterday, reschedules, and closes after success', (
    tester,
  ) async {
    final repository = _FakeMaintenancesRepository();
    final service = _FakeNotificationService();
    final result = ValueNotifier<bool?>(null);
    await _pumpSheetHost(
      tester,
      repository: repository,
      notificationService: service,
      result: result,
    );
    await _openSheet(tester);
    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.maintenanceMarkDoneYesterday));
    await tester.tap(find.text(l10n.maintenanceMarkDoneConfirm));
    await tester.pump();
    await tester.pump();

    expect(repository.markedDoneCalls.single.id, 'maintenance-1');
    expect(repository.markedDoneCalls.single.doneAt, DateTime(2026, 5, 26));
    expect(find.text(l10n.maintenanceMarkDoneCompletedTitle), findsOneWidget);
    expect(service.cancelledPrefixes, ['hk:m:maintenance-1:']);

    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(result.value, isTrue);
    expect(find.text(l10n.maintenanceMarkDoneCompletedTitle), findsNothing);
  });

  testWidgets('allows selecting another completion date', (tester) async {
    final repository = _FakeMaintenancesRepository();
    await _pumpSheetHost(tester, repository: repository);
    await _openSheet(tester);
    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.maintenanceMarkDoneOtherDate));
    await tester.pumpAndSettle();
    await tester.tap(find.text('24').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.maintenanceMarkDoneConfirm));
    await tester.pump();
    await tester.pump();

    expect(repository.markedDoneCalls.single.doneAt, DateTime(2026, 5, 24));
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  });

  testWidgets('keeps the sheet open and shows feedback when completion fails', (
    tester,
  ) async {
    final repository = _FakeMaintenancesRepository(failOnMarkDone: true);
    await _pumpSheetHost(tester, repository: repository);
    await _openSheet(tester);
    final l10n = _l10n(tester);

    await tester.tap(find.text(l10n.maintenanceMarkDoneConfirm));
    await tester.pumpAndSettle();

    expect(find.text(l10n.maintenanceMarkDoneSheetTitle), findsOneWidget);
    expect(find.text(l10n.maintenanceMarkDoneFailed), findsOneWidget);
  });
}

final _now = DateTime(2026, 5, 27);

Future<void> _pumpSheetHost(
  WidgetTester tester, {
  required _FakeMaintenancesRepository repository,
  _FakeNotificationService? notificationService,
  ValueNotifier<bool?>? result,
}) async {
  final service = notificationService ?? _FakeNotificationService();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        maintenancesRepositoryProvider.overrideWithValue(repository),
        notificationSchedulerProvider.overrideWithValue(
          NotificationScheduler(service: service, now: () => _now),
        ),
        isProProvider.overrideWith((ref) => Stream.value(false)),
      ],
      child: _TestApp(
        home: _SheetHost(result: result ?? ValueNotifier<bool?>(null)),
      ),
    ),
  );
}

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('open-sheet')));
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(_SheetHost)));
}

class _SheetHost extends StatelessWidget {
  const _SheetHost({required this.result});

  final ValueNotifier<bool?> result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        key: const ValueKey('open-sheet'),
        onPressed: () async {
          result.value = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (_) => MarkDoneSheet(
              maintenance: _maintenance(),
              item: _item(),
              now: () => _now,
            ),
          );
        },
        child: const Text('Open'),
      ),
    );
  }
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

class _MarkDoneCall {
  const _MarkDoneCall({required this.id, required this.doneAt});

  final String id;
  final DateTime? doneAt;
}

class _FakeMaintenancesRepository implements MaintenancesRepository {
  _FakeMaintenancesRepository({this.failOnMarkDone = false});

  final bool failOnMarkDone;
  final List<_MarkDoneCall> markedDoneCalls = [];
  Maintenance? _updated;

  @override
  Future<void> markAsDone(String id, {DateTime? doneAt}) async {
    markedDoneCalls.add(_MarkDoneCall(id: id, doneAt: doneAt));
    if (failOnMarkDone) throw Exception('completion failed');
    _updated = _maintenance(
      lastDoneAt: doneAt,
      nextDueAt: DateTime(2027, doneAt!.month, doneAt.day),
    );
  }

  @override
  Future<Maintenance?> getMaintenance(String id) async => _updated;

  @override
  Future<int> deleteMaintenance(String id) async => 0;

  @override
  Future<int> deleteMaintenancesForItem(String itemId) async => 0;

  @override
  Future<void> saveMaintenance(Maintenance maintenance) async {}

  @override
  Stream<List<Maintenance>> watchAllMaintenances() =>
      Stream.value(const <Maintenance>[]);

  @override
  Stream<List<Maintenance>> watchMaintenancesForItem(String itemId) =>
      Stream.value(const <Maintenance>[]);

  @override
  Stream<List<Maintenance>> watchUpcomingMaintenances({int limit = 15}) =>
      Stream.value(const <Maintenance>[]);
}

class _FakeNotificationService extends NotificationService {
  final List<String> cancelledPrefixes = [];

  @override
  Future<void> cancelByPayloadPrefix(String prefix) async {
    cancelledPrefixes.add(prefix);
  }

  @override
  Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    return true;
  }
}

Maintenance _maintenance({DateTime? lastDoneAt, DateTime? nextDueAt}) {
  return Maintenance(
    id: 'maintenance-1',
    itemId: 'item-1',
    name: 'Annual service',
    description: null,
    intervalMonths: 12,
    lastDoneAt: lastDoneAt,
    nextDueAt: nextDueAt ?? DateTime(2026, 6, 20),
    notifyDaysBefore: 7,
    isFromTemplate: false,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

Item _item() {
  return Item(
    id: 'item-1',
    name: 'Boiler',
    category: ItemCategory.plumbing,
    brand: null,
    model: null,
    purchaseDate: null,
    warrantyMonths: null,
    photoPath: null,
    notes: null,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}
