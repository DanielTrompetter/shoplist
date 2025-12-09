import 'package:hive/hive.dart';

part 'shopping_item.g.dart';

@HiveType(typeId: 0)
class ShoppingItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final int amount;

  @HiveField(3)
  final bool shopped;

  @HiveField(4)
  final bool isRemovable;

  @HiveField(5)
  final bool isFavorite;   // <--- NEU

  ShoppingItem({
    required this.name,
    required this.category,
    required this.amount,
    this.shopped = false,
    this.isRemovable = false,
    this.isFavorite = false,   // <--- Default
  });

  /// Hilfsmethode für Riverpod-State-Updates
  ShoppingItem copyWith({
    String? name,
    String? category,
    int? amount,
    bool? shopped,
    bool? isRemovable,
    bool? isFavorite,
  }) {
    return ShoppingItem(
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      shopped: shopped ?? this.shopped,
      isRemovable: isRemovable ?? this.isRemovable,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

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
