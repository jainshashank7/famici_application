import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';

class FCTextFormField extends StatelessWidget {
  const FCTextFormField({
    Key? key,
    this.hasError = false,
    this.label = '',
    this.onChanged,
    this.error,
    this.initialValue,
    this.hintText,
    this.onComplete,
    this.focusNode,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.keyboardType,
    this.textEditingController,
    this.onSubmit,
    this.onSaved,
    this.textInputFormatters,
    this.contentPadding,
    this.enabled,
    this.readOnly,
    this.scrollController,
    this.autoFocus,
    this.hintFontSize,
    this.textStyle,
    this.borderRadius = 16.0,
    this.textAlign,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.obscureText,
    this.suffix,
    this.textCapitalization,
  }) : super(key: key);

  final bool hasError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String?>? onSaved;
  final String? error;

  final String label;
  final String? initialValue;
  final String? hintText;

  final VoidCallback? onComplete;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? textInputFormatters;
  final EdgeInsets? contentPadding;
  final bool? enabled;
  final bool? readOnly;
  final ScrollController? scrollController;
  final bool? autoFocus;
  final double? hintFontSize;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final double borderRadius;
  final TextAlign? textAlign;
  final Color? fillColor;
  final Color? borderColor;
  final bool? obscureText;
  final Widget? suffix;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextFormField(
              textAlign: textAlign ?? TextAlign.start,
              scrollController: scrollController,
              enabled: enabled,
              readOnly: readOnly ?? false,
              obscureText: obscureText ?? false,
              focusNode: focusNode,
              controller: textEditingController,
              initialValue: initialValue,
              onChanged: onChanged,
              onEditingComplete: onComplete,
              style: textStyle ??
                  TextStyle(
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorPallet.kPrimaryColor),
              cursorColor: Colors.black,
              cursorWidth: 2.0,
              maxLines: maxLines,
              minLines: minLines,
              textInputAction: textInputAction ?? TextInputAction.done,
              keyboardType: keyboardType,
              onFieldSubmitted: onSubmit,
              onSaved: onSaved,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: textInputFormatters,
              autofocus: autoFocus ?? false,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              decoration: InputDecoration(
                suffix: suffix,
                filled: true,
                fillColor: fillColor ?? ColorPallet.kPrimaryColor,
                hintText: hintText ?? label.toUpperCase(),
                hintStyle: hintStyle ??
                    TextStyle(
                      fontSize: hintFontSize ?? FCStyle.mediumFontSize,
                      color: ColorPallet.kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(
                      vertical: FCStyle.blockSizeVertical * 2,
                      horizontal: FCStyle.blockSizeHorizontal * 4,
                    ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                errorText: hasError ? error : null,
                errorStyle: TextStyle(
                    fontSize: FCStyle.smallFontSize,
                    color: ColorPallet.kDarkRed),
              )),
        ),
      ],
    );
  }
}
