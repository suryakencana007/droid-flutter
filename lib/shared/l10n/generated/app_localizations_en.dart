// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboarding1Title => 'Structured from day one';

  @override
  String get onboarding1Body =>
      'Feature-Sliced Design separates pages, features, entities, and shared code with import rules that are tested automatically.';

  @override
  String get onboarding2Title => 'UI kit included';

  @override
  String get onboarding2Body =>
      'forui components in the shadcn/ui style, light and dark themes, one entry point through shared/ui.';

  @override
  String get onboarding3Title => 'Ready to run';

  @override
  String get onboarding3Body =>
      'Auth, onboarding, tab navigation, and settings are in place. Swap the backend, then build your features.';

  @override
  String get signInTitle => 'Sign in';

  @override
  String signInSubtitle(String appName) {
    return 'Welcome back to $appName.';
  }

  @override
  String get signInAction => 'Sign in';

  @override
  String get signInProcessing => 'Signing in...';

  @override
  String get signInFailed => 'Sign in failed';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get noAccountLink => 'No account yet? Sign up';

  @override
  String demoAccountHint(String email, String password) {
    return 'Demo account: $email / $password';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get signUpSubtitle => 'Free and takes a minute.';

  @override
  String get signUpAction => 'Sign up';

  @override
  String get signUpProcessing => 'Creating...';

  @override
  String get signUpFailed => 'Sign up failed';

  @override
  String get haveAccountLink => 'Already have an account? Sign in';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Full name';

  @override
  String get passwordMinHint => 'At least 8 characters';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get forgotSubtitle =>
      'Enter your email and we will send a reset link.';

  @override
  String get forgotSend => 'Send reset link';

  @override
  String get forgotSending => 'Sending...';

  @override
  String get forgotFailed => 'Could not send';

  @override
  String get forgotSentTitle => 'Check your email';

  @override
  String forgotSentBody(String email) {
    return 'If $email is registered, a password reset link has been sent.';
  }

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get tabHome => 'Home';

  @override
  String get tabProfile => 'Profile';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeGuest => 'friend';

  @override
  String get homeDescription =>
      'This page composes widgets, features, and entities from the layers below it.';

  @override
  String get showToast => 'Show toast';

  @override
  String get toastTitle => 'UI kit: forui';

  @override
  String get toastBody => 'Components are used through shared/ui.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Theme, language, and app info';

  @override
  String get signOut => 'Sign out';

  @override
  String get signingOut => 'Signing out...';

  @override
  String get signOutConfirmTitle => 'Sign out of your account?';

  @override
  String get signOutConfirmBody =>
      'You will need to sign in again to use the app.';

  @override
  String get cancel => 'Cancel';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeDescription => 'Applies across the app and is remembered.';

  @override
  String get themeSystem => 'Follow system';

  @override
  String get themeSystemSub => 'Matches the device setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get lightMode => 'Light mode';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageDescription => 'Display language of the app.';

  @override
  String get languageSystem => 'Follow system';

  @override
  String get languageId => 'Indonesia';

  @override
  String get languageEn => 'English';

  @override
  String get aboutLabel => 'About';

  @override
  String get appLabel => 'App';

  @override
  String get versionLabel => 'Version';

  @override
  String notFoundMessage(String uri) {
    return 'Page not found: $uri';
  }

  @override
  String get backHome => 'Back to home';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationEmail => 'Invalid email format';

  @override
  String validationMinLength(int count) {
    return 'At least $count characters';
  }

  @override
  String get errorGeneric => 'Something went wrong. Try again.';

  @override
  String get authInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authEmailInUse => 'This email is already registered.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorTimeout => 'The server did not respond. Try again.';

  @override
  String get errorUnauthorized => 'Your session expired, please sign in again.';

  @override
  String get errorNotFound => 'Not found.';

  @override
  String get errorServer => 'The server had a problem. Try again later.';

  @override
  String get retry => 'Retry';

  @override
  String get offlineBanner => 'No internet connection';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyBody => 'Data will show up here.';

  @override
  String get tabNotes => 'Notes';

  @override
  String get notesTitle => 'Notes';

  @override
  String get noteNew => 'New note';

  @override
  String get noteEdit => 'Edit note';

  @override
  String get noteTitleLabel => 'Title';

  @override
  String get noteTitleHint => 'Note title';

  @override
  String get noteBodyLabel => 'Body';

  @override
  String get noteBodyHint => 'Write something...';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get delete => 'Delete';

  @override
  String get deleting => 'Deleting...';

  @override
  String get edit => 'Edit';

  @override
  String get noteDeleteConfirmTitle => 'Delete this note?';

  @override
  String get noteDeleteConfirmBody => 'Deleted notes cannot be recovered.';

  @override
  String get notesEmptyTitle => 'No notes yet';

  @override
  String get notesEmptyBody => 'Tap + to create your first note.';

  @override
  String get noteSaved => 'Note saved';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String updatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String get loadMoreFailed => 'Could not load the next page';

  @override
  String get permissionsLabel => 'Permissions';

  @override
  String get permissionsDescription =>
      'System permission status for features that need them.';

  @override
  String get permissionNotifications => 'Notifications';

  @override
  String get permissionNotificationsBody =>
      'Used to tell you about important updates. You can turn it off anytime.';

  @override
  String get permissionCamera => 'Camera';

  @override
  String get permissionCameraBody =>
      'Used to take attachment photos. Photos are not sent anywhere without your consent.';

  @override
  String get permissionLocation => 'Location';

  @override
  String get permissionLocationBody =>
      'Used to show content near you while the app is open.';

  @override
  String get permissionGranted => 'Granted';

  @override
  String get permissionDenied => 'Denied';

  @override
  String get permissionPermanentlyDenied => 'Permanently denied';

  @override
  String get permissionUnknown => 'Not asked yet';

  @override
  String get permissionContinue => 'Continue';

  @override
  String get permissionDeniedTitle => 'Permission denied';

  @override
  String get permissionDeniedBody =>
      'Enable this permission in the system settings.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get notificationsToggle => 'Receive notifications';

  @override
  String get notificationsToggleBody =>
      'Important updates from the app. Requires the system notification permission.';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String testNotificationTitle(String appName) {
    return 'Hello from $appName';
  }

  @override
  String get testNotificationBody => 'Tap to open your notes.';

  @override
  String get notificationChannelName => 'General';

  @override
  String get notificationChannelDescription => 'General app notifications';
}
