class AppConstants {
  const AppConstants._();

  static const int freeItemsLimit = 5;
  static const int freeDocumentsLimit = 3;
  static const String bundleId = 'com.housekeep.app';
  static const String entitlementId = 'housekeep_pro';

  /// Pre-launch beta flag: exposes the debug PRO toggle and test-notification
  /// action in release builds so testers can preview gated features without a
  /// real purchase. Disabled for the public release.
  static const bool betaShowProToggle = false;

  static const String revenueCatAndroidKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
    defaultValue: 'test_PtrKyhyjSKLUXMVyUsbGpCxVGfd',
  );
  static const String revenueCatIosKey = String.fromEnvironment(
    'REVENUECAT_IOS_KEY',
    defaultValue: '',
  );
}
