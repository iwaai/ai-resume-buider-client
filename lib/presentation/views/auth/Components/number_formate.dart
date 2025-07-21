import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Apply the format: (XXX) XXX-XXXX
    StringBuffer formatted = StringBuffer();
    if (digits.isNotEmpty) {
      if (digits.length >= 1) {
        formatted.write('(');
        formatted
            .write(digits.substring(0, digits.length < 3 ? digits.length : 3));
      }
      if (digits.length >= 4) {
        formatted.write(') ');
        formatted
            .write(digits.substring(3, digits.length < 6 ? digits.length : 6));
      }
      if (digits.length >= 7) {
        formatted.write('-');
        formatted.write(
            digits.substring(6, digits.length < 10 ? digits.length : 10));
      }
    }

    // Return the updated value
    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.toString().length),
    );
  }
}

// import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    int baseOffset = newValue.selection.baseOffset;

    // Remove any leading spaces
    if (text.startsWith(' ')) {
      text = oldValue.text;
      baseOffset = oldValue.selection.baseOffset;
    }

    // Allow only letters, spaces (between words), hyphens, and apostrophes
    String filteredText = text.replaceAll(RegExp(r"[^a-zA-Z-' ]"), '');

    // Ensure only one space between words
    filteredText = filteredText.replaceAll(RegExp(r"\s{2,}"), ' ');

    // Adjust cursor position if needed
    int offset = baseOffset - (newValue.text.length - filteredText.length);
    offset = offset.clamp(0, filteredText.length);

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
