import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_buttons.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_details_widgets.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

class MedicationScreenLoading extends StatefulWidget {
  const MedicationScreenLoading({Key? key}) : super(key: key);

  @override
  _MedicationScreenLoadingState createState() =>
      _MedicationScreenLoadingState();
}

class _MedicationScreenLoadingState extends State<MedicationScreenLoading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 35,
                  top: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: FCStyle.blockSizeHorizontal*15,
                        height: FCStyle.blockSizeVertical*6,
                        color: ColorPallet.kLoadingColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: FCStyle.blockSizeHorizontal*12,
                        height: FCStyle.blockSizeVertical*5,
                        color: ColorPallet.kLoadingColor,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      MedicationStrings.todaysMedications.tr(),
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: FCStyle.mediumFontSize+6,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: FCStyle.blockSizeHorizontal*20,
                      height: FCStyle.blockSizeVertical*6,
                      color: ColorPallet.kLoadingColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            //width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.64,
            child: AnimationLimiter(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2.5, crossAxisCount: 3),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: 100.0,
                      child: FadeInAnimation(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: ColorPallet.kLoadingColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.photo,
                                          size: FCStyle.blockSizeVertical*12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  baseColor: ColorPallet.kWhite,
                                  highlightColor: ColorPallet.kPrimaryGrey),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: FCStyle.blockSizeHorizontal*13,
                                    height: FCStyle.blockSizeVertical*4,
                                    color: ColorPallet.kLoadingColor,
                                  ),

                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    width: FCStyle.blockSizeHorizontal*18,
                                    height: FCStyle.blockSizeVertical*3,
                                    color: ColorPallet.kLoadingColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
