import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Kerangka menu utama: bottom tabs yang membungkus branch go_router.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
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
