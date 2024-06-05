import 'package:formz/formz.dart';
import 'package:famici/utils/barrel.dart';

import 'input_field_error.dart';

class EmailInput extends FormzInput<String, InputFieldError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty({String value = ''}) : super.dirty(value);
  const EmailInput.valid({String value = ''}) : super.pure(value);

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      //return InputFieldError(message: "Email cannot be empty.");
      return null;
    } else if (!emailRegex.hasMatch(value)) {
      return InputFieldError(message: "Invalid email address.");
    } else if (value.length > 50) {
      return InputFieldError(message: "Maximum length exceeded.");
    }
    return null;
  }
}
