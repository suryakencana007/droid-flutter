/// Daftar path route. Diletakkan di `shared` agar bisa dipakai lintas layer
/// tanpa bergantung pada konfigurasi router di layer `app`.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';

  static const home = '/';
  static const explore = '/explore';
  static const profile = '/profile';
  static const settings = '/profile/settings';

  /// Halaman yang hanya untuk pengguna yang belum masuk.
  static const authPages = {signIn, signUp, forgotPassword};
}
