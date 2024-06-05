import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/strings/barrel.dart';

class FCPrimaryButton extends StatelessWidget {
  const FCPrimaryButton({
    Key? key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.onPressed,
    this.color,
    this.labelColor,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.width,
    this.height,
    this.defaultSize = true,
    this.prefixIconSize,
  }) : super(key: key);

  final String? label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? labelColor;
  final EdgeInsets? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final bool defaultSize;
  final double? prefixIconSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return NeumorphicButton(
          padding: padding ??
              EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 32.0,
              ),
          minDistance: 4,
          style: FCStyle.primaryButtonStyle.copyWith(color: color),
          onPressed: onPressed,
          child: SizedBox(
            width: defaultSize ? FCStyle.largeFontSize * 3 : width,
            height: defaultSize ? FCStyle.largeFontSize : height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          prefixIcon ?? Icons.arrow_back_ios,
                          color: labelColor ?? ColorPallet.kPrimaryTextColor,
                          size: prefixIconSize ?? FCStyle.mediumFontSize,
                        ),
                      )
                    : SizedBox.shrink(),
                label != null
                    ? Flexible(
                        child: Container(
                          child: Text(
                            label ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  labelColor ?? ColorPallet.kPrimaryTextColor,
                              fontSize: fontSize ?? FCStyle.mediumFontSize,
                              fontWeight: fontWeight,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                suffixIcon != null
                    ? Icon(
                        suffixIcon ?? Icons.arrow_back_ios,
                        color: labelColor ?? ColorPallet.kPrimaryTextColor,
                        size: fontSize ?? FCStyle.mediumFontSize,
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
