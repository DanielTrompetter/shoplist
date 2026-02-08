import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplist/app.dart';
import 'package:shoplist/core/app_config.dart';
import 'package:shoplist/data/models/fav_item.dart';
import 'package:shoplist/features/favorites/providers/favprovider.dart';
import 'package:shoplist/shared/widgets/slbottomnavbar.dart';

class FavScreen extends ConsumerWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favoriten'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 4,
        ),
        body: const Center(child: Text('Noch keine Favoriten')),
        bottomNavigationBar: const Slbottomnavbar(origin: Screen.favorites),
      );
    }

    // Gruppiere Favoriten nach Kategorie
    final Map<String, List<FavItem>> groupedItems = {};
    for (var item in favorites) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    final categoryWidgets = groupedItems.entries.map((entry) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            children: [
              ...entry.value.map((item) {
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      final index = favorites.indexOf(item);
                      ref.read(favoritesProvider.notifier).removeFavorite(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('„${item.name}“ wurde entfernt'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        title: const Text('Favoriten'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/Neutral.png', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x03D9D9D9), Color(0xFFC2C2C2)],
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: categoryWidgets,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Slbottomnavbar(
        origin: Screen.favorites,
        onAddItem: (shoppingItem) {
          ref.read(favoritesProvider.notifier).addFavorite(
            FavItem(
              name: shoppingItem.name,
              category: shoppingItem.category,
            ),
          );
        },
      ),
    );
  }
}
