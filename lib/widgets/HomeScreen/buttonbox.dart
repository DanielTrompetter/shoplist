import 'package:flutter/material.dart';
import 'package:shoplist/widgets/bigbutton.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: BigButton(
                icon: Icons.group,
                label: 'Mitglieder',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BigButton(
                icon: Icons.star,
                label: 'Favoriten verwalten',
              ),
            ),
          ],
        ),
      ),
    );
  }
}