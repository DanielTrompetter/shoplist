import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shoplist/core/firebase/firebase_options.dart';
import 'package:shoplist/core/theme/themes.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/data/models/shopping_list.dart';
import 'package:shoplist/data/repositories/dbinterface.dart';

// Screens
import 'package:shoplist/features/home/view/homescreen.dart';
import 'package:shoplist/features/info/view/infoscreen.dart';
import 'package:shoplist/features/profile/view/profilescreen.dart';
import 'package:shoplist/features/settings/view/settingsscreen.dart';
import 'package:shoplist/features/shoplist/view/listscreen.dart';
import 'package:shoplist/features/shoplist/view/newlistscreen.dart';

// Riverpod FutureProvider für DbInterface
final dbProvider = FutureProvider<DbInterface>((ref) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestore = FirebaseFirestore.instanceFor(app: app);

  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ShoppingItemAdapter());
  final box = await Hive.openBox<ShoppingList>('shoppingLists');

  // hier wird die 'factory' genutzt...
  return await DbInterface.create(hiveBox: box, firestore: firestore);
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbAsync = ref.watch(dbProvider);

    return dbAsync.when(
      data: (db) {
      return MaterialApp(
        title: 'ShopList',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(), // ← Startet garantiert den HomeScreen
        routes: {
          '/listscreen': (context) => const ListScreen(),
          '/newlist': (context) => const NewListScreen(listName: '', iconName: ''),
          '/infos': (context) => const InfoScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Fehler beim Initialisieren: $err')),
        ),
      ),
    );
  }
}
