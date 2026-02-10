import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:shoplist/data/models/favItem.dart';
import 'package:shoplist/data/models/shoppingItem.dart';
import 'package:shoplist/data/models/shoppingList.dart';
import 'package:shoplist/app.dart';
import 'package:shoplist/features/shoplist/providers/favprovider.dart'; // ⭐ wichtig

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // ✔ Adapter registrieren – WICHTIG: vor ProviderScope!
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ShoppingItemAdapter());
  Hive.registerAdapter(FavItemAdapter());

  await Hive.openBox<FavItem>('favorites');
  await Hive.openBox<ShoppingList>('shoppingLists');

  final container = ProviderContainer();
  container.read(favoritesProvider);

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
