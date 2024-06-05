import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';

class FCRadioButton extends StatelessWidget {
  FCRadioButton({
    Key? key,
    this.value,
    this.groupValue,
    this.onChanged,
    this.hasError = false,
  }) : super(key: key);

  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic>? onChanged;
  final double size = FCStyle.xLargeFontSize;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: 4,
      style: FCStyle.buttonCardStyle.copyWith(
          shadowLightColor: ColorPallet.kCardShadowColor.withOpacity(0.4),
          border: hasError
              ? NeumorphicBorder(
                  width: 2.0,
                  color: ColorPallet.kRed,
                )
              : NeumorphicBorder.none(),
          boxShape: NeumorphicBoxShape.circle(),
          lightSource: LightSource.top),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value == groupValue ? ColorPallet.kGreen : Colors.transparent,
        ),
        child: Icon(
          Icons.check,
          size: FCStyle.mediumFontSize,
          color: value == groupValue
              ? ColorPallet.kLightBackGround
              : Colors.transparent,
        ),
      ),
      onPressed: () {
        if (value != null) {
          onChanged?.call(value);
        }
      },
    );
  }
}
