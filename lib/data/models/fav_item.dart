import 'package:hive/hive.dart';

part 'fav_item.g.dart';

@HiveType(typeId: 2)
class FavItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String iconName; // optional, für UI

  FavItem({
    required this.name,
    required this.category,
    this.iconName = '',
  });

  FavItem copyWith({
    String? name,
    String? category,
    String? iconName,
  }) {
    return FavItem(
      name: name ?? this.name,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
    );
  }
}
