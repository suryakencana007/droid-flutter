import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Kerangka menu utama: banner offline, konten branch, dan bottom tabs.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final online = ref.watch(isOnlineProvider).value ?? true;

    return Scaffold(
      body: Column(
        children: [
          if (!online) const SafeArea(bottom: false, child: OfflineBanner()),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: FBottomNavigationBar(
        index: navigationShell.currentIndex,
        onChange: (index) => navigationShell.goBranch(
          index,
          // Tap tab yang sedang aktif mengembalikan ke root branch tersebut.
          initialLocation: index == navigationShell.currentIndex,
        ),
        children: [
          FBottomNavigationBarItem(
            icon: const Icon(FLucideIcons.house),
            label: Text(l10n.tabHome),
          ),
          FBottomNavigationBarItem(
            icon: const Icon(FLucideIcons.compass),
            label: Text(l10n.tabExplore),
          ),
          FBottomNavigationBarItem(
            icon: const Icon(FLucideIcons.user),
            label: Text(l10n.tabProfile),
          ),
        ],
      ),
    );
  }
}
