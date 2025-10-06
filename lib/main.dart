import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/homescreen.dart';
import 'package:device_preview/device_preview.dart';

final bool useDevicePreview = Platform.isMacOS || Platform.isWindows || Platform.isLinux;

enum Screen
{
  HomeScreen,
  ListScreen
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

class MyApp extends StatelessWidget 
{
  final bool useDevicePreview;
  const MyApp({super.key, required this.useDevicePreview});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'ShopList',
      builder: useDevicePreview ? DevicePreview.appBuilder : null,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        //'/showorders': (context) => OrderScreen(), 
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

