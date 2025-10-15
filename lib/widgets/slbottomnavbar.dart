import 'package:lucide_icons/lucide_icons.dart';
import 'package:shoplist/main.dart';
import 'package:flutter/material.dart';
import 'package:shoplist/widgets/NewListItem/edititempopup.dart';

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
      items: items
          .map((e) => BottomNavigationBarItem(
                icon: _buildIcon(e.icon),
                label: '',
              ))
          .toList(),
      onTap: (index) => items[index].onTap(),
    );
  }

  Widget _buildIcon(Icon icon) {
    return Transform.translate(
      offset: const Offset(0, 6), // z. B. 6 Pixel nach unten
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              blurRadius: 6,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon.icon,
            size: 32,
            color: Colors.black.withAlpha(192),
          ),
        ),
      ),
    );
  }

  List<NavbarItem> _buildItemsForOrigin(BuildContext context) {
    switch (origin) {
      case Screen.homeScreen:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.info),
            label: 'Info',
            onTap: () => Navigator.pushNamed(context, '/infos'),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.user),
            label: 'Profil',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
        ];
      case Screen.listScreen:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.home),
            label: 'Info',
            onTap: () => Navigator.pushNamed(context, '/infos'),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.settings),
            label: 'Einstellungen',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ];
      case Screen.newlist:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.save),
            label: 'Fertig',
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.plus),
            label: 'Neuer Gegenstand',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const EditItemPopup(),
              );
            },
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.settings),
            label: 'Einstellungen',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ];
    }
  }
}

class NavbarItem {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  NavbarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
