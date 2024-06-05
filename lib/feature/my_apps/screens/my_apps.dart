import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/wellness_entity.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vitals_and_wellness_widgets.dart';
import 'package:famici/feature/my_apps/blocs/my_apps_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../core/router/router_delegate.dart';
import '../widgets/my_app_card_button.dart';

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
      leading: FCBackButton(
        label: "Menu",
        onPressed: () async {
          fcRouter.pop();
        },
      ),
      topRight: const LogoutButton(),
      title: Center(
        child: Text(
          HomeStrings.myApps.tr(),
          style: FCStyle.textStyle.copyWith(
            fontSize: 50.sp,
          ),
        ),
      ),

      child: Container(
        alignment: Alignment.center,
        height: FCStyle.screenHeight,
        width: FCStyle.screenWidth - FCStyle.largeFontSize * 2,
        margin: EdgeInsets.only(
          top: FCStyle.largeFontSize,
          bottom: FCStyle.xLargeFontSize,
          left: FCStyle.xLargeFontSize,
          right: FCStyle.xLargeFontSize,
        ),
        child: AnimationLimiter(
          child: GridView.count(
            childAspectRatio:
                (FCStyle.screenHeight - FCStyle.xLargeFontSize * 3) /
                    FCStyle.screenHeight,
            crossAxisCount: 2,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              AnimationConfiguration.staggeredList(
                position: 1,
                delay: Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 100.0,
                  child: FadeInAnimation(
                    child: MyAppCardButton(
                      icon: AssetImage(AssetIconPath.rideShare),
                      onPressed: () async {
                        context.read<MyAppsCubit>().openLyft();
                      },
                      label: "Ride Share",
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 2,
                delay: Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 100.0,
                  child: FadeInAnimation(
                    child: MyAppCardButton(
                      icon: AssetImage(AssetIconPath.internetIcon),
                      onPressed: () async {
                        fcRouter.navigate(InternetRoute());
                      },
                      label: "Internet",
                    ),
                  ),
                ),
              ),
              // AnimationConfiguration.staggeredList(
              //   position: 3,
              //   delay: Duration(milliseconds: 100),
              //   duration: const Duration(milliseconds: 500),
              //   child: SlideAnimation(
              //     horizontalOffset: 100.0,
              //     child: FadeInAnimation(
              //       child: MyAppCardButton(
              //         icon: AssetImage(AssetIconPath.appointmentsIcon),
              //         onPressed: () async {
              //           fcRouter.navigate(CalenderRoute());
              //         },
              //         label: "Appointments",
              //       ),
              //     ),
              //   ),
              // ),
              AnimationConfiguration.staggeredList(
                position: 3,
                delay: Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 100.0,
                  child: FadeInAnimation(
                    child: MyAppCardButton(
                      icon: AssetImage(AssetIconPath.gamesIcon),
                      onPressed: () async {
                        fcRouter.navigate(GamesSelectionRoute());
                      },
                      label: "Games",
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 4,
                delay: Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 100.0,
                  child: FadeInAnimation(
                    child: MyAppCardButton(
                      icon: AssetImage(AssetIconPath.contentDelivery),
                      onPressed: () async {
                        context.read<MyAppsCubit>().openContentDelivery();
                      },
                      label: "Content Delivery \nEngine",
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
