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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 20.0),
              child: Container(color: Colors.white.withAlpha(70)),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: height*0.03),
                    SizedBox(
                      height: height * 0.5,
                      child: CenterRect(screenWidth: width),
                    ),
                    SizedBox(height: height*0.05),
                    SizedBox(
                      height: height * 0.4,
                      child: ShopListCaroussel(shopLists: shopListButtons),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const Slbottomnavbar(origin: Screen.homeScreen),
    );
  }
}
