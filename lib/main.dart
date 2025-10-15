import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoplist/Screens/infoscreen.dart';
import 'package:shoplist/Screens/listscreen.dart';
import 'package:shoplist/Screens/homescreen.dart';
import 'package:shoplist/Screens/newlistscreen.dart';
import 'package:shoplist/Screens/profilescreen.dart';
import 'package:shoplist/Screens/settingsscreen.dart';
import 'package:shoplist/theme/themes.dart';
import 'package:device_preview/device_preview.dart';

final bool useDevicePreview = Platform.isMacOS || Platform.isWindows || Platform.isLinux;

enum Screen {
  homeScreen,
  listScreen,
  newlist,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (useDevicePreview) {
    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(useDevicePreview: true),
      ),
    );
  } else {
    runApp(const MyApp(useDevicePreview: false));
  }
}

class MyApp extends StatelessWidget {
  final bool useDevicePreview;
  const MyApp({super.key, required this.useDevicePreview});

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
        '/listscreen': (context) => const ListScreen(), // wichtig: const oder ohne Argumente
        '/newlist': (context) => const NewListScreen(listName: '', iconName: '',),
        '/infos': (context) => const InfoScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
