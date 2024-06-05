import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';

class FCGradientButton extends StatelessWidget {
  const FCGradientButton({
    Key? key,
    this.child,
    this.onPressed,
    this.colors,
    this.begin,
    this.end,
    double? borderRadius,
    this.padding,
  })  : borderRadius = borderRadius ?? 24.0,
        super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final double borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      minDistance: 4,
      style: FCStyle.buttonCardStyle.copyWith(
        shadowLightColor: ColorPallet.kCardShadowColor,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(borderRadius),
        ),
        border: NeumorphicBorder.none(),
      ),
      onPressed: onPressed,
      child: Container(
        padding: padding ?? EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: begin ?? Alignment.centerLeft,
            end: end ?? Alignment.centerRight,
            colors: colors ?? [ColorPallet.kPrimary, ColorPallet.kPrimary],
          ),
        ),
        child: child,
      ),
    );
  }
}
