import 'package:flutter/material.dart';

enum SquareButtonMode {
  list,       // Check / X
  favAdd,     // Plus
  favRemove,  // Minus
}

class SquareButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isShopped;
  final SquareButtonMode mode;

  const SquareButton({
    super.key,
    required this.onPressed,
    required this.isShopped,
    required this.mode,
  });

  IconData _getIcon() {
    switch (mode) {
      case SquareButtonMode.favAdd:
        return Icons.add;
      case SquareButtonMode.favRemove:
        return Icons.remove;
      case SquareButtonMode.list:
      default:
        // isShopped == false => Häkchen
        // isShopped == true  => Kreuz
        return isShopped ? Icons.close : Icons.check;
    }
  }

  Color _getColor() {
    switch (mode) {
      case SquareButtonMode.favAdd:
        return Colors.green.shade300;
      case SquareButtonMode.favRemove:
        return Colors.red.shade300;
      case SquareButtonMode.list:
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: Ink(
          decoration: BoxDecoration(
            gradient: mode == SquareButtonMode.list
                ? (isShopped
                    ? const LinearGradient(
                        colors: [Color(0xFFE0E0E0), Color(0xFFB0B0B0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFC9C9F3), Color(0xFF9696D7)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ))
                : null,
            color: mode != SquareButtonMode.list ? _getColor() : null,
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
                _getIcon(),
                size: 42,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
