import 'package:flutter/services.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  final String countryCode;

  NumberTextInputFormatter({required this.countryCode});
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int textLength = 10;
    int dashPoint = 6;
    // Only allow digits
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (countryCode == '+1') {
      textLength = 10;
      dashPoint = 6;
    } else if (countryCode == '+82') {
      textLength = 11;
      dashPoint = 7;
    }
    if (newText.length > textLength) {
      return oldValue;
    }

    var formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 3 || i == dashPoint) {
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
