import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/DBInterface/shopping_list.dart';
import 'package:shoplist/app_config.dart';
import 'package:shoplist/main.dart';
import 'package:shoplist/widgets/HomeScreen/centerrectandlogo.dart';
import 'package:shoplist/widgets/HomeScreen/shoplistcarousell.dart';
import 'package:shoplist/widgets/slbottomnavbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ShoppingList>> shoppingLists;

  @override
  void initState() {
    super.initState();
    // DbInterface aus Provider holen
    final db = Provider.of<DbInterface>(context, listen: false);
    shoppingLists = db.loadLists();
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
                    SizedBox(height: height * 0.03),
                    SizedBox(
                      height: height * 0.5,
                      child: CenterRect(screenWidth: width),
                    ),
                    SizedBox(height: height * 0.05),
                    SizedBox(
                      height: height * 0.4,
                      child: FutureBuilder<List<ShoppingList>>(
                        future: this.shoppingLists,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final shoppingLists = snapshot.data!;
                          final shopListButtons = shoppingLists.map((list) {
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

                          return ShopListCaroussel(shopLists: shopListButtons);
                        },
                      ),
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
