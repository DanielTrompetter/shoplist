import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Über die App')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Shoplist\n\nMit dieser App kannst du deine Einkaufsliste verwalten.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}