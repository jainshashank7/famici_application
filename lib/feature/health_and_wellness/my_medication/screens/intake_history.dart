import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/screens/intake_history_loading.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/calendar_intake_history.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_details_widgets.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../../core/screens/home_screen/widgets/bottom_status_bar.dart';

class IntakeHistoryScreen extends StatefulWidget {
  const IntakeHistoryScreen({Key? key}) : super(key: key);

  @override
  State<IntakeHistoryScreen> createState() => _IntakeHistoryScreenState();
}

class _IntakeHistoryScreenState extends State<IntakeHistoryScreen> {
  @override
  void initState() {
    context.read<MedicationBloc>().add(FetchIntakeHistory(
        DateFormat("MM").format(DateTime.now()),
        DateTime.now().year.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
      title: Center(
        child: Text(
          MedicationStrings.intakeHistory.tr(),
          style: TextStyle(
            color: ColorPallet.kPrimaryTextColor,
            fontSize: FCStyle.largeFontSize,
          ),
        ),
      ),
      trailing: LogoutButton(),
      bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
      child: BlocBuilder<MedicationBloc, MedicationState>(
        builder: (context, state) {
          if (state.status == MedicationStatus.loading) {
            return IntakeHistoryLoading();
          }
          return Container(
            height: 0.9 * FCStyle.screenHeight,
            margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 12),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Color.fromARGB(229, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
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
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            34 * FCStyle.fem,
                            30 * FCStyle.fem,
                            29 * FCStyle.fem,
                            23 * FCStyle.fem),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorPallet.kPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 72 * FCStyle.fem,
                            height: 82 * FCStyle.fem,
                            child: CachedNetworkImage(
                              width: 72 * FCStyle.fem,
                              height: 82 * FCStyle.fem,
                              imageUrl: state.selectedMedicationDetails
                                      .medicationTypeImageUrl ??
                                  "",
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
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  10 * FCStyle.fem,
                                  2 * FCStyle.fem),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem,
                                        10 * FCStyle.fem),
                                    child: Text(
                                      state.selectedMedicationDetails
                                              .medicationName ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 50 * FCStyle.ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1 * FCStyle.ffem / FCStyle.fem,
                                        color: Color(0xff001221),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    state.selectedMedicationDetails
                                            .nextDosageTime ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 30 * FCStyle.ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 0.8666666667 *
                                          FCStyle.ffem /
                                          FCStyle.fem,
                                      color: Color(0xff001221),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  21 * FCStyle.fem,
                                  0 * FCStyle.fem),
                              padding: EdgeInsets.fromLTRB(
                                  22 * FCStyle.fem,
                                  6 * FCStyle.fem,
                                  6 * FCStyle.fem,
                                  6 * FCStyle.fem),
                              height: 60 * FCStyle.fem,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffdfe4eb)),
                                color: Color(0xffffffff),
                                borderRadius:
                                    BorderRadius.circular(10 * FCStyle.fem),
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
                                  Container(
                                    width: 133 * FCStyle.fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorPallet.kPrimary),
                                      color: ColorPallet.kPrimary,
                                      borderRadius: BorderRadius.circular(
                                          10 * FCStyle.fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        int.parse(state
                                                    .selectedMedicationMissedDoses) >
                                                1
                                            ? "${state.selectedMedicationMissedDoses} " +
                                                MedicationStrings.days.tr()
                                            : "${state.selectedMedicationMissedDoses} " +
                                                MedicationStrings.day.tr(),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 20 * FCStyle.ffem,
                                          fontWeight: FontWeight.w600,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimaryText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem),
                              padding: EdgeInsets.fromLTRB(
                                  22 * FCStyle.fem,
                                  6 * FCStyle.fem,
                                  6 * FCStyle.fem,
                                  6 * FCStyle.fem),
                              height: 60 * FCStyle.fem,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffdfe4eb)),
                                color: Color(0xffffffff),
                                borderRadius:
                                    BorderRadius.circular(10 * FCStyle.fem),
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
                                  Container(
                                    width: 133 * FCStyle.fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorPallet.kPrimary),
                                      color: ColorPallet.kPrimary,
                                      borderRadius: BorderRadius.circular(
                                          10 * FCStyle.fem),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${state.selectedMedicationRemainingCount} Days',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 20 * FCStyle.ffem,
                                          fontWeight: FontWeight.w600,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimaryText,
                                        ),
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
                            padding:
                                EdgeInsets.only(top: 14, left: 30, right: 30),
                            child: FCCalendarIntakeHistory())),
                    SizedBox(
                      width: 30,
                    ),
                    context.colorCodes(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  },
);
  }
}
