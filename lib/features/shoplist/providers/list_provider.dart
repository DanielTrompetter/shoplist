import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/data/models/shopping_list.dart';

class ShoppingListNotifier extends Notifier<ShoppingList> {
  @override
  ShoppingList build() {
    // Leerer Default-State; wird nach dem Erstellen via initialize() gesetzt.
    return ShoppingList(name: '', iconName: '', shoppingItems: []);
  }

  // Einmalige Initialisierung (z. B. beim Screen-Aufbau)
  void initialize({required String name, required String iconName, List<ShoppingItem> initialItems = const []}) {
    state = ShoppingList(name: name, iconName: iconName, shoppingItems: [...initialItems]);
  }

  void addItem(ShoppingItem item) {
    final newItem = item.copyWith(isRemovable: true);
    state = state.copyWith(shoppingItems: [...state.shoppingItems, newItem]);
  }

  void editItem(int index, ShoppingItem newItem) {
    final items = [...state.shoppingItems];
    items[index] = newItem;
    state = state.copyWith(shoppingItems: items);
  }

  void removeItem(ShoppingItem item) {
    final items = [...state.shoppingItems]..remove(item);
    state = state.copyWith(shoppingItems: items);
  }

  void toggleShopped(ShoppingItem item) {
    final items = [...state.shoppingItems];
    final index = items.indexOf(item);
    if (index != -1) {
      final updated = items[index].copyWith(
        shopped: !items[index].shopped,
        isRemovable: !items[index].shopped,
      );
      items[index] = updated;
      state = state.copyWith(shoppingItems: items);
    }
  }
}

/// Riverpod 3: NotifierProvider (ohne Family), autoDispose optional
final shoppingListProvider =
    NotifierProvider.autoDispose<ShoppingListNotifier, ShoppingList>(ShoppingListNotifier.new);
