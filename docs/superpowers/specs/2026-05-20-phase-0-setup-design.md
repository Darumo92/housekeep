# HouseKeep Phase 0 Setup Design

## Context

HouseKeep is currently a documentation-only repository. Phase 0 is the first implementation phase and must create a runnable Flutter foundation that matches the architecture already defined in `README.md`, `docs/PLAN.md`, `docs/ARCHITECTURE.md`, and `docs/PHASE_CHECKLIST.md`.

The goal of this phase is not to build product features. The goal is to create the project skeleton, shared infrastructure, and verification workflow that later phases will build on without rework.

## Goals

- Create the Flutter project in the current repository directory.
- Align the generated project with the documented architecture and naming conventions.
- Add and validate the core dependencies for state, routing, i18n, drift, notifications, purchases, and Firebase.
- Leave the app runnable with a minimal tab-based shell.
- Configure code generation for Riverpod, l10n, and drift so later phases can add feature logic without revisiting setup.
- Prepare Firebase initialization in code and complete live integration if local tooling and credentials allow it.

## Non-Goals

- No feature-complete CRUD flows.
- No repository or provider business logic beyond what setup requires.
- No paywall logic, notification scheduling logic, or production purchase integration.
- No broad test suite beyond optional smoke-level validation if it fits naturally.

## Recommended Approach

Use a two-block implementation inside the same phase.

### Block 1: Project foundation

Create the Flutter app, add dependencies, establish folder structure, register assets, and wire up the app shell. At the end of this block, the app should start and show a minimal Material 3 interface with the four planned tabs: Home, Items, Documents, and Settings.

### Block 2: Integration and verification

Add Firebase initialization, run all code generation, and verify the environment with Flutter tooling and a base compile or run. This isolates project-structure issues from environment and Firebase issues while still completing the full phase in one pass.

## Considered Alternatives

### Alternative A: Everything in one pass

Do all scaffold, architecture, Firebase, and validation work as a single undifferentiated sequence.

Trade-off: slightly faster when nothing goes wrong, but harder to debug when environment problems and code-structure problems appear together.

### Alternative B: Infra first, app second

Resolve SDKs, Firebase, and platform tooling before creating app structure.

Trade-off: cleaner environment-first workflow, but delays the moment when the repository becomes a working app and adds little value given the repo is currently empty.

### Chosen approach

Block 1 then Block 2. This is the best fit for the current repo because it creates a working baseline early while still keeping validation strict.

## Target Repository State

At the end of Phase 0, the repository should contain:

- A standard Flutter app created in `/home/darumo/Proyectos/housekeep`.
- `lib/main.dart` for app and platform initialization.
- `lib/app.dart` holding `MaterialApp.router` setup.
- `lib/core/theme/` with `app_colors.dart`, `app_typography.dart`, and `app_theme.dart`.
- `lib/core/l10n/` with `app_en.arb` and `app_es.arb`.
- `lib/core/constants/` for shared constants and asset paths.
- `lib/data/database/` with `app_database.dart` and three table files for items, maintenances, and documents.
- Base feature folders for `home`, `items`, `documents`, and `settings`, each with a minimal screen.
- `assets/templates/` and `assets/images/` registered in `pubspec.yaml`.

The code should follow the documented conventions: Riverpod-oriented setup, relative project imports, strict null safety, centralized theme, and user-facing strings in ARB files.

## Architecture Decisions

### Flutter scaffold location

Generate the Flutter project directly into the existing repository root instead of a nested subdirectory. The docs already assume that layout and all future phase references point to it.

### App shell

Create a minimal tabbed shell using `go_router` from the start. The shell should expose the four planned primary sections, even if each screen initially contains placeholder content. This avoids replacing the entry navigation structure in later phases.

### Theme setup

Create a centralized Material 3 theme in `core/theme/` using the documented palette and typography split. The first version should be small but real, not placeholder constants that will need to be rewritten.

