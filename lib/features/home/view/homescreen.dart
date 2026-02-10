import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/shoppingList.dart';
import 'package:shoplist/app.dart';
import 'package:shoplist/data/repositories/dbinterface.dart';
import 'package:shoplist/features/home/widgets/carousellbutton.dart';
import 'package:shoplist/features/home/widgets/centerrectandlogo.dart';
import 'package:shoplist/features/home/widgets/shoplistcarousell.dart';
import 'package:shoplist/shared/widgets/slbottomnavbar.dart';
import 'package:shoplist/features/shoplist/providers/shoppingListprovider.dart';
import 'package:shoplist/shared/widgets/newlistdialog.dart';
import 'package:shoplist/features/shoplist/view/newlistscreen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ⭐ Provider ist jetzt die einzige Quelle für Listen
    final shoppingLists = ref.watch(shoppingListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Willkommen zu Shoplist'),
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

              // ⭐ Buttons aus Provider-Daten erzeugen
              final shopListButtons = shoppingLists.map((list) {
                return ShopListButton(
                  title: list.name,
                  icon: ListTypeManager.getIcon(list.iconName),
                  itemCount: list.shoppingItems.length,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/listscreen',
                      arguments: list.name, // ⭐ WICHTIG: Name als String
                    );
                  },
                );
              }).toList();

              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.03),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CenterRect(screenWidth: width),
                    ),

                    const SizedBox(height: 4),
                    Divider(
                      thickness: 1.2,
                      color: Colors.black26,
                      indent: 32,
                      endIndent: 32,
                    ),
                    const SizedBox(height: 4),

                    Expanded(
                      child: ShopListCaroussel(
                        shopLists: shopListButtons,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: const Slbottomnavbar(
        origin: Screen.homeScreen,
      ),
    );
  }
}
