import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'info_screen.dart'; // Import hinzufügen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
{
  int selectedIndex = 1; // Startet jetzt auf Profil

  // Füge die pages-Liste wieder hinzu:
  final List<Widget> pages = [
    // Platzhalter für Info, wird nie angezeigt
    SizedBox.shrink(),
    Center(child: Text('Profil-Seite')),
    Center(child: Text('Einstellungen')),
  ];

  void onTap(int index) {
    if (index == 0) {
      // Info-Screen anzeigen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const InfoScreen()),
      );
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar
      (
        title: Text('Shoplist'),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: selectedIndex,
        onTap: onTap,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const 
        [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }
}
