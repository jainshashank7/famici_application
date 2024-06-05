import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/barrel.dart';

class MyAppCardButton extends StatelessWidget {
  const MyAppCardButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.icon,
      this.color,
      this.svgSize,
      this.margin,
      this.svgIcon,
      this.labelTextStyle})
      : super(key: key);

  final VoidCallback onPressed;
  final ImageProvider? icon;
  final String label;
  final Color? color;
  final String? svgIcon;
  final Size? svgSize;
  final TextStyle? labelTextStyle;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: FCStyle.buttonCardStyleWithBorderRadius(
        borderRadius: FCStyle.mediumFontSize,
        color: color,
      ),
      minDistance: 3,
      padding: EdgeInsets.all(FCStyle.defaultFontSize),
      margin: margin ?? EdgeInsets.all(FCStyle.mediumFontSize),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Image(
                  image: icon!,
                  width: FCStyle.xLargeFontSize * 2,
                  height: FCStyle.xLargeFontSize * 2,
                )
              : SvgPicture.asset(
                  svgIcon!,
                  height: svgSize != null ? svgSize?.height : 100 * FCStyle.fem,
                  width: svgSize != null ? svgSize?.width : 105 * FCStyle.fem,
                ),
          SizedBox(height: 16.0),
          Text(
            textAlign: TextAlign.center,
            label,
            style: labelTextStyle ?? FCStyle.textStyle,
          ),
        ],
      ),
    );
  }
}