The visual implementation of the theme and app shell should use the installed `ui-ux-pro-max` skill during implementation. If a fallback is needed for a narrower frontend execution task, `impeccable` or `design-taste-frontend` can be considered secondarily, but `ui-ux-pro-max` is the default requirement for visual design decisions in this phase.

### Internationalization

Enable `l10n.yaml`, add English and Spanish ARB files, and ensure all visible base-shell text comes from generated localizations. Even placeholder tab labels should use i18n.

### Drift scope in Phase 0

Configure drift and create the three core table files now because the database shape is foundational and required by the checklist. Keep this phase limited to schema and generated database setup; DAOs and repositories remain for Phase 1 unless setup requires minimal stubs.

### Firebase scope

Prepare the code path for Firebase initialization in `main.dart` and wire in generated options if `flutterfire configure` can run successfully in the environment. If the CLI or console-side setup blocks completion, keep the code structure ready and document the exact pending step without changing the overall architecture.

## Implementation Sequence

1. Verify the local Flutter environment and platform tooling.
2. Create the Flutter project in the current directory.
3. Update `pubspec.yaml` with the documented dependencies and assets.
4. Configure `analysis_options.yaml` for `riverpod_lint` and project linting.
5. Create the `lib/` folder structure from the architecture document.
6. Implement the base theme files and app constants.
7. Add `l10n.yaml`, ARB files, and app localization wiring.
8. Configure `go_router` with the four-tab shell and placeholder screens.
9. Add drift base files, tables, and app database definition.
10. Run `flutter pub get`, localization generation, and drift code generation.
11. Configure Firebase CLI integration and initialize Firebase in `main.dart` if the environment supports it.
12. Run analyzer and a base compile or run to validate the setup.
13. Update `docs/PHASE_CHECKLIST.md` to mark only the tasks that are truly complete.

## Error Handling Strategy

Failures should be handled in this order:

- If `flutter doctor` shows blocking SDK issues, stop and resolve environment problems before adding more app code.
- If `flutter pub get` fails, fix dependency or SDK compatibility before continuing.
- If `gen-l10n` or `build_runner` fails, fix project structure, annotations, or imports before moving to Firebase.
- If Firebase setup is blocked by external console credentials or unsupported local tooling, complete every repo-local task first and leave a precise pending note for the remaining manual step.

This ordering prevents hiding foundational setup problems behind later layers.

## Verification Criteria

Phase 0 is complete only when these checks pass or are explicitly documented as externally blocked:

- `flutter doctor` without Android-blocking issues.
- `flutter pub get`.
- `flutter gen-l10n` or equivalent generated localization success.
- `dart run build_runner build --delete-conflicting-outputs`.
- Static analysis on the project.
- A base app compile or run.

In addition, the codebase must visibly reflect the documented architecture rather than leaving setup implied.

## Risks and Mitigations

### Risk: SDK or platform mismatch

Mitigation: validate tooling before deep project edits and keep the first compile early.

### Risk: Firebase setup partially blocked by external console work

Mitigation: structure the code so only generated options and platform config files remain as the final moving part.

### Risk: Overbuilding Phase 0

Mitigation: keep screens as minimal placeholders and defer business logic, repositories, and detailed tests to later phases.

### Risk: Generic-looking UI foundation

Mitigation: use a dedicated design skill when implementing the theme and app shell so the base visual system is intentional instead of default Flutter scaffolding.

## Testing Scope

Testing in this phase is limited to setup validation, analyzer cleanliness, and successful generation/compile signals. Unit tests for repositories, date logic, urgency calculation, and free-limit behavior remain in Phase 1 and later phases, matching the existing roadmap.

## Completion Definition

Phase 0 is done when the repo transitions from documentation-only to a working Flutter project with:

- architecture-aligned folders and files,
- centralized theme and i18n,
- configured drift generation,
- a four-tab app shell,
- Firebase initialization prepared or completed,
- and validation commands run with real outputs.

After implementation, `docs/PHASE_CHECKLIST.md` must reflect the true completion state task by task.
