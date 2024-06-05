import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';

class FCTextFormField extends StatelessWidget {
  const FCTextFormField(
      {this.key,
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
        this.errorTextStyle,
        this.hintTextStyle,
        this.textAlign,
        this.onTap,
        this.obscureText,
        this.suffix})
      : super(key: key);

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
  final TextStyle? errorTextStyle;
  final TextStyle? hintTextStyle;
  final TextAlign? textAlign;
  final Key? key;
  final Function()? onTap;
  final bool? obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      obscureText: obscureText ?? false,
      onTap: onTap,
      scrollController: scrollController,
      enabled: enabled,
      readOnly: readOnly ?? false,
      focusNode: focusNode,
      controller: textEditingController,
      initialValue: initialValue,
      onChanged: onChanged,
      onEditingComplete: onComplete,
      textAlign: textAlign ?? TextAlign.start,
      style: textStyle ??
          TextStyle(
            fontSize: FCStyle.mediumFontSize,
            color: ColorPallet.kPrimaryColor,
          ),
      cursorColor: Colors.black,
      cursorWidth: 4.0,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      onSaved: onSaved,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      inputFormatters: textInputFormatters,
      autofocus: autoFocus ?? false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText ?? label.toUpperCase(),
        hintStyle: hintTextStyle ??
            TextStyle(
              fontSize: hintFontSize ?? FCStyle.mediumFontSize,
              color: ColorPallet.kCardInnerShadowColor.withOpacity(
                0.4,
              ),
            ),
        suffixIcon: suffix,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              vertical: FCStyle.blockSizeVertical * 3.3,
              horizontal: FCStyle.blockSizeHorizontal * 2,
            ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 4.0,
            color: ColorPallet.kGrey,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(0.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 4.0,
            color: ColorPallet.kGrey.withOpacity(0.8),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(0.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 4.0,
            color: ColorPallet.kGrey,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(0.0),
        ),
        errorText: hasError && error != null ? "*$error" : null,
        errorStyle:
        errorTextStyle ?? TextStyle(fontSize: FCStyle.defaultFontSize),
      ),
    );
  }
}
