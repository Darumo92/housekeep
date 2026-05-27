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

### Phase 6 — Documents (`lib/features/documents/`)

- `documents_list_screen.dart` rewritten — H1 + Free/Pro counter, red overflow state over the free limit, `HkFab`, first-use `HkCard` empty state, and three chronological sections (expired / expiring soon / current). The screen now consumes an unfiltered `documentsProvider` stream so grouping always covers all saved documents.
- `widgets/document_card.dart` rewritten — Cozy `HkCard` row with document icon tile, ISO expiry date in JetBrains Mono, compact `HkStatusPill`, tap-to-edit navigation, and retained edit/delete menu.
- `add_edit_document_screen.dart` rewritten — custom header, scan/gallery photo block, `HkFormField` inputs, icon pills for the existing `DocumentType` values, ISO expiry picker, reminder chips, notes and sticky save bar. CRUD, photo replacement and notification rescheduling remain wired to the existing providers/services.
- Reminder UI follows the current data contract: Free stores one configurable `notifyDaysBefore`; Pro displays and uses the scheduler's existing fixed `90/30/7` reminders. Configurable multi-select reminders would require a data-model migration.
- Image attachment continues to use the existing `photoPath`/`PhotoService` contract (camera and image gallery). PDF attachment is not implemented because no persisted file/PDF service exists.
- ARB ES+EN updated for document headings, counts, section labels, form hints/actions and reminder explanations; generated localization files regenerated.
- Tests added: `documents_list_screen_test.dart` and `add_edit_document_screen_test.dart` cover grouping/order, card navigation, Free gate, redesigned form validation and edit persistence.

### Phase 7 — Mark-done sheet (`lib/features/maintenance/widgets/`)

- `mark_done_sheet.dart` (new) — Cozy modal launched from an item maintenance row, with drag handle, Hoy/Ayer/Otra fecha completion selector, localized next-reminder banner, haptic confirmation, animated success state and automatic close.
- `item_detail_screen.dart` now opens the sheet instead of completing maintenance immediately; successful confirmation persists through the existing repository and reprograms notifications through `NotificationScheduler`.
- Completion notes are intentionally deferred: the existing domain/Drift contract has no per-completion note or history entity, and this redesign phase does not introduce data migrations.
- ARB ES+EN updated for the modal and the touched item-detail labels (`Marcar como hecho`, warranty/photo/interval/status copy); generated localization output regenerated.
- Tests added: `mark_done_sheet_test.dart` covers cancellation, selected completion dates, rescheduling, success auto-close and errors; `item_detail_screen_test.dart` covers opening the sheet without an immediate write and Spanish redesign copy.

### Phase 8 — Paywall (`lib/features/paywall/`)

- `paywall_screen.dart` rewritten — `Scaffold(bg)` + `AnnotatedRegion<SystemUiOverlayStyle>` for white status-bar icons over the hero band. Layout: scrollable hero (gradient `primary→primary→accent`) + benefits list + sticky CTA bar. `Wrap` for the price row so price+sub keep working at 2× text scale.
- New constructor param `gate` (bool, default `false`). `/paywall` route in `lib/app.dart` reads `state.uri.queryParameters['gate']` to populate it. Banner with lock icon, gate title and copy renders only when `gate=true`.
- Hero band: white circular back button (`Colors.white.withValues(alpha:.18)`), `PRO` chip, H1 32 w600 Inter `paywallHeroTitle`, subtitle 15 white .85, price 44 w600 with `· pago único` sub. Price uses `offering?.primaryPackage?.priceString` from RevenueCat with `€5,99` placeholder fallback.
- Benefits list: 5 rows (Inventory/Notifications/AutoAwesome/Share/Florist) over `primarySoft` 36×36 tiles + check icon in `ok` green.
- Sticky CTA bar: `HkButton(primary, lg, full)` `paywallUnlockCta`; loading state swaps in a teal-bg `CircularProgressIndicator`. Below: `Flexible` Restore / Skip text buttons in `textMuted` so they don't overflow at large text scale.
- Purchase flow keeps `PurchaseControllerProvider`: tap → `HapticFeedback.lightImpact()` → `buy(package)` → state machine drives success view (`_SuccessView` redesigned with primarySoft check medallion + `HkButton`). Cancelled → existing SnackBar; new error path also surfaces SnackBar with `paywallPurchaseError` fallback. Offering errors render an `AppColors.dangerSoft` notice inside the scroll.
- Gate routing: `items_provider.dart`, `documents_provider.dart`, `add_edit_document_screen.dart` reminder upsell, and `template_picker_sheet.dart` locked tap all switched to `/paywall?gate=true`. Home `ProUpsellCard` and Settings entries keep the gate-less `/paywall`.
- ARB ES+EN: `paywallHeroTitle, paywallSubtitle, paywallOnce, paywallUnlockCta, paywallSkip, paywallGateTitle, paywallGateSub, paywallBenefitUnlimited, paywallBenefitMultiReminder, paywallBenefitWidget, paywallBenefitPdf, paywallBenefitTemplates, paywallPurchaseError`. Legacy strings (tagline, feature list, comparison table values) preserved for back-compat but no longer rendered.
- Tests updated: `items_list_screen_test.dart`, `items_provider_test.dart`, `documents_provider_test.dart` switched to new gate URL + `paywallHeroTitle` matcher.

### Phase 9 — Settings (`lib/features/settings/`)

