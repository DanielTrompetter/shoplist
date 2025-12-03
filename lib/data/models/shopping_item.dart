import 'package:hive/hive.dart';

part 'shopping_item.g.dart';

@HiveType(typeId: 0)
class ShoppingItem {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  int amount;

  @HiveField(3)
  bool shopped;

  @HiveField(4)
  bool isRemovable;

  @HiveField(5)
  bool isFavorite;   // <--- NEU

  ShoppingItem({
    required this.name,
    required this.category,
    required this.amount,
    this.shopped = false,
    this.isRemovable = false,
    this.isFavorite = false,   // <--- Default
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'category': category,
        'amount': amount,
        'shopped': shopped,
        'isRemovable': isRemovable,
        'isFavorite': isFavorite,
      };

  factory ShoppingItem.fromMap(Map<String, dynamic> map) => ShoppingItem(
        name: map['name'],
        category: map['category'],
        amount: map['amount'],
        shopped: map['shopped'] ?? false,
        isRemovable: map['isRemovable'] ?? false,
        isFavorite: map['isFavorite'] ?? false,
      );
}
