import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/purchase_repository.dart';
import 'data/repositories/repository_providers.dart';
import 'data/repositories/revenuecat_purchase_repository.dart';
import 'data/services/notification_providers.dart';
import 'data/services/notification_service.dart';
import 'features/widget/widget_deep_link.dart';
import 'features/widget/widget_sync_provider.dart';
import 'firebase_options.dart';

bool firebaseInitialized = false;

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

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;

    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint('[HouseKeep] Firebase initialized successfully');
  } catch (e) {
    // Firebase is not yet configured (flutterfire configure has not been run)
    // or the current platform is unsupported. The app continues to work
    // without Analytics/Crashlytics.
    debugPrint('[HouseKeep] Firebase initialization skipped: $e');
  }
}
