import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoplist/DBInterface/dbinterface.dart';
import 'package:shoplist/DBInterface/shopping_item.dart';
import 'package:shoplist/widgets/NewListItem/categorycarousselitem.dart';
import 'package:shoplist/widgets/smallbutton.dart';

class EditItemPopup extends StatefulWidget {
  final ShoppingItem? item; // optionaler Parameter zum editieren
  final bool newItem;

  const EditItemPopup({super.key, required this.item, required this.newItem});

  @override
  State<EditItemPopup> createState() => _EditItemPopupState();
  
}


class _EditItemPopupState extends State<EditItemPopup> {
  String selectedCategory = 'Gemüse';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isFavorite = false;
  String selectedUnit = 'Stk'; // Einheiten-Variable

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      selectedCategory = item.category;
      amountController.text = item.amount.toString();
      nameController.text = item.name;
      isFavorite = false; // oder item.isFavorite wenn es das irgendwann gibt
      selectedUnit = 'Stk'; // oder item.unit? Muss noch in meine Daten!
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryManager.categoryIcons.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFC2CEC4),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header mit Close & Checkmark
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFDFDF63),
                      Color(0xFFFFFFB3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(-2, -2),
                      child: SmallButton(
                        theIcon: const Icon(Icons.close),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      widget.item == null ? 'Neues Item' : 'Item bearbeiten',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(2, -2),
                      child: SmallButton(
                        theIcon: const Icon(Icons.check),
                        onTap: () {
                        final name = nameController.text.trim();
                        final amount = int.tryParse(amountController.text) ?? 1;

                          if (name.isNotEmpty) {
                            final item = ShoppingItem(
                              name: name,
                              category: selectedCategory,
                              amount: amount,
                              shopped: false,
                            );
                            Navigator.pop(context, item); // 👈 Rückgabe des neuen Items
                          } else {
                            Navigator.pop(context); // kein Item zurückgeben
                          }
                        },                      
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Kategorie-Karussell mit CategoryManager
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedCategory;
                    final icon = CategoryManager.getIcon(category);
                    return Categorycarousselitem(
                      theIcon: icon,
                      onTap: () => setState(() => selectedCategory = category),
                      isSelected: isSelected,
                      category: category,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Eingabefelder mit Einheit-Auswahl
              Row(
                children: [
                  // Mengenfeld mit Dropdown daneben
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          // Mengen-Eingabe
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, // nur Ziffern (0–9) erlaubt hier!!!
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Menge',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Einheit-Dropdown
                          DropdownButton<String>(
                            value: selectedUnit,
                            underline: const SizedBox(),
                            // Auswahl der Mengen Einheit, hardcodet im Moment, weiss nicht ob das später 
                            // in ein Enum mit ner Map soll oder ob das so bleiben kann
                            items: ['Stk', 'g', 'kg', 'L'].map((unit) {
                              return DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => selectedUnit = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name-Feld
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Favoriten-Button
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                  color: isFavorite ? Colors.orange : Colors.grey,
                  onPressed: () => setState(() => isFavorite = !isFavorite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
