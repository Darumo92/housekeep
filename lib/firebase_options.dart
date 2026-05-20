// PLACEHOLDER — This file will be replaced by `flutterfire configure`.
// Until then, any access to DefaultFirebaseOptions.currentPlatform throws,
// which main.dart catches so the app still runs without Firebase.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web — '
        'run `flutterfire configure` to generate real credentials.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS — '
          'run `flutterfire configure` to generate real credentials.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows — '
          'run `flutterfire configure` to generate real credentials.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux — '
          'run `flutterfire configure` to generate real credentials.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia.',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBicZ6eGk41f7gqX0o2RukZ7L5CEi129VI',
    appId: '1:24721474076:ios:26017620d090da8bb915d9',
    messagingSenderId: '24721474076',
    projectId: 'housekeep-8715e',
    storageBucket: 'housekeep-8715e.firebasestorage.app',
    iosBundleId: 'com.housekeep.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBP_h5jP6WqQc3LgMVDsrrpcFh4u87C_P0',
    appId: '1:24721474076:android:f232bd323a3ca618b915d9',
    messagingSenderId: '24721474076',
    projectId: 'housekeep-8715e',
    storageBucket: 'housekeep-8715e.firebasestorage.app',
  );

}