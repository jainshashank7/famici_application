import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/utils/barrel.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FCMaterialButton extends StatelessWidget {
  const FCMaterialButton(
      {Key? key,
      this.child,
      this.onPressed,
      this.color,
      this.borderRadius,
      this.elevation,
      bool? defaultSize,
      bool? isBorder,
      Color? borderColor})
      : defaultSize = defaultSize ?? true,
        isBorder = isBorder ?? false,
        borderColor = borderColor ?? Colors.black,
        super(key: key);

  final Widget? child;
  final VoidCallback? onPressed;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool defaultSize;
  final isBorder;
  final borderColor;

  @override
  Widget build(BuildContext context) {
    return TapDebouncer(
        cooldown: const Duration(milliseconds: 500),
        onTap: () async => onPressed?.call(),
        builder: (context, onTap) {
          return NeumorphicButton(
            minDistance: 3,
            margin: EdgeInsets.zero,
            padding: defaultSize
                ? EdgeInsets.all(0)
                : EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            style: FCStyle.primaryButtonStyle.copyWith(
              border: NeumorphicBorder(
                  isEnabled: isBorder, color: borderColor, width: 1),
              boxShape: NeumorphicBoxShape.roundRect(
                borderRadius ?? BorderRadius.circular(20.r),
              ),
              color: color,
              depth: elevation ?? 6,
              // border: NeumorphicBorder.none(),
            ),
            onPressed: onTap ?? () {},
            child: child,
          );
        });
  }
}
