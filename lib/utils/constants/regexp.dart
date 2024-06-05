import 'package:flutter/services.dart';

final nameExcludedRegex = RegExp(r'[!@#<>?".,$/:_`~;[\]\\|=+)(*&^%0-9-]');
final nameIncludedRegex = RegExp(r'^[A-Za-z0-9 ]+$');
final emailRegex = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);
final phoneRegexp =
RegExp(r'\+994\s+\([0-9]{2}\)\s+[0-9]{3}\s+[0-9]{2}\s+[0-9]{2}');

final phoneAllowedInputRegex = RegExp(r'[0-9 + - ]');
final numberOnlyRegexp = RegExp(r"\D");

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.startsWith(' ')) {
      final String trimmedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimmedText,
        selection: TextSelection(
          baseOffset: trimmedText.length,
          extentOffset: trimmedText.length,
        ),
      );
    }

    return newValue;
  }
}
