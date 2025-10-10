import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/main.dart';
import 'package:shoplist/widgets/bigbutton.dart';
import 'package:shoplist/widgets/slbottomnavbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DbInterface db;
  late List<ShoppingList> shoppingLists;
  late List<ShopListButton> shopListButtons;

  @override
  void initState() {
    super.initState();

    // Initialisierung
    db = DbInterface();
    shoppingLists = db.shoppinglists;

    // Buttons aus den ShoppingLists generieren
    shopListButtons = shoppingLists.map((list) {
      return ShopListButton(
        title: list.name,
        icon: IconFactory.getIcon(list.iconName),
        itemCount: list.shoppingItems.length,
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/listscreen',
            arguments: list,
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Shoplist'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/Neutral.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x03D9D9D9), // 1% Alpha
                    Color(0xFFC2C2C2), // 100% Alpha
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 20.0),
              child: Container(color: Colors.white.withAlpha(70)),
            ),
          ),
          SafeArea(
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

                Flexible(flex: 2, child: CenterRect(screenWidth: screenWidth)),
                const SizedBox(height: 16),

                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OverflowBox(
                      maxHeight: 240,
                      alignment: Alignment.topCenter,
                      child: ShopListCaroussel(shopLists: shopListButtons),
                    ),
                  ),
                ),
                // die beiden großen Buttons unten!
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: const Buttonbox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Slbottomnavbar(origin: Screen.homeScreen),
    );
  }
}

class Buttonbox extends StatelessWidget {
  const Buttonbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(70, 69, 69, 69),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: BigButton(
                icon: Icons.group,
                label: 'Mitglieder',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BigButton(
                icon: Icons.star,
                label: 'Favoriten verwalten',
              ),
            ),
          ],
        ),
      ),
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
                      onPressed: () {},
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

// Das Karussell in dem man die Listen auswählen kann
class ShopListCaroussel extends StatelessWidget {
  final List<ShopListButton> shopLists;

  const ShopListCaroussel({super.key, required this.shopLists});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: shopLists.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16), // Abstand zwischen Buttons
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16), // schiebt Button nach oben
            child: AspectRatio(
              aspectRatio: 1.0, // quadratisch
              child: SizedBox(
                width: screenWidth * 0.6,
                child: shopLists[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Das sind die großen Buttons im Karussell!
class ShopListButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final int itemCount;
  final VoidCallback onPressed;

  const ShopListButton({
    super.key,
    required this.title,
    required this.icon,
    required this.itemCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFADD8E6), // Startfarbe
                Color(0xFFF4F4F4), // Endfarbe
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.black),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(100, 0xFC, 0xFB, 0xFB),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.list_alt, size: 16, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        '$itemCount Gegenstände',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




