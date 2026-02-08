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
    final screenHeight = MediaQuery.of(context).size.height;

    // 🔵 Dynamische Skalierung
    final isSmall = screenHeight < 700;
    final isMedium = screenHeight < 850;

    final double imageHeight = isSmall
        ? 140
        : isMedium
            ? 180
            : 220;

    final double buttonPaddingV = isSmall ? 10 : 16;
    final double buttonPaddingH = isSmall ? 24 : 40;

    return Column(
      children: [

        // 🔵 Bild mit runden Ecken + Schatten
        Container(
          width: screenWidth,
          height: imageHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(height: 24),

        // 🔵 Button mit Schatten
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8686D7),
              padding: EdgeInsets.symmetric(
                horizontal: buttonPaddingH,
                vertical: buttonPaddingV,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'Neue Liste erstellen',
              style: GoogleFonts.inriaSans(
                fontSize: isSmall ? 14 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(height: isSmall ? 12 : 24),
      ],
    );
  }
}
