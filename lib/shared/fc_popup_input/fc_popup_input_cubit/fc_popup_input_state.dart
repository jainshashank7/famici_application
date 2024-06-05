part of 'fc_popup_input_cubit.dart';

class FCPopupInputState {
  FCPopupInputState(
      {required this.value,
      required this.error,
      this.errorMessage,
      required this.maxLength});

  String value;
  bool error;
  String? errorMessage;
  int maxLength;

  factory FCPopupInputState.initial() {
    return FCPopupInputState(value: "", error: false, maxLength: 100);
  }

  FCPopupInputState copyWith(
      {String? value, bool? error, String? errorMessage, int? maxLength}) {
    return FCPopupInputState(
        value: value ?? this.value,
        error: error ?? this.error,
        errorMessage: errorMessage ?? this.errorMessage,
        maxLength: maxLength ?? this.maxLength);
  }
}
