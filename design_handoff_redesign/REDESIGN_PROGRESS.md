# Redesign Progress

Snapshot of redesign work executed so far. Spec lives in `design_handoff_redesign/`. Visual direction: **Cozy** (per `PHASES.md`).

## Completed phases

### Phase 1 — Tokens & theme

- `lib/core/theme/app_colors.dart` rewritten with Cozy palette (`bg=#F6F1E9`, `primary=#2E7D6F`, `accent=#E0913A`, semantic `ok/warn/danger` + `*Soft` variants, `text/textMuted/textFaint`, `placeholderStripe`). Retro-compat aliases preserved (`background, success, warning, error, textPrimary, textSecondary, textTertiary, secondary, primaryLight, primaryDark, surfaceVariant, outline, shadow`) so legacy widgets compile.
- `lib/core/theme/app_radii.dart` (new) — `card=20, btn=14, chip=999, tile=14, sheet=28`.
- `lib/core/theme/app_shadows.dart` (new) — `card` (soft primary-tinted), `fab` (stronger).
- `lib/core/theme/app_typography.dart` rewritten — Inter via `google_fonts`, full Material 3 scale per spec, plus `mono()` helper using JetBrains Mono.
- `lib/core/theme/app_theme.dart` rewritten — Material 3 ThemeData with explicit `ColorScheme` (no `fromSeed`), themed cards/buttons/inputs/appBar/bottomSheet/divider/icon/FAB/navigationBar/snackBar/dialog tuned to new tokens. Inputs 1px `border` + radius 14, cards radius 20, scaffold bg = `AppColors.bg`.
- `pubspec.yaml` — added `google_fonts: ^6.2.1`.
- `app_dimens.dart` (`Spacing`, `Radii`) intentionally kept for legacy widgets.
- Dark theme is a placeholder returning `light()`.

### Phase 2 — Shared widgets (`lib/shared/widgets/hk_*.dart`)

All 11 components built and unit-tested. None hardcode `Color(0xFF…)` — all read from `AppColors` (category palette extracted to `core/theme/app_category_palette.dart`).

| Widget | File | Notes |
|--------|------|-------|
| `HkCard` | `hk_card.dart` | Soft-shadow card + optional `onTap` via Material/InkWell. |
| `HkButton` | `hk_button.dart` | 5 variants (`primary/accent/soft/outline/ghost`) × 3 sizes. `icon`, `full`, nullable `onPressed`. |
| `HkChip` | `hk_chip.dart` | Filter chip with 5 tones. Inverts bg/fg when `active`. |
| `HkStatusPill` | `hk_status_pill.dart` | Pill with colored dot (overdue/due/soon/ok). |
| `HkCategoryTile` | `hk_category_tile.dart` | Rounded square tile per `ItemCategory`, sizes 44–60. Palette in `AppCategoryPalette`. |
| `HkPhotoSlot` | `hk_photo_slot.dart` | Placeholder with diagonal stripes (`CustomPaint`) + JetBrains Mono uppercase label. |
| `HkFormField` | `hk_form_field.dart` | Uppercase eyebrow label + child input. |
| `HkToggle` | `hk_toggle.dart` | Custom 44×26 switch with `AnimatedPositioned` (200 ms). |
| `HkTabBar` | `hk_tab_bar.dart` | Custom bottom nav with `primarySoft` pill behind active icon. Reads labels from `AppLocalizations`. |
| `HkFab` | `hk_fab.dart` | Rounded-square accent FAB (56×56, accent bg, `AppShadows.fab`). `onPressed` nullable for gating. |
| `HkSummaryStat` | `hk_summary_stat.dart` | Dot + number + label card for home stats. |

Tests: `test/shared/widgets/hk_widgets_test.dart` — 13 widget tests (render + tap callback per component). `GoogleFonts.config.allowRuntimeFetching = false` in `setUpAll`.

### Phase 3 — Onboarding (`lib/features/onboarding/`)

- `widgets/onboarding_art.dart` (new) — 3 abstract compositions inside 280×280: `OnboardingArtHomeCluster` (teal tile + 4 rotated mini-tiles), `OnboardingArtBellStack` (3 fake notification cards with fading opacity + accent bell hero), `OnboardingArtSparkleItem` (mock HkCard + sparkle accent).
- `onboarding_screen.dart` rewritten — 3-page PageView, animated dots (6 ↔ 24 width, 250 ms), Skip on pages 0+1, back button on 1+2, primary CTA via `HkButton` (Next → `arrow_forward`, last → `auto_awesome` + "Empezar"). Home type picker dropped per spec; provider untouched (`complete()` called without `homeType`). Completion overlay preserved.
- ARB ES+EN: `onboardingPage1/2/3Title/Body` updated to spec copy.

### Phase 4 — Home dashboard (`lib/features/home/`)

- `lib/features/home/widgets/home_redesign_widgets.dart` (new) — bundles `GreetingHeader`, `SummaryTriplet`, `TimelineSectionHeader`, `TimelineRow`, `ProUpsellCard`, `HomeEmptyState`, plus `shortDayLabel()` helper.
- `home_screen.dart` rewritten — ListView body with greeting + summary triplet (due/soon/ok counts derived from upcoming events vs total maintenances+documents) + timeline header + timeline rows + Pro upsell card (hidden when `isPro`). `HkFab` ámbar routes to `/items/add`. `RefreshIndicator` invalidates `home*Provider`s. Empty-state branch wires `HomeEmptyState`.
- `UpcomingEvent` extended with optional `ItemCategory category` (additive); populated in `home_provider.dart` for maintenance + warranty events.
- ARB ES+EN: `homeGreetingMorning/Afternoon/Evening, homeSubtitle, homeSummaryDue/Soon/Ok, homeSeeAll, homeProUpsellTitle/Sub/Cta, homeShortDayToday/Tomorrow/InDays/Yesterday/AgoDays, homeFallbackName`. `homeEmptyTitle/Body/Cta` updated to spec copy.
- `_AppShell` rewritten — drops material `AppBar` + `NavigationBar`, swaps in `HkTabBar`. Each screen now owns its own header.
- `test/app_smoke_test.dart` adapted (`NavigationBar → HkTabBar`, locale-override expectation aligned with new greeting fallback).

