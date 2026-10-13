import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'gap.dart';
import 'spacing.dart';

/// Dialog konfirmasi sederhana di atas [FDialog]. Mengembalikan `true` bila
/// user menekan tombol konfirmasi.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showFDialog<bool>(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      builder: (context, style) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: style.titleTextStyle),
            const Gap(AppSpacing.sm),
            Text(message, style: style.bodyTextStyle),
            const Gap(AppSpacing.lg),
            FButton(
              variant: destructive
                  ? FButtonVariant.destructive
                  : FButtonVariant.primary,
              onPress: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
            const Gap(AppSpacing.sm),
            FButton(
              variant: FButtonVariant.outline,
              onPress: () => Navigator.of(context).pop(false),
              child: Text(cancelLabel),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
