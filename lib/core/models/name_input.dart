import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:famici/utils/constants/regexp.dart';

import 'input_field_error.dart';

// Extend FormzInput and provide the input type and error type.
class FirstNameInput extends FormzInput<String, InputFieldError> {
  FirstNameInput.pure({String? value}) : super.pure(value ?? '');

  FirstNameInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      return InputFieldError(message: "First name cannot be empty.");
    }
    if (!nameIncludedRegex.hasMatch(value)) {
      return InputFieldError(
        message: "Invalid letters found.",
      );
    }
    if (value.length > 25) {
      return InputFieldError(
        message: "Maximum length exceeded.",
      );
    }
    return null;
  }
}

// Extend FormzInput and provide the input type and error type.
class LastNameInput extends FormzInput<String, InputFieldError> {
  const LastNameInput.pure({String? value}) : super.pure(value ?? '');

  const LastNameInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      return InputFieldError(message: "Last name cannot be empty.");
    }
    if (!nameIncludedRegex.hasMatch(value)) {
      return InputFieldError(
        message: "Invalid letters found.",
      );
    }
    if (value.length > 25) {
      return InputFieldError(
        message: "Maximum length exceeded.",
      );
    }
    return null;
  }
}
