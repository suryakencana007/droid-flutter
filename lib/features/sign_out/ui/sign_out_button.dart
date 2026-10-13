import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/sign_out_controller.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l10n.signOutConfirmTitle,
      message: l10n.signOutConfirmBody,
      confirmLabel: l10n.signOut,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (ok) await ref.read(signOutControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signOutControllerProvider);
    final l10n = context.l10n;

    return FButton(
      variant: FButtonVariant.outline,
      prefix: const Icon(FLucideIcons.logOut),
      onPress: state.isLoading ? null : () => _confirm(context, ref),
      child: Text(state.isLoading ? l10n.signingOut : l10n.signOut),
    );
  }
}
