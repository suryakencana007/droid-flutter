import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';

/// Kerangka halaman auth: logo, judul, subjudul, form, dan tautan bawah.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 56)),
                  const Gap(AppSpacing.xl),
                  Text(
                    title,
                    style: theme.typography.display.xl2.copyWith(
                      color: theme.colors.foreground,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const Gap(AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: theme.typography.body.sm
                          .copyWith(color: theme.colors.mutedForeground),
                    ),
                  ],
                  const Gap(AppSpacing.lg),
                  child,
                  if (footer != null) ...[
                    const Gap(AppSpacing.lg),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
