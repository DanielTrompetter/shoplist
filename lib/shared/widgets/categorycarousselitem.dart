import 'package:flutter/material.dart';

class Categorycarousselitem extends StatelessWidget {
  final IconData theIcon;
  final VoidCallback onTap;
  final bool isSelected;
  final String category;
  const Categorycarousselitem({
    super.key,
    required this.theIcon,
    required this.onTap,
    required this.isSelected,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              theIcon,
              color: isSelected ? Colors.green : Colors.black,
            ),
            Text(
              category,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}