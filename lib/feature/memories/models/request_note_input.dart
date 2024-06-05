import 'package:formz/formz.dart';

import '../../../core/models/input_field_error.dart';
import '../../../utils/constants/regexp.dart';

class NoteInput extends FormzInput<String, InputFieldError> {
  NoteInput.pure({String? value}) : super.pure(value ?? '');

  NoteInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      return InputFieldError(message: "Note cannot be empty.");
    }
    if (value.length > 300) {
      return InputFieldError(
        message: "Maximum length exceeded.",
      );
    }
    return null;
  }
}
