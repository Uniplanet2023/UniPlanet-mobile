import 'package:flutter/services.dart';

class UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Only allow digits
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (newText.length > 10) {
      return oldValue;
    }

    var formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 3 || i == 6) {
        formattedText += '-';
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
