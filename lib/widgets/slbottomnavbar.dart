import 'package:lucide_icons/lucide_icons.dart';
import 'package:shoplist/main.dart';
import 'package:flutter/material.dart';

class Slbottomnavbar extends StatelessWidget {
  final Screen origin;

  const Slbottomnavbar({super.key, required this.origin});

  @override
  Widget build(BuildContext context) {
    final items = _buildItemsForOrigin(context);

    return BottomNavigationBar(
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      backgroundColor: const Color.fromARGB(255, 0xC3, 0xE7, 0xB5),
      elevation: 10,
      items: items.map((e) => BottomNavigationBarItem(icon: e.icon, label: e.label)).toList(),
      onTap: (index) => items[index].onTap(),
    );
  }

  List<NavbarItem> _buildItemsForOrigin(BuildContext context) {
    switch (origin) {
      case Screen.homeScreen:
        return [
          NavbarItem(icon: const Icon(LucideIcons.info), label: 'Info', onTap: () => Navigator.pushNamed(context, '/info')),
          NavbarItem(icon: const Icon(LucideIcons.user), label: 'Profil', onTap: () => Navigator.pushNamed(context, '/profile')),
        ];
      case Screen.listScreen:
        return [
          NavbarItem(icon: const Icon(LucideIcons.home), label: 'Home', onTap: () => Navigator.pushNamed(context, '/home')),
          NavbarItem(icon: const Icon(LucideIcons.settings), label: 'Einstellungen', onTap: () => Navigator.pushNamed(context, '/settings')),
        ];
    }
  }
}

class NavbarItem {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  NavbarItem({required this.icon, required this.label, required this.onTap});
}

