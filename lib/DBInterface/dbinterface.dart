import 'package:shoplist/DBInterface/shopping_list.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    'Fleisch': LucideIcons.drumstick,
  };

  static IconData getIcon(String category) =>
      categoryIcons[category] ?? LucideIcons.helpCircle;
}

/// DbInterface mit Hive + Firestore Sync
class DbInterface {
  final Box<ShoppingList> hiveBox;
  final FirebaseFirestore? firestore;

  DbInterface({required this.hiveBox, required this.firestore}) {
    // Firestore Listener starten wenn != null, dann Änderungen anderer User zurück ins lokale Hive
    if(firestore != null)
    {
      firestore!.collection('shoppingLists').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        var list = ShoppingList.fromMap(doc.data());
        hiveBox.put(list.name, list);
        }
      });
    }
  }

  Future<List<ShoppingList>> loadLists() async {
    return hiveBox.values.toList();
  }

  Future<void> saveList(ShoppingList list) async {
    // Lokal speichern
    await hiveBox.put(list.name, list);

    // Cloud speichern
    if(firestore != null)
    {
      await firestore!.collection('shoppingLists').doc(list.name).set(list.toMap());
    }
  }

  Future<void> deleteList(String name) async {
    await hiveBox.delete(name);
    if(firestore != null)
    {
      await firestore!.collection('shoppingLists').doc(name).delete();
    }
  }
}
