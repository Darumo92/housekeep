import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

final reviewServiceProvider = Provider<ReviewService>(
  (ref) => ReviewService(),
);

/// Requests the native in-app review prompt after the user has had a few
/// genuinely positive moments (completing maintenances), throttled so they are
/// never nagged. Google Play additionally caps how often the dialog actually
/// shows, so this only ever *asks*; it cannot force the dialog.
class ReviewService {
  ReviewService({InAppReview? inAppReview})
    : _inAppReview = inAppReview ?? InAppReview.instance;

  final InAppReview _inAppReview;

  static const _actionCountKey = 'review.positive_actions';
  static const _lastRequestKey = 'review.last_request_ms';
  static const _minActions = 3;
  static const _cooldown = Duration(days: 120);

  /// Call after a positive action. Once [_minActions] have accumulated and the
  /// cooldown has elapsed, asks for an in-app review. All failures are
  /// swallowed — a review prompt must never disrupt the user's flow.
  Future<void> registerPositiveAction() async {
    try {
      final prefs = SharedPreferencesAsync();
      final count = (await prefs.getInt(_actionCountKey) ?? 0) + 1;
      await prefs.setInt(_actionCountKey, count);
      if (count < _minActions) return;

      final lastMs = await prefs.getInt(_lastRequestKey);
      if (lastMs != null) {
        final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
        if (DateTime.now().difference(last) < _cooldown) return;
      }

      if (!await _inAppReview.isAvailable()) return;
      await prefs.setInt(
        _lastRequestKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      await _inAppReview.requestReview();
    } catch (e) {
      debugPrint('[Review] in-app review skipped: $e');
    }
  }
}
