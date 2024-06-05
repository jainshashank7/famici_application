import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/fc_popup_input/fc_popup_input_cubit/fc_popup_input_cubit.dart';
import 'package:famici/utils/barrel.dart';
import 'package:easy_localization/src/public_ext.dart';

class FCPopupInput extends StatefulWidget {
  const FCPopupInput(
      {Key? key, this.title = '', this.text, this.errorMessage, this.maxLength})
      : super(key: key);

  final String? title;
  final String? text;
  final String? errorMessage;
  final int? maxLength;

  @override
  State<FCPopupInput> createState() => _FCPopupInputState();
}

class _FCPopupInputState extends State<FCPopupInput> {
  final FCPopupInputCubit popupInputCubit = FCPopupInputCubit();
  final TextEditingController _controller = TextEditingController();

  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.text != null && widget.text != "") {
        popupInputCubit.validate(value: widget.text ?? "");
      }
      _controller.text = widget.text ?? "";
    });
  }

  @override
  void dispose() {
    popupInputCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: FCStyle.xLargeFontSize * 3,
                child: BlocBuilder(
                  bloc: popupInputCubit,
                  builder: (context, FCPopupInputState state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: FCTextFormField(
                            textEditingController: _controller,
                            focusNode: _node,
                            autoFocus: true,
                            textInputFormatters:[LengthLimitingTextInputFormatter(widget.maxLength)] ,
                            hasError: state.error,
                            errorTextStyle: FCStyle.textStyle.copyWith(
                              color: ColorPallet.kRed,
                            ),
                            error: state.errorMessage ??
                                widget.errorMessage ??
                                CommonStrings.emptyTextInputMessage.tr(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: FCStyle.defaultFontSize,
                              vertical: FCStyle.defaultFontSize,
                            ),
                            onChanged: (value) {
                              popupInputCubit.changeMaxLength(
                                  maxLength: widget.maxLength ?? 100);
                              popupInputCubit.validate(
                                value: value,
                              );
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            onSubmit: !state.error
                                ? (value) {
                                    if (value.isNotEmpty) {
                                      Navigator.pop(context, value);
                                    } else {
                                      _node.requestFocus();
                                    }
                                  }
                                : (val) {
                                    _node.requestFocus();
                                  },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 108.0,
                child: Row(
                  children: [
                    FCBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 108.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title!,
                      style: FCStyle.textStyle.copyWith(
                        fontSize: FCStyle.largeFontSize,
                        color: ColorPallet.kWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
