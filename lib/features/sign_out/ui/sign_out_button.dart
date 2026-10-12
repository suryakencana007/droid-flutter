import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/sign_out_controller.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Keluar dari akun?',
      message: 'Kamu perlu masuk lagi untuk menggunakan aplikasi.',
      confirmLabel: 'Keluar',
      destructive: true,
    );
    if (ok) await ref.read(signOutControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signOutControllerProvider);

    return FButton(
      variant: FButtonVariant.outline,
      prefix: const Icon(FLucideIcons.logOut),
      onPress: state.isLoading ? null : () => _confirm(context, ref),
      child: Text(state.isLoading ? 'Keluar...' : 'Keluar'),
    );
  }
}
