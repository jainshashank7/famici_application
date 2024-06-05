import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../core/blocs/theme_bloc/theme_cubit.dart';
import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({Key? key}) : super(key: key);

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
          builder: (context, stateM) {
            return FamiciScaffold(
                topRight: const LogoutButton(),
                title: Center(
                  child: Text(
                    "Waiting Room",
                    style: TextStyle(
                        color: ColorPallet.kBlack,
                        fontSize: 36 * FCStyle.ffem,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                bottomNavbar: stateM.templateId != 2
                    ? const FCBottomStatusBar()
                    : const BottomStatusBar(),
                child: Container(
                  height: FCStyle.screenHeight * 0.9,
                  margin: const EdgeInsets.only(
                      right: 20, left: 20, top: 0, bottom: 12),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(229, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 62 * FCStyle.fem,
                        ),
                        Image.asset(
                          AssetIconPath.waitingRoomUserIcon,
                          color: const Color(0xFF4D54BB),
                          width: 100 * FCStyle.fem,
                        ),
                        SizedBox(
                          height: 43 * FCStyle.fem,
                        ),
                        Text(
                          "Waiting for meeting's host to let you join..",
                          style: TextStyle(
                              fontSize: 45 * FCStyle.ffem,
                              color: const Color(0xE54CBC9A),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 13 * FCStyle.fem,
                        ),
                        Image.asset(
                          AssetIconPath.waitingRoomImage,
                          width: 823 * FCStyle.fem,
                          height: 388 * FCStyle.fem,
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}
