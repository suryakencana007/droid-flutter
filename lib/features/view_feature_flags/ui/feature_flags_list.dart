import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Daftar flag aktif beserta sumbernya; untuk debugging di flavor non-prod.
class FeatureFlagsList extends ConsumerWidget {
  const FeatureFlagsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final source = ref.watch(featureFlagsProvider).sourceName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AsyncValueView<Map<String, FlagValue>>(
          value: ref.watch(flagsProvider),
          onRetry: () => ref.read(flagsProvider.notifier).refresh(),
          isEmpty: (flags) => flags.isEmpty,
          empty: EmptyView(title: l10n.featureFlagsEmpty),
          data: (flags) => FTileGroup(
            label: Text(l10n.featureFlagsLabel),
            description: Text(l10n.featureFlagsDescription(source)),
            children: [
              for (final entry in flags.entries)
                FTile(
                  prefix: Icon(
                    entry.value.enabled
                        ? FLucideIcons.toggleRight
                        : FLucideIcons.toggleLeft,
                  ),
                  title: Text(entry.key),
                  details: Text(entry.value.toString()),
                ),
            ],
          ),
        ),
        const Gap(AppSpacing.md),
        FButton(
          variant: FButtonVariant.outline,
          prefix: const Icon(FLucideIcons.refreshCw),
          onPress: () => ref.read(flagsProvider.notifier).refresh(),
          child: Text(l10n.refresh),
        ),
      ],
    );
  }
}
