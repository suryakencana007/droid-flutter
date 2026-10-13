import 'package:droid/shared/lib/errors/describe_error.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../l10n/index.dart';
import 'gap.dart';
import 'loading_view.dart';
import 'spacing.dart';

/// Merender [AsyncValue] ke loading / error (dengan coba lagi) / kosong / data,
/// supaya halaman tidak mengulang boilerplate `when`.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    super.key,
    this.onRetry,
    this.isEmpty,
    this.empty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  /// Bila mengembalikan `true`, [empty] (atau [EmptyView] bawaan) ditampilkan.
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  @override
  Widget build(BuildContext context) => value.when(
    data: (d) =>
        (isEmpty?.call(d) ?? false) ? (empty ?? const EmptyView()) : data(d),
    loading: () => const LoadingView(),
    error: (error, _) => ErrorView(
      message: describeError(error, context.l10n),
      onRetry: onRetry,
    ),
  );
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, super.key, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FLucideIcons.circleAlert,
              size: 40,
              color: theme.colors.destructive,
            ),
            const Gap(AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.typography.body.md.copyWith(
                color: theme.colors.foreground,
              ),
            ),
            if (onRetry != null) ...[
              const Gap(AppSpacing.md),
              FButton(
                variant: FButtonVariant.outline,
                prefix: const Icon(FLucideIcons.refreshCw),
                onPress: onRetry,
                child: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.icon = FLucideIcons.inbox,
    this.title,
    this.body,
    this.action,
  });

  final IconData icon;
  final String? title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colors.mutedForeground),
            const Gap(AppSpacing.md),
            Text(
              title ?? l10n.emptyTitle,
              textAlign: TextAlign.center,
              style: theme.typography.body.lg.copyWith(
                color: theme.colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(AppSpacing.xs),
            Text(
              body ?? l10n.emptyBody,
              textAlign: TextAlign.center,
              style: theme.typography.body.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            if (action != null) ...[const Gap(AppSpacing.md), action!],
          ],
        ),
      ),
    );
  }
}
