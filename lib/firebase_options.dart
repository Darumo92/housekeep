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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android — '
          'run `flutterfire configure` to generate real credentials.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS — '
          'run `flutterfire configure` to generate real credentials.',
        );
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
}