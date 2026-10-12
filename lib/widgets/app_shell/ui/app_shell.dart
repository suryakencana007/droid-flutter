import 'package:droid/shared/ui/index.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Kerangka menu utama: bottom tabs yang membungkus branch go_router.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: FBottomNavigationBar(
        index: navigationShell.currentIndex,
        onChange: (index) => navigationShell.goBranch(
          index,
          // Tap tab yang sedang aktif mengembalikan ke root branch tersebut.
          initialLocation: index == navigationShell.currentIndex,
        ),
        children: const [
          FBottomNavigationBarItem(
            icon: Icon(FLucideIcons.house),
            label: Text('Beranda'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FLucideIcons.compass),
            label: Text('Jelajah'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FLucideIcons.user),
            label: Text('Profil'),
          ),
        ],
      ),
    );
  }
}
