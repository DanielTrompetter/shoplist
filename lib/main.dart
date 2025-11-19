import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoplist/app_config.dart'; // dein Config-File
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/DBInterface/shopping_item.dart';
import 'package:shoplist/DBInterface/shopping_list.dart';
import 'package:shoplist/Screens/infoscreen.dart';
import 'package:shoplist/Screens/listscreen.dart';
import 'package:shoplist/Screens/homescreen.dart';
import 'package:shoplist/Screens/newlistscreen.dart';
import 'package:shoplist/Screens/profilescreen.dart';
import 'package:shoplist/Screens/settingsscreen.dart';
import 'package:shoplist/theme/themes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Firebase Optionen
import 'firebase_options.dart' as prod;
import 'firebase_options_dev.dart' as dev;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Init
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Firebase init mit Config-Schalter
  await Firebase.initializeApp(
    options: Config.useFinalFSDB
        ? prod.DefaultFirebaseOptions.currentPlatform
        : dev.DefaultFirebaseOptions.currentPlatform,
  );

  // TypeAdapter registrieren
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ShoppingItemAdapter());

  // Box öffnen
  final box = await Hive.openBox<ShoppingList>('shoppingLists');

  // Firestore Instanz
  final firestore = FirebaseFirestore.instance;

  // DbInterface mit Hive + Firestore
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
