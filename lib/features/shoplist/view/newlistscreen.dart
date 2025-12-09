import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/data/models/shopping_list.dart';
import 'package:shoplist/data/repositories/dbinterface.dart';
import 'package:shoplist/app.dart';
import 'package:shoplist/features/shoplist/providers/list_provider.dart';
import 'package:shoplist/shared/widgets/listbutton.dart';
import 'package:shoplist/shared/widgets/edititempopup.dart';
import 'package:shoplist/shared/widgets/slbottomnavbar.dart';

class NewListScreen extends ConsumerWidget {
  final String listName;
  final String iconName;

  const NewListScreen({
    super.key,
    required this.listName,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State aus dem Notifier lesen
    final shoppingList = ref.watch(shoppingListProvider);

    // Initialisierung einmalig setzen
    if (shoppingList.name.isEmpty) {
      ref.read(shoppingListProvider.notifier)
          .initialize(name: listName, iconName: iconName);
    }

    final bodyContent = shoppingList.shoppingItems.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Noch keine Einträge in dieser Liste',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Füge mit dem + Button unten neue Items hinzu!',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Icon(Icons.arrow_downward, size: 64, color: Colors.grey),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: _buildCategoryWidgets(context, ref, shoppingList),
          );

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ListTypeManager.iconMap[shoppingList.iconName] ?? Icons.help_outline,
              color: Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              shoppingList.name,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/Neutral.png', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x03D9D9D9), Color(0xFFC2C2C2)],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 20.0),
              child: Container(color: Colors.white.withAlpha(70)),
            ),
          ),
          SafeArea(child: bodyContent),
        ],
      ),
      bottomNavigationBar: Slbottomnavbar(
        origin: Screen.newlist,
        onAddItem: (item) {
          ref.read(shoppingListProvider.notifier).addItem(item);
        },
        onSaveList: () async {
          if (shoppingList.shoppingItems.isNotEmpty) {
            final db = await ref.read(dbProvider.future);
            await db.saveList(shoppingList);
          }
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }

  List<Widget> _buildCategoryWidgets(
      BuildContext context, WidgetRef ref, ShoppingList shoppingList) {
    final groupedItems = <String, List<ShoppingItem>>{};
    for (var item in shoppingList.shoppingItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return groupedItems.entries.expand((entry) {
      final categoryHeader = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(entry.key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

      final items = entry.value.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListButton(
            item: item,
            onEdit: () async {
              final editedItem = await showModalBottomSheet<ShoppingItem>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => EditItemPopup(item: item, newItem: true),
              );
              if (editedItem != null) {
                final index = shoppingList.shoppingItems.indexOf(item);
                final newItems = [...shoppingList.shoppingItems];
                newItems[index] = editedItem;
                ref.read(shoppingListProvider.notifier).editItem(index, editedItem);
              }
            },
            onToggleShopped: () {
              ref.read(shoppingListProvider.notifier).toggleShopped(item);
            },
          ),
        );
      });

      return [categoryHeader, ...items];
    }).toList();
  }
}