### Phase 5 — Items (`lib/features/items/`)

- `items_list_screen.dart` rewritten — H1 "Mis cosas" + Free/Pro counter (JetBrains Mono for free `n/5`), horizontal `HkChip` filter row (All + 6 categories), `HkCard` rows with `HkCategoryTile(60)` + brand/model + warranty status pill + chevron, empty state (`HkCard` centered, primary-soft circle icon, CTA), filtered-empty state, skeleton on load. `HkFab` nullable-onPressed gating during navigation.
- `item_detail_screen.dart` rewritten — hero photo 220 px full bleed (Image.file or `HkPhotoSlot`), back/more circular buttons with backdrop blur, `HkCategoryTile(64)` Hero overlap (-22 px) bottom-left, title block, warranty `HkCard` with mono dates + status pill + 6 px progress bar, maintenances section (`HkCard` rows with calendar icon + name + interval + `HkStatusPill` + soft `HkButton` "Marcar como hecho"), edit/delete `HkButton` row.
- `add_edit_item_screen.dart` rewritten — custom header, photo block (`HkPhotoSlot` 86×86 + outline Camera/Gallery `HkButton`s), `HkFormField` wrappers for Name/Brand/Category/Date/Warranty/Notes, custom category chip picker with icon, 2-column purchase-date + warranty-months grid (mono numeric input), notes textarea, sticky save bar with gradient fade + Cancel/Save `HkButton`s. Data layer untouched (`saveItemProvider`, `photoServiceProvider`, notification reschedule).
- ARB ES+EN: `itemsTitle="Mis cosas/My things"`, `itemsEmpty*` updated, `itemsCount, itemsCountFree, itemsWarrantyActive, itemDetailWarranty, itemDetailPurchasedOn, itemDetailUntil, itemDetailHistory, itemDetailMonthsWarranty, addFieldPurchased, addSave, addCancel, addPhotoCamera, addPhotoGallery`.
- Tests adapted: `items_list_screen_test.dart` (`FloatingActionButton → HkFab`, `ChoiceChip → HkChip`, `Card → HkCard`, item-card ValueKey), `item_detail_screen_test.dart` (`OutlinedButton → HkButton` finder, warranty-active expectation), `add_edit_item_screen_test.dart` (FilledButton → addSave, brand expectation merged "Bosch A1"). 114/114 tests pass.

## Verification

- `flutter analyze` clean (1 preexisting `prefer_const_constructors` info in `test/app_smoke_test.dart:127`).
- `flutter test` — 114 tests pass.
- `flutter build apk --debug` succeeds.
- Manual emulator runs: Cozy palette applied, onboarding redesign renders (home-cluster + bell-stack + sparkle pages), home empty state renders with `HkTabBar` + `HkFab`, items list "Mis cosas" + chip filter + empty card render correctly.

## Known issue (open)

- **Items add/edit form save bar overlap.** Last fix changed `Align(bottomCenter)` to `Positioned(left:0,right:0,bottom:0)` because the gradient `Container` lacked height constraints and stretched the Save button to full vertical. Build is clean but pending visual re-test on emulator.

## Remaining phases

| Phase | Spec file | Scope |
|------|-----------|-------|
| 6 | `phases/phase_6_documents.md` | Documents list redesign. |
| 7 | `phases/phase_7_maintenance_done.md` | Mark-done bottom sheet (new) + integration in item detail. |
| 8 | `phases/phase_8_paywall.md` | Paywall screen redesign. |
| 9 | `phases/phase_9_settings.md` | Settings screen redesign. |

## Files touched

```
lib/app.dart                                       (M — shell uses HkTabBar)
lib/core/l10n/app_en.arb                           (M — onboarding/home/items strings)
lib/core/l10n/app_es.arb                           (M — onboarding/home/items strings)
lib/core/l10n/generated/*.dart                     (M — flutter gen-l10n output)
lib/core/theme/app_colors.dart                     (M — Cozy palette + aliases)
lib/core/theme/app_theme.dart                      (M — Cozy ThemeData)
lib/core/theme/app_typography.dart                 (M — Inter via google_fonts)
lib/core/theme/app_category_palette.dart           (NEW)
lib/core/theme/app_radii.dart                      (NEW)
lib/core/theme/app_shadows.dart                    (NEW)
lib/domain/models/upcoming_event.dart              (M — category field)
lib/features/home/home_provider.dart               (M — populate category)
lib/features/home/home_screen.dart                 (M — rewritten Phase 4)
lib/features/home/widgets/home_redesign_widgets.dart (NEW)
lib/features/items/add_edit_item_screen.dart       (M — rewritten Phase 5)
lib/features/items/item_detail_screen.dart         (M — rewritten Phase 5)
lib/features/items/items_list_screen.dart          (M — rewritten Phase 5)
lib/features/onboarding/onboarding_screen.dart     (M — rewritten Phase 3)
lib/features/onboarding/widgets/onboarding_art.dart (NEW)
lib/shared/widgets/hk_*.dart                       (NEW × 11)
pubspec.yaml + pubspec.lock                        (M — google_fonts)
test/app_smoke_test.dart                           (M — adapted for HkTabBar + greeting)
test/features/items/*.dart                         (M — adapted for Hk* widgets)
test/shared/widgets/hk_widgets_test.dart           (NEW)
```
