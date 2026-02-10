import 'package:flutter/material.dart';
import 'package:shoplist/data/models/shoppingItem.dart';
import 'package:shoplist/shared/widgets/squarebutton.dart';

class ListButton extends StatelessWidget {
  final ShoppingItem item;
  final bool isNewItem;

  // Favoriten-Modus
  final bool isFavoriteMode;

  // Aktionen
  final VoidCallback? onEdit;
  final VoidCallback? onToggleShopped;
  final VoidCallback? onAddFavorite;     // Plus
  final VoidCallback? onRemoveFavorite;  // Minus

  const ListButton({
    super.key,
    required this.item,
    required this.isNewItem,
    required this.isFavoriteMode,
    this.onEdit,
    this.onToggleShopped,
    this.onAddFavorite,
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ------------------------------------------------------------
          // FAVORITEN-MODUS: Minus-Button links
          // ------------------------------------------------------------
          if (isFavoriteMode)
            SizedBox(
              width: 56,
              child: SquareButton(
                mode: SquareButtonMode.favRemove,
                isShopped: false,
                onPressed: onRemoveFavorite,
              ),
            ),

          if (isFavoriteMode) const SizedBox(width: 8),

          // ------------------------------------------------------------
          // Hauptbutton
          // ------------------------------------------------------------
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(16),
              elevation: item.shopped ? 0 : 2,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: item.shopped
                      ? const LinearGradient(
                          colors: [Color(0xFFE0E0E0), Color(0xFFB0B0B0)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFC9C9F3), Color(0xFF9696D7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onEdit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'x${item.amount}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ------------------------------------------------------------
          // Rechts: Plus NUR wenn erlaubt
          // ------------------------------------------------------------
          if (isFavoriteMode && onAddFavorite != null)
            SizedBox(
              width: 56,
              child: SquareButton(
                mode: SquareButtonMode.favAdd,
                isShopped: false,
                onPressed: onAddFavorite,
              ),
            ),

          // ------------------------------------------------------------
          // Normaler Listenmodus
          // ------------------------------------------------------------
          if (!isFavoriteMode)
            SizedBox(
              width: 56,
              child: SquareButton(
                mode: SquareButtonMode.list,
                isShopped: isNewItem || item.shopped,
                onPressed: onToggleShopped,
              ),
            ),
        ],
      ),
    );
  }
}
