import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.uri, super.key});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FLucideIcons.compass, size: 48),
              const Gap(AppSpacing.md),
              Text(l10n.notFoundMessage(uri.toString()), textAlign: TextAlign.center),
              const Gap(AppSpacing.md),
              FButton(
                onPress: () => context.go(AppRoutes.home),
                child: Text(l10n.backHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
