import 'package:flutter/widgets.dart';

import 'analytics.dart';

/// Mencatat screen view setiap route baru tampil. Pasang di `GoRouter.observers`
/// dan di setiap `StatefulShellBranch.observers` agar branch tab ikut tercatat.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._analytics);

  final Analytics _analytics;

  void _record(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) _analytics.logScreen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _record(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _record(newRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _record(previousRoute);
}
