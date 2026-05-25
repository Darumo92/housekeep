import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

class WidgetDeepLinkHandler {
  WidgetDeepLinkHandler._();
  static final WidgetDeepLinkHandler instance = WidgetDeepLinkHandler._();

  GoRouter? _router;
  String? _pendingRoute;
  bool _initialized = false;

  void init(ProviderContainer container) {
    if (_initialized) return;
    _initialized = true;
    HomeWidget.widgetClicked.listen(_handleUri);
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleUri);
  }

  void attachRouter(GoRouter router) {
    _router = router;
    final pending = _pendingRoute;
    if (pending != null) {
      _pendingRoute = null;
      _navigate(pending);
    }
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;
    if (uri.scheme != 'housekeep' || uri.host != 'widget') return;
    final route = uri.queryParameters['route'];
    if (route == null || route.isEmpty) return;
    final router = _router;
    if (router == null) {
      _pendingRoute = route;
      return;
    }
    _navigate(route);
  }

  void _navigate(String route) {
    try {
      _router?.go(route);
    } catch (e) {
      debugPrint('[WidgetDeepLink] navigation failed for $route: $e');
    }
  }
}
