import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vitals_and_wellness_widgets.dart';
import 'package:famici/utils/barrel.dart';

import 'package:timeago/timeago.dart' as timeago;

class VitalsSection extends StatelessWidget {
  const VitalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<VitalsAndWellnessBloc, VitalsAndWellnessState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.only(top: 25),
                  alignment: Alignment.center,
                  height: FCStyle.screenHeight,
                  width: FCStyle.screenWidth,
                  margin: EdgeInsets.only(
                      // top: FCStyle.largeFontSize,
                      // bottom: FCStyle.xLargeFontSize,
                      right: 0,
                      left: 0,
                      top: 10
                      // left: FCStyl,
                      // right: FCStyle.xLargeFontSize,
                      ),
                  child: AnimationLimiter(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.62,
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.vitalList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: context.vitalItem(state.vitalList[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                right: 10,
                bottom: FCStyle.defaultFontSize,
              ),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: InkWell(
                onTap: () {
                  context.read<VitalsAndWellnessBloc>().add(ToggleShowVitals());
                },
                customBorder: CircleBorder(),
                child: Padding(
                    padding: const EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
