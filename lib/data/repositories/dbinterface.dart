import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hive/hive.dart';

import 'package:shoplist/data/models/shoppingList.dart';
import 'package:shoplist/data/models/favItem.dart';

class ListTypeManager {
  static final Map<String, IconData> iconMap = {
    'users': LucideIcons.users,
    'tent': LucideIcons.tent,
    'Drogerie': LucideIcons.flaskConical,
    'beer': LucideIcons.beer,
  };

  static IconData getIcon(String name) =>
      iconMap[name] ?? LucideIcons.helpCircle;
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

/// ------------------------------------------------------------
/// DbInterface – jetzt NUR noch zum Öffnen der Hive-Boxen.
/// ------------------------------------------------------------
class DbInterface {
  final Box<ShoppingList> hiveBox;

  DbInterface._({
    required this.hiveBox,
  });

  /// Wird einmal beim App-Start über Riverpod geladen
  static Future<DbInterface> create() async {
    // Favoriten-Box öffnen
    await Hive.openBox<FavItem>('favorites');

    // ShoppingLists-Box öffnen
    final hiveBox = await Hive.openBox<ShoppingList>('shoppingLists');

    return DbInterface._(
      hiveBox: hiveBox,
    );
  }
}
