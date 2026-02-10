import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shoplist/data/models/favItem.dart';

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<FavItem>>(FavoritesNotifier.new);

class FavoritesNotifier extends Notifier<List<FavItem>> {
  late Box<FavItem> box;

  @override
  List<FavItem> build() {
    box = Hive.box<FavItem>('favorites');
    return box.values.toList();
  }

  void addFavorite(FavItem item) {
    box.add(item); // ✔ int-Key, konsistent
    state = box.values.toList();
  }

  void editFavorite(int index, FavItem updated) {
    box.putAt(index, updated); // ✔ int-Key bleibt int-Key
    state = box.values.toList();
  }

  void removeFavorite(int index) {
    box.deleteAt(index); // ✔ int-Key löschen
    state = box.values.toList();
  }
}
