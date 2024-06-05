import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/feature/calander/blocs/appointment/appointment_bloc.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/calander/entities/recurrence_model.dart'
    as ClientTypeEnum;
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/stringExtention.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import '../../../core/enitity/user.dart';
import '../../../shared/custom_snack_bar/fc_alert.dart';
import '../../member_portal/blocs/meeting_bloc.dart';

String _isoCountryCode = "";

class CalendarAppointmentScreen extends StatefulWidget {
  const CalendarAppointmentScreen(
      {Key? key,
      this.appointment,
      this.calEvent,
      this.rem,
      this.activityReminder})
      : super(key: key);
  final Appointment? appointment;
  final Reminders? rem;
  final CalendarEventData? calEvent;
  final ActivityReminder? activityReminder;

  @override
  _CalendarAppointmentScreenState createState() =>
      _CalendarAppointmentScreenState();
}

class _CalendarAppointmentScreenState extends State<CalendarAppointmentScreen> {
  late User _me;
  Appointment? get appointment => widget.appointment;
  Reminders? get rem => widget.rem;
  CalendarEventData? get ical => widget.calEvent;
  ActivityReminder? get activityReminder => widget.activityReminder;
  @override
  void initState() {
    _me = Provider.of<User>(context, listen: false);
    if (appointment != null)
      context.read<AppointmentBloc>().add(SyncAppointmentEvent(appointment!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      constrained: false,
      width: 1000 * FCStyle.fem,
      height: appointment != null
          ? appointment?.telehealth != 0 &&
                  (DateTime(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day) ==
                      DateTime(
                          appointment!.appointmentDate.year,
                          appointment!.appointmentDate.month,
                          appointment!.appointmentDate.day))
              ? appointment?.notes != ''
                  ? 600 * FCStyle.fem
                  : 451 * FCStyle.fem
              : appointment?.notes != ''
                  ? 509 * FCStyle.fem
                  : 360 * FCStyle.fem
          : rem != null
              ? (rem?.note != '' || ical != null)
                  ? 600 * FCStyle.fem
                  : 451 * FCStyle.fem
              : ical != null
                  ? 600 * FCStyle.fem
                  : 360 * FCStyle.fem,
      backgroundColor: Color.fromARGB(176, 0, 0, 0),
      bodyColor: Colors.transparent,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        0 * FCStyle.fem, 420 * FCStyle.fem, 0 * FCStyle.fem),
                    child: Text(
                      appointment != null
                          ? 'Appointment'
                          : (ical != null)
                              ? ical!.idTitle.toString()
                              : rem != null
                                  ? rem?.itemType.name ==
                                          ClientTypeEnum
                                              .ClientReminderType.EVENT.name
                                      ? ClientTypeEnum
                                          .ClientReminderType.EVENT.name
                                          .toTitleCase()
                                      : ClientTypeEnum
                                          .ClientReminderType.REMINDER.name
                                          .toTitleCase()
                                  : ClientTypeEnum
                                      .ClientReminderType.REMINDER.name
                                      .toTitleCase(),
                      style: TextStyle(
                        fontSize: 45 * FCStyle.ffem,
                        fontWeight: FontWeight.w600,
                        height: 1 * FCStyle.ffem / FCStyle.fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
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
            Container(
              padding: EdgeInsets.fromLTRB(44 * FCStyle.fem, 31 * FCStyle.fem,
                  47 * FCStyle.fem, 31 * FCStyle.fem),
              width: double.infinity,
              child: Card(
                elevation: 10 * FCStyle.fem,
                child: Row(
                  children: [
                    Container(
                      width: 10 * FCStyle.fem,
                      height:
                          (appointment != null && appointment?.notes != '' ||
                                  rem != null && rem?.note != '')
                              ? 329 * FCStyle.fem
                              : ical != null
                                  ? 400 * FCStyle.fem
                                  : 180 * FCStyle.fem,
                      color: appointment != null
                          ? appointment!.color
                          : ical != null
                              ? ical!.color
                              : rem != null
                                  ? rem!.itemType.name ==
                                          ClientTypeEnum
                                              .ClientReminderType.EVENT.name
                                              .toString()
                                      ? ColorPallet.kPrimary
                                      : ColorPallet.kTertiary
                                  : Colors.redAccent,
                      margin: EdgeInsets.only(right: 38 * FCStyle.fem),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 400,
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  30 * FCStyle.fem),
                              child: Text(
                                appointment != null
                                    ? appointment!.appointmentName
                                    : ical != null
                                        ? ical!.title
                                        : rem != null
                                            ? rem!.title
                                            : activityReminder!.title,
                                style: TextStyle(
                                    fontSize: 35 * FCStyle.ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1 * FCStyle.ffem / FCStyle.fem,
                                    color: Color(0xff000000),
                                    overflow: TextOverflow.visible),
                              ),
                            ),
                            Container(
                              // pm15january2023EJt (688:1870)
                              margin: EdgeInsets.fromLTRB(
                                  0 * FCStyle.fem,
                                  5 * FCStyle.fem,
                                  0 * FCStyle.fem,
                                  32.63 * FCStyle.fem),
                              child: Text(
                                appointment != null
                                    ? '${DateFormat('h:mm a').format(
                                          appointment!.startTime,
                                        ).replaceAll("pm", "PM").replaceAll("am", "AM")} - ${DateFormat(time12hFormat).format(
                                          appointment!.endTime,
                                        ).replaceAll('pm', "PM,").replaceAll("am", "AM")} ${DateFormat('MMMM d, y').format(
                                        appointment!.appointmentDate,
                                      )}'
                                    : ical != null
                                        ? '${DateFormat('h:mm a').format(
                                              ical!.startTime!,
                                            ).replaceAll("pm", "PM").replaceAll("am", "AM")} - ${DateFormat(time12hFormat).format(
                                              ical!.endTime!,
                                            ).replaceAll('pm', "PM,").replaceAll("am", "AM")} ${DateFormat('MMMM d, y').format(
                                            ical!.startTime!,
                                          )}'
                                        : rem != null
                                            ? rem!.itemType.name ==
                                                    ClientTypeEnum
                                                        .ClientReminderType
                                                        .EVENT
                                                        .name
                                                        .toString()
                                                ? '${DateFormat('h:mm a').format(
                                                      rem!.startTime,
                                                    ).replaceAll("pm", "PM").replaceAll("am", "AM")} - ${DateFormat(time12hFormat).format(
                                                      rem!.endTime,
                                                    ).replaceAll('pm', "PM,").replaceAll("am", "AM")} ${DateFormat('d MMMM, y').format(
                                                    rem!.startTime,
                                                  )}'
                                                : '${DateFormat('h:mm a').format(
                                                      rem!.startTime,
                                                    ).replaceAll("pm", "PM").replaceAll("am", "AM")}, ${DateFormat('d MMMM, y').format(
                                                    rem!.startTime,
                                                  )}'
                                            : '${DateFormat('h:mm a').format(activityReminder!.reminderDateTime).replaceAll("pm", "PM").replaceAll("am", "AM")}, ${DateFormat('d MMMM, y').format(
                                                activityReminder!
                                                    .reminderDateTime,
                                              )}',
                                style: TextStyle(
                                  fontSize: 26 * FCStyle.ffem,
                                  fontWeight: FontWeight.w600,
                                  height:
                                      0.5769230769 * FCStyle.ffem / FCStyle.fem,
                                  color: ColorPallet.kTertiary,
                                ),
                              ),
                            ),
                            (appointment != null && appointment?.notes != '' ||
                                    rem != null && rem?.note != '' ||
                                    ical != null)
                                ? Container(
                                    width: 550,
                                    // decoration: BoxDecoration(
                                    //     color: Colors.blueGrey.shade100,
                                    //     border: Border.all(
                                    //         color: Colors.black, width: 1)),
                                    height: ical != null
                                        ? 190 * FCStyle.fem
                                        : 149 * FCStyle.fem,
                                    child: TextFormField(
                                        enabled: true,
                                        readOnly: true,
                                        maxLines: ical != null ? 9 : 3,
                                        initialValue: (appointment != null &&
                                                appointment?.notes != '')
                                            ? appointment!.notes
                                            : ical != null
                                                ? ical!.description!
                                                    .replaceAll(r'\n', '\n')
                                                : rem!.note!,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 24 * FCStyle.fem,
                                            fontWeight: FontWeight.w400),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.blue.shade50,
                                          focusColor: Color.fromARGB(
                                              255, 125, 125, 125),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 125, 125, 125),
                                                  width: 1)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 125, 125, 125),
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 125, 125, 125),
                                                  width: 1)),
                                          contentPadding: EdgeInsets.only(
                                              top: 12,
                                              bottom: 12,
                                              left: 14,
                                              right: 14),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 125, 125, 125),
                                                  width: 1)),
                                        )
                                        // contentPadding: EdgeInsets.only(
                                        //     top: 12,
                                        //     bottom: 12,
                                        //     left: 14,
                                        //     right: 14),
                                        // border:
                                        //     OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color.fromARGB(255, 125, 125, 125), width: 1)),
                                        // hintText: 'Enter ' + 'Notes',
                                        // hintStyle: TextStyle(color: Color.fromARGB(255, 143, 146, 161), fontSize: 28 * FCStyle.fem, fontWeight: FontWeight.w600)),
                                        ),
                                  )
                                : SizedBox.shrink(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                appointment != null
                                    ? Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0 * FCStyle.fem,
                                            2.53 * FCStyle.fem,
                                            88.74 * FCStyle.fem,
                                            0 * FCStyle.fem),
                                        constraints:
                                            BoxConstraints(maxWidth: 200),
                                        child: Text(
                                          appointment!.counselors
                                              .map((e) => e.name)
                                              .join(','),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 24 * FCStyle.ffem,
                                            fontWeight: FontWeight.w500,
                                            height:
                                                1 * FCStyle.ffem / FCStyle.fem,
                                            letterSpacing:
                                                -0.5125181675 * FCStyle.fem,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                appointment != null
                                    ? appointment!.telehealth != 0
                                        ? Row(
                                            children: [
                                              Container(
                                                // group519zxG (688:1873)
                                                margin: EdgeInsets.fromLTRB(
                                                    0 * FCStyle.fem,
                                                    0 * FCStyle.fem,
                                                    9.26 * FCStyle.fem,
                                                    0 * FCStyle.fem),
                                                width: 45 * FCStyle.fem,
                                                height: 29.21 * FCStyle.fem,
                                                child: SvgPicture.asset(
                                                  AssetIconPath.telehealthIcon,
                                                  color:
                                                      ColorPallet.kPrimaryColor,
                                                  width: 45 * FCStyle.fem,
                                                  height: 29.21 * FCStyle.fem,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0 * FCStyle.fem,
                                                    3 * FCStyle.fem,
                                                    0 * FCStyle.fem,
                                                    0.47 * FCStyle.fem),
                                                child: Text(
                                                  'Telehealth',
                                                  style: TextStyle(
                                                    fontSize: 24 * FCStyle.ffem,
                                                    fontWeight: FontWeight.w500,
                                                    height: 0.5833333333 *
                                                        FCStyle.ffem /
                                                        FCStyle.fem,
                                                    letterSpacing:
                                                        -0.5125181675 *
                                                            FCStyle.fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : SizedBox.shrink()
                                    : ical != null
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // group519zxG (688:1873)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0 * FCStyle.fem,
                                                              0 * FCStyle.fem,
                                                              9.26 *
                                                                  FCStyle.fem,
                                                              0 * FCStyle.fem),
                                                      width: 45 * FCStyle.fem,
                                                      height:
                                                          29.21 * FCStyle.fem,
                                                      child: Icon(
                                                        Icons.calendar_month,
                                                        color: ColorPallet
                                                            .kPrimaryColor,
                                                        size: 30 * FCStyle.fem,
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0 * FCStyle.fem,
                                                        3 * FCStyle.fem,
                                                        0 * FCStyle.fem,
                                                        0.47 * FCStyle.fem),
                                                    child: Text(
                                                      'Calendar Event',
                                                      style: TextStyle(
                                                        fontSize:
                                                            24 * FCStyle.ffem,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0.5833333333 *
                                                            FCStyle.ffem /
                                                            FCStyle.fem,
                                                        letterSpacing:
                                                            -0.5125181675 *
                                                                FCStyle.fem,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        : rem != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // group519zxG (688:1873)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0 * FCStyle.fem,
                                                              0 * FCStyle.fem,
                                                              9.26 *
                                                                  FCStyle.fem,
                                                              0 * FCStyle.fem),
                                                      width: 45 * FCStyle.fem,
                                                      height:
                                                          29.21 * FCStyle.fem,
                                                      child: Icon(
                                                        Icons.tablet_mac,
                                                        color: ColorPallet
                                                            .kPrimaryColor,
                                                        size: 30 * FCStyle.fem,
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0 * FCStyle.fem,
                                                        3 * FCStyle.fem,
                                                        0 * FCStyle.fem,
                                                        0.47 * FCStyle.fem),
                                                    child: Text(
                                                      'Tablet ' +
                                                          rem!.itemType.name
                                                              .toLowerCase(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            24 * FCStyle.ffem,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0.5833333333 *
                                                            FCStyle.ffem /
                                                            FCStyle.fem,
                                                        letterSpacing:
                                                            -0.5125181675 *
                                                                FCStyle.fem,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : activityReminder != null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          // group519zxG (688:1873)
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0 *
                                                                      FCStyle
                                                                          .fem,
                                                                  0 *
                                                                      FCStyle
                                                                          .fem,
                                                                  9.26 *
                                                                      FCStyle
                                                                          .fem,
                                                                  0 *
                                                                      FCStyle
                                                                          .fem),
                                                          width:
                                                              45 * FCStyle.fem,
                                                          height: 29.21 *
                                                              FCStyle.fem,
                                                          child: Icon(
                                                            Icons.monitor,
                                                            color: ColorPallet
                                                                .kPrimaryColor,
                                                            size: 30 *
                                                                FCStyle.fem,
                                                          )),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0 * FCStyle.fem,
                                                                3 * FCStyle.fem,
                                                                0 * FCStyle.fem,
                                                                0.47 *
                                                                    FCStyle
                                                                        .fem),
                                                        child: Text(
                                                          'Provider reminder',
                                                          style: TextStyle(
                                                            fontSize: 24 *
                                                                FCStyle.ffem,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height:
                                                                0.5833333333 *
                                                                    FCStyle
                                                                        .ffem /
                                                                    FCStyle.fem,
                                                            letterSpacing:
                                                                -0.5125181675 *
                                                                    FCStyle.fem,
                                                            color: Color(
                                                                0xff000000),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : SizedBox.shrink()
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            appointment != null
                ? (appointment!.telehealth != 0 &&
                        (DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day) ==
                            DateTime(
                                appointment!.appointmentDate.year,
                                appointment!.appointmentDate.month,
                                appointment!.appointmentDate.day)))
                    ? BlocBuilder<ConnectivityBloc, ConnectivityState>(
                        builder: (context, connectivity) {
                        return GestureDetector(
                            onTap: () {
                              if (!isMeetingTime()) {
                                if (DateTime.now().isAfter(DateTime(
                                    appointment!.appointmentDate.year,
                                    appointment!.appointmentDate.month,
                                    appointment!.appointmentDate.day,
                                    appointment!.endTime.hour,
                                    appointment!.endTime.minute))) {
                                  FCAlert.showInfo(
                                      "The meeting has already ended.",
                                      duration:
                                          const Duration(milliseconds: 1000));
                                } else {
                                  FCAlert.showInfo(
                                      "The meeting hasn't started yet.",
                                      duration:
                                          const Duration(milliseconds: 1000));
                                }
                              } else if (isMeetingTime() &&
                                  connectivity.hasInternet) {
                                context.read<MeetingBloc>().add(
                                    FetchMeetingDetailsEvent(
                                        appointment!.groupUuid));
                                fcRouter.popAndPush(WaitingRoomRoute());
                              } else {
                                connectivity.hasInternet
                                    ? () {}
                                    : FCAlert.showError(
                                        "No internet, Please check you network connection.",
                                        duration:
                                            const Duration(milliseconds: 1000));
                              }
                            },
                            child: Container(
                              width: 207 * FCStyle.fem,
                              height: 65 * FCStyle.fem,
                              margin: EdgeInsets.only(left: 44 * FCStyle.fem),
                              decoration: BoxDecoration(
                                color: ColorPallet.kPrimary,
                                borderRadius:
                                    BorderRadius.circular(10 * FCStyle.fem),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x07000000),
                                    offset: Offset(
                                        0 * FCStyle.fem, 10 * FCStyle.fem),
                                    blurRadius: 2.5 * FCStyle.fem,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Enter Waiting Room',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20 * FCStyle.ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.05 * FCStyle.ffem / FCStyle.fem,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ));
                      })
                    : SizedBox.shrink()
                : rem != null
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              fcRouter.pop();
                              fcRouter.navigate(
                                  CreateAppointmentRoute(appointment: rem));
                            },
                            child: Container(
                              width: 207 * FCStyle.fem,
                              height: 65 * FCStyle.fem,
                              margin: EdgeInsets.only(left: 44 * FCStyle.fem),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: ColorPallet.kPrimary, width: 2),
                                borderRadius:
                                    BorderRadius.circular(10 * FCStyle.fem),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x07000000),
                                    offset: Offset(
                                        0 * FCStyle.fem, 10 * FCStyle.fem),
                                    blurRadius: 2.5 * FCStyle.fem,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Edit ' + rem!.itemType.name.toLowerCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20 * FCStyle.ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.05 * FCStyle.ffem / FCStyle.fem,
                                    color: ColorPallet.kPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          BlocBuilder<CalendarBloc, CalendarState>(
                              builder: (context, state) {
                            return GestureDetector(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FCConfirmDialog(
                                        height: 430,
                                        thirdButtonText: 'Delete only One',
                                        isThirdButton: true,
                                        width: 800,
                                        submitText: 'Delete All',
                                        cancelText: 'Cancel',
                                        icon: VitalIcons.deleteIcon,
                                        message:
                                            "Do you want to delete all the recurrence ${rem!.itemType.name.toLowerCase()} associated with the selected ${rem!.itemType.name.toLowerCase()}?",
                                      );
                                    }).then((value) async {
                                  if (value) {
                                    context.read<ManageRemindersBloc>().add(
                                        DeleteEventsAndRemindersForByRecurrenceRule(
                                            recurrence_id: rem!.recurrenceId,
                                            isEvent: rem!.itemType.name ==
                                                    ClientReminderType
                                                        .EVENT.name
                                                        .toString()
                                                ? true
                                                : false));
                                    context.read<CalendarBloc>().add(
                                        FetchCalendarDetailsEvent(
                                            state.startDate, state.endDate));
                                    context.read<CalendarBloc>().add(
                                        FetchThisWeekAppointmentsCalendarEvent());
                                    await AwesomeNotifications()
                                        .cancelSchedulesByGroupKey(
                                            rem!.reminderId.toString());
                                  }
                                  if (!value) {
                                    context.read<ManageRemindersBloc>().add(
                                        DeleteEventsAndRemindersData(
                                            reminder_id: rem!.reminderId,
                                            isEvent: rem!.itemType.name ==
                                                    ClientTypeEnum
                                                        .ClientReminderType
                                                        .EVENT
                                                        .name
                                                        .toString()
                                                ? true
                                                : false));
                                    context.read<CalendarBloc>().add(
                                        FetchCalendarDetailsEvent(
                                            state.startDate, state.endDate));
                                    context.read<CalendarBloc>().add(
                                        FetchThisWeekAppointmentsCalendarEvent());
                                    await AwesomeNotifications()
                                        .cancelSchedulesByGroupKey(
                                            rem!.reminderId.toString());
                                  }

                                  fcRouter.pop();
                                });
                              },
                              child: Container(
                                width: 207 * FCStyle.fem,
                                height: 65 * FCStyle.fem,
                                margin: EdgeInsets.only(left: 44 * FCStyle.fem),
                                decoration: BoxDecoration(
                                  color: ColorPallet.kPrimary,
                                  borderRadius:
                                      BorderRadius.circular(10 * FCStyle.fem),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x07000000),
                                      offset: Offset(
                                          0 * FCStyle.fem, 10 * FCStyle.fem),
                                      blurRadius: 2.5 * FCStyle.fem,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Delete ' +
                                        rem!.itemType.name.toLowerCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20 * FCStyle.ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.05 * FCStyle.ffem / FCStyle.fem,
                                      color: ColorPallet.kPrimaryText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  bool isMeetingTime() {
    DateTime apptDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(appointment!.appointmentDate));

    DateTime start = appointment!.startTime;
    DateTime end = appointment!.endTime;
    DateTime startTime = apptDate.add(Duration(
        hours: start.hour, minutes: start.minute - 15, seconds: start.second));
    DateTime endTime = apptDate.add(
        Duration(hours: end.hour, minutes: end.minute, seconds: end.second));
    DateTime current = DateTime.now();

    if (current.isAfter(startTime) && current.isBefore(endTime)) {
      return true;
    }
    return false;
  }
}
