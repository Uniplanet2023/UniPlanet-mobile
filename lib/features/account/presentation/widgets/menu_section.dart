import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? ontap;
  final Color? color;
  final Switch? transition;

  const MenuSection(
      {super.key,
      required this.title,
      required this.icon,
      this.ontap,
      this.color,
      this.transition});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, color: color)),
        leading: Icon(
          icon,
          color: color,
        ),
        trailing:
            (transition != null) ? transition : const Icon(Icons.arrow_forward),
        onTap: ontap,
      ),
    );
  }
}
