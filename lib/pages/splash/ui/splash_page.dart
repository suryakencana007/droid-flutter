import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';

/// Ditampilkan selama sesi dan flag onboarding dipulihkan. Router yang
/// memindahkan ke halaman berikutnya.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [AppLogo(), Gap(AppSpacing.xl), FCircularProgress()],
        ),
      ),
    );
  }
}
