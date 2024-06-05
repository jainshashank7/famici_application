import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../repositories/auth_repository.dart';
import '../../../../shared/fc_confirm_dialog.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../blocs/app_bloc/app_bloc.dart';
import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../blocs/theme_bloc/theme_cubit.dart';
import '../../../enitity/user.dart';
import '../../../router/router_delegate.dart';

class MultipleUserProfiles extends StatelessWidget {
  const MultipleUserProfiles({Key? key}) : super(key: key);

  Future<String?> username() async {
    final AuthRepository _authRepository = AuthRepository();
    User current = await _authRepository.currentUser();
    return current.username;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, stated) {
      return NeumorphicButton(
        minDistance: 3,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FCConfirmDialog(
                  message:
                      "Are you sure you want to switch to a different account?",
                );
              }).then((value) async {
            if (value) {
              fcRouter.navigate(const MultipleUserRoute());
            }
          });
        },
        style: FCStyle.buttonCardStyle.copyWith(
          boxShape: NeumorphicBoxShape.roundRect(
            const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          border: NeumorphicBorder(
            color: ColorPallet.kCardDropShadowColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPallet.kLightGreen,
                ),
                child: const Center(
                  child: FittedBox(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    // child: SvgPicture.asset(
                    //   AssetIconPath.logoutIcon,
                    //   // height: FCStyle.mediumFontSize,
                    // ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prv, next) =>
                    prv.user.givenName != next.user.givenName,
                builder: (context, authState) {
                  return Text(
                    authState.user.name?.split(" ").first ?? '',
                    style: TextStyle(
                      fontSize: FCStyle.mediumFontSize - 3,
                      color: ColorPallet.kPrimaryTextColor,
                    ),
                  );
                },
              ),
              Icon(
                Icons.arrow_drop_down,
                size: FCStyle.largeFontSize,
                color: stated.isDark ? ColorPallet.kWhite : ColorPallet.kBlack,
              ),
            ],
          ),
        ),
      );
    });
  }
}
