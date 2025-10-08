import 'package:flutter/material.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';

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
    return Row(
      children: [
        // Hauptbutton für Editieren
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: item.shopped ? Colors.grey[300] : Colors.green[100],
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: item.shopped ? 0 : 2,
            ),
            onPressed: onEdit,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 16)),
                Text('x${item.amount}', style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Status-Button mit Häkchen
        SizedBox(
          height: 48,
          width: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: item.shopped ? Colors.red[300] : Colors.green[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
              elevation: 2,
            ),
            onPressed: onToggleShopped,
            child: Icon(
              item.shopped ? Icons.close : Icons.check,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

