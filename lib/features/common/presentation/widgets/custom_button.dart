import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? fontColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withOpacity(0.1);
            }
            return null; // Defer to the widget's default.
          },
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: color == null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
