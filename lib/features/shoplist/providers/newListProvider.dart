import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/data/models/shoppingItem.dart';
import 'package:shoplist/data/models/shoppingList.dart';

final newListProvider =
    NotifierProvider<NewListNotifier, ShoppingList?>(NewListNotifier.new);

class NewListNotifier extends Notifier<ShoppingList?> {
  bool initialized = false;

  @override
  ShoppingList? build() {
    return null; // Startzustand: noch keine Liste
  }

  // ------------------------------------------------------------
  // Neue Liste initialisieren (nur EINMAL!)
  // ------------------------------------------------------------
  void startNewList(String name, String iconName) {
    if (initialized) return;

    state = ShoppingList(
      name: name,
      iconName: iconName,
      shoppingItems: [],
    );

    initialized = true;
  }

  // ------------------------------------------------------------
  // Items hinzufügen / bearbeiten / löschen
  // ------------------------------------------------------------
  void addItem(ShoppingItem item) {
    if (state == null) return;

    final updated = [...state!.shoppingItems, item];
    state = state!.copyWith(shoppingItems: updated);
  }

  void updateItem(int index, ShoppingItem item) {
    if (state == null) return;

    final updated = [...state!.shoppingItems];
    updated[index] = item;

    state = state!.copyWith(shoppingItems: updated);
  }

  void removeItem(int index) {
    if (state == null) return;

    final updated = [...state!.shoppingItems]..removeAt(index);
    state = state!.copyWith(shoppingItems: updated);
  }
}
