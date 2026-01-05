import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/data/models/shopping_list.dart';
import 'package:shoplist/shared/widgets/listbutton.dart';
import 'package:shoplist/shared/widgets/edititempopup.dart';
import 'package:shoplist/shared/widgets/slbottomnavbar.dart';
import 'package:shoplist/features/shoplist/providers/list_provider.dart'; // <- wichtig!

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! ShoppingList) {
      return const Scaffold(
        body: Center(child: Text('ALARM! Keine ShoppingList übergeben!')),
      );
    }

    final shoppingList = ref.watch(shoppingListProvider);

    // Initialisierung verzögert nach dem ersten Frame
    if (shoppingList.name.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(shoppingListProvider.notifier).initialize(
          name: args.name,
          iconName: args.iconName,
          initialItems: args.shoppingItems,
        );
      });
    }

    if (shoppingList.shoppingItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(shoppingList.name.isEmpty ? args.name : shoppingList.name),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 4,
        ),
        body: const Center(child: Text('Diese Liste ist leer')),
        bottomNavigationBar: const Slbottomnavbar(origin: Screen.homeScreen),
      );
    }

    // Gruppiere Items nach Kategorie
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
              color: Colors.black.withAlpha(20),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            children: [
              ...entry.value.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListButton(
                    item: item,
                    isNewItem: false,
                    onEdit: () async {
                      final editedItem = await showModalBottomSheet<ShoppingItem>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => EditItemPopup(item: item, newItem: false),
                      );
                      if (editedItem != null) {
                        final index = shoppingList.shoppingItems.indexOf(item);
                        ref.read(shoppingListProvider.notifier).editItem(index, editedItem);
                      }
                    },
                    onToggleShopped: () {
                      if (item.shopped) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eintrag löschen'),
                            content: Text('Wirklich „${item.name}“ löschen?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Abbrechen'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(shoppingListProvider.notifier).removeItem(item);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('„${item.name}“ wurde entfernt'),
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Text('Ja'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ref.read(shoppingListProvider.notifier).toggleShopped(item);
                      }
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
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
      bottomNavigationBar: const Slbottomnavbar(origin: Screen.homeScreen),
    );
  }
}
