import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/wellness_entity.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vitals_and_wellness_widgets.dart';

import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../widgets/sliverDelegateWithFixedHeight.dart';

class WellnessSection extends StatelessWidget {
  const WellnessSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 25),
                      alignment: Alignment.center,
                      height: FCStyle.screenHeight,
                      width: FCStyle.screenWidth,
                      margin: EdgeInsets.only(
                          // top: FCStyle.largeFontSize,
                          // bottom: FCStyle.xLargeFontSize,
                          right: 0,
                          left: 0,
                          top: 10,
                          bottom: 245
                          // left: FCStyl,
                          // right: FCStyle.xLargeFontSize,
                          ),
                      child: AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            height: 300.0,
                            crossAxisCount: 1,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.wellnessList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return
                                //remove this condition when they add "How Are You Feeling Today?" feature. im hide it in here
                                //because of when we remove this "How Are You Feeling Today?" from vitals and wellness repository
                                //it will remove for fresh installers, and already app users it will not remove because it will appear from cache memory.
                                state.wellnessList[index].name
                                        .toString()
                                        .contains("How Are You Feeling Today?")
                                    ? SizedBox.shrink()
                                    : AnimationConfiguration.staggeredList(
                                        position: index,
                                        delay: Duration(milliseconds: 100),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                          horizontalOffset: 100.0,
                                          child: FadeInAnimation(
                                            child: context.wellnessItem(
                                              state.wellnessList[index],
                                            ),
                                          ),
                                        ),
                                      );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Container(
        //     margin: EdgeInsets.only(right: 10, bottom: FCStyle.defaultFontSize),
        //     decoration: BoxDecoration(shape: BoxShape.circle),
        //     child: InkWell(
        //       onTap: () {
        //         context.read<VitalsAndWellnessBloc>().add(ToggleShowVitals());
        //       },
        //       customBorder: CircleBorder(),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Icon(
        //           Icons.arrow_back_ios_rounded,
        //           size: FCStyle.xLargeFontSize,
        //           color: ColorPallet.kPrimaryTextColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
