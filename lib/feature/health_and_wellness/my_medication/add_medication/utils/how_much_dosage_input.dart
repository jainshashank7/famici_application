// Extend FormzInput and provide the input type and error type.
import 'package:easy_localization/src/public_ext.dart';
import 'package:formz/formz.dart';
import 'package:famici/core/models/input_field_error.dart';
import 'package:famici/utils/strings/medication_strings.dart';

class HowMuchDosageInput extends FormzInput<String, InputFieldError> {
  const HowMuchDosageInput.pure() : super.pure('');

  const HowMuchDosageInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    if (value.isEmpty) {
      return InputFieldError(
          message: MedicationStrings.textFieldEmptyError.tr());
    }
    if (int.parse(value)<=0 ) {
      return InputFieldError(
          message: MedicationStrings.invalidValue.tr());
    }
    if (int.parse(value)>10 ) {
      return InputFieldError(
          message: MedicationStrings.invalidValue.tr());
    }
    return null;
  }
}
