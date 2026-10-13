import 'package:droid/entities/user/index.dart';
import 'package:droid/features/complete_onboarding/index.dart';
import 'package:droid/pages/forgot_password/index.dart';
import 'package:droid/pages/home/index.dart';
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
import 'package:droid/widgets/app_shell/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router_refresh.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh();
  ref
    ..listen(currentUserProvider, (_, _) => refresh.refresh())
    ..listen(onboardingDoneProvider, (_, _) => refresh.refresh())
    ..onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
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
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsPage(),
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
/// splash (saat memulihkan sesi) → onboarding (sekali) → auth → menu utama.
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

  if (onAuthPage ||
      location == AppRoutes.splash ||
      location == AppRoutes.onboarding) {
    return AppRoutes.home;
  }
  return null;
}
