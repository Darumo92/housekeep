# Redesign Phase 7 Mark-Done Sheet Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the immediate maintenance completion action in item detail with the Cozy mark-done bottom sheet from `design_handoff_redesign/phases/phase_7_maintenance_done.md`.

**Architecture:** Add a focused `MarkDoneSheet` under the maintenance feature that owns completion-date selection, persistence through the existing repository, notification rescheduling, and transient success UI. `ItemDetailScreen` remains responsible only for opening the sheet for its item and reacting to its result; existing Drift models and DAOs remain unchanged.

**Tech Stack:** Flutter/Dart, flutter_riverpod, Drift repositories, Material 3, generated ARB localization, `flutter_test`.

---

## Scope Decision

The phase handoff includes optional completion notes, but the existing `Maintenance` contract stores only the recurring task `description`, `lastDoneAt`, and `nextDueAt`. A completion-note field would require a data-model and persistence migration, while `design_handoff_redesign/PHASES.md` explicitly prohibits changing the data layer during redesign phases. This implementation omits the notes control and records the deferred requirement in redesign progress; it does not silently discard text or overwrite the task description.

## File Structure Map

- Create `lib/features/maintenance/widgets/mark_done_sheet.dart`: sheet presentation, selected date, confirm workflow, success/error states, and notification rescheduling.
- Modify `lib/features/items/item_detail_screen.dart`: pass the current `Item` into the maintenance section and launch `MarkDoneSheet` instead of immediately completing a task.
- Modify `lib/core/l10n/app_en.arb` and `lib/core/l10n/app_es.arb`: add bottom-sheet strings and accessible labels.
- Generate `lib/core/l10n/generated/app_localizations*.dart`: generated API for new ARB strings.
- Create `test/features/maintenance/mark_done_sheet_test.dart`: selector, cancellation, completion date, success and failure behavior.
- Modify `test/features/items/item_detail_screen_test.dart`: verify the detail CTA opens the sheet without immediately mutating maintenance data.
- Modify `design_handoff_redesign/REDESIGN_PROGRESS.md`: mark Phase 7 delivered and state that completion notes remain deferred pending a persistence model.

### Task 1: Add Localized Sheet Contract And Widget Tests

**Files:**
- Modify: `lib/core/l10n/app_en.arb`
- Modify: `lib/core/l10n/app_es.arb`
- Generate: `lib/core/l10n/generated/app_localizations.dart`
- Generate: `lib/core/l10n/generated/app_localizations_en.dart`
- Generate: `lib/core/l10n/generated/app_localizations_es.dart`
- Create: `test/features/maintenance/mark_done_sheet_test.dart`

- [x] **Step 1: Write failing presentation and cancellation tests**

Create widget tests that pump a localized `MaterialApp` around `MarkDoneSheet` with a fake maintenance repository and a fixed `now: () => DateTime(2026, 5, 27)`. Assert the form renders localized title/date options/banner and that dismissing it without tapping confirm leaves `markedDoneCalls` empty:

```dart
expect(find.text(l10n.maintenanceMarkDoneSheetTitle), findsOneWidget);
expect(find.text(l10n.maintenanceMarkDoneToday), findsOneWidget);
expect(find.text(l10n.maintenanceMarkDoneYesterday), findsOneWidget);
expect(repository.markedDoneCalls, isEmpty);
```

- [x] **Step 2: Run the focused test to establish RED**

Run:

```bash
flutter test test/features/maintenance/mark_done_sheet_test.dart
```

Expected: FAIL because `mark_done_sheet.dart` and the localization accessors do not exist.

- [x] **Step 3: Add ARB keys and generate localization output**

Add the following API in both ARB files, translated to Spanish in `app_es.arb`:

```json
"maintenanceMarkDoneSheetTitle": "Mark as done",
"maintenanceMarkDoneWhenLabel": "When did you do it?",
"maintenanceMarkDoneToday": "Today",
"maintenanceMarkDoneYesterday": "Yesterday",
"maintenanceMarkDoneOtherDate": "Other date",
"maintenanceMarkDoneNextReminder": "Next reminder",
"maintenanceMarkDoneNextInMonths": "in {count, plural, one {{count} month} other {{count} months}}",
"maintenanceMarkDoneConfirm": "Confirm",
"maintenanceMarkDoneCompletedTitle": "Done!",
"maintenanceMarkDoneCompletedSubtitle": "Next reminder in {days, plural, one {{days} day} other {{days} days}}"
```

Run:

```bash
flutter gen-l10n
```

Expected: generated localization classes expose the new `maintenanceMarkDone*` getters/methods.

### Task 2: Implement The Bottom Sheet With Existing Persistence Contracts

**Files:**
- Create: `lib/features/maintenance/widgets/mark_done_sheet.dart`
- Test: `test/features/maintenance/mark_done_sheet_test.dart`

- [x] **Step 1: Extend failing tests for date selection and confirmation**

Add tests that select Yesterday and Other date, tap Confirm, and assert the existing repository API receives the chosen date:

```dart
expect(repository.markedDoneCalls.single.doneAt, DateTime(2026, 5, 26));
expect(repository.markedDoneCalls.single.id, maintenance.id);
```

Add a success-state assertion after confirmation:

```dart
expect(find.text(l10n.maintenanceMarkDoneCompletedTitle), findsOneWidget);
await tester.pump(const Duration(milliseconds: 1200));
expect(completionResult, isTrue);
```

