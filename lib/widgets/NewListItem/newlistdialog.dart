import 'package:flutter/material.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';

class NewListDialog extends StatefulWidget {
  const NewListDialog({super.key});

  @override
  State<NewListDialog> createState() => _NewListDialogState();
}

class _NewListDialogState extends State<NewListDialog> {
  final TextEditingController nameController = TextEditingController();
  String selectedIcon = ListTypeManager.iconMap.keys.first;

  @override
  Widget build(BuildContext context) {
    final iconChoices = ListTypeManager.iconMap.entries.toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Neue Liste erstellen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Name-Eingabe
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'z.B. Wocheneinkauf'),
            ),

            const SizedBox(height: 16),

            // Icon-Karussell
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: iconChoices.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final entry = iconChoices[index];
                  final isSelected = entry.key == selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => selectedIcon = entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(entry.value, color: isSelected ? Colors.white : Colors.black),
                          const SizedBox(width: 6),
                          Text(
                            entry.key,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Buttons unten
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      Navigator.pop(context, (name, selectedIcon));
                    }
                  },
                  child: const Text('Erstellen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
