import 'package:droid/entities/user/index.dart';
import 'package:droid/features/app_lock/index.dart';
import 'package:droid/features/complete_onboarding/index.dart';
import 'package:droid/pages/change_password/index.dart';
import 'package:droid/pages/edit_profile/index.dart';
import 'package:droid/pages/feature_flags/index.dart';
import 'package:droid/pages/forgot_password/index.dart';
import 'package:droid/pages/home/index.dart';
import 'package:droid/pages/lock/index.dart';
import 'package:droid/pages/not_found/index.dart';
import 'package:droid/pages/note_detail/index.dart';
import 'package:droid/pages/note_edit/index.dart';
import 'package:droid/pages/notes/index.dart';
import 'package:droid/pages/onboarding/index.dart';
import 'package:droid/pages/profile/index.dart';
import 'package:droid/pages/settings/index.dart';
import 'package:droid/pages/sign_in/index.dart';
import 'package:droid/pages/sign_up/index.dart';
import 'package:droid/pages/splash/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/widgets/app_shell/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router_refresh.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh();
  ref
    ..listen(currentUserProvider, (_, _) => refresh.refresh())
    ..listen(onboardingDoneProvider, (_, _) => refresh.refresh())
    ..listen(appLockProvider, (_, _) => refresh.refresh())
    ..onDispose(refresh.dispose);

  final analytics = ref.watch(analyticsProvider);
  AnalyticsRouteObserver observer() => AnalyticsRouteObserver(analytics);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    observers: [observer()],
    debugLogDiagnostics: Env.isDebug,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.lock,
        builder: (context, state) => const LockPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            observers: [observer()],
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            observers: [observer()],
            routes: [
              GoRoute(
                path: AppRoutes.notes,
                builder: (context, state) => const NotesPage(),
                routes: [
                  // `new` harus sebelum `:id` agar tidak dianggap id.
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const NoteEditPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) =>
                        NoteDetailPage(id: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) =>
                            NoteEditPage(id: state.pathParameters['id']),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            observers: [observer()],
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const EditProfilePage(),
                  ),
                  GoRoute(
                    path: 'password',
                    builder: (context, state) => const ChangePasswordPage(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsPage(),
                    routes: [
                      GoRoute(
                        path: 'flags',
                        builder: (context, state) => const FeatureFlagsPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => NotFoundPage(uri: state.uri),
  );
  ref.onDispose(router.dispose);
  return router;
});

/// Satu-satunya tempat aturan alur layar diputuskan:
/// splash (saat memulihkan sesi) → onboarding (sekali) → auth → kunci app
/// (bila aktif) → menu utama.
String? _redirect(Ref ref, GoRouterState state) {
  final user = ref.read(currentUserProvider);
  final onboarded = ref.read(onboardingDoneProvider);
  final location = state.matchedLocation;

  if (user.isLoading || onboarded.isLoading) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }

  if (!(onboarded.value ?? false)) {
    return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
  }

  final signedIn = user.value != null;
  final onAuthPage = AppRoutes.authPages.contains(location);

  if (!signedIn) return onAuthPage ? null : AppRoutes.signIn;

  final locked = ref.read(appLockProvider).value?.locked ?? false;
  if (locked) {
    if (location == AppRoutes.lock) return null;
    // Simpan asal agar setelah dibuka kembali ke halaman yang sama.
    return Uri(
      path: AppRoutes.lock,
      queryParameters: {'from': state.uri.toString()},
    ).toString();
  }
  if (location == AppRoutes.lock) {
    return state.uri.queryParameters['from'] ?? AppRoutes.home;
  }

  if (onAuthPage ||
      location == AppRoutes.splash ||
      location == AppRoutes.onboarding) {
    return AppRoutes.home;
  }
  return null;
}
