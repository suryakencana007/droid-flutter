import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/lib/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

typedef _Tab = ({IconData icon, String label});

/// Kerangka menu utama: banner offline + konten branch, dengan bottom tabs di
/// ponsel atau sidebar di layar lebar (>= breakpoint `sm` forui).
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _go(int index) => navigationShell.goBranch(
    index,
    // Tap tab yang sedang aktif mengembalikan ke root branch tersebut.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final online = ref.watch(isOnlineProvider).value ?? true;
    final wide =
        MediaQuery.sizeOf(context).width >= context.theme.breakpoints.sm;
    final tabs = <_Tab>[
      (icon: FLucideIcons.house, label: l10n.tabHome),
      (icon: FLucideIcons.notebookPen, label: l10n.tabNotes),
      (icon: FLucideIcons.user, label: l10n.tabProfile),
    ];

    final content = Column(
      children: [
        if (!online) const SafeArea(bottom: false, child: OfflineBanner()),
        Expanded(child: navigationShell),
      ],
    );

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            FSidebar(
              header: const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: AppLogo(size: 40),
              ),
              children: [
                FSidebarGroup(
                  children: [
                    for (final (i, tab) in tabs.indexed)
                      FSidebarItem(
                        icon: Icon(tab.icon),
                        label: Text(tab.label),
                        selected: i == navigationShell.currentIndex,
                        onPress: () => _go(i),
                      ),
                  ],
                ),
              ],
            ),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: FBottomNavigationBar(
        index: navigationShell.currentIndex,
        onChange: _go,
        children: [
          for (final tab in tabs)
            FBottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: Text(tab.label),
            ),
        ],
      ),
    );
  }
}
