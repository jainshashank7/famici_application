import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/widgets/add_medication_widgets.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_details_widgets.dart';
import 'package:famici/shared/concave_card.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

class IntakeHistoryLoading extends StatelessWidget {
  const IntakeHistoryLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 0.9 * FCStyle.screenHeight,
        margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 12),
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Color.fromARGB(229, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(
              top: 20,
            ),
            margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 10 * FCStyle.fem,
                2 * FCStyle.fem, 16 * FCStyle.fem),
            width: double.infinity,
            height: 127 * FCStyle.fem,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: ColorPallet.kWhite,
                  highlightColor: ColorPallet.kPrimaryGrey,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(34 * FCStyle.fem,
                        30 * FCStyle.fem, 29 * FCStyle.fem, 23 * FCStyle.fem),
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorPallet.kPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 72 * FCStyle.fem,
                        height: 82 * FCStyle.fem,
                        child: Icon(
                          size: 72 * FCStyle.fem,
                          //height: 82 * FCStyle.fem,
                          Icons.photo,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(29 * FCStyle.fem,
                      4 * FCStyle.fem, 0 * FCStyle.fem, 4 * FCStyle.fem),
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 493 * FCStyle.fem,
                        margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                            0 * FCStyle.fem, 10 * FCStyle.fem, 2 * FCStyle.fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  10 * FCStyle.fem),
                              color: ColorPallet.kLoadingColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                            0 * FCStyle.fem, 21 * FCStyle.fem, 0 * FCStyle.fem),
                        padding: EdgeInsets.fromLTRB(22 * FCStyle.fem,
                            6 * FCStyle.fem, 6 * FCStyle.fem, 6 * FCStyle.fem),
                        height: 60 * FCStyle.fem,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffdfe4eb)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  17 * FCStyle.fem,
                                  4 * FCStyle.fem),
                              child: Text(
                                'Missed Doses',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20 * FCStyle.ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 2 * FCStyle.ffem / FCStyle.fem,
                                  color: Color(0xff7d7f81),
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor: ColorPallet.kPrimary,
                              child: Container(
                                width: 133 * FCStyle.fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorPallet.kPrimary),
                                  color: ColorPallet.kPrimary,
                                  borderRadius:
                                      BorderRadius.circular(10 * FCStyle.fem),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                            0 * FCStyle.fem, 0 * FCStyle.fem, 0 * FCStyle.fem),
                        padding: EdgeInsets.fromLTRB(22 * FCStyle.fem,
                            6 * FCStyle.fem, 6 * FCStyle.fem, 6 * FCStyle.fem),
                        height: 60 * FCStyle.fem,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffdfe4eb)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  17 * FCStyle.fem,
                                  4 * FCStyle.fem),
                              child: Text(
                                'Remaining Days',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20 * FCStyle.ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 2 * FCStyle.ffem / FCStyle.fem,
                                  color: Color(0xff7d7f81),
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor: ColorPallet.kPrimary,
                              child: Container(
                                width: 133 * FCStyle.fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorPallet.kPrimary),
                                  color: ColorPallet.kPrimary,
                                  borderRadius:
                                      BorderRadius.circular(10 * FCStyle.fem),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   padding: EdgeInsets.fromLTRB(
                      //       24 * FCStyle.fem,
                      //       6 * FCStyle.fem,
                      //       6 * FCStyle.fem,
                      //       6 * FCStyle.fem),
                      //   height: 60 * FCStyle.fem,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: Color(0xffdfe4eb)),
                      //     color: Color(0xffffffff),
                      //     borderRadius:
                      //         BorderRadius.circular(10 * FCStyle.fem),
                      //   ),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         margin: EdgeInsets.fromLTRB(
                      //             0 * FCStyle.fem,
                      //             2 * FCStyle.fem,
                      //             15 * FCStyle.fem,
                      //             0 * FCStyle.fem),
                      //         child: Text(
                      //           'Remaining Days',
                      //           style: TextStyle(
                      //             fontFamily: 'Roboto',
                      //             fontSize: 20 * FCStyle.ffem,
                      //             fontWeight: FontWeight.w500,
                      //             height: 2 * FCStyle.ffem / FCStyle.fem,
                      //             color: Color(0xff7d7f81),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         width: 133 * FCStyle.fem,
                      //         height: double.infinity,
                      //         decoration: BoxDecoration(
                      //           border:
                      //               Border.all(color: ColorPallet.kPrimary),
                      //           color: ColorPallet.kPrimary,
                      //           borderRadius: BorderRadius.circular(
                      //               10 * FCStyle.fem),
                      //         ),
                      //         child: Center(
                      //           child: Text(
                      //             '${state.selectedMedicationRemainingCount} Days',
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //               fontFamily: 'Roboto',
                      //               fontSize: 20 * FCStyle.ffem,
                      //               fontWeight: FontWeight.w600,
                      //               height:
                      //                   1.25 * FCStyle.ffem / FCStyle.fem,
                      //               color: Color(0xffffffff),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),

            // Row(

            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Shimmer.fromColors(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
            //           children: <Widget>[
            //             Container(
            //               child: Icon(
            //                 Icons.photo,
            //                 size: FCStyle.blockSizeVertical * 16,
            //               ),
            //             ),
            //           ],
            //         ),
            //         baseColor: ColorPallet.kWhite,
            //         highlightColor: ColorPallet.kPrimaryGrey),
            //     Container(
            //       width: FCStyle.blockSizeHorizontal * 20,
            //       height: FCStyle.blockSizeVertical * 5,
            //       color: ColorPallet.kLoadingColor,
            //     )
            //   ],
            // ),
          ),
          SizedBox(
            height: 0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      height: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.only(top: 14, left: 30, right: 30),
                      child: LoadingScreen())),
              SizedBox(
                width: 30,
              ),
              context.colorCodes(),
            ],
          ),
        ]));
  }
}
