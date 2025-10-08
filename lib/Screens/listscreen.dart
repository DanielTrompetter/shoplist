import 'package:flutter/material.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/widgets/listbutton.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingList = ModalRoute.of(context)?.settings.arguments as ShoppingList?;

    if (shoppingList == null) {
      return const Scaffold(
        body: Center(child: Text('Keine Liste übergeben')),
      );
    }
    
    // Gruppiere Items nach Kategorie
    final Map<String, List<ShoppingItem>> groupedItems = {};
    for (var item in shoppingList.shoppingItems) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }

    // Baue die Liste manuell ohne Spread-Operator
    final List<Widget> categoryWidgets = [];

    for (var entry in groupedItems.entries) {
      final category = entry.key;
      final items = entry.value;

      // Kategorie-Trenner
      categoryWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      );

      // Buttons für Items
      for (var item in items) {
        categoryWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListButton(
              item: item,
              onEdit: () {
                // Item bearbeiten
              },
              onToggleShopped: () {
                // Item als gekauft markieren oder zurücksetzen
              },
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categoryWidgets,
      ),
    );
  }
}
