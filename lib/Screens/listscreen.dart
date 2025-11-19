import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shoplist/DBInterface/shopping_item.dart';
import 'package:shoplist/DBInterface/shopping_list.dart';
import 'package:shoplist/app_config.dart';
import 'package:shoplist/widgets/NewListItem/edititempopup.dart';
import 'package:shoplist/widgets/listbutton.dart';
import 'package:shoplist/widgets/slbottomnavbar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  ShoppingList? shoppingList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ShoppingList) {
      setState(() {
        shoppingList = args;
      });
    } else {
      debugPrint('ALARM! List ist null oder kein ShoppingList-Objekt!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shoppingList == null) {
      return const Scaffold(
        body: Center(child: Text('Lade Liste...')),
      );
    }

    if (shoppingList!.shoppingItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(shoppingList!.name),
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
    for (var item in shoppingList!.shoppingItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    final List<Widget> categoryWidgets = [];
    for (var entry in groupedItems.entries) {
      categoryWidgets.add(
        Container(
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
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Trennstrich weg!
            ),
            // hier kommen die zur jeweiligen Kategorie gehörenden Items in einem ausklappbaren Tile! :-)
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
                  ...entry.value.map((item) {  // map() erzeugt Widgets, das doofe '...' entpackt sie in die children-Liste
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: ListButton(
                      item: item,
                      onEdit: () async {
                        final editedItem = await showModalBottomSheet<ShoppingItem>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => EditItemPopup(item: item, newItem: false), // Item zum editieren übergeben
                        );
                        if (editedItem != null) {
                          setState(() {
                            // Ersetze das alte Item durch das neue
                            final index = shoppingList!.shoppingItems.indexOf(item);
                            if (index != -1) {
                              shoppingList!.shoppingItems[index] = editedItem;
                            }
                          });
                        }
                      },
                      // Switch zwischen geshoppt und löschen! Inklusive tollem Dialog xD
                      onToggleShopped: () {
                        if (item.isRemovable) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eintrag löschen'),
                              content: Text('Wirklich „${item.name}“ löschen?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), // Abbrechen
                                  child: const Text('Abbrechen'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      shoppingList!.shoppingItems.remove(item);
                                    });
                                    Navigator.pop(context); // Dialog schließen
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
                          setState(() {
                            item.shopped = !item.shopped;
                            item.isRemovable = item.shopped;
                          });
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 8), // Abstand unterhalb des letzten Items
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        title: Text(shoppingList!.name),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/Neutral.png', fit: BoxFit.cover),
          ),
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
