import 'package:droid/features/app_lock/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Layar kunci; router memindahkan ke sini saat `AppLockState.locked`.
class LockPage extends ConsumerStatefulWidget {
  const LockPage({super.key});

  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> {
  var _failed = false;
  var _busy = false;

  Future<void> _unlock() async {
    setState(() => _busy = true);
    final ok = await ref
        .read(appLockProvider.notifier)
        .unlock(reason: context.l10n.unlockReason(AppInfo.name));
    if (!mounted) return;
    setState(() {
      _busy = false;
      _failed = !ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogo(),
                const Gap(AppSpacing.xl),
                Text(
                  l10n.lockTitle,
                  textAlign: TextAlign.center,
                  style: theme.typography.display.xl.copyWith(
                    color: theme.colors.foreground,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const Gap(AppSpacing.sm),
                Text(
                  l10n.lockBody,
                  textAlign: TextAlign.center,
                  style: theme.typography.body.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                if (_failed) ...[
                  const Gap(AppSpacing.md),
                  FAlert(
                    variant: FAlertVariant.destructive,
                    icon: const Icon(FLucideIcons.circleAlert),
                    title: Text(l10n.unlockFailed),
                  ),
                ],
                const Gap(AppSpacing.lg),
                FButton(
                  prefix: const Icon(FLucideIcons.fingerprint),
                  onPress: _busy ? null : _unlock,
                  child: Text(l10n.unlock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
