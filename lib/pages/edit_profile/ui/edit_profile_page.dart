import 'package:droid/entities/user/index.dart';
import 'package:droid/features/edit_profile/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: user == null
          ? const LoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: EditProfileForm(
                user: user,
                onSaved: () {
                  showFToast(context: context, title: Text(l10n.profileSaved));
                  context.go(AppRoutes.profile);
                },
              ),
            ),
    );
  }
}
