import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoplist/widgets/bigbutton.dart';
import '../widgets/Slbottomnavbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Shoplist'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              'ShopList',
              style: GoogleFonts.inriaSans(
                fontSize: screenWidth * 0.12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              flex: 3,
              child: CenterRect(screenWidth: screenWidth),
            ),
            const SizedBox(height: 16),
            const Flexible(
              flex: 3,
              child: ShopListCaroussel(),
            ),
            const SizedBox(height: 16),
            Buttonbox(),
          ],
        ),
      ),
      bottomNavigationBar: const Slbottomnavbar(),
    );
  }
}

class Buttonbox extends StatelessWidget {
  const Buttonbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Bigbutton(
                icon: Icons.group,
                label: 'Mitglieder',
              ),
              SizedBox(height: 12),
              Bigbutton(
                icon: Icons.star,
                label: 'Favoriten verwalten',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Das Karussell in dem man die Listen auswählen kann
class ShopListCaroussel extends StatelessWidget {
  const ShopListCaroussel({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade600),
            ),
            child: Center(
              child: Text(
                'Item ${index + 1}',
                style: GoogleFonts.inriaSans(
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


// Das ist das weisse Rechteck in der Mitte mit dem rotiertem Bild 
// und dem Button für neue Listen!
// Dank an JP für dieses irre Design und 8h Arbeit! *keif*
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
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Deine ShopLists in\nder Übersicht',
                //       style: GoogleFonts.belanosima(
                //         fontSize: screenWidth * 0.05,
                //         color: Colors.black87,
                //       ),
                //     ),
                //     const SizedBox(height: 8),
                //     ElevatedButton(
                //       onPressed: () {},
                //       style: ButtonStyle(
                //         backgroundColor: WidgetStateProperty.all(const Color(0xFF8686D7)),
                //         shape: WidgetStateProperty.all(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(4),
                //           ),
                //         ),
                //       ),
                //       child: Text(
                //         'Neue Liste erstellen',
                //         style: GoogleFonts.inriaSans(
                //           fontSize: screenWidth * 0.035,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
            Expanded(
              child: ClipRect( // 👈 Clipping auf Stack-Ebene
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: const Offset(80, 20),
                          child: Transform.rotate(
                            angle: -30 * (pi / 180),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/Title.png',
                                fit: BoxFit.contain,
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



