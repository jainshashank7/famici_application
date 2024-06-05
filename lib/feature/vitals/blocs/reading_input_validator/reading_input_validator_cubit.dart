import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/reading_input_models.dart';

part 'reading_input_validator_state.dart';

class ReadingInputValidatorCubit extends Cubit<ReadingInputValidatorState> {
  ReadingInputValidatorCubit() : super(ReadingInputValidatorState.initial());

  void validate({
    String value = '',
    double? min = 0,
    double? max = 200,
  }) {
    emit(state.copyWith(
      value:
          ReadingInputModel.dirty(value: value, min: min ?? 0, max: max ?? 200),
    ));
  }
}
