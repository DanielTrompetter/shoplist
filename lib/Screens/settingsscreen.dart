import 'package:flutter/material.dart';


//#TODO: A lot of Stuff is missing here! Settings, Scheme and more.. and perhaps login?!
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Settings\n\nPlatzhalter für Settings.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}