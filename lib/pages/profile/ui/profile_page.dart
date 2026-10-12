import 'package:droid/entities/user/index.dart';
import 'package:droid/features/sign_out/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: const DroidAppBar(title: 'Profil'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (user != null) UserCard(user: user),
          const Gap(AppSpacing.lg),
          FTileGroup(
            children: [
              FTile(
                prefix: const Icon(FLucideIcons.settings),
                title: const Text('Pengaturan'),
                subtitle: const Text('Tema dan info aplikasi'),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => context.go(AppRoutes.settings),
              ),
            ],
          ),
          const Gap(AppSpacing.lg),
          const SignOutButton(),
        ],
      ),
    );
  }
}
