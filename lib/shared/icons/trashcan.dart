import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:famici/utils/constants/assets_paths.dart';

class TrashIcon extends StatelessWidget {
  const TrashIcon({
    Key? key,
    this.disableThemeChange = false,
    this.isDark = false,
  }) : super(key: key);

  final bool disableThemeChange;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (!disableThemeChange) {
          if (state.mode == Brightness.dark) {
            return Image.asset(
              AssetIconPath.trashCanDark,
              height: FCStyle.largeFontSize,
            );
          } else {
            return Image.asset(
              AssetIconPath.trashCan,
              height: FCStyle.largeFontSize,
            );
          }
        } else if (isDark) {
          return Image.asset(
            AssetIconPath.trashCanDark,
            height: FCStyle.largeFontSize,
          );
        }

        return Image.asset(
          AssetIconPath.trashCan,
          height: FCStyle.largeFontSize,
        );
      },
    );
  }
}
