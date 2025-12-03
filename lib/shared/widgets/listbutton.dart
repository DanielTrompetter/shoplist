import 'package:flutter/material.dart';
import 'package:shoplist/data/models/shopping_item.dart';
import 'package:shoplist/shared/widgets/squarebutton.dart';

class ListButton extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleShopped;

  const ListButton({
    super.key,
    required this.item,
    this.onEdit,
    this.onToggleShopped,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hauptbutton mit Gradient
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 24, color: Colors.black87)),
                        Text('x${item.amount}', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Quadratischer Switch-Button, gekauft oder x für kann weg! xD
          SizedBox(
            width: 56,
            child: SquareButton(
              isShopped: item.shopped,
              isRemovable: item.isRemovable,
              onPressed: onToggleShopped,
            ),
          ),
        ],
      ),
    );
  }
}
