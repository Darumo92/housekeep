class AppConstants {
  const AppConstants._();

  static const int freeItemsLimit = 5;
  static const int freeDocumentsLimit = 3;
  static const String bundleId = 'com.housekeep.app';
  static const String entitlementId = 'housekeep_pro';

  static const String revenueCatAndroidKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
    defaultValue: 'test_PtrKyhyjSKLUXMVyUsbGpCxVGfd',
  );
  static const String revenueCatIosKey = String.fromEnvironment(
    'REVENUECAT_IOS_KEY',
    defaultValue: '',
  );
}
