import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'Screens/homescreen.dart';
import 'package:device_preview/device_preview.dart';

final bool useDevicePreview = Platform.isMacOS || Platform.isWindows || Platform.isLinux;

void main() {
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
      home: HomeScreen(),
    );
  }
}

