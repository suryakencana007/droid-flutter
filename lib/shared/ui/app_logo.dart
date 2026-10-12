import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../config/app_info.dart';
import 'gap.dart';
import 'spacing.dart';

/// Logo aplikasi: ikon di dalam kotak + nama dari [AppInfo].
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64, this.showName = true});

  final double size;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colors.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Icon(
            FLucideIcons.bot,
            size: size * 0.55,
            color: theme.colors.primaryForeground,
          ),
        ),
        if (showName) ...[
          const Gap(AppSpacing.sm),
          Text(
            AppInfo.name,
            style: theme.typography.display.xl.copyWith(
              color: theme.colors.foreground,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
