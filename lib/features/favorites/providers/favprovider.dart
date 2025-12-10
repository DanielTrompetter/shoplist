import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shoplist/data/models/fav_item.dart';

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
    box.add(item);
    state = box.values.toList();
  }

  void removeFavorite(int index) {
    box.deleteAt(index);
    state = box.values.toList();
  }
}
