import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/main.dart';
import 'package:shoplist/widgets/listbutton.dart';
import 'package:shoplist/widgets/slbottomnavbar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late ShoppingList shoppingList;

  // wenn sich was in der Liste geändert hat, neu holen und rendern!
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as ShoppingList?;
    if (args != null) {
      shoppingList = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shoppingList.shoppingItems.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Keine Liste übergeben')),
      );
    }

    // Gruppiere Items nach Kategorie
    final Map<String, List<ShoppingItem>> groupedItems = {};
    for (var item in shoppingList.shoppingItems) {
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
              onEdit: () {
                // Item bearbeiten
              },
              onToggleShopped: () {
                setState(() {
                  item.shopped = !item.shopped;
                });
              },
            ),
          ),
        );
      }
    }

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
