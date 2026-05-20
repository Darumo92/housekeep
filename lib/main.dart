import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

bool firebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initFirebase();

  runApp(const ProviderScope(child: HouseKeepApp()));
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
