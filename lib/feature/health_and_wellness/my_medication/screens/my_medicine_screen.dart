import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/blocs/add_medication/add_medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/screens/empty_medication_details.dart';
import 'package:famici/feature/health_and_wellness/my_medication/screens/medication_screen_loading.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_buttons.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/medication_strings.dart';

import '../../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../../shared/custom_snack_bar/fc_alert.dart';
import '../../../../shared/fc_back_button.dart';
import '../../../../shared/fc_bottom_status_bar.dart';
import '../../../notification/blocs/notification_bloc/notification_bloc.dart';
import '../entity/medication.dart';

class MyMedicineScreen extends StatefulWidget {
  const MyMedicineScreen({Key? key}) : super(key: key);

  @override
  _MyMedicineScreenState createState() => _MyMedicineScreenState();
}

class _MyMedicineScreenState extends State<MyMedicineScreen> {
  late Timer _timer;
  late DateTime _now = DateTime.now();

  void changeDateTime() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void initState() {
    context.read<MedicationBloc>().add(FetchMedications());
    context
        .read<NotificationBloc>()
        .add(DismissAllMedicationNotificationEvent());
    changeDateTime();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return BlocBuilder<MedicationBloc, MedicationState>(
        buildWhen: (prev, current) {
      if (current.addStatus.name == MedicationFormStatus.success.name) {
        FCAlert.showSuccess('Medication created successfully.');
        context.read<MedicationBloc>().add(FetchMedications());
        current.addStatus = MedicationStatus.initial;
      }
      if (current.editStatus.name == MedicationFormStatus.success.name) {
        FCAlert.showSuccess('Medication edited successfully.');
        context.read<MedicationBloc>().add(FetchMedications());
        current.editStatus = MedicationStatus.initial;
      }
      if (current.deleteStatus.name == MedicationFormStatus.success.name) {
        FCAlert.showSuccess('Medication deleted successfully.');
        context.read<MedicationBloc>().add(FetchMedications());
        current.deleteStatus = MedicationStatus.initial;
      }
      if (current.deleteStatus.name == MedicationFormStatus.failure.name) {
        FCAlert.showError('Medication deleted Failed.');
        current.deleteStatus = MedicationStatus.initial;
      }
      if (current.editStatus.name == MedicationFormStatus.failure.name) {
        FCAlert.showError('Medication edition Failed.');
        current.editStatus = MedicationStatus.initial;
      }
      if (current.addStatus.name == MedicationFormStatus.failure.name) {
        FCAlert.showError('Medication addition Failed.');
        current.addStatus = MedicationStatus.initial;
      }
      if (prev != current) return true;
      return false;
    }, builder: (context, state) {
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
            Container(
              child: ElevatedButton(
                // borderRadius: BorderRadius.circular(10),
                // color: Colors.white,
                onPressed: () {
                  fcRouter.navigate(AddEditMedicationRoute());
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    )),
                    elevation: MaterialStatePropertyAll(20),
                    shadowColor: MaterialStatePropertyAll(
                        Color.fromARGB(87, 41, 72, 152)),
                    alignment: Alignment.center,
                    backgroundColor:
                        MaterialStatePropertyAll(ColorPallet.kTertiary)),
                // defaultSize: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        VitalIcons.addDevice,
                        color: ColorPallet.kTertiaryText,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Add Medication',
                        textAlign: TextAlign.center,
                        style: FCStyle.textStyle.copyWith(
                            fontFamily: 'roboto',
                            fontSize: 25 * FCStyle.fem,
                            fontWeight: FontWeight.w400,
                            color: ColorPallet.kTertiaryText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            LogoutButton(),
          ],
        ),
        bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
        child: state.medicationList.isEmpty
            ? state.status == MedicationStatus.loading
                ? Center(child: MedicationScreenLoading())
                : EmptyMedicationDetails()
            : Container(
                margin: EdgeInsets.fromLTRB(17 * FCStyle.fem, 0 * FCStyle.fem,
                    23 * FCStyle.fem, 16.87 * FCStyle.fem),
                padding: EdgeInsets.fromLTRB(45 * FCStyle.fem, 15 * FCStyle.fem,
                    24 * FCStyle.fem, 20 * FCStyle.fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xe5ffffff),
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(3 * FCStyle.fem,
                          0 * FCStyle.fem, 10 * FCStyle.fem, 23 * FCStyle.fem),
                      width: double.infinity,
                      height: 60 * FCStyle.fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                                0 * FCStyle.fem, 0, 0 * FCStyle.fem),
                            child: Text(
                              'Today\'s Medication\n',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 35 * FCStyle.ffem,
                                fontWeight: FontWeight.w500,
                                height:
                                    1.1428571429 * FCStyle.ffem / FCStyle.fem,
                                color: Color(0xff080400),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                24 * FCStyle.fem,
                                16 * FCStyle.fem,
                                28 * FCStyle.fem,
                                17 * FCStyle.fem),
                            height: 60 * FCStyle.fem,
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorPallet.kTertiary),
                              color: ColorPallet.kTertiary.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(8 * FCStyle.fem),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * FCStyle.fem,
                                      2 * FCStyle.fem,
                                      16 * FCStyle.fem,
                                      0 * FCStyle.fem),
                                  child: Text(
                                    DateFormat('MMMM d, y')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 24 * FCStyle.ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.0416666667 *
                                          FCStyle.ffem /
                                          FCStyle.fem,
                                      color: ColorPallet.kTertiary,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * FCStyle.fem,
                                      0 * FCStyle.fem,
                                      0 * FCStyle.fem,
                                      0.33 * FCStyle.fem),
                                  width: 25 * FCStyle.fem,
                                  height: 26.67 * FCStyle.fem,
                                  child: SvgPicture.asset(
                                    AssetIconPath.appointmentIcon,
                                    width: 25 * FCStyle.fem,
                                    height: 26.67 * FCStyle.fem,
                                    color: ColorPallet.kTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.all(10),
                      //width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: AnimationLimiter(
                        child: Scrollbar(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2.5,
                              crossAxisCount: 3,
                            ),
                            // shrinkWrap: false,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.medicationList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Medication _medication =
                                  state.medicationList[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: Duration(milliseconds: 100),
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: MedicineListItem(
                                      medication: _medication,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  },
);
  }
}
