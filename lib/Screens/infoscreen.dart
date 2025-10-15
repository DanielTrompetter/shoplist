import 'package:flutter/material.dart';


//#TODO: A lot of Stuff is missing here! Impressum, App Icon and so on
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
            'Infos\n\nHier sollen später Impressum und Version angezeigt werden und was weiss ich noch!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}