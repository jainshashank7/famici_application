import 'package:formz/formz.dart';

import 'input_field_error.dart';

class ImageInput extends FormzInput<String, InputFieldError> {
  const ImageInput.pure() : super.pure('');

  const ImageInput.dirty({String value = ''}) : super.dirty(value);
  const ImageInput.valid({String value = ''}) : super.pure(value);

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      return InputFieldError(message: "Image not selected.");
    }
    return null;
  }
}
