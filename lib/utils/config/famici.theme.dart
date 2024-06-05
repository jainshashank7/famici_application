import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_pallet.dart';

class FCStyle {
  // static const fontFamily = 'family_connect';
  static String? fontFamily = GoogleFonts.roboto().fontFamily;
  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;

  static ThemeData getTheme(BuildContext context, Brightness mode) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenWidth = _screenWidth > 96 ? _screenWidth : 96 - 96;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenHeight = _screenHeight > 120 ? _screenHeight : 120 - 120;
    return Theme.of(context).copyWith(
      backgroundColor: ColorPallet.kBackground,
      scaffoldBackgroundColor: ColorPallet.kBackground,
      brightness: mode,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorPallet.kBackground,
        titleTextStyle: AppBarTheme.of(context).titleTextStyle?.copyWith(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: 18.0,
            ),
      ),
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: fontFamily,
          ),
    );
  }

  static double get screenWidth => _screenWidth;

  static double get screenHeight => _screenHeight;

  static NeumorphicStyle get backButtonStyle => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 12,
        lightSource: LightSource.top,
        oppositeShadowLightSource: true,
        color: ColorPallet.kDark,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack.withOpacity(0.7),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
      );

  static NeumorphicStyle get primaryButtonStyle => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 20,
        lightSource: LightSource.bottom,
        color: ColorPallet.kCardBackground,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kCardShadowColor.withOpacity(0.8),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
        border: NeumorphicBorder(
          color: ColorPallet.kCardDropShadowColor,
          width: 0,
        ),
      );

  static NeumorphicStyle get primaryButtonStyleWithoutBorder => NeumorphicStyle(
        disableDepth: true,
        surfaceIntensity: 12,
        lightSource: LightSource.top,
        oppositeShadowLightSource: false,
        color: ColorPallet.kDark,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kCardShadowColor.withOpacity(0.8),
      );

  static NeumorphicStyle get primaryLightButtonStyle => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 20,
        lightSource: LightSource.bottom,
        color: ColorPallet.kCardLightColor,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kCardShadowColor.withOpacity(0.8),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
        border: NeumorphicBorder(
          color: ColorPallet.kCardDropShadowColor,
          width: 0,
        ),
      );

  static NeumorphicStyle get greenButtonStyle => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 12,
        lightSource: LightSource.top,
        oppositeShadowLightSource: true,
        color: ColorPallet.kGreen,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack.withOpacity(0.7),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
      );

  static NeumorphicStyle get redButtonStyle => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 12,
        lightSource: LightSource.bottom,
        oppositeShadowLightSource: false,
        color: ColorPallet.kDarkRed,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack.withOpacity(0.7),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
      );

  static NeumorphicStyle get blueButtonStyle => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 12,
        lightSource: LightSource.top,
        oppositeShadowLightSource: false,
        color: ColorPallet.kBlue,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack.withOpacity(0.7),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
      );

  static NeumorphicStyle get flatButtonStyle => NeumorphicStyle(
        disableDepth: true,
        surfaceIntensity: 12,
        lightSource: LightSource.top,
        oppositeShadowLightSource: false,
        color: ColorPallet.kDark,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack.withOpacity(0.7),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(24.0)),
      );

  static NeumorphicStyle get buttonCardStyle => NeumorphicStyle(
        disableDepth: false,
        depth: 6,
        surfaceIntensity: 20,
        lightSource: LightSource.bottom,
        color: ColorPallet.kCardBackground,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kCardShadowColor,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(32.0)),
        border: NeumorphicBorder(
          color: ColorPallet.kCardDropShadowColor,
          width: 1,
        ),
      );

  static NeumorphicStyle get highlightedButtonCardStyle => NeumorphicStyle(
        disableDepth: false,
        depth: 6,
        surfaceIntensity: 20,
        lightSource: LightSource.bottom,
        color: ColorPallet.kCardBackground,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.bellIconColor1,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(32.0)),
        border: NeumorphicBorder(
          color: ColorPallet.bellIconColor2,
          width: 3,
        ),
      );

  static NeumorphicStyle buttonCardStyleWithBorderRadius(
          {double? borderRadius,
          bool hasBorder = true,
          Color? color,
          double? depth}) =>
      NeumorphicStyle(
        disableDepth: false,
        depth: depth ?? 0,
        surfaceIntensity: 10,
        lightSource: LightSource.top,
        color: color ?? ColorPallet.kCardBackground,
        shape: NeumorphicShape.flat,
        shadowLightColor: Colors.black12,
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(borderRadius ?? 32.0)),
        border: hasBorder
            ? NeumorphicBorder(
                color: ColorPallet.kCardDropShadowColor,
                width: 1,
              )
            : NeumorphicBorder.none(),
      );

  static NeumorphicStyle selectedButtonCardStyleWithBorderRadius({
    double? borderRadius,
  }) =>
      NeumorphicStyle(
        disableDepth: false,
        depth: 6,
        surfaceIntensity: 20,
        lightSource: LightSource.bottom,
        color: ColorPallet.kBrightGreen,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kCardShadowColor,
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(borderRadius ?? 32.0)),
        border: NeumorphicBorder(
          color: ColorPallet.kCardDropShadowColor,
          width: 1,
        ),
      );

  static NeumorphicStyle get popupBackground => NeumorphicStyle(
        disableDepth: false,
        depth: 8,
        // surfaceIntensity: 20,
        lightSource: LightSource.topLeft,
        color: Colors.transparent,
        oppositeShadowLightSource: true,
        // color: ColorPallet.kDarkBackGround,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.zero),
        border: NeumorphicBorder(
          color: ColorPallet.kCardDropShadowColor,
          width: 0,
        ),
      );

  static double get xLargeFontSize => screenWidth * 4 / 100;

  static double get largeFontSize => screenWidth * 3 / 100;

  static double get mediumFontSize => screenWidth * 2 / 100;

  static double get defaultFontSize => screenWidth * 3 / 200;

  static double get smallFontSize => screenWidth * 1 / 100;

  static double get xSmallFontSize => screenWidth * 1 / 200;

  static double get blockSizeVertical => screenHeight / 100;

  static double get blockSizeHorizontal => screenWidth / 100;

  static double get baseWidth => 1440;

  static double get fem => screenWidth / baseWidth;

  static double get ffem => fem * 0.97;

  static NeumorphicStyle get healthyHabitsTopStoriesButton => NeumorphicStyle(
        depth: 6,
        surfaceIntensity: 1,
        lightSource: LightSource.top,
        oppositeShadowLightSource: true,
        color: ColorPallet.kHealthyHabitsTopStoriesColor,
        shape: NeumorphicShape.flat,
        shadowLightColor: ColorPallet.kBlack.withOpacity(0.7),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
      );

  static TextStyle get textStyle => TextStyle(
        color: ColorPallet.kPrimaryTextColor,
        fontSize: mediumFontSize,
      );

  static TextStyle get textHeaderStyle => TextStyle(
        color: ColorPallet.kPrimaryTextColor,
        fontSize: 50.r,
      );

  static TextStyle get textHeaderBoldStyle => TextStyle(
        color: ColorPallet.kPrimaryTextColor,
        fontSize: 50.r,
        fontWeight: FontWeight.bold,
      );

  static updateLayout(BuildContext context) {
    _screenHeight = context.size?.height ?? _screenHeight;
    _screenWidth = context.size?.width ?? _screenWidth;
  }
}
