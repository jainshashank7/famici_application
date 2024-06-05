import 'package:easy_localization/src/public_ext.dart';
import 'package:formz/formz.dart';
import 'package:famici/core/models/input_field_error.dart';
import 'package:famici/utils/strings/medication_strings.dart';

// Extend FormzInput and provide the input type and error type.
class MedicationNameInput extends FormzInput<String, InputFieldError> {
  const MedicationNameInput.pure() : super.pure('');

  const MedicationNameInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    String val = value.trim();
    if (val.isEmpty) {
      return InputFieldError(
        message: MedicationStrings.medicationNameEmptyError.tr(),
      );
    }
    if (val.length > 25) {
      return InputFieldError(
        message: MedicationStrings.medicationNameLengthError.tr(),
      );
    }
    if (!RegExp(r'^[A-Za-z0-9 ]+$').hasMatch(val)) {
      return InputFieldError(
        message: MedicationStrings.invalidMedicationName.tr(),
      );
    }
    return null;
  }
}
