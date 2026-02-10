import 'package:hive/hive.dart';
import 'package:shoplist/data/models/shoppingItem.dart';

part 'favItem.g.dart';

@HiveType(typeId: 2)
class FavItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  FavItem({
    required this.name,
    required this.category,
    this.amount = 1.0,
  });

  FavItem copyWith({
    String? name,
    String? category,
    double? amount,
  }) {
    return FavItem(
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
    );
  }

  // ⭐ FavItem → ShoppingItem (für UI)
  ShoppingItem toShoppingItem() {
    return ShoppingItem(
      name: name,
      category: category,
      amount: amount,
      shopped: false,
    );
  }

  // ⭐ ShoppingItem → FavItem (für Speichern)
  factory FavItem.fromShoppingItem(ShoppingItem item) {
    return FavItem(
      name: item.name,
      category: item.category,
      amount: item.amount,
    );
  }
}
