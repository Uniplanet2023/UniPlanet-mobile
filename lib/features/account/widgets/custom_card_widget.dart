import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:uniplanet/constants/global_variables.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CustomCard({super.key, this.color, this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white60,
                Colors.white10,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: (color ?? GlobalVariables.secondaryColor).withOpacity(0.5),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
