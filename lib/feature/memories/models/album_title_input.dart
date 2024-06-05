import 'package:formz/formz.dart';
import 'package:famici/core/models/barrel.dart';

// Extend FormzInput and provide the input type and error type.
class AlbumTitleInput extends FormzInput<String, InputFieldError> {
  const AlbumTitleInput.pure() : super.pure('');

  const AlbumTitleInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    String val = value.trim();

    if (val.isEmpty) {
      return InputFieldError(message: "Title cannot be empty");
    }
    if (val.length > 25) {
      return InputFieldError(message: "Title length cannot be more than 25");
    }
    return null;
  }
}
