import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:famici/utils/constants/assets_paths.dart';

class MicrophoneIcon extends StatelessWidget {
  const MicrophoneIcon({
    Key? key,
    this.disableThemeChange = false,
    this.isDark = false,
    this.height,
    this.width,
  }) : super(key: key);

  final bool disableThemeChange;
  final bool isDark;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (!disableThemeChange) {
          if (state.mode == Brightness.dark) {
            return Image.asset(
              AssetIconPath.microphoneIconDark,
              height: height ?? FCStyle.largeFontSize,
              width: width,
            );
          } else {
            return Image.asset(
              AssetIconPath.microphoneIcon,
              height: height ?? FCStyle.largeFontSize,
              width: width,
            );
          }
        } else if (isDark) {
          return Image.asset(
            AssetIconPath.microphoneIconDark,
            height: height ?? FCStyle.largeFontSize,
            width: width,
          );
        }

        return Image.asset(
          AssetIconPath.microphoneIcon,
          height: height ?? FCStyle.largeFontSize,
          width: width,
        );
      },
    );
  }
}

class MicrophoneOffIcon extends StatelessWidget {
  const MicrophoneOffIcon({
    Key? key,
    this.disableThemeChange = false,
    this.isDark = false,
    this.height,
    this.width,
  }) : super(key: key);

  final bool disableThemeChange;
  final bool isDark;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (!disableThemeChange) {
          if (state.mode == Brightness.dark) {
            return Image.asset(
              AssetIconPath.microphoneOffIconDark,
              height: height ?? FCStyle.largeFontSize,
              width: width,
            );
          } else {
            return Image.asset(
              AssetIconPath.microphoneOffIcon,
              height: height ?? FCStyle.largeFontSize,
              width: width,
            );
          }
        } else if (isDark) {
          return Image.asset(
            AssetIconPath.microphoneOffIconDark,
            height: height ?? FCStyle.largeFontSize,
            width: width,
          );
        }

        return Image.asset(
          AssetIconPath.microphoneOffIcon,
          height: height ?? FCStyle.largeFontSize,
          width: width,
        );
      },
    );
  }
}
