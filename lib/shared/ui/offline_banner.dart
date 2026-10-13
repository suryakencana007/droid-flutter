import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../l10n/index.dart';
import 'gap.dart';
import 'spacing.dart';

/// Pita tipis di atas konten saat tidak ada koneksi.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      color: theme.colors.destructive,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FLucideIcons.wifiOff, size: 16, color: theme.colors.destructiveForeground),
          const Gap(AppSpacing.sm),
          Flexible(
            child: Text(
              context.l10n.offlineBanner,
              overflow: TextOverflow.ellipsis,
              style: theme.typography.body.sm
                  .copyWith(color: theme.colors.destructiveForeground),
            ),
          ),
        ],
      ),
    );
  }
}
