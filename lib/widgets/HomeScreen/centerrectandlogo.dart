// Das ist das weisse Rechteck in der Mitte mit dem rotiertem Bild 
// und dem Button für neue Listen!
// Dank an JP für dieses irre Design und 8h Arbeit! *keif*
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoplist/Screens/newlist.dart';

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
                  spacing: 12.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deine ShopLists in\nder Übersicht',
                      style: GoogleFonts.belanosima(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final TextEditingController controller = TextEditingController();
                        final FocusNode focusNode = FocusNode();

                        final String? listName = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                // Tastatur nach Dialog-Render aktivieren
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  focusNode.requestFocus();
                                });

                                return AlertDialog(
                                  title: const Text('Name der neuen Liste'),
                                  content: TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: 'z.B. Wocheneinkauf',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Abbrechen'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final name = controller.text.trim();
                                        if (name.isNotEmpty) {
                                          Navigator.pop(context, name);
                                        }
                                      },
                                      child: const Text('Erstellen'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                        if (listName != null && listName.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewListScreen(listName: listName),
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
                            offset: const Offset(50, 30),
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