import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/main.dart';
import 'package:shoplist/widgets/NewListItem/edititempopup.dart';
import 'package:shoplist/widgets/listbutton.dart';
import 'package:shoplist/widgets/slbottomnavbar.dart';

class NewListScreen extends StatefulWidget {
  final String listName;
  final String iconName;

  const NewListScreen({super.key, required this.listName, required this.iconName});

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}


class _NewListScreenState extends State<NewListScreen> {
  late ShoppingList newShoppingList;

  void addItem(ShoppingItem item) {
    setState(() {
      item.isRemovable = true;
      newShoppingList.shoppingItems.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    newShoppingList = ShoppingList(
      name: widget.listName,
      iconName: widget.iconName,
      shoppingItems: [],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = newShoppingList.shoppingItems.isEmpty;

    final bodyContent = isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
                Icon(
                  Icons.arrow_downward,
                  size: 64,
                  color: Colors.grey,
                ),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: _buildCategoryWidgets(),
          );

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      //Appbar mit Namen der Liste und dem Icon links neben dem Namen
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ListTypeManager.iconMap[newShoppingList.iconName] ?? Icons.help_outline,
              color: Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              newShoppingList.name,
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
          SafeArea(child: bodyContent),
        ],
      ),
      bottomNavigationBar: Slbottomnavbar(
        origin: Screen.newlist,
        onAddItem: addItem,
        onSaveList: () {
          if (newShoppingList.shoppingItems.isNotEmpty) {
            DbInterface().shoppinglists.add(newShoppingList);
          }
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }

  List<Widget> _buildCategoryWidgets() {
    final Map<String, List<ShoppingItem>> groupedItems = {};
    for (var item in newShoppingList.shoppingItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    final List<Widget> categoryWidgets = [];

    for (var entry in groupedItems.entries) {
      categoryWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            entry.key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );

      for (var item in entry.value) {
        categoryWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListButton(
              item: item,
              onEdit: () async {
                final editedItem = await showModalBottomSheet<ShoppingItem>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => EditItemPopup(item: item, newItem: true), // Item zum editieren übergeben
                );
                if (editedItem != null) {
                  setState(() {
                    // Ersetze das alte Item durch das neue
                    final index = newShoppingList.shoppingItems.indexOf(item);
                    if (index != -1) {
                      newShoppingList.shoppingItems[index] = editedItem;
                    }
                  });
                }
              },
              onToggleShopped: () {
                setState(() {
                    newShoppingList.shoppingItems.remove(item); // wirklich löschen
                });
              },
            ),
          ),
        );
      }
    }
    return categoryWidgets;
  }
}
