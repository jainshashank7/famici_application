import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class FCSelectButton extends StatelessWidget {
  const FCSelectButton({
    Key? key,
    this.child,
    this.value,
    this.groupValue,
    this.onChanged,
    this.hasError = false,
    this.color,
    this.gradientColors,
    this.begin,
    this.end,
    this.padding,
    this.elevation,
    this.borderRadius,
  }) : super(key: key);

  final Widget? child;
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic>? onChanged;
  final bool hasError;
  final Color? color;
  final List<Color>? gradientColors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final EdgeInsets? padding;
  final double? elevation;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: 3,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      style: FCStyle.primaryButtonStyle.copyWith(
        boxShape: NeumorphicBoxShape.roundRect(
          borderRadius ?? BorderRadius.circular(16.0),
        ),
        color: color,
        depth: elevation ?? 6,
        border: NeumorphicBorder.none(),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
        alignment: Alignment.center,
        padding: padding,
        height: 100.h,
        width: 220.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: value == groupValue
              ? LinearGradient(
                  begin: begin ?? Alignment.centerLeft,
                  end: end ?? Alignment.centerRight,
                  colors: gradientColors ??
                      [
                        Color(0xFFAA875A),
                        Color(0xFFBA9765),
                        Color(0xFF7E5A2F),
                      ],
                )
              : null,
        ),
        child: DefaultTextStyle(
          style: FCStyle.textStyle.copyWith(
            color: value == groupValue ? ColorPallet.kWhite : null,
          ),
          child: child ?? SizedBox.shrink(),
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
