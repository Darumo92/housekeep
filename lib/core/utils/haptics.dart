import 'package:flutter/services.dart';

class AppHaptics {
  const AppHaptics._();

  static void tap() {
    HapticFeedback.selectionClick();
  }

  static void success() {
    HapticFeedback.lightImpact();
  }

  static void destructive() {
    HapticFeedback.mediumImpact();
  }

  static void error() {
    HapticFeedback.heavyImpact();
  }
}
