
import 'package:flutter/cupertino.dart';

import '../utils/config/color_pallet.dart';
import '../utils/config/famici.theme.dart';

class FCText extends StatelessWidget {
  const FCText({Key? key,
    required this.text,
    this.textStyle,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.textDecoration,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,softWrap: true,
      style: textStyle??TextStyle(
        decoration: textDecoration,
        color:textColor?? ColorPallet.kPrimaryTextColor,
        fontSize:fontSize?? FCStyle.mediumFontSize,
        fontWeight:fontWeight?? FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
      textAlign: textAlign?? TextAlign.center,
      overflow: textOverflow?? TextOverflow.ellipsis,
      maxLines: maxLines??2,
    );
  }
}
