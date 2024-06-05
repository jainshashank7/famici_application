import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/medication_strings.dart';

import '../../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../../shared/fc_back_button.dart';
import '../../../../shared/fc_bottom_status_bar.dart';
import '../add_medication/entity/dosage.dart';
import '../entity/reminder_popup.dart';
import '../entity/selected_medication_details.dart';

class MedicationDetailsScreen extends StatefulWidget {
  const MedicationDetailsScreen({Key? key}) : super(key: key);

  @override
  _MedicationDetailsScreenState createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late MedicationBloc _medicationBloc;

  bool isShowDetails = false;
  bool isTaken = false;
  bool hasReminder = false;

  @override
  void initState() {
    _medicationBloc = context.read<MedicationBloc>();
    _medicationBloc.add(FetchMedicationDetails());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      builder: (context, medicationState) {
        if (medicationState.selectedReminderTime != '0') {
          hasReminder = true;
        }
        return FamiciScaffold(
          title: Center(
            child: Text(
              MedicationStrings.myMedication.tr(),
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 45 * FCStyle.ffem,
                height: 0.8888888889 * FCStyle.ffem / FCStyle.fem,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          leading: const FCBackButton(),
          topRight: Row(
            children: [
              LogoutButton(),
            ],
          ),
          bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
          child: Container(
            margin: EdgeInsets.fromLTRB(20 * FCStyle.fem, 0 * FCStyle.fem,
                20 * FCStyle.fem, 16.87 * FCStyle.fem),
            padding: EdgeInsets.fromLTRB(35 * FCStyle.fem, 27 * FCStyle.fem,
                31 * FCStyle.fem, 5 * FCStyle.fem),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xf2ffffff),
              borderRadius: BorderRadius.circular(10 * FCStyle.fem),
            ),
            child: medicationState.status == MedicationStatus.loading
                ? const Center(child: LoadingScreen())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                            0 * FCStyle.fem, 2 * FCStyle.fem, 16 * FCStyle.fem),
                        width: double.infinity,
                        height: 122 * FCStyle.fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  34 * FCStyle.fem,
                                  17 * FCStyle.fem,
                                  29 * FCStyle.fem,
                                  23 * FCStyle.fem),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorPallet.kPrimary.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(10 * FCStyle.fem),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 72 * FCStyle.fem,
                                  height: 82 * FCStyle.fem,
                                  child: CachedNetworkImage(
                                    width: 72 * FCStyle.fem,
                                    height: 82 * FCStyle.fem,
                                    imageUrl: medicationState
                                            .selectedMedicationDetails
                                            .medicationTypeImageUrl ??
                                        "",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  29 * FCStyle.fem,
                                  4 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  4 * FCStyle.fem),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0 * FCStyle.fem,
                                              10 * FCStyle.fem,
                                              0 * FCStyle.fem,
                                              26 * FCStyle.fem),
                                          child: Text(
                                            medicationState
                                                    .selectedMedicationDetails
                                                    .medicationName ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 50 * FCStyle.ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1 *
                                                  FCStyle.ffem /
                                                  FCStyle.fem,
                                              color: Color(0xff001221),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          medicationState
                                                  .selectedMedicationDetails
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
                                      border:
                                          Border.all(color: Color(0xffdfe4eb)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(
                                          10 * FCStyle.fem),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0 * FCStyle.fem,
                                              0 * FCStyle.fem,
                                              17 * FCStyle.fem,
                                              4 * FCStyle.fem),
                                          child: Text(
                                            'Course Duration',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20 * FCStyle.ffem,
                                              fontWeight: FontWeight.w500,
                                              height: 2 *
                                                  FCStyle.ffem /
                                                  FCStyle.fem,
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
                                              '${medicationState.selectedMedicationDetails.durationDays} Days',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 20 * FCStyle.ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.25 *
                                                    FCStyle.ffem /
                                                    FCStyle.fem,
                                                color: ColorPallet.kPrimaryText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        24 * FCStyle.fem,
                                        6 * FCStyle.fem,
                                        6 * FCStyle.fem,
                                        6 * FCStyle.fem),
                                    height: 60 * FCStyle.fem,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffdfe4eb)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(
                                          10 * FCStyle.fem),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0 * FCStyle.fem,
                                              2 * FCStyle.fem,
                                              15 * FCStyle.fem,
                                              0 * FCStyle.fem),
                                          child: Text(
                                            'Remaining Days',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20 * FCStyle.ffem,
                                              fontWeight: FontWeight.w500,
                                              height: 2 *
                                                  FCStyle.ffem /
                                                  FCStyle.fem,
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
                                              '${medicationState.selectedMedicationDetails.remainingDays} Days',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 20 * FCStyle.ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.25 *
                                                    FCStyle.ffem /
                                                    FCStyle.fem,
                                                color: ColorPallet.kPrimaryText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(1 * FCStyle.fem,
                            0 * FCStyle.fem, 0 * FCStyle.fem, 0 * FCStyle.fem),
                        padding: EdgeInsets.fromLTRB(
                            15 * FCStyle.fem,
                            22 * FCStyle.fem,
                            21 * FCStyle.fem,
                            0 * FCStyle.fem),
                        width: 1333 * FCStyle.fem,
                        height: 467 * FCStyle.fem,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x286c6974),
                              offset: Offset(0 * FCStyle.fem, 10 * FCStyle.fem),
                              blurRadius: 15 * FCStyle.fem,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 80,
                              child: SizedBox(
                                width: 1333 * FCStyle.fem,
                                height: 70 * FCStyle.fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          200 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          107 * FCStyle.fem,
                                          0 * FCStyle.fem),
                                      child: Text(
                                        'Dose',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 28 * FCStyle.ffem,
                                          fontWeight: FontWeight.w400,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150 * FCStyle.fem,
                                      margin: EdgeInsets.fromLTRB(
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          30 * FCStyle.fem,
                                          0 * FCStyle.fem),
                                      child: Text(
                                        'Med Time',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 28 * FCStyle.ffem,
                                          fontWeight: FontWeight.w400,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          35 * FCStyle.fem,
                                          2 * FCStyle.fem,
                                          78 * FCStyle.fem,
                                          0 * FCStyle.fem),
                                      child: Text(
                                        'Taken',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 28 * FCStyle.ffem,
                                          fontWeight: FontWeight.w400,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          250 * FCStyle.fem,
                                          0 * FCStyle.fem),
                                      child: Text(
                                        'Notes',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 28 * FCStyle.ffem,
                                          fontWeight: FontWeight.w400,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem),
                                      child: Text(
                                        'Local Reminder',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 28 * FCStyle.ffem,
                                          fontWeight: FontWeight.w400,
                                          height:
                                              1.25 * FCStyle.ffem / FCStyle.fem,
                                          color: ColorPallet.kPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 125,
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  height: 200 * FCStyle.fem,
                                  width: 1333 * FCStyle.fem,
                                  child: medicationState
                                              .selectedMedicationDetails
                                              .dosageList !=
                                          null
                                      ? ListView.builder(
                                          itemCount: medicationState
                                              .selectedMedicationDetails
                                              .dosageList
                                              ?.length,
                                          itemBuilder: (context, index) {
                                            return DoseWidgetItem(
                                              dosage: medicationState
                                                  .selectedMedicationDetails
                                                  .dosageList![index],
                                              index: index,
                                              medName: medicationState
                                                      .selectedMedicationDetails
                                                      .medicationName ??
                                                  "",
                                              reminderTime: medicationState
                                                  .selectedReminderTime,
                                              medication: medicationState
                                                  .selectedMedicationDetails,
                                              isTaken: medicationState
                                                      .selectedMedicationDetails
                                                      .dosageList?[0]
                                                      .hasTaken ??
                                                  false,
                                              hasReminder: hasReminder,
                                            );
                                          })
                                      : const SizedBox(),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: Container(
                                height: 60 * FCStyle.fem,
                                width: 200 * FCStyle.fem,
                                margin: EdgeInsets.fromLTRB(
                                    1108 * FCStyle.fem,
                                    0 * FCStyle.fem,
                                    13 * FCStyle.fem,
                                    0 * FCStyle.fem),
                                child: TextButton(
                                  onPressed: () {
                                    fcRouter
                                        .navigate(const IntakeHistoryRoute());
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        13.92 * FCStyle.fem,
                                        10 * FCStyle.fem,
                                        20.5 * FCStyle.fem,
                                        9 * FCStyle.fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xfff1f3f4)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(
                                          10 * FCStyle.fem),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x286c6974),
                                          offset: Offset(0 * FCStyle.fem,
                                              10 * FCStyle.fem),
                                          blurRadius: 15 * FCStyle.fem,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0 * FCStyle.fem,
                                              2.15 * FCStyle.fem,
                                              2.19 * FCStyle.fem,
                                              0 * FCStyle.fem),
                                          width: 25.38 * FCStyle.fem,
                                          height: 25.38 * FCStyle.fem,
                                          child: SvgPicture.asset(
                                            AssetIconPath.intakeHistoryIcon,
                                            color: ColorPallet.kPrimary,
                                            width: 25.38 * FCStyle.fem,
                                            height: 25.38 * FCStyle.fem,
                                          ),
                                        ),
                                        Text(
                                          'Intake History',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18 * FCStyle.ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 2.2222222222 *
                                                FCStyle.ffem /
                                                FCStyle.fem,
                                            color: ColorPallet.kPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: isShowDetails
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            10 * FCStyle.fem),
                                        border: Border.all(
                                            color: Color(0xffb2b4bd)),
                                        color: Colors.white,
                                      ),
                                      margin: EdgeInsets.fromLTRB(
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          37 * FCStyle.fem),
                                      width: 1292 * FCStyle.fem,
                                      height: 263 * FCStyle.fem,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              DetailsWidgetItem(
                                                placeholder: 'Prescriber Name',
                                                value: medicationState
                                                        .selectedMedicationDetails
                                                        .prescriberName ??
                                                    "Not Provided",
                                                width: 289,
                                              ),
                                              DetailsWidgetItem(
                                                placeholder: 'Effective Date',
                                                value: medicationState
                                                        .selectedMedicationDetails
                                                        .effectiveDate ??
                                                    "Not Provided",
                                                width: 289,
                                              ),
                                              DetailsWidgetItem(
                                                placeholder: 'End Date',
                                                value: medicationState
                                                        .selectedMedicationDetails
                                                        .endDate ??
                                                    "Not Provided",
                                                width: 289,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isShowDetails =
                                                        !isShowDetails;
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  padding: EdgeInsets.fromLTRB(
                                                      24 * FCStyle.fem,
                                                      13 * FCStyle.fem,
                                                      24 * FCStyle.fem,
                                                      12 * FCStyle.fem),
                                                  width: 200 * FCStyle.fem,
                                                  height: 55 * FCStyle.fem,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: ColorPallet
                                                            .kPrimary),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10 * FCStyle.fem),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0 * FCStyle.fem,
                                                                0 * FCStyle.fem,
                                                                14 *
                                                                    FCStyle.fem,
                                                                0 *
                                                                    FCStyle
                                                                        .fem),
                                                        child: Text(
                                                          'Show Detail',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 19 *
                                                                FCStyle.ffem,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height:
                                                                1.0526315789 *
                                                                    FCStyle
                                                                        .ffem /
                                                                    FCStyle.fem,
                                                            color: ColorPallet
                                                                .kPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 30 * FCStyle.fem,
                                                        height:
                                                            30 * FCStyle.fem,
                                                        padding: EdgeInsets.all(
                                                            7 * FCStyle.fem),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(15 *
                                                                        FCStyle
                                                                            .fem),
                                                            color: ColorPallet
                                                                .kPrimary
                                                                .withOpacity(
                                                                    0.2)),
                                                        child: SvgPicture.asset(
                                                          AssetIconPath
                                                              .showDetailsUpIcon,
                                                          color: ColorPallet
                                                              .kPrimary,
                                                          width: 7.77 *
                                                              FCStyle.fem,
                                                          height:
                                                              7 * FCStyle.fem,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DetailsWidgetItem(
                                                placeholder: 'Prescriber Phone',
                                                value: medicationState
                                                        .selectedMedicationDetails
                                                        .prescriberPhone ??
                                                    "Not Provided",
                                                width: 329,
                                              ),
                                              DetailsWidgetItem(
                                                placeholder:
                                                    'Prescriber Address',
                                                value: medicationState
                                                        .selectedMedicationDetails
                                                        .prescriberInfoAddress ??
                                                    "Not Provided",
                                                width: 450,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              DetailsWidgetItem(
                                                placeholder: 'Issue to',
                                                value: medicationState
                                                        .selectedMedicationDetails
                                                        .issueTo ??
                                                    "Not Provided",
                                                width: 820,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            10 * FCStyle.fem),
                                        border: Border.all(
                                            color: Color(0xffb2b4bd)),
                                      ),
                                      margin: EdgeInsets.fromLTRB(
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          0 * FCStyle.fem,
                                          37 * FCStyle.fem),
                                      width: 1292 * FCStyle.fem,
                                      height: 90 * FCStyle.fem,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          DetailsWidgetItem(
                                            placeholder: 'Prescriber Name',
                                            value: medicationState
                                                    .selectedMedicationDetails
                                                    .prescriberName ??
                                                "Not Provided",
                                            width: 289,
                                          ),
                                          DetailsWidgetItem(
                                            placeholder: 'Effective Date',
                                            value: medicationState
                                                    .selectedMedicationDetails
                                                    .effectiveDate ??
                                                "Not Provided",
                                            width: 289,
                                          ),
                                          DetailsWidgetItem(
                                            placeholder: 'End Date',
                                            value: medicationState
                                                    .selectedMedicationDetails
                                                    .endDate ??
                                                "Not Provided",
                                            width: 289,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isShowDetails = !isShowDetails;
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              padding: EdgeInsets.fromLTRB(
                                                  24 * FCStyle.fem,
                                                  13 * FCStyle.fem,
                                                  24 * FCStyle.fem,
                                                  12 * FCStyle.fem),
                                              width: 200 * FCStyle.fem,
                                              height: 55 * FCStyle.fem,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        ColorPallet.kPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10 * FCStyle.fem),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0 * FCStyle.fem,
                                                        0 * FCStyle.fem,
                                                        14 * FCStyle.fem,
                                                        0 * FCStyle.fem),
                                                    child: Text(
                                                      'Show Detail',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize:
                                                            19 * FCStyle.ffem,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.0526315789 *
                                                            FCStyle.ffem /
                                                            FCStyle.fem,
                                                        color: ColorPallet
                                                            .kPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 30 * FCStyle.fem,
                                                    height: 30 * FCStyle.fem,
                                                    padding: EdgeInsets.all(
                                                        7 * FCStyle.fem),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15 *
                                                                    FCStyle
                                                                        .fem),
                                                        color: ColorPallet
                                                            .kPrimary
                                                            .withOpacity(0.2)),
                                                    child: SvgPicture.asset(
                                                      AssetIconPath
                                                          .showDetailsDownIcon,
                                                      color:
                                                          ColorPallet.kPrimary,
                                                      width: 7.77 * FCStyle.fem,
                                                      height: 7 * FCStyle.fem,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  },
);
  }
}

