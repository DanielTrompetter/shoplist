import 'package:shoplist/config.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ListTypeManager {
  static final Map<String, IconData> iconMap = {
    'users': LucideIcons.users,
    'tent': LucideIcons.tent,
    'Drogerie': LucideIcons.flaskConical,
    'beer': LucideIcons.beer,
  };

  static IconData getIcon(String name) {
    return iconMap[name] ?? LucideIcons.helpCircle; // fallback
  }
}

class CategoryManager {
  static final Map<String, IconData> categoryIcons = {
    'Lebensmittel': LucideIcons.utensils,
    'Drogerie': LucideIcons.flaskConical,
    'Getränke': LucideIcons.beer,
    'Snacks': LucideIcons.cookie,
    'Gemüse': LucideIcons.salad,
  };

  static IconData getIcon(String category) =>
      categoryIcons[category] ?? LucideIcons.helpCircle;
}

class ShoppingItem {
  String name;
  String category;
  int amount;
  bool shopped;

  ShoppingItem({
    required this.name,
    required this.category,
    required this.amount,
    this.shopped = false,
  });
}

class ShoppingList{
  String name;
  String iconName;
  List<ShoppingItem> shoppingItems;

  ShoppingList({
    required this.name, 
    required this.iconName, 
    required this.shoppingItems
  });
}

class DbInterface {
  List<ShoppingList> shoppinglists = [];

  DbInterface() {
    if (Config.dbBaseUrl.isEmpty) {
      shoppinglists = _generateFakeLists();
    }
  }

  List<ShoppingList> _generateFakeLists() {
    return [
      ShoppingList(
        name: 'Familie',
        iconName: 'users',
        shoppingItems: [
          ShoppingItem(name: 'Milch', category: 'Lebensmittel', amount: 2),
          ShoppingItem(name: 'Windeln', category: 'Drogerie', amount: 1),
          ShoppingItem(name: 'Toastbrot', category: 'Lebensmittel', amount: 1),
          ShoppingItem(name: 'Waschmittel', category: 'Drogerie', amount: 1),
          ShoppingItem(name: 'Äpfel', category: 'Obst & Gemüse', amount: 6),
        ],
      ),
      ShoppingList(
        name: 'Camping',
        iconName: 'tent',
        shoppingItems: [
          ShoppingItem(name: 'Gaskartusche', category: 'Outdoor', amount: 2),
          ShoppingItem(name: 'Brot', category: 'Lebensmittel', amount: 4),
          ShoppingItem(name: 'Margarine', category: 'Lebensmittel', amount: 4),
          ShoppingItem(name: 'Instant-Nudeln', category: 'Lebensmittel', amount: 4),
          ShoppingItem(name: 'Feuchttücher',  category: 'Drogerie', amount: 1),
          ShoppingItem(name: 'Mückenspray',  category: 'Drogerie', amount: 1),
          ShoppingItem(name: 'Wasserflaschen',  category: 'Getränke', amount: 6),
          ShoppingItem(name: 'Bananen', category: 'Obst & Gemüse', amount: 6),
          ShoppingItem(name: 'Grillfleisch', category: 'Fleisch', amount: 6),
          ShoppingItem(name: 'Würstchen', category: 'Fleisch', amount: 20),
          ShoppingItem(name: 'Bier', category: 'Getränke', amount: 20),
        ],
      ),
      ShoppingList(
        name: 'Freunde',
        iconName: 'beer',
        shoppingItems: [
          ShoppingItem(name: 'Chips', category: 'Snacks', amount: 3),
          ShoppingItem(name: 'Bier', category: 'Getränke', amount: 12),
          ShoppingItem(name: 'Cola', category: 'Getränke', amount: 6),
          ShoppingItem(name: 'Eiswürfel', category: 'Sonstiges', amount: 2),
          ShoppingItem(name: 'Servietten', category: 'Haushalt', amount: 1),
        ],
      ),
    ];
  }
}

