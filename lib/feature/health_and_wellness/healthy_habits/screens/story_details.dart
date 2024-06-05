import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/blocs/healthy_habits_bloc.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/widgets/healthy_habits_widgets.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/constants/assets_paths.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../shared/time_ago_text.dart';
import '../entity/barrel.dart';
import 'notion_web_view.dart';

class StoryDetails extends StatelessWidget {
  const StoryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthyHabitsBloc, HealthyHabitsState>(
      builder: (context, HealthyHabitsState state) {
        Blog _story = state.stories[state.storyViewSliderIndex];

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            //padding: EdgeInsets.only(top: FCStyle.largeFontSize),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      // Row(
                      //   children: [
                      //     Flexible(
                      //       child: Text(
                      //         _story.author,
                      //         style: TextStyle(
                      //           //overflow: TextOverflow.ellipsis,
                      //           color: ColorPallet.kPrimaryTextColor,
                      //           fontSize: FCStyle.mediumFontSize,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //     SizedBox(width: FCStyle.mediumFontSize),
                      //     TimeAgoText(
                      //       isDefault: true,
                      //       startTime:
                      //           _story.createdAt.millisecondsSinceEpoch,
                      //       textStyle: FCStyle.textStyle.copyWith(
                      //         fontSize: FCStyle.mediumFontSize,
                      //         fontWeight: FontWeight.w400,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  child: SvgPicture.asset(
                                      VitalIcons.blogImageLine,
                                      color: ColorPallet.kTertiary,
                                      fit: BoxFit.fill),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _story.author,
                                  style: TextStyle(
                                    //overflow: TextOverflow.ellipsis,
                                    color: ColorPallet.kPrimaryTextColor,
                                    fontSize: 24 * FCStyle.fem,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Row(
                            children: [
                              SvgPicture.asset(
                                VitalIcons.blogImageClock,
                                width: 20,
                                height: 20,
                                color: ColorPallet.kPrimary,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TimeAgoText(
                                isDefault: true,
                                startTime:
                                    _story.createdAt.millisecondsSinceEpoch,
                                textStyle: FCStyle.textStyle.copyWith(
                                  fontSize: 24 * FCStyle.fem,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: NotionWebView(
                            key: Key(_story.id),
                            url: _story.url,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  // top: 100,
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HealthyHabitsBloc>()
                          .add(ShowPreviousStory());
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100 * FCStyle.fem,
                          width: 100 * FCStyle.fem,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(144, 0, 0, 0),
                                offset: Offset.fromDirection(20),
                                blurRadius: 6),
                          ], shape: BoxShape.circle, color: Colors.white),
                        ),
                        // Image.asset(
                        //   state.storyViewSliderIndex > 0
                        //       ? AssetIconPath.rectangleFilled
                        //       : AssetIconPath.rectangleUnfilled,
                        //   width: 100,
                        // ),
                        SvgPicture.asset(
                          VitalIcons.arrowLargeRight,
                          width: 15,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  // top: 100,
                  child: InkWell(
                    onTap: () {
                      context.read<HealthyHabitsBloc>().add(ShowNextStory());
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100 * FCStyle.fem,
                          width: 100 * FCStyle.fem,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(144, 0, 0, 0),
                                offset: Offset.fromDirection(20),
                                blurRadius: 6),
                          ], shape: BoxShape.circle, color: Colors.white),
                        ),
                        // Image.asset(
                        //   state.storyViewSliderIndex > 0
                        //       ? AssetIconPath.rectangleFilled
                        //       : AssetIconPath.rectangleUnfilled,
                        //   width: 100,
                        // ),
                        SvgPicture.asset(
                          VitalIcons.arrowLargeLeft,
                          width: 15,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
