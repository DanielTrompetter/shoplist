import 'package:flutter/material.dart';

class ShopListCaroussel extends StatefulWidget {
  final List<ShopListButton> shopLists;

  const ShopListCaroussel({super.key, required this.shopLists});

  @override
  State<ShopListCaroussel> createState() => _ShopListCarousselState();
}

class _ShopListCarousselState extends State<ShopListCaroussel> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateIndicator);
  }

  void _updateIndicator() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = screenWidth * 0.6 + 16;
    final index = (_scrollController.offset / itemSize).round();
    _currentIndex.value = index.clamp(0, widget.shopLists.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth * 0.5;
    final buttonHeight = screenHeight * 0.20; // oder 0.3 je nach Geschmack
    final carouselHeight = buttonHeight + 32; // Platz für Schatten + Padding

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: carouselHeight,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            clipBehavior: Clip.none,
            itemCount: widget.shopLists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: widget.shopLists[index],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.shopLists.length, (index) {
                final isActive = index == value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
        ),
      ],
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
