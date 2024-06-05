import 'package:easy_localization/src/public_ext.dart';
import 'package:formz/formz.dart';
import 'package:famici/core/models/input_field_error.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/screens/add_medication_screen.dart';
import 'package:famici/utils/strings/medication_strings.dart';

// Extend FormzInput and provide the input type and error type.
class MedicationAdditionalDetailsInput
    extends FormzInput<String, InputFieldError> {
  const MedicationAdditionalDetailsInput.pure() : super.pure('');

  const MedicationAdditionalDetailsInput.dirty({String value = ''})
      : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    if (value.length > 100) {
      return InputFieldError(message: MedicationStrings.invalidValue.tr());
    }
    return null;
  }
}

class ReminderRadioTypeInput extends FormzInput<ReminderType, InputFieldError> {
  const ReminderRadioTypeInput.pure() : super.pure(ReminderType.unknown);

  const ReminderRadioTypeInput.dirty(
      {ReminderType value = ReminderType.unknown})
      : super.dirty(value);

  @override
  InputFieldError? validator(ReminderType value) {
    if (value == ReminderType.unknown) {
      return InputFieldError(
        message: "Reminder required",
      );
    }
    return null;
  }
}
