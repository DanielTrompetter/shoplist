import 'package:flutter/material.dart';


//#TODO: A lot of Stuff is missing here! User Picture, Friends, Name and more fields
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Profile\n\nPlatzhalter Screen für deine persönlichen Daten.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}