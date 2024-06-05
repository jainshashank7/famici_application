import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../shared/fc_back_button.dart';
import '../../../utils/barrel.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/strings/home_strings.dart';
import '../widgets/my_app_card_button.dart';

class GamesSelectionScreen extends StatelessWidget {
  const GamesSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
      bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
      title: Center(
        child: Text(
          'Games',
          style: FCStyle.textStyle.copyWith(
              fontSize: 45 * FCStyle.fem, fontWeight: FontWeight.w600),
        ),
      ),
      topRight: const LogoutButton(),
      leading: const FCBackButton(),
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
        decoration: BoxDecoration(
            color: Color.fromARGB(229, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      'Interesting Games',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 70 * FCStyle.fem,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100 * FCStyle.fem),
                        bottomRight: Radius.circular(100 * FCStyle.fem)),
                    color: ColorPallet.kPrimary,
                  ),
                  height: 330 * FCStyle.fem,
                  width: double.infinity,
                )),
            Positioned(
              top: 170,
              left: 80,
              right: 70,
              child: Container(
                child: AnimationLimiter(
                  child: Row(
                    children: [
                      Container(
                        width: 280 * FCStyle.fem,
                        height: 300 * FCStyle.fem,
                        child: AnimationConfiguration.staggeredList(
                          position: 1,
                          delay: Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: MyAppCardButton(
                                color: Colors.white,
                                svgIcon: VitalIcons.sudoku,
                                margin: EdgeInsets.all(0),
                                labelTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 76, 188, 154),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30 * FCStyle.fem),
                                onPressed: () async {
                                  fcRouter
                                      .navigate(GameRoute(game: Game.sudoku));
                                },
                                label: "Sudoku",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 280 * FCStyle.fem,
                        height: 300 * FCStyle.fem,
                        child: AnimationConfiguration.staggeredList(
                          position: 2,
                          delay: Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: MyAppCardButton(
                                color: Colors.white,
                                margin: EdgeInsets.all(0),
                                svgIcon: VitalIcons.jigsaw,
                                labelTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 51, 51, 51),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30 * FCStyle.fem),
                                onPressed: () async {
                                  fcRouter
                                      .navigate(GameRoute(game: Game.jigsaw));
                                },
                                label: "Jigsaw",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 280 * FCStyle.fem,
                        height: 300 * FCStyle.fem,
                        child: AnimationConfiguration.staggeredList(
                          position: 3,
                          delay: Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: MyAppCardButton(
                                margin: EdgeInsets.all(0),
                                color: Colors.white,
                                svgIcon: VitalIcons.solitaire,
                                labelTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 89, 91, 196),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30 * FCStyle.fem),
                                onPressed: () async {
                                  fcRouter.navigate(
                                      GameRoute(game: Game.solitaire));
                                },
                                label: "Solitaire",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 280 * FCStyle.fem,
                        height: 300 * FCStyle.fem,
                        child: AnimationConfiguration.staggeredList(
                          position: 4,
                          delay: Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: MyAppCardButton(
                                color: Colors.white,
                                margin: EdgeInsets.all(0),
                                svgIcon: VitalIcons.wordSearch,
                                labelTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 172, 39, 52),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30 * FCStyle.fem),
                                onPressed: () async {
                                  fcRouter.navigate(
                                      GameRoute(game: Game.wordSearch));
                                },
                                label: "Word Search",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }
}
