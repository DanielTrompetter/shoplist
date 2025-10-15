import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/main.dart';
import 'package:shoplist/widgets/HomeScreen/buttonbox.dart';
import 'package:shoplist/widgets/HomeScreen/centerrectandlogo.dart';
import 'package:shoplist/widgets/HomeScreen/shoplistcarousell.dart';
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
        icon: ListTypeManager.getIcon(list.iconName),
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
                // const SizedBox(height: 12),
                Text(
                  'ShopList',
                  style: GoogleFonts.inriaSans(
                    fontSize: screenWidth * 0.12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // SizedBox(height: screenWidth*0.1),

                Flexible(flex: 2, child: CenterRect(screenWidth: screenWidth)),
                SizedBox(height: 20),

                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OverflowBox(
                      maxHeight: screenWidth*0.6,
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




