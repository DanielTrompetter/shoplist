// Das ist das weisse Rechteck in der Mitte mit dem rotiertem Bild 
// und dem Button für neue Listen!
// Dank an JP für dieses irre Design und 8h Arbeit! *keif*
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoplist/features/shoplist/view/newlistscreen.dart';
import 'package:shoplist/shared/widgets/newlistdialog.dart';

class CenterRect extends StatelessWidget {
  const CenterRect({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8), // Clipping für das gesamte Rect
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: screenWidth * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deine\nEinkaufslisten in der Übersicht',
                      style: GoogleFonts.belanosima(
                      fontSize: screenWidth * 0.07,
                      color: Colors.black87,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await showDialog<(String, String)>(
                          context: context,
                          builder: (context) => const NewListDialog(),
                        );

                        if (result != null) {
                          final (name, iconName) = result;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewListScreen(
                                listName: name,
                                iconName: iconName,
                              ),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color(0xFF8686D7)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Text(
                        'Neue Liste erstellen',
                        style: GoogleFonts.inriaSans(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Transform.translate(
                            offset: const Offset(80, 10),
                            child: Transform.rotate(
                              angle: -30 * (pi / 180),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12), // Bild-eigene Rundung
                                child: Image.asset(
                                  'assets/Title.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}