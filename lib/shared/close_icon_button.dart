import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';

class CloseIconButton extends StatelessWidget {
  const CloseIconButton({
    Key? key,
    this.size,
    this.onTap,
    this.margin,
    this.color,
    this.boxed = false,
  }) : super(key: key);

  final Function()? onTap;
  final double? size;
  final EdgeInsets? margin;
  final Color? color;
  final bool? boxed;
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: margin,
      padding: margin,
      style: NeumorphicStyle(
        shape: boxed != false ? NeumorphicShape.convex : NeumorphicShape.flat,
        color: boxed != false
            ? Color.fromARGB(255, 198, 2, 2)
            : Colors.transparent,
        disableDepth: true,
      ),
      onPressed: onTap ??
          () {
            Navigator.pop(context);
          },
      child: NeumorphicIcon(
        Icons.close_rounded,
        style: NeumorphicStyle(
          color: color ?? ColorPallet.kPrimaryTextColor,
          lightSource: LightSource.top,
          oppositeShadowLightSource: true,
          depth: 2,
          shadowLightColor: ColorPallet.kDark,
        ),
        size: size ?? FCStyle.xLargeFontSize,
      ),
    );
  }
}
