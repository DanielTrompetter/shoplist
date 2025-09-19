import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Slbottomnavbar extends StatelessWidget {
  const Slbottomnavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar
    (
      // erstmal alles off, weil diese Pages kommen später!
      // currentIndex: 0,
      // selectedItemColor: Colors.green[700],
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 10,
      items:  
      [
        bottomnavitem(index: 0, icon: Icon(LucideIcons.info), label: 'Info'),
        bottomnavitem(index: 1, icon: Icon(LucideIcons.user), label: 'Profil'),
        bottomnavitem(index: 2, icon: Icon(LucideIcons.settings), label: 'Einstellungen'),
      ],
    );
  }

  // index schon vorbereitet für spätere Nutzung in onTap!
  BottomNavigationBarItem bottomnavitem({required int index, required Icon icon, required String label}) {
    return BottomNavigationBarItem(
        icon: icon,
        label: label,
      );
  }
}
