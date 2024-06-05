import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:formz/formz.dart';
import 'package:phone_number/phone_number.dart';
import 'package:famici/utils/barrel.dart';

import 'input_field_error.dart';

class PhoneInput extends FormzInput<String, InputFieldError> {
  PhoneInput.pure()
      : isValidNumber = true,
        super.pure('');
  PhoneInput.valid({String value = '', bool valid = true})
      : isValidNumber = valid,
        super.pure(value);
  PhoneInput.dirty({String value = '', bool valid = true})
      : isValidNumber = valid,
        super.dirty(value);
  PhoneInput.invalid({String value = '', bool valid = true})
      : isValidNumber = valid,
        super.dirty(value);
  bool isValidNumber = true;
  @override
  InputFieldError? validator(String value) {
    CountryWithPhoneCode? countryCode =
        CountryWithPhoneCode.getCountryDataByPhone(value);
    String onlyDigits = value.replaceAll(RegExp(r'[^\w]+'), "");
    if (value.isEmpty) {
      return InputFieldError(message: "Phone number cannot be empty.");
    } else if (countryCode == null) {
      return InputFieldError(
          message: "Phone number must contain country code.");
    } else if (onlyDigits.length < 10) {
      return InputFieldError(
        message: "Phone number must contain at least 9 digits.",
      );
    } else if (onlyDigits.length > 13) {
      return InputFieldError(message: "Phone number maximum length exceeded.");
    } else if (!isValidNumber) {
      return InputFieldError(message: "Invalid phone number.");
    }
    return null;
  }
}
