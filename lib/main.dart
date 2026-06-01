import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/purchase_repository.dart';
import 'data/repositories/repository_providers.dart';
import 'data/repositories/revenuecat_purchase_repository.dart';
import 'data/services/demo_seed_service.dart';
import 'data/services/notification_providers.dart';
import 'data/services/notification_service.dart';
import 'features/settings/settings_provider.dart';
import 'features/widget/widget_deep_link.dart';
import 'features/widget/widget_sync_provider.dart';
import 'firebase_options.dart';

bool firebaseInitialized = false;

const _kScreenshotDemo = bool.fromEnvironment('SCREENSHOT_DEMO');
const _kScreenshotLocale = String.fromEnvironment(
  'SCREENSHOT_LOCALE',
  defaultValue: 'es',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _configureSystemUi();

  await _initFirebase();

  final purchaseRepository = await _initPurchases();

  final container = ProviderContainer(
    overrides: [
      if (purchaseRepository != null)
        purchaseRepositoryProvider.overrideWithValue(purchaseRepository),
    ],
  );
  await _initNotifications(container.read(notificationServiceProvider));
  await _applyNotificationPreference(
    container.read(notificationServiceProvider),
  );
  await container.read(proDebugOverrideProvider.notifier).load();
  if (_kScreenshotDemo) {
    await _prepareScreenshotDemo(container, _kScreenshotLocale);
  }

  if (Platform.isAndroid || Platform.isIOS) {
    container.listen(widgetSyncProvider, (_, __) {}, fireImmediately: true);
    WidgetDeepLinkHandler.instance.init(container);
  }

  final initialLocation = await _resolveInitialLocation();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: HouseKeepApp(initialLocation: initialLocation),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _requestNotificationPermissions(
      container.read(notificationServiceProvider),
    );
  });
}

Future<void> _prepareScreenshotDemo(
  ProviderContainer container,
  String languageCode,
) async {
  try {
    final normalizedLanguage = languageCode.startsWith('en') ? 'en' : 'es';
    final prefs = SharedPreferencesAsync();
    await prefs.setBool('onboarding.completed', true);
    await prefs.setString('settings.locale', normalizedLanguage);
    await prefs.setBool(kNotificationsEnabledPrefKey, false);

    final service = DemoSeedService(
      items: container.read(itemsRepositoryProvider),
      maintenances: container.read(maintenancesRepositoryProvider),
      documents: container.read(documentsRepositoryProvider),
    );
    await service.clear();
    await service.seed(DemoSeedStrings.forLanguageCode(normalizedLanguage));

    await container.read(proDebugOverrideProvider.notifier).set(true);
    container.read(notificationServiceProvider).enabled = false;
    debugPrint('[HouseKeep] Screenshot demo ready ($normalizedLanguage)');
  } catch (e) {
    debugPrint('[HouseKeep] Screenshot demo setup failed: $e');
  }
}

Future<PurchaseRepository?> _initPurchases() async {
  final key = Platform.isIOS
      ? AppConstants.revenueCatIosKey
      : Platform.isAndroid
      ? AppConstants.revenueCatAndroidKey
      : '';
  if (key.isEmpty) {
    debugPrint('[HouseKeep] RevenueCat key missing for this platform');
    return null;
  }
  final repo = RevenueCatPurchaseRepository(apiKey: key);
  try {
    await repo.init();
    debugPrint('[HouseKeep] RevenueCat initialized');
    return repo;
  } catch (e) {
    debugPrint('[HouseKeep] RevenueCat init failed: $e');
    return null;
  }
}

Future<void> _requestNotificationPermissions(
  NotificationService service,
) async {
  if (!service.isInitialized) return;
  try {
    await service.requestPermissions();
  } catch (e) {
    debugPrint('[HouseKeep] Notification permissions skipped: $e');
  }
}

Future<void> _initNotifications(NotificationService service) async {
  try {
    await service.init();
  } catch (e) {
    debugPrint('[HouseKeep] Notification init skipped: $e');
  }
}

Future<void> _applyNotificationPreference(NotificationService service) async {
  try {
    final prefs = SharedPreferencesAsync();
    service.enabled = await prefs.getBool(kNotificationsEnabledPrefKey) ?? true;
  } catch (e) {
    debugPrint('[HouseKeep] Notification preference read failed: $e');
  }
}

Future<String> _resolveInitialLocation() async {
  try {
    final prefs = SharedPreferencesAsync();
    final completed = await prefs.getBool('onboarding.completed') ?? false;
    return completed ? '/' : '/onboarding';
  } catch (e) {
    debugPrint('[HouseKeep] Onboarding state read failed: $e');
    return '/';
  }
}

void _configureSystemUi() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFAFAF8),
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Color(0x00000000),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: SystemUiOverlay.values,
  );
}

Future<bool> _isGooglePlayServicesAvailable() async {
  if (!Platform.isAndroid) return true;
  try {
    final result = await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability();
    if (result == GooglePlayServicesAvailability.success) {
      return true;
    }
    debugPrint('[HouseKeep] Google Play Services unavailable: $result');
    return false;
  } catch (e) {
    debugPrint('[HouseKeep] GMS availability check failed: $e');
    return false;
  }
}

Future<void> _initFirebase() async {
  try {
    if (Platform.isAndroid) {
      final gmsAvailable = await _isGooglePlayServicesAvailable();
      if (!gmsAvailable) {
        debugPrint(
          '[HouseKeep] Skipping Firebase: Google Play Services unavailable',
        );
        return;
      }
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint('[HouseKeep] Firebase initialized successfully');
  } catch (e) {
    debugPrint('[HouseKeep] Firebase initialization skipped: $e');
  }
}
