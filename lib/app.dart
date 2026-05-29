import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/l10n/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/documents/add_edit_document_screen.dart';
import 'features/documents/documents_list_screen.dart';
import 'features/home/home_screen.dart';
import 'features/items/add_edit_item_screen.dart';
import 'features/items/item_detail_screen.dart';
import 'features/items/items_list_screen.dart';
import 'features/maintenance/add_edit_maintenance_screen.dart';
import 'features/maintenance/maintenance_list_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/paywall/paywall_screen.dart';
import 'features/settings/settings_provider.dart';
import 'features/settings/settings_screen.dart';
import 'features/widget/widget_deep_link.dart';
import 'shared/widgets/hk_tab_bar.dart';

class ShellDestination {
  const ShellDestination({
    required this.index,
    required this.location,
    required this.title,
  });

  final int index;
  final String location;
  final String Function(AppLocalizations l10n) title;
}

ShellDestination resolveShellDestination(String location) {
  if (_matchesBranch(location, '/items')) {
    return ShellDestination(
      index: 1,
      location: '/items',
      title: (l10n) => l10n.itemsTitle,
    );
  }

  if (_matchesBranch(location, '/documents')) {
    return ShellDestination(
      index: 2,
      location: '/documents',
      title: (l10n) => l10n.documentsTitle,
    );
  }

  if (_matchesBranch(location, '/settings')) {
    return ShellDestination(
      index: 3,
      location: '/settings',
      title: (l10n) => l10n.settingsTitle,
    );
  }

  return ShellDestination(
    index: 0,
    location: '/',
    title: (l10n) => l10n.appName,
  );
}

bool _matchesBranch(String location, String branch) {
  return location == branch || location.startsWith('$branch/');
}

CustomTransitionPage<T> _sharedAxisPage<T>(LocalKey key, Widget child) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final secondaryFade = Tween<double>(begin: 1, end: 0.7).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
      );
      return FadeTransition(
        opacity: secondaryFade,
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        ),
      );
    },
  );
}

GoRouter _createRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    restorationScopeId: 'housekeep_router',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _AppShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/items',
            builder: (context, state) => const ItemsListScreen(),
          ),
          GoRoute(
            path: '/items/add',
            pageBuilder: (context, state) =>
                _sharedAxisPage(state.pageKey, const AddEditItemScreen()),
          ),
          GoRoute(
            path: '/items/:id/edit',
            pageBuilder: (context, state) => _sharedAxisPage(
              state.pageKey,
              AddEditItemScreen(itemId: state.pathParameters['id']),
            ),
          ),
          GoRoute(
            path: '/items/:id',
            pageBuilder: (context, state) => _sharedAxisPage(
              state.pageKey,
              ItemDetailScreen(itemId: state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/items/:id/maintenance',
            pageBuilder: (context, state) => _sharedAxisPage(
              state.pageKey,
              MaintenanceListScreen(itemId: state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/items/:id/maintenance/add',
            pageBuilder: (context, state) => _sharedAxisPage(
              state.pageKey,
              AddEditMaintenanceScreen(itemId: state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/items/:id/maintenance/:maintenanceId/edit',
            pageBuilder: (context, state) => _sharedAxisPage(
              state.pageKey,
              AddEditMaintenanceScreen(
                itemId: state.pathParameters['id']!,
                maintenanceId: state.pathParameters['maintenanceId'],
              ),
            ),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsListScreen(),
          ),
          GoRoute(
            path: '/documents/add',
            pageBuilder: (context, state) =>
                _sharedAxisPage(state.pageKey, const AddEditDocumentScreen()),
          ),
          GoRoute(
            path: '/documents/:id/edit',
            pageBuilder: (context, state) => _sharedAxisPage(
              state.pageKey,
              AddEditDocumentScreen(documentId: state.pathParameters['id']),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/paywall',
        pageBuilder: (context, state) => _sharedAxisPage(
          state.pageKey,
          PaywallScreen(gate: state.uri.queryParameters['gate'] == 'true'),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}

class HouseKeepApp extends ConsumerStatefulWidget {
  const HouseKeepApp({
    super.key,
    this.localeOverride,
    this.initialLocation = '/',
  });

  final Locale? localeOverride;
  final String initialLocation;

  @override
  ConsumerState<HouseKeepApp> createState() => _HouseKeepAppState();
}

class _HouseKeepAppState extends ConsumerState<HouseKeepApp> {
  late final GoRouter _router = _createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void initState() {
    super.initState();
    WidgetDeepLinkHandler.instance.attachRouter(_router);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final localeFromSettings = settings.maybeWhen(
      data: (s) => s.localePreference.toLocale(),
      orElse: () => null,
    );

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: widget.localeOverride ?? localeFromSettings,
      theme: AppTheme.light(),
      restorationScopeId: 'housekeep_app',
      routerConfig: _router,
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

class _AppShell extends StatelessWidget {
  const _AppShell({required this.location, required this.child});

  final String location;
  final Widget child;

  static const _destinations = <HkTab, String>{
    HkTab.home: '/',
    HkTab.items: '/items',
    HkTab.docs: '/documents',
    HkTab.settings: '/settings',
  };

  HkTab _currentTab() {
    final destination = resolveShellDestination(location);
    switch (destination.index) {
      case 1:
        return HkTab.items;
      case 2:
        return HkTab.docs;
      case 3:
        return HkTab.settings;
      default:
        return HkTab.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(bottom: false, child: child),
      bottomNavigationBar: HkTabBar(
        current: _currentTab(),
        onChanged: (tab) {
          final dest = _destinations[tab]!;
          context.go(dest);
        },
      ),
    );
  }
}
