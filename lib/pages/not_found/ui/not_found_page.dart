import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.uri, super.key});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off_outlined, size: 48),
            const Gap(AppSpacing.md),
            Text('Halaman tidak ditemukan: $uri'),
            const Gap(AppSpacing.md),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Kembali ke beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
