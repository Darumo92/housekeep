import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

class FirebaseAnalyticsService extends AnalyticsService {
  FirebaseAnalyticsService({required FirebaseAnalytics analytics})
    : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserProperty(String name, String value) {
    return _analytics.setUserProperty(name: name, value: value);
  }
}
