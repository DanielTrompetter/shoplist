import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/shoppingItem.dart';
import 'package:shoplist/data/models/shoppingList.dart';
import 'package:shoplist/data/repositories/dbProvider.dart';
import 'package:shoplist/shared/widgets/listbutton.dart';
import 'package:shoplist/shared/widgets/edititempopup.dart';
import 'package:shoplist/shared/widgets/slbottomnavbar.dart';
import 'package:shoplist/features/shoplist/providers/shoppingListprovider.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! String) {
      return const Scaffold(
        body: Center(child: Text('Keine Listen-ID übergeben!')),
      );
    }

    final listName = args;
    final allLists = ref.watch(shoppingListProvider);

    // passende Liste finden
    final shoppingList =
        allLists.firstWhere((l) => l.name == listName, orElse: () => ShoppingList.empty());

    if (shoppingList.name.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(listName),
          centerTitle: true,
        ),
        body: const Center(child: Text('Liste nicht gefunden')),
      );
    }

    // Gruppieren nach Kategorie
    final Map<String, List<ShoppingItem>> groupedItems = {};
    for (var item in shoppingList.shoppingItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    final categoryWidgets = groupedItems.entries.map((entry) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            entry.key,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            ...entry.value.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: ListButton(
                  item: item,
                  isNewItem: false,
                  isFavoriteMode: false,

                  onEdit: () async {
                    final editedItem = await showModalBottomSheet<ShoppingItem>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => EditItemPopup(item: item, newItem: false),
                    );

                    if (editedItem != null) {
                      final updatedItems = [...shoppingList.shoppingItems];
                      final index = updatedItems.indexOf(item);
                      updatedItems[index] = editedItem;

                      final updatedList = shoppingList.copyWith(
                        shoppingItems: updatedItems,
                      );

                      ref.read(shoppingListProvider.notifier)
                          .updateList(shoppingList.name, updatedList);
                    }
                  },

                  onToggleShopped: () {
                    final updatedItems = [...shoppingList.shoppingItems];
                    final index = updatedItems.indexOf(item);
                    updatedItems[index] = item.copyWith(shopped: !item.shopped);

                    final updatedList = shoppingList.copyWith(
                      shoppingItems: updatedItems,
                    );

                    ref.read(shoppingListProvider.notifier)
                        .updateList(shoppingList.name, updatedList);
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        title: Text(shoppingList.name),
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
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: categoryWidgets,
            ),
          ),
        ],
      ),

      bottomNavigationBar: Slbottomnavbar(
        origin: Screen.listScreen,

        // ← Das hat vorher gefehlt!
        onAddItem: (ShoppingItem item) {
          final updatedItems = [...shoppingList.shoppingItems, item];

          final updatedList = shoppingList.copyWith(
            shoppingItems: updatedItems,
          );

          ref.read(shoppingListProvider.notifier)
              .updateList(shoppingList.name, updatedList);
        },

        onDeleteList: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Liste löschen?"),
                content: const Text("Willst du diese Liste wirklich löschen?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Abbrechen"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Löschen!"),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            ref.read(shoppingListProvider.notifier).deleteList(shoppingList.name);
            Navigator.pop(context, true);
          }
        },
      ),
    );
  }
}
