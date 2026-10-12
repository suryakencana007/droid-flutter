import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    return Scaffold(
      appBar: const DroidAppBar(title: 'Beranda'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Halo, ${user?.name ?? 'teman'}',
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
          if (user != null) UserCard(user: user),
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
