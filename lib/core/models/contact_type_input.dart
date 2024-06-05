import 'package:formz/formz.dart';
import 'package:famici/utils/barrel.dart';

import 'input_field_error.dart';

class ContactTypeDescriptionInput extends FormzInput<String, InputFieldError> {
  const ContactTypeDescriptionInput.pure({String? value})
      : super.pure(value ?? '');

  const ContactTypeDescriptionInput.dirty({String value = ''})
      : super.dirty(value);

  @override
  InputFieldError? validator(String value) {
    String val = value.trim();
    if (val.isEmpty) {
      return InputFieldError(
        message: "Relationship required.",
      );
    } else if (!nameIncludedRegex.hasMatch(val)) {
      return InputFieldError(
        message: "Invalid letters found.",
      );
    } else if (val.length > 25) {
      return InputFieldError(
        message: "Maximum length exceeded.",
      );
    }
    return null;
  }
}

class ContactTypeInput extends FormzInput<ContactType, InputFieldError> {
  const ContactTypeInput.pure({ContactType? value})
      : super.pure(value ?? ContactType.familyOrFriend);

  const ContactTypeInput.dirty({ContactType value = ContactType.familyOrFriend})
      : super.dirty(value);

  @override
  InputFieldError? validator(ContactType value) {
    // if (value == ContactType.unknown) {
    //   return InputFieldError(
    //     message: "Relationship type required",
    //   );
    // }
    return null;
  }
}
