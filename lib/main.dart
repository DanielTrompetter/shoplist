import 'package:flutter/material.dart';
import 'Screens/homescreen.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopList',
      builder: DevicePreview.appBuilder,
      home: const HomeScreen(),
    );
  }
}

