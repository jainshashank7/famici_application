import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/selected_medication_details.dart';

import '../../../../core/offline/local_database/notifiction_db.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../shared/popup_scaffold.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/constants/assets_paths.dart';
import '../../../notification/helper/medication_notify_helper.dart';
import '../blocs/medication_bloc.dart';

class ReminderPopUpScreen extends StatefulWidget {
  const ReminderPopUpScreen({
    Key? key,
    required this.medName,
    required this.reminderTime,
    required this.sig,
    required this.medication,
  }) : super(key: key);
  final String medName;
  final String reminderTime;
  final String sig;
  final SelectedMedicationDetails medication;

  @override
  State<ReminderPopUpScreen> createState() => _ReminderPopUpScreenState();
}

class _ReminderPopUpScreenState extends State<ReminderPopUpScreen> {
  TextEditingController timeinput = TextEditingController();
  TimeOfDay? pickedTime;
  bool showError = false;

  DateTime dateTime = DateTime.now();
  bool hasReminder = false;

  final DatabaseHelperForNotifications notificationDb =
      DatabaseHelperForNotifications();

  @override
  void initState() {
    if (widget.reminderTime != '0') {
      String formattedTime = DateFormat('hh:mm a')
          .format(DateTime.parse(widget.reminderTime))
          .replaceAll("pm", "PM")
          .replaceAll('am', "AM");
      timeinput.text = formattedTime;
    } else {
      timeinput.text = '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reminderTime != '0') {
      dateTime = DateTime.parse(widget.reminderTime);
      hasReminder = true;
    }
    return PopupScaffold(
      width: 750 * FCStyle.fem,
      height: 451 * FCStyle.fem,
      backgroundColor: Color.fromARGB(176, 0, 0, 0),
      bodyColor: Colors.transparent,
      constrained: false,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(10 * FCStyle.fem),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(43 * FCStyle.fem, 24 * FCStyle.fem,
                  15 * FCStyle.fem, 16 * FCStyle.fem),
              width: double.infinity,
              height: 95 * FCStyle.fem,
              decoration: BoxDecoration(
                color: ColorPallet.kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10 * FCStyle.fem),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    hasReminder ? "Edit Reminder" : 'Set Reminder',
                    style: TextStyle(
                      fontSize: 45 * FCStyle.ffem,
                      fontWeight: FontWeight.w500,
                      height: 1 * FCStyle.ffem / FCStyle.fem,
                      color: Color(0xff000000),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        0 * FCStyle.fem, 0 * FCStyle.fem, 1 * FCStyle.fem),
                    child: TextButton(
                      onPressed: () {
                        fcRouter.pop();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFAC2734),
                        radius: 35 * FCStyle.fem,
                        child: SvgPicture.asset(
                          AssetIconPath.closeIcon,
                          width: 35 * FCStyle.fem,
                          height: 35 * FCStyle.fem,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: 33 * FCStyle.fem, left: 45 * FCStyle.fem),
                    child: Text(
                      widget.medName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 27 * FCStyle.ffem,
                        color: Color(0xff666666),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(
                        top: 33 * FCStyle.fem, left: 2 * FCStyle.fem),
                    child: Text(
                      ' - Dose 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 27 * FCStyle.ffem,
                        color: Color(0xff666666),
                      ),
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 33 * FCStyle.fem, left: 45 * FCStyle.fem),
              padding: EdgeInsets.only(left: 10 * FCStyle.fem),
              width: 353 * FCStyle.fem,
              height: 54 * FCStyle.fem,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorPallet.kPrimary, width: 3 * FCStyle.ffem),
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem)),
              child: Center(
                child: TextField(
                  controller: timeinput,
                  decoration: InputDecoration.collapsed(hintText: "Enter Time"),
                  readOnly: true,
                  onTap: () async {
                    pickedTime = await showTimePicker(
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: ColorPallet.kPrimary,
                              accentColor: ColorPallet.kPrimary,
                              colorScheme: ColorScheme.light(
                                  primary: ColorPallet.kPrimary,  onPrimary: ColorPallet.kPrimaryText),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child ?? SizedBox.shrink());
                      },
                      initialTime: TimeOfDay.now(),
                      context: context,
                      useRootNavigator: false,
                      // builder: (BuildContext context, Widget? child) {
                      //   return MediaQuery(
                      //     data: MediaQuery.of(context)
                      //         .copyWith(alwaysUse24HourFormat: false),
                      //     child: child!,
                      //   );
                      // },
                    );

                    if (pickedTime != null) {
                      DateTime parsedTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          pickedTime!.hour,
                          pickedTime!.minute);

                      String formattedTime = DateFormat('hh:mm a')
                          .format(parsedTime)
                          .replaceAll("pm", "PM")
                          .replaceAll('am', "AM");

                      setState(() {
                        timeinput.text = formattedTime;
                      });
                    }
                  },
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: 33 * FCStyle.fem, left: 45 * FCStyle.fem),
                child: Text(
                  widget.sig,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 27 * FCStyle.ffem,
                    color: Color(0xff666666),
                  ),
                )),
            GestureDetector(
              onTap: () {
                if (pickedTime == null) {
                  setState(() {
                    showError = true;
                  });
                } else {
                  DateTime parsedTime = DateTime(dateTime.year, dateTime.month,
                      dateTime.day, pickedTime!.hour, pickedTime!.minute);

                  MedicationNotificationHelper.createLocalNotification(
                      widget.medication, parsedTime);

                  notificationDb.updateOrInsertReminder(
                      widget.medication.medicationId.toString(),
                      parsedTime.toString());

                  context.read<MedicationBloc>().add(
                      SetSelectedMedicationReminder(parsedTime.toString()));

                  fcRouter.pop();
                }
              },
              child: Container(
                width: 207 * FCStyle.fem,
                height: 65 * FCStyle.fem,
                margin: EdgeInsets.only(
                    top: 33 * FCStyle.fem, left: 45 * FCStyle.fem),
                decoration: BoxDecoration(
                  color: ColorPallet.kPrimary,
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x07000000),
                      offset: Offset(0 * FCStyle.fem, 10 * FCStyle.fem),
                      blurRadius: 2.5 * FCStyle.fem,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    hasReminder ? "Save Reminder" : 'Set Reminder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20 * FCStyle.ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.05 * FCStyle.ffem / FCStyle.fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            if (showError)
              Container(
                margin: EdgeInsets.only(
                    left: 50 * FCStyle.fem, top: 5 * FCStyle.fem),
                child: Text(
                  'Please select a time',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18 * FCStyle.ffem,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
