import 'package:flutter/material.dart';

class HeightSpacer extends StatelessWidget {
  const HeightSpacer({super.key, required this.size});
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
    );
  }
}
