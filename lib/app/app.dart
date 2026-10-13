import 'package:droid/entities/user/index.dart';
import 'package:droid/features/select_locale/index.dart';
import 'package:droid/features/toggle_theme/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider).value;

    ref.listen(currentUserProvider, (_, next) {
      final id = next.value?.id;
      ref.read(crashReporterProvider).setUser(id);
      ref.read(analyticsProvider).setUser(id);
    });

    return MaterialApp.router(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...FLocalizations.localizationsDelegates,
      ],
      routerConfig: router,
      builder: (context, child) {
        final themed = FTheme(
          data: Theme.brightnessOf(context) == Brightness.dark
              ? UiTheme.dark
              : UiTheme.light,
          child: FToaster(child: FTooltipGroup(child: child!)),
        );
        if (Env.isProd) return themed;
        return Banner(
          message: Env.flavor.name.toUpperCase(),
          location: BannerLocation.topEnd,
          child: themed,
        );
      },
    );
  }
}
