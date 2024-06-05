import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/utils/barrel.dart';

class CallHangupMessageIcon extends StatelessWidget {
  const CallHangupMessageIcon({
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
              AssetIconPath.callHungUp,
              height: height ?? FCStyle.largeFontSize,
              width: width,
            );
          } else {
            return Image.asset(
              AssetIconPath.callHungUp,
              height: height ?? FCStyle.largeFontSize,
              width: width,
            );
          }
        } else if (isDark) {
          return Image.asset(
            AssetIconPath.callHungUp,
            height: height ?? FCStyle.largeFontSize,
            width: width,
          );
        }

        return Image.asset(
          AssetIconPath.callHungUp,
          height: height ?? FCStyle.largeFontSize,
          width: width,
        );
      },
    );
  }
}
