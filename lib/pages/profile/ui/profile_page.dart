import 'package:droid/entities/user/index.dart';
import 'package:droid/features/sign_out/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: DroidAppBar(title: l10n.tabProfile),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (user != null) UserCard(user: user),
          const Gap(AppSpacing.lg),
          FTileGroup(
            children: [
              FTile(
                prefix: const Icon(FLucideIcons.userPen),
                title: Text(l10n.editProfileTitle),
                subtitle: Text(l10n.editProfileSubtitle),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => context.go(AppRoutes.editProfile),
              ),
              FTile(
                prefix: const Icon(FLucideIcons.keyRound),
                title: Text(l10n.changePasswordTitle),
                subtitle: Text(l10n.changePasswordSubtitle),
                suffix: const Icon(FLucideIcons.chevronRight),
                onPress: () => context.go(AppRoutes.changePassword),
              ),
              FTile(
                prefix: const Icon(FLucideIcons.settings),
                title: Text(l10n.settingsTitle),
                subtitle: Text(l10n.settingsSubtitle),
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
