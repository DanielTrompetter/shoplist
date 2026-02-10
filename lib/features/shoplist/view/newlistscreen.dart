import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/shoppingItem.dart';
import 'package:shoplist/data/models/shoppingList.dart';
import 'package:shoplist/data/repositories/dbinterface.dart';
import 'package:shoplist/features/shoplist/providers/newListProvider.dart';
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
    final newList = ref.watch(newListProvider);

    // Liste nur EINMAL initialisieren
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(newListProvider.notifier);

      if (newList == null && !notifier.initialized) {
        notifier.startNewList(listName, iconName);
      }
    });

    if (newList == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bodyContent = newList.shoppingItems.isEmpty
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
            children: _buildCategoryWidgets(context, ref, newList),
          );

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ListTypeManager.iconMap[newList.iconName] ?? Icons.help_outline,
              color: Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              newList.name,
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
          ref.read(newListProvider.notifier).addItem(item);
        },
        onSaveList: () async {
          await ref.read(newListProvider.notifier).saveList();
          Navigator.pop(context, true); // HomeScreen kann refreshen
        },
      ),
    );
  }

  List<Widget> _buildCategoryWidgets(
      BuildContext context, WidgetRef ref, ShoppingList newList) {
    final groupedItems = <String, List<ShoppingItem>>{};
    for (var item in newList.shoppingItems) {
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
            isNewItem: true,
            isFavoriteMode: false,
            onEdit: () async {
              final editedItem = await showModalBottomSheet<ShoppingItem>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => EditItemPopup(item: item, newItem: true),
              );
              if (editedItem != null) {
                final index = newList.shoppingItems.indexOf(item);
                ref.read(newListProvider.notifier).updateItem(index, editedItem);
              }
            },
            onToggleShopped: () {
              final index = newList.shoppingItems.indexOf(item);
              ref.read(newListProvider.notifier).removeItem(index);
            },
          ),
        );
      });

      return [categoryHeader, ...items];
    }).toList();
  }
}