class DoseWidgetItem extends StatelessWidget {
  const DoseWidgetItem({
    Key? key,
    required this.dosage,
    required this.index,
    required this.medName,
    required this.reminderTime,
    required this.medication,
    required this.isTaken,
    required this.hasReminder,
  }) : super(key: key);
  final Dosage dosage;
  final int index;
  final String medName;
  final String reminderTime;
  final SelectedMedicationDetails medication;
  final bool isTaken;
  final bool hasReminder;
  @override
  Widget build(BuildContext context) {
    var time = DateFormat('HH:mm').parse(dosage.time);
    var currentTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, time.hour, time.minute);
    String formattedTime = DateFormat('h:mm a')
        .format(currentTime)
        .replaceAll('am', 'AM')
        .replaceAll('pm', 'PM');
    return Container(
      margin: EdgeInsets.fromLTRB(
          0 * FCStyle.fem, 0 * FCStyle.fem, 12 * FCStyle.fem, 19 * FCStyle.fem),
      width: 1285 * FCStyle.fem,
      height: 81 * FCStyle.fem,
      child: Stack(
        children: [
          Positioned(
            left: 32 * FCStyle.fem,
            top: 0 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 1253 * FCStyle.fem,
                height: 81 * FCStyle.fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    color: ColorPallet.kPrimary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 689 * FCStyle.fem,
            top: 29 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 350 * FCStyle.fem,
                height: 50 * FCStyle.fem,
                child: Text(
                  dosage.detail ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25 * FCStyle.ffem,
                    fontWeight: FontWeight.w700,
                    height: 1 * FCStyle.ffem / FCStyle.fem,
                    color: ColorPallet.kPrimaryText,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 175 * FCStyle.fem,
            top: 14 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 133 * FCStyle.fem,
                height: 54 * FCStyle.fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    color: Color(0x0cffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x07000000),
                        offset: Offset(0 * FCStyle.fem, 20 * FCStyle.fem),
                        blurRadius: 2.5 * FCStyle.fem,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 350 * FCStyle.fem,
            top: 14 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 150 * FCStyle.fem,
                height: 54 * FCStyle.fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    color: Color(0x0cffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x07000000),
                        offset: Offset(0 * FCStyle.fem, 20 * FCStyle.fem),
                        blurRadius: 2.5 * FCStyle.fem,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 370 * FCStyle.fem,
            top: 22 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 110 * FCStyle.fem,
                height: 40 * FCStyle.fem,
                child: Text(
                  formattedTime,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25 * FCStyle.ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.6 * FCStyle.ffem / FCStyle.fem,
                    color: ColorPallet.kPrimaryText,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 220 * FCStyle.fem,
            top: 22 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 70 * FCStyle.fem,
                height: 40 * FCStyle.fem,
                child: Text(
                  dosage.quantity.value,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25 * FCStyle.ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.6 * FCStyle.ffem / FCStyle.fem,
                    color: ColorPallet.kPrimaryText,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 562 * FCStyle.fem,
            top: 5 * FCStyle.fem,
            child: TextButton(
              onPressed: () {
                if (!isTaken) {
                  fcRouter.navigate(LocalMedicationNotifyRoute(
                      medicationDetails: medication));
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(4 * FCStyle.fem),
              ),
              child: SizedBox(
                width: 35 * FCStyle.fem,
                height: 35 * FCStyle.fem,
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 35 * FCStyle.fem,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8 * FCStyle.fem),
                        border: Border.all(color: ColorPallet.kTertiary),
                        color: isTaken
                            ? ColorPallet.kTertiary
                            : ColorPallet.kPrimary,
                      ),
                      child: isTaken
                          ? Icon(
                              Icons.check,
                              color: ColorPallet.kTertiaryText,
                              weight: 10 * FCStyle.ffem,
                            )
                          : SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 1061 * FCStyle.fem,
            top: 5 * FCStyle.fem,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return ReminderPopUpScreen(
                          medName: medName,
                          sig: dosage.detail,
                          medication: medication,
                          reminderTime: reminderTime);
                    }));
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x07000000),
                      offset: Offset(0 * FCStyle.fem, 20 * FCStyle.fem),
                      blurRadius: 2.5 * FCStyle.fem,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(19.82 * FCStyle.fem,
                      15 * FCStyle.fem, 19 * FCStyle.fem, 10.92 * FCStyle.fem),
                  width: 193 * FCStyle.fem,
                  height: 50 * FCStyle.fem,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0x7fffffff)),
                    color: ColorPallet.kPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x07000000),
                        offset: Offset(0 * FCStyle.fem, 20 * FCStyle.fem),
                        blurRadius: 2.5 * FCStyle.fem,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * FCStyle.fem,
                            0.08 * FCStyle.fem,
                            5.18 * FCStyle.fem,
                            0 * FCStyle.fem),
                        width: 24 * FCStyle.fem,
                        height: 24 * FCStyle.fem,
                        child: SvgPicture.asset(
                          AssetIconPath.reminderBellIcon,
                          width: 24 * FCStyle.fem,
                          height: 24 * FCStyle.fem,
                          color: ColorPallet.kPrimary,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * FCStyle.fem,
                            0 * FCStyle.fem,
                            0 * FCStyle.fem,
                            3.08 * FCStyle.fem),
                        child: Text(
                          hasReminder ? "Edit Reminder" : 'Set Reminder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20 * FCStyle.ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.05 * FCStyle.ffem / FCStyle.fem,
                            color: ColorPallet.kPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0 * FCStyle.fem,
            top: 13 * FCStyle.fem,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                border: Border.all(color: ColorPallet.kPrimary),
                color: Colors.white,
              ),
              child: Align(
                child: SizedBox(
                  width: 117 * FCStyle.fem,
                  height: 54 * FCStyle.fem,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                      border: Border.all(color: ColorPallet.kPrimary),
                      color: ColorPallet.kPrimary.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            // dose1Ycp (571:1486)
            left: 23 * FCStyle.fem,
            top: 23 * FCStyle.fem,
            child: Align(
              child: SizedBox(
                width: 77 * FCStyle.fem,
                height: 40 * FCStyle.fem,
                child: Text(
                  'Dose1',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 27 * FCStyle.ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.4814814815 * FCStyle.ffem / FCStyle.fem,
                    color: ColorPallet.kPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsWidgetItem extends StatelessWidget {
  const DetailsWidgetItem(
      {Key? key,
      required this.placeholder,
      required this.value,
      required this.width})
      : super(key: key);

  final double width;
  final String placeholder;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 * FCStyle.fem,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: width * FCStyle.fem,
            height: 20 * FCStyle.fem,
            child: Text(
              placeholder,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16 * FCStyle.ffem,
                fontWeight: FontWeight.w600,
                height: 1.25 * FCStyle.ffem / FCStyle.fem,
                color: Color(0xff666666),
              ),
            ),
          ),
          SizedBox(
            width: width * FCStyle.fem,
            height: 20 * FCStyle.fem,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 23 * FCStyle.ffem,
                fontWeight: FontWeight.w500,
                height: 0.8695652174 * FCStyle.ffem / FCStyle.fem,
                color: Color(0xff000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
