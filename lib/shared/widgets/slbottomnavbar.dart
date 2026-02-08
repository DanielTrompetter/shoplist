import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/fav_item.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/shared/widgets/edititempopup.dart';
import 'package:shoplist/features/favorites/providers/favprovider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Slbottomnavbar extends ConsumerWidget {
  final Screen origin;
  final void Function(ShoppingItem)? onAddItem;
  final VoidCallback? onSaveList;

  const Slbottomnavbar({
    super.key,
    required this.origin,
    this.onAddItem,
    this.onSaveList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _buildItemsForOrigin(context, ref);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      backgroundColor: const Color.fromARGB(255, 181, 194, 231),
      elevation: 10,
      items: items
          .map((e) => BottomNavigationBarItem(
                icon: _buildIcon(e.icon),
                label: e.label,
              ))
          .toList(),
      onTap: (index) => items[index].onTap(),
    );
  }

  Widget _buildIcon(Icon icon) {
    return Transform.translate(
      offset: const Offset(0, 6),
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

  List<NavbarItem> _buildItemsForOrigin(BuildContext context, WidgetRef ref) {
    switch (origin) {

      // ------------------------------------------------------------
      // HOME SCREEN
      // ------------------------------------------------------------
      case Screen.homeScreen:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.star),
            label: 'favorites',
            onTap: () => Navigator.pushNamed(context, '/favscreen'),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.info),
            label: 'info',
            onTap: () => Navigator.pushNamed(context, '/infos'),
          ),
        ];

      // ------------------------------------------------------------
      // NORMAL LIST SCREEN
      // ------------------------------------------------------------
      case Screen.listScreen:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.star),
            label: 'favorites',
            onTap: () => Navigator.pushNamed(context, '/favscreen'),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.plus),
            label: 'add',
            onTap: () async {
              final newItem = await showModalBottomSheet<ShoppingItem>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const EditItemPopup(item: null, newItem: false),
              );

              if (newItem != null && onAddItem != null) {
                onAddItem!(newItem);
              }
            },
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.home),
            label: 'home',
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
        ];

      // ------------------------------------------------------------
      // NEW LIST SCREEN
      // ------------------------------------------------------------
      case Screen.newlist:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.save),
            label: 'save',
            onTap: () {
              if (onSaveList != null) {
                onSaveList!();
              } else {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.plus),
            label: 'add',
            onTap: () async {
              final newItem = await showModalBottomSheet<ShoppingItem>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const EditItemPopup(item: null, newItem: false),
              );

              if (newItem != null && onAddItem != null) {
                onAddItem!(newItem);
              }
            },
          ),
        ];

      // ------------------------------------------------------------
      // INFO SCREEN
      // ------------------------------------------------------------
      case Screen.info:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.star),
            label: 'favorites',
            onTap: () => Navigator.pushNamed(context, '/favscreen'),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.home),
            label: 'home',
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
        ];

      // ------------------------------------------------------------
      // FAVORITES SCREEN
      // ------------------------------------------------------------
      case Screen.favorites:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.plus),
            label: 'add',
            onTap: () async {
              final newItem = await showModalBottomSheet<ShoppingItem>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const EditItemPopup(item: null, newItem: false),
              );

              if (newItem != null) {
                ref.read(favoritesProvider.notifier).addFavorite(
                  FavItem(
                    name: newItem.name,
                    category: newItem.category,
                  ),
                );
              }
            },
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.home),
            label: 'home',
            onTap: () => Navigator.pushNamed(context, '/home'),
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