- `settings_screen.dart` rewritten as Cozy: H1 `Ajustes`, plan card (Free `HkCard` with accent `HkButton` to `/paywall` / Pro gradient card with white "Activo" chip), then `HkCard(padding:0)` groups containing `_SettingsRow` rows separated by indented dividers (`AppColors.border`).
- Sections preserved: AVISOS (toggle + system permissions row + denied-permission banner using existing `StatusBanner` + soft `HkButton` "Abrir ajustes"), PREFERENCIAS (Idioma with inline `_LanguagePillSwitcher` SYS/ES/EN backed by `LocalePreference`), PRO (`Widget`, `Export PDF`, `Restaurar compras`, BETA Pro override toggle when `AppConstants.betaShowProToggle`), INFORMACIÓN (Version with mono trailing, Contact + Feedback `mailto:`, Privacy + Terms locale-aware URLs, Rate store URL per platform).
- New `_SettingsRow`: 32×32 `primarySoft` icon tile + label + optional trailing + optional chevron. `_LanguagePillSwitcher` pill: surfaceAlt + border, `AnimatedContainer` highlights current selection in `primary`.
- Pro-gated rows (Widget, Export PDF) route to `/paywall?gate=true` when Free; `Pasar a Pro` CTA in the plan card stays on `/paywall` (entry path, no gate).
- Mono `JetBrainsMono` footer `HOUSEKEEP · MADE WITH CARE` in `textFaint`. `ListView` uses 100-px bottom padding so content clears `HkTabBar` and FABs in adjacent shells.
- ARB ES+EN: `settingsPlanFreeSub`, `settingsPlanProSub`, `settingsProActive`, `settingsSectionPreferences`, `settingsFooter` added; existing settings keys reused unchanged.

### Phase 10 — Home widget polish (`android/app/src/main/res/`)

- Widget data + `HouseKeepWidgetProvider` already shipped earlier (see `lib/features/widget/widget_service.dart` + `widget_deep_link.dart`). This pass aligns the Android widget visuals with the Cozy palette and adds a dark-mode resource variant.
- `values/widget_colors.xml` retoned to Cozy tokens: `widget_text_primary=#1F2624`, `widget_text_secondary=#6B7270`, `widget_text_faint=#A4A8A4`, `widget_accent=#2E7D6F`, new `widget_primary_soft=#DBEAE5`, `widget_border=#1A2E7D6F`, stripes use `ok=#3F9C5C / warn=#D4A017 / danger=#C8513C`. Added `widget_surface_alt=#FBF6EE` for future fills.
- `values-night/widget_colors.xml` (new) mirrors the `AppColorsDark` overlay from `DESIGN_TOKENS.md`: dark surface `#1E1C17`, muted text `#A39E94`, teal accent lightened to `#6FB9A9`, soft variants drop to 20%, stripes brightened so they still pop on dark.
- `drawable/widget_background.xml` corner radius bumped 20 → 28 dp per spec ("corner radius 28dp visible").
- Pro/Free demo gating, deep links, sync triggers and `home_widget` SharedPreferences keys remain on the existing data layer — no changes required.

### Microanimations

- `lib/shared/widgets/hk_summary_stat.dart` count value wrapped in an `AnimatedSwitcher` (220 ms slide + fade, keyed by `count`) so the home summary triplet animates whenever due / soon / ok totals change. Label and dot stay static so the row keeps its layout footprint.

### Dark mode

- `AppTheme.dark()` still returns `light()`. The codebase reads `AppColors.*` as static constants (not via `ColorScheme`), so a real dark theme requires migrating all widgets through the scheme before enabling — out of scope for this phase. The widget variant above means the home-screen widget already adapts when the OS is in dark mode.

## Verification

- `flutter analyze` clean.
- `flutter test` — 125 tests pass.
- `flutter build apk --debug` succeeds.
- Manual emulator runs: Cozy palette applied, onboarding redesign renders (home-cluster + bell-stack + sparkle pages), home empty state renders with `HkTabBar` + `HkFab`, items list "Mis cosas" + chip filter + empty card render correctly.

## Known issue (open)

- **Items add/edit form save bar overlap.** Last fix changed `Align(bottomCenter)` to `Positioned(left:0,right:0,bottom:0)` because the gradient `Container` lacked height constraints and stretched the Save button to full vertical. Build is clean but pending visual re-test on emulator.

## Remaining phases

_All numbered redesign phases (1–10) complete._

## Optional follow-ups

- **Full dark theme:** migrate `AppColors.*` reads to `Theme.of(context).colorScheme.*` (or pass `AppColors` through a Theme extension) so `AppTheme.dark()` can ship; widget already supports `values-night/widget_colors.xml`.
- **More microanimations:** `Hero` on item thumbnails between `items_list_screen` and `item_detail_screen`; shared-axis transitions are already wired via `go_router` `_sharedAxisPage`.
- **Regression goldens:** add `goldenFileComparator` and regenerate after Cozy redesign — defer until visual direction is locked.

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
lib/features/documents/documents_provider.dart     (M — unfiltered list provider)
lib/features/documents/documents_list_screen.dart  (M — rewritten Phase 6)
lib/features/documents/add_edit_document_screen.dart (M — rewritten Phase 6)
lib/features/documents/widgets/document_card.dart  (M — rewritten Phase 6)
lib/features/maintenance/widgets/mark_done_sheet.dart (NEW — Phase 7 completion modal)
lib/features/onboarding/onboarding_screen.dart     (M — rewritten Phase 3)
lib/features/onboarding/widgets/onboarding_art.dart (NEW)
lib/shared/widgets/hk_*.dart                       (NEW × 11)
pubspec.yaml + pubspec.lock                        (M — google_fonts)
test/app_smoke_test.dart                           (M — adapted for HkTabBar + greeting)
test/features/items/*.dart                         (M — adapted for Hk* widgets)
test/features/documents/*_screen_test.dart         (NEW — Phase 6 UI coverage)
test/shared/widgets/hk_widgets_test.dart           (NEW)
```
