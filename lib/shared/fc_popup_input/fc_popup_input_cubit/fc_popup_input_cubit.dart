import 'package:bloc/bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:easy_localization/src/public_ext.dart';

part 'fc_popup_input_state.dart';

class FCPopupInputCubit extends Cubit<FCPopupInputState> {
  FCPopupInputCubit() : super(FCPopupInputState.initial());

  void validate({
    String value = '',
  }) {
    bool error = false;
    String? errorMessage;


    if (value == "") {
      error = true;
    } else if (value.length > state.maxLength) {
      error = true;
      errorMessage = CommonStrings.lengthErrorTextInputMessage.tr();
    }

    emit(
        state.copyWith(value: value, error: error, errorMessage: errorMessage));
  }

  void changeMaxLength({required int maxLength}) {
    emit(state.copyWith(maxLength: maxLength));
  }
}
