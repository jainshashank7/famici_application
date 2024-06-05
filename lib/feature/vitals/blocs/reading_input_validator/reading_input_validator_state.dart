part of 'reading_input_validator_cubit.dart';

class ReadingInputValidatorState {
  ReadingInputValidatorState({
    required this.value,
  });

  ReadingInputModel value;

  factory ReadingInputValidatorState.initial() {
    return ReadingInputValidatorState(
      value: ReadingInputModel.pure(),
    );
  }

  ReadingInputValidatorState copyWith({ReadingInputModel? value}) {
    return ReadingInputValidatorState(
      value: value ?? this.value,
    );
  }
}
