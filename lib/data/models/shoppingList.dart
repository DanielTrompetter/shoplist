import 'package:hive/hive.dart';
import 'package:shoplist/data/models/shoppingItem.dart';

part 'shoppingList.g.dart';

@HiveType(typeId: 1)
class ShoppingList {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String iconName;

  @HiveField(2)
  final List<ShoppingItem> shoppingItems;

  ShoppingList({
    required this.name,
    required this.iconName,
    required this.shoppingItems,
  });

  // ⭐ GENAU DAS HAT DIR GEFELT: EMPTY
  factory ShoppingList.empty() {
    return ShoppingList(
      name: '',
      iconName: '',
      shoppingItems: const [],
    );
  }

  /// Hilfsmethode für Riverpod-State-Updates
  ShoppingList copyWith({
    String? name,
    String? iconName,
    List<ShoppingItem>? shoppingItems,
  }) {
    return ShoppingList(
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      shoppingItems: shoppingItems ?? this.shoppingItems,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'iconName': iconName,
        'shoppingItems': shoppingItems.map((i) => i.toMap()).toList(),
      };

  factory ShoppingList.fromMap(Map<String, dynamic> map) => ShoppingList(
        name: map['name'],
        iconName: map['iconName'],
        shoppingItems: (map['shoppingItems'] as List)
            .map((i) => ShoppingItem.fromMap(i))
            .toList(),
      );
}
