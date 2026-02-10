import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/favItem.dart';
import 'package:shoplist/data/models/shoppingItem.dart';
import 'package:shoplist/shared/widgets/edititempopup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/features/shoplist/providers/favprovider.dart';

class Slbottomnavbar extends ConsumerWidget {
  final Screen origin;
  final void Function(ShoppingItem)? onAddItem;
  final VoidCallback? onSaveList;
  final VoidCallback? onDeleteList;

  const Slbottomnavbar({
    super.key,
    required this.origin,
    this.onAddItem,
    this.onSaveList,
    this.onDeleteList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _buildItemsForOrigin(context, ref);

    return BottomNavigationBar(
      currentIndex: 0,
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
            label: '',
            onTap: () => Navigator.pushNamed(
              context,
              '/favscreen',
              arguments: {
                'origin': origin,
                'onAddItem': null, // HomeScreen → kein kleiner Plusbutton
              },
            ),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.info),
            label: '',
            onTap: () => Navigator.pushNamed(context, '/infos'),
          ),
        ];

      // ------------------------------------------------------------
      // LIST SCREEN
      // ------------------------------------------------------------
      case Screen.listScreen:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.star),
            label: '',
            onTap: () => Navigator.pushNamed(
              context,
              '/favscreen',
              arguments: {
                'origin': origin,
                'onAddItem': onAddItem, // wichtig!
              },
            ),
          ),
          NavbarItem(
            icon: const Icon(LucideIcons.plus),
            label: '',
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
            icon: const Icon(LucideIcons.trash),
            label: '',
            onTap: () {
              if (onDeleteList != null) {
                onDeleteList!();
              } else {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
        ];

      // ------------------------------------------------------------
      // NEW LIST SCREEN
      // ------------------------------------------------------------
      case Screen.newlist:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.save),
            label: '',
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
            label: '',
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
            icon: const Icon(LucideIcons.star),
            label: '',
            onTap: () => Navigator.pushNamed(
              context,
              '/favscreen',
              arguments: {
                'origin': origin,
                'onAddItem': onAddItem, // wichtig!
              },
            ),
          ),
        ];

      // ------------------------------------------------------------
      // FAVORITES SCREEN
      // ------------------------------------------------------------
      case Screen.favorites:
        return [
          // Add Favorite
          NavbarItem(
            icon: const Icon(LucideIcons.plus),
            label: '',
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

          // Home (zweiter Button → verhindert Crash)
          NavbarItem(
            icon: const Icon(LucideIcons.home),
            label: '',
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
        ];

      default:
        return [
          NavbarItem(
            icon: const Icon(LucideIcons.home),
            label: '',
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
