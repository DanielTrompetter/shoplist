import 'package:flutter/material.dart';
import 'package:shoplist/features/shoplist/view/newlistscreen.dart';
import 'package:shoplist/shared/widgets/newlistdialog.dart';
import 'package:shoplist/shared/widgets/bigbutton.dart';

class Buttonbox extends StatelessWidget {
  const Buttonbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(70, 69, 69, 69),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: BigButton(
                icon: Icons.list,
                label: 'Neue Liste',
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
          ],
        ),
      ),
    );
  }
}