Add a failing-repository test asserting the form stays visible and an error `SnackBar` is presented.

- [x] **Step 2: Run tests and confirm RED**

Run:

```bash
flutter test test/features/maintenance/mark_done_sheet_test.dart
```

Expected: FAIL because the sheet does not yet implement completion/date/error behavior.

- [x] **Step 3: Implement `MarkDoneSheet`**

Create a `ConsumerStatefulWidget` receiving `Maintenance maintenance`, `Item item`, and an optional `DateTime Function() now` test clock. Its state uses:

```dart
enum MarkDoneWhen { today, yesterday, other }

MarkDoneWhen _when = MarkDoneWhen.today;
DateTime? _otherDate;
bool _isSubmitting = false;
bool _isComplete = false;
```

Render a Cozy Material bottom-sheet surface with drag handle, localized segmented date actions, a `primarySoft` next-reminder banner based on `maintenance.intervalMonths`, and a full-width `HkButton` confirmation CTA. For Other date, call `showDatePicker` and retain the selection only after a date is chosen.

Implement confirmation through existing contracts only:

```dart
final completedAt = switch (_when) {
  MarkDoneWhen.today => _dateOnly(widget.now()),
  MarkDoneWhen.yesterday =>
    _dateOnly(widget.now()).subtract(const Duration(days: 1)),
  MarkDoneWhen.other => _otherDate ?? _dateOnly(widget.now()),
};
await ref.read(maintenancesRepositoryProvider).markAsDone(
  widget.maintenance.id,
  doneAt: completedAt,
);
final updated = await ref
    .read(maintenancesRepositoryProvider)
    .getMaintenance(widget.maintenance.id);
if (updated != null) {
  final isPro = await ref.read(isProProvider.future);
  await ref.read(notificationSchedulerProvider).rescheduleMaintenance(
    maintenance: updated,
    item: widget.item,
    isPro: isPro,
    texts: NotificationTexts.fromL10n(AppLocalizations.of(context)),
  );
}
```

Call `AppHaptics.destructive()` when the user confirms, show a scale/fade success state after successful persistence, and `Navigator.pop(context, true)` after 1200 ms. On error, reset `_isSubmitting`, call `AppHaptics.error()`, and show `maintenanceMarkDoneFailed` without closing the sheet.

- [x] **Step 4: Run the sheet tests to confirm GREEN**

Run:

```bash
flutter test test/features/maintenance/mark_done_sheet_test.dart
```

Expected: PASS.

### Task 3: Integrate The Sheet In Item Detail

**Files:**
- Modify: `lib/features/items/item_detail_screen.dart`
- Modify: `test/features/items/item_detail_screen_test.dart`

- [x] **Step 1: Write the failing integration test**

Provide one maintenance through `_FakeMaintenancesRepository`, tap the `HkButton` labelled `maintenanceMarkDone`, and verify the sheet title is shown while the repository has not yet received a completion:

```dart
await tester.tap(find.widgetWithText(HkButton, l10n.maintenanceMarkDone));
await tester.pumpAndSettle();
expect(find.text(l10n.maintenanceMarkDoneSheetTitle), findsOneWidget);
expect(maintenanceRepository.markedDoneCalls, isEmpty);
```

- [x] **Step 2: Run the item detail test to verify RED**

Run:

```bash
flutter test test/features/items/item_detail_screen_test.dart
```

Expected: FAIL because tapping the button still completes immediately and does not open the new sheet.

- [x] **Step 3: Wire the new sheet into `_MaintenancesList`**

Import `../maintenance/widgets/mark_done_sheet.dart`, change `_MaintenancesList` to receive the current `Item`, and replace its immediate repository workflow with:

```dart
await showModalBottomSheet<bool>(
  context: context,
  isScrollControlled: true,
  backgroundColor: AppColors.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
  ),
  builder: (_) => MarkDoneSheet(maintenance: maintenance, item: item),
);
```

Remove the now-unused notification and repository imports/workflow from `item_detail_screen.dart`; Drift stream updates after sheet persistence refresh the visible maintenance row.

- [x] **Step 4: Run both feature test files to confirm GREEN**

Run:

```bash
flutter test test/features/maintenance/mark_done_sheet_test.dart test/features/items/item_detail_screen_test.dart
```

Expected: PASS.

### Task 4: Document Scope And Verify The Phase

**Files:**
- Modify: `design_handoff_redesign/REDESIGN_PROGRESS.md`

- [x] **Step 1: Record delivered phase and constrained deferral**

Move Phase 7 into completed phases and state that the sheet implements date selection, computed next reminder, completion feedback, and rescheduling. Record completion notes as deferred because no per-completion notes/history persistence exists and this redesign phase does not migrate data.

- [x] **Step 2: Format and run complete verification**

Run:

```bash
dart format lib/features/maintenance/widgets/mark_done_sheet.dart lib/features/items/item_detail_screen.dart test/features/maintenance/mark_done_sheet_test.dart test/features/items/item_detail_screen_test.dart
flutter analyze
flutter test
```

Expected: formatter succeeds, analyzer reports no issues, and all tests pass.

- [x] **Step 3: Review requirements against the handoff**

Confirm in the diff that the drag handle, date selector/date picker, localized next-reminder banner, success animation/auto-close, persistence, haptic confirmation, notification rescheduling, dismiss-without-write behavior, and progress note are present. Confirm there are no changes to Drift schema, repositories, or generated Riverpod providers.
