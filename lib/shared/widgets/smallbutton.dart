import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final Icon theIcon;
  final VoidCallback onTap;
  const SmallButton({
    super.key,
    required this.theIcon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color.fromARGB(0xFF,0xF4, 0xF4,0xF4), Color.fromARGB(0xFF,0x73,0x73,0x73)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Transform.scale(scale: 1.4,
        child: IconButton(
          icon: theIcon,
          onPressed: onTap,
          color: Colors.black,
          iconSize: 24,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
