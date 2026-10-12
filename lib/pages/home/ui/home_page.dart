import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:material_ui/material_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const user = User(id: '1', name: 'Surya', email: 'surya@example.com');
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    return Scaffold(
      appBar: const DroidAppBar(title: 'Droid'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Feature-Sliced Design bootstrap',
            // Typeface display forui memakai line-height besar untuk judul satu
            // baris; rapatkan untuk judul yang bisa membungkus.
            style: typography.display.xl2.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Halaman ini merakit widget, feature, dan entity dari layer di bawahnya.',
            style: typography.body.sm.copyWith(color: colors.mutedForeground),
          ),
          const Gap(AppSpacing.lg),
          const UserCard(user: user),
          const Gap(AppSpacing.lg),
          FButton(
            onPress: () => showFToast(
              context: context,
              title: const Text('UI kit: forui'),
              description: const Text('Komponen dipakai lewat shared/ui.'),
            ),
            child: const Text('Tampilkan toast'),
          ),
        ],
      ),
    );
  }
}
