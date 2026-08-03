import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'analytics_service.dart';
import 'firebase_analytics_service.dart';

part 'analytics_providers.g.dart';

/// Shared [FirebaseAnalytics] instance so [FirebaseAnalyticsService] and
/// the auto-generated observer use the same underlying client.
@Riverpod(keepAlive: true)
FirebaseAnalytics firebaseAnalyticsInstance(FirebaseAnalyticsInstanceRef ref) {
  return FirebaseAnalytics.instance;
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(AnalyticsServiceRef ref) {
  try {
    final analytics = ref.watch(firebaseAnalyticsInstanceProvider);
    return FirebaseAnalyticsService(analytics: analytics);
  } catch (_) {
    return const NoOpAnalyticsService();
  }
}
