import 'dart:convert';

import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/fc_confirm_dialog.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/helpers/widget_key.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/theme_bloc/theme_cubit.dart';
import '../../enitity/user.dart';
import '../../router/router_delegate.dart';

class UserIcon extends StatelessWidget {
  final String email;

  const UserIcon({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Center(
          child: NeumorphicButton(
            key: FCElementID.myAppsButton,
            onPressed: () async {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return const FCConfirmDialog(
              //         message:
              //             "Are you sure you want to switch to a different account?",
              //       );
              //     }).then((value) async {
              //   if (value) {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('email', email);
                  } catch (err) {
                    DebugLogger.error(err);
                  }
                  context.read<AuthBloc>().add(SignOutAuthEvent());
                  fcRouter.removeUntil((route) => false);
                  fcRouter.navigate(UserLoginRoute());
              //   } else{
              //     fcRouter.pop();
              //   }
              // });
            },
            minDistance: 5,
            padding: EdgeInsets.all(FCStyle.smallFontSize),
            margin: EdgeInsets.symmetric(
              horizontal: FCStyle.smallFontSize + 2,
            ),
            style: FCStyle.buttonCardStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SvgPicture.asset(
                    AssetIconPath.avatarIcon,
                    excludeFromSemantics: true,
                    height: FCStyle.mediumFontSize * 4,
                    color: themeState.isDark
                        ? ColorPallet.kPrimaryGrey
                        : ColorPallet.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AddUserIcon extends StatelessWidget {
  const AddUserIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Center(
          child: NeumorphicButton(
            key: FCElementID.myAppsButton,
            onPressed: () async {
              context.read<AuthBloc>().add(SignOutAuthEvent());
              fcRouter.removeUntil((route) => false);
              fcRouter.navigate(AddUserLoginRoute());
            },
            minDistance: 5,
            padding: EdgeInsets.all(FCStyle.smallFontSize),
            margin: EdgeInsets.symmetric(
              horizontal: FCStyle.smallFontSize + 2,
            ),
            style: FCStyle.buttonCardStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Container(
                    width: FCStyle.mediumFontSize * 4,
                    height: FCStyle.mediumFontSize * 4,
                    // padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeState.isDark
                          ? ColorPallet.kLightBackGround
                          : ColorPallet.kPrimaryColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add,
                          size: FCStyle.mediumFontSize * 3,
                          color: themeState.isDark
                              ? ColorPallet.kPrimaryColor
                              : ColorPallet.kWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
