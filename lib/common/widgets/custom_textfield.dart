import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool enabled;
  final TextInputType keyboardType;
  final dynamic inputFormatters;
  final String prefixText;
  final bool obscureText;
  final bool validatorEnabled;
  final int? maxLength;
  final Color? borderColor; // Added borderColor parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines = 1,
    this.inputFormatters,
    this.prefixText = "",
    this.obscureText = false,
    this.validatorEnabled = true,
    this.maxLength,
    this.borderColor, // Initialize borderColor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      decoration: InputDecoration(
          prefixText: prefixText,
          hintText: hintText,
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: borderColor ?? Colors.black38, // Use borderColor if provided
          )),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: borderColor ?? Colors.black38, // Use borderColor if provided
          )),
          // Add a focused border to highlight the field when it is active
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: borderColor ??
                Colors.blue, // Use borderColor if provided, default to blue
            width: 2.0, // You can adjust the width
          ))),
      validator: (val) {
        if (!validatorEnabled) {
          return null;
        }
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }
}
