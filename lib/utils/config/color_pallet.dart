import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ColorPallet {
  static bool _isDark = false;
  static Brightness _theme = Brightness.light;
  static var kThemeSecondaryColor = Color(0xFFAC2734);
  static var kThemePrimaryColor = Color(0xFF595BC4);
  static var kThemeTertiaryColor = Color(0xFF4CBC9A);
  static var kThemeSecondaryTextColor = Colors.white;
  static var kThemePrimaryTextColor = Colors.white;
  static var kThemeTertiaryTextColor = Colors.white;
  static bool isDark = _isDark;
  static setThemeMode(Brightness mode) {
    _theme = mode;
    _isDark = mode == Brightness.dark;
  }

  static set setKSecondary(Color color) {
    kThemeSecondaryColor = color;
  }

  static set setKPrimary(Color color) {
    kThemePrimaryColor = color;
  }

  static set setKTertiary(Color color) {
    kThemeTertiaryColor = color;
  }

  // text color
  static set setKSecondaryText(Color color) {
    kThemeSecondaryTextColor = color;
  }

  static set setKPrimaryText(Color color) {
    kThemePrimaryTextColor = color;
  }

  static set setKTertiaryText(Color color) {
    kThemeTertiaryTextColor = color;
  }

  Brightness get theme => _theme;
  static Color get kSecondary {
    return kThemeSecondaryColor;
  }

  static Color get kPrimary {
    return kThemePrimaryColor;
  }

  static Color get kTertiary {
    return kThemeTertiaryColor;
  }

// get text color
  static Color get kSecondaryText {
    return kThemeSecondaryTextColor;
  }

  static Color get kPrimaryText {
    return kThemePrimaryTextColor;
  }

  static Color get kTertiaryText {
    return kThemeTertiaryTextColor;
  }

  static Color get kLightGreen => const Color(0xFF3DCA64);
  static Color get kFadedGreen => const Color(0xFF57C454);
  static Color get kSimpleLightGreen => const Color(0xFF86D57F);
  static Color get kNextDoorGreen => const Color(0xFF8ED500);
  static Color get kBrightGreen => const Color(0xFF219653);
  static Color get kBrightGreen2 => const Color(0xFF27AE60);
  static Color get kDarkShadeGreen => const Color(0xFF2D781A);
  static Color get kGreen => const Color(0xFF2D781B);
  static Color get kBlack => Colors.black;
  static Color get kDark => Color(0xFF404040);
  static Color get kGrey => Color(0xFF7D7D7D);
  static Color get kFadedGrey => Color(0xFFCCCCCC);
  static Color get kWhite => Color(0xFFFFFFFF);
  static Color get kYellow => Colors.yellow;
  static Color get kFadedYellow => Color(0xFFEFCA49);
  static Color get kDarkYellow => Color(0xFFD29D35);
  static Color get kOrange => Colors.orangeAccent;
  static Color get kRed => Color(0xFFDB4040);
  static Color get kFadedRed => Color.fromARGB(255, 179, 60, 72);
  static Color get kDarkRed => Color(0xFFAF2709);
  static Color get kBlue => Color(0xFF144F93);
  static Color get kCyan => Color(0xFF1B9FA8);
  static Color get bellIconColor1 => Color(0xFFAA875A);
  static Color get bellIconColor2 => Color(0xFFBA9765);
  static Color get bellIconColor3 => Color(0xFF7E5A2F);
  static Color get kPrimaryColor => Colors.black;
  static Color get kCardLightColor => Color(0xFFE7EBF0);
  static Color get kNavFooterColor => Color(0xFF656878);
  static Color get kCopyRightColor => Color(0xFFA2A6BB);
  static Color get kDarkBackGround => const Color(0xFF2F2E2D);
  static Color get kLightBackGround => const Color(0xFFF8F8F8);
  static Color get kPurple => const Color(0xFF712FD3);
  static Color get kBrown => const Color(0xFF573E21);

  static Color get kPrimaryGrey => Color(0xFFC4C4C4);
  static Color get kSecondaryGrey => Color(0xFFEAEAEA);

  static Color get kBrightBlue => Color(0xFF9BF1F6);
  static Color get kMemberBackGround => Color(0xEBF0F6FF);
  static Color get kBrightFadedGreen => Color(0xFF7BD963);
  static Color get kBrightRed => Color(0xFFFF9D88);
  static Color get kBrightYellow => Color(0xFFFFF9C3);

  static Color get kBottomStatusBarColor =>
      _isDark ? kCardBackground : Color(0xFFEAEAEA);

  static Color get kLoadingColor =>
      _isDark ? Color(0xFFB8B8B8) : Color(0xFFBBBBBB);

  static Color get kDisabledColor =>
      _isDark ? Color(0xFF7D7D7D) : Color(0xFFC4C4C4);

  static Color get kCardBackground =>
      _isDark ? Color(0xFF424242) : Color(0xFFE7EBF0);

  static Color get kBackground => _isDark ? kDarkBackGround : kLightBackGround;

  static Color get kInverseBackground =>
      _isDark ? kLightBackGround : kDarkBackGround;

  static Color get kPrimaryTextColor => const Color(0xff030420);

  static Color get kBackButtonTextColor =>
      _isDark ? const Color(0xFFDADADA) : Colors.white;

  static Color get kCardShadowColor => Colors.black.withOpacity(0.9);

  static Color get kCardInnerShadowColor => _isDark ? kBackground : Colors.grey;

  static Color get kCardDropShadowColor =>
      _isDark ? Colors.transparent : Color.fromRGBO(255, 255, 255, 0.25);

  static Color get kHealthyHabitsTopStoriesColor =>
      _isDark ? Color(0xFF424242) : Color(0xFFE7EBF0);

  static Color get kHealthyHabitsNavBarColor =>
      _isDark ? Color(0xFF424242) : Color(0xFFD7D7D7);

  static Color get kHealthyHabitsStoryCardColor =>
      _isDark ? Color(0xFF424242) : Color(0xFFFFFFFF);

  static Color get kCardBorderColor => _isDark
      ? Colors.grey.withOpacity(0.2)
      : Color.fromRGBO(255, 255, 255, 0.25);

  static Color get kBackGroundGradientColor1 =>
      _isDark ? Color(0xFF2F2E2D) : Color(0xFFF8F8F8);
  static Color get kBackGroundGradientColor2 =>
      _isDark ? Color(0xFF2F2E2D) : Color(0xFFD7D7D7);

  static Color get kCalendarRow => Color(0x407D7D7D);
  static Color get kCalendarSelectedText => Color(0xFF3E3E3E);
  static Color get kTimePickerBorder => Color(0xFF7D7D7D);
  static Color get kTimePickerBackground =>
      _isDark ? Color(0xFF424242) : Color(0xFFE7EBF0);
}
