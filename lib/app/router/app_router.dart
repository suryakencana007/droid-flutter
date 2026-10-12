import 'package:droid/pages/home/index.dart';
import 'package:droid/pages/not_found/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: Env.isDebug,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => NotFoundPage(uri: state.uri),
  );
});
