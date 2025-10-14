// Das Karussell in dem man die Listen auswählen kann
import 'package:flutter/material.dart';

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
