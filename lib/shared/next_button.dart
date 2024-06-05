import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/utils/barrel.dart';

import 'barrel.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    this.label,
    this.iconData,
    this.onPressed,
    this.size,
    this.hasIcon = true,
    this.color,
    this.disabled = false,
  }) : super(key: key);

  final String? label;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final Size? size;
  final bool hasIcon;
  final Color? color;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: FCMaterialButton(
        onPressed: onPressed,
        defaultSize: false,
        color: disabled ? ColorPallet.kGrey : color ?? ColorPallet.kGreen,
        child: SizedBox(
          width: size?.width ?? 200.w,
          height: size?.height ?? 100.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label ?? CommonStrings.next.tr(),
                style: FCStyle.textStyle.copyWith(
                  color: ColorPallet.kPrimaryText,
                ),
              ),
              if (hasIcon) SizedBox(width: 8.0),
              if (hasIcon)
                Icon(
                  iconData ?? Icons.arrow_forward_ios_rounded,
                  color: ColorPallet.kLightBackGround,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
