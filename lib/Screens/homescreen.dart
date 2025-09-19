import 'package:flutter/material.dart';
import '../widgets/slbottomnavbar.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  int? get onTap => null;

  @override
  Widget build(BuildContext context) 
  {
    var scaffold = Scaffold
    (
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar
      (
        centerTitle: true,
        title: Text('Shoplist'),
      ),
      bottomNavigationBar: Slbottomnavbar(),
    );
    return scaffold;
  }
}

