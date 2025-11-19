import 'package:hive/hive.dart';
import 'package:shoplist/DBInterface/shopping_item.dart';

part 'shopping_list.g.dart';

@HiveType(typeId: 1)
class ShoppingList {
  @HiveField(0)
  String name;

  @HiveField(1)
  String iconName;

  @HiveField(2)
  List<ShoppingItem> shoppingItems;

  ShoppingList({
    required this.name,
    required this.iconName,
    required this.shoppingItems,
  });

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
