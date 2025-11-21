import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/DBInterface/shopping_item.dart';
import 'package:shoplist/DBInterface/shopping_list.dart';
import 'package:shoplist/Screens/homescreen.dart';
import 'package:shoplist/Screens/infoscreen.dart';
import 'package:shoplist/Screens/listscreen.dart';
import 'package:shoplist/Screens/newlistscreen.dart';
import 'package:shoplist/Screens/profilescreen.dart';
import 'package:shoplist/Screens/settingsscreen.dart';
import 'package:shoplist/theme/themes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Firebase Optionen (nur Prod)
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Init
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Firebase Init – immer Prod
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialisiert: ${app.name}");

  // Firestore Instanz explizit mit App binden
  final firestore = FirebaseFirestore.instanceFor(app: app);

  // Hive Adapter + Box
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ShoppingItemAdapter());
  final box = await Hive.openBox<ShoppingList>('shoppingLists');

  final db = DbInterface(hiveBox: box, firestore: firestore);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    Provider<DbInterface>.value(
      value: db,
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopList',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/listscreen': (context) => const ListScreen(),
        '/newlist': (context) => const NewListScreen(listName: '', iconName: ''),
        '/infos': (context) => const InfoScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
