import 'package:flutter/material.dart';
import 'package:shoplist/features/home/widgets/carousellbutton.dart';
import 'package:shoplist/features/shoplist/view/newlistscreen.dart';
import 'package:shoplist/shared/widgets/newlistdialog.dart';

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
    final itemSize = (screenWidth * 0.55) + 16;
    final index = (_scrollController.offset / itemSize).round();
    _currentIndex.value = index.clamp(0, widget.shopLists.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Quadratische Buttons
    final double maxButtonWidth = screenWidth * 0.55;
    const double minSize = 110;
    const double maxSize = 180;
    final double buttonSize = maxButtonWidth.clamp(minSize, maxSize);

    final double carouselHeight = buttonSize + 32;

    // Wenn keine Listen existieren
    if (widget.shopLists.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Text(
            "Deine Einkaufslisten...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: ShopListButton(
                title: 'Liste anlegen',
                icon: Icons.add,
                itemCount: 0,
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
              ),
            ),
          ),
        ],
      );
    }

    // Wenn genau eine Liste existiert
    if (widget.shopLists.length == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Deine Einkaufslisten",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: widget.shopLists.first,
            ),
          ),
        ],
      );
    }

    // Normales Karussell
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Deine Einkaufslisten",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

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
                  width: buttonSize,
                  height: buttonSize,
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
