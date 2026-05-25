import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/services/notification_providers.dart';
import 'data/services/notification_service.dart';
import 'firebase_options.dart';

bool firebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initFirebase();

  final container = ProviderContainer();
  await _initNotifications(container.read(notificationServiceProvider));

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const HouseKeepApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _requestNotificationPermissions(
      container.read(notificationServiceProvider),
    );
  });
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
