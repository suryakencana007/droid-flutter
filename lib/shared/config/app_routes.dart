/// Daftar path route. Diletakkan di `shared` agar bisa dipakai lintas layer
/// tanpa bergantung pada konfigurasi router di layer `app`.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const lock = '/lock';

  static const home = '/';
  static const notes = '/notes';
  static const noteNew = '/notes/new';
  static String noteDetail(String id) => '/notes/$id';
  static String noteEdit(String id) => '/notes/$id/edit';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const changePassword = '/profile/password';
  static const settings = '/profile/settings';
  static const featureFlags = '/profile/settings/flags';

  /// Halaman yang hanya untuk pengguna yang belum masuk.
  static const authPages = {signIn, signUp, forgotPassword};
}
