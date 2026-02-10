import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shoplist/data/models/shoppingList.dart';

final shoppingListProvider =
    NotifierProvider<ShoppingListNotifier, List<ShoppingList>>(
  ShoppingListNotifier.new,
);

class ShoppingListNotifier extends Notifier<List<ShoppingList>> {
  late Box<ShoppingList> box;

  @override
  List<ShoppingList> build() {
    box = Hive.box<ShoppingList>('shoppingLists');
    // immer frisch aus Hive laden
    return box.values.toList();
  }

  void addList(ShoppingList list) {
    box.put(list.name, list);
    state = box.values.toList(); // state ist hier gültig
  }

  void updateList(String name, ShoppingList updated) {
    box.put(name, updated);
    state = box.values.toList();
  }

  void deleteList(String name) {
    box.delete(name);
    state = box.values.toList();
  }
}
