import 'package:flutter/services.dart';
import 'package:formz/formz.dart';

import '../../../../core/models/input_field_error.dart';

class ReadingInputModel extends FormzInput<String, InputFieldError> {
  const ReadingInputModel.pure({
    this.min = 0,
    this.max = 200,
  }) : super.pure('');

  const ReadingInputModel.dirty({
    String value = '',
    this.min = 0,
    this.max = 200,
  }) : super.dirty(value);
  const ReadingInputModel.valid({
    String value = '',
    this.min = 100,
    this.max = 200,
  }) : super.pure(value);

  final double min;
  final double max;

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      return InputFieldError(message: "Value cannot be empty.");
    } else if (value == '-' || value == '+') {
      return null;
    } else if (double.parse(value) < min) {
      return InputFieldError(message: "Enter a valid number.");
    } else if (double.parse(value) > max) {
      return InputFieldError(message: "Enter a valid number.");
    }
    return null;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    int? decimalRange = 6,
    bool activatedNegativeValues = false,
  }) : assert(decimalRange == null || decimalRange >= 0, '') {
    String dp = (decimalRange != null && decimalRange > 0)
        ? "([.][0-9]{0,$decimalRange}){0,1}"
        : "";
    String num = "[0-9]*$dp";

    if (activatedNegativeValues) {
      _exp = RegExp("^((((-){0,1})|((-){0,1}[0-9]$num))){0,1}\$");
    } else {
      _exp = RegExp("^($num){0,1}\$");
    }
  }

  RegExp _exp = RegExp(r'^\-?\d+\.?\d{0,2}');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
