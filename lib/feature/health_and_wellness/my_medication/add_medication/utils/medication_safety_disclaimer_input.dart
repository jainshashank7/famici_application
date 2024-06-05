import 'package:easy_localization/src/public_ext.dart';
import 'package:formz/formz.dart';
import 'package:famici/core/models/input_field_error.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/screens/add_medication_screen.dart';
import 'package:famici/utils/strings/medication_strings.dart';

class SafetyDisclaimerToggleInput extends FormzInput<bool, InputFieldError> {
  const SafetyDisclaimerToggleInput.pure() : super.pure(false);

  const SafetyDisclaimerToggleInput.dirty(
      {bool value = false})
      : super.dirty(value);

  @override
  InputFieldError? validator(bool value) {
    if (value == false) {
      return InputFieldError(
        message: "Accepted required",
      );
    }
    return null;
  }
}
