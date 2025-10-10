import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isShopped;

  const SquareButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.isShopped,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: Ink(
          decoration: BoxDecoration(
            gradient: isShopped
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
            onTap: onPressed,
            child: Center(
              child: Icon(
                isShopped ? Icons.close : Icons.check, size: 42, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
