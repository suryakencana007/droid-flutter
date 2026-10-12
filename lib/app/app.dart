import 'package:droid/features/toggle_theme/index.dart';
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

    return MaterialApp.router(
      title: 'Droid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) => FTheme(
        data: Theme.brightnessOf(context) == Brightness.dark
            ? UiTheme.dark
            : UiTheme.light,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
    );
  }
}
