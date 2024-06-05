import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../shared/custom_snack_bar/fc_alert.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/helpers/events_track.dart';
import '../../calander/blocs/calendar/calendar_bloc.dart';
import '../../calander/entities/appointments_entity.dart';
import '../blocs/meeting_bloc.dart';

class WaitingRoomOverViewScreen extends StatelessWidget {
  const WaitingRoomOverViewScreen({Key? key}) : super(key: key);

  String formatTimeRange(DateTime startTime, DateTime endTime) {
    DateFormat formatter = DateFormat('h:mm a');

    String formattedStartTime = formatter.format(startTime);
    String formattedEndTime = formatter.format(endTime);

    return '$formattedStartTime - $formattedEndTime'
        .replaceAll("am", "AM")
        .replaceAll('pm', "PM");
  }

  bool isMeetingTime(Appointment appointment) {
    DateTime apptDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(appointment.appointmentDate));

    DateTime start = appointment.startTime;
    DateTime end = appointment.endTime;
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
      topRight: const LogoutButton(),
      title: Text(
        "Upcoming Appointments",
        style: TextStyle(
          color: ColorPallet.kBlack,
          fontSize: 45 * FCStyle.ffem,
        ),
      ),
      bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          DateTime dateTime = state.selectedAppointment.appointmentDate;
          String date =
              '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}-${dateTime.year.toString()}';

          String time = formatTimeRange(state.selectedAppointment.startTime,
              state.selectedAppointment.endTime);
          return Container(
            height: FCStyle.screenHeight * 0.9,
            margin:
                const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 12),
            decoration: BoxDecoration(
                color: const Color.fromARGB(229, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 65 * FCStyle.fem, top: 47 * FCStyle.fem),
                  child: Text(
                    "Your Next Telehealth Appointment",
                    style: TextStyle(
                      fontSize: 28 * FCStyle.ffem,
                      color: const Color(0xff575D63),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 65 * FCStyle.fem, top: 17 * FCStyle.fem),
                  child: Text(
                    state.selectedAppointment.appointmentName,
                    style: TextStyle(
                      fontSize: 45 * FCStyle.ffem,
                      color: ColorPallet.kBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 68 * FCStyle.fem, top: 48 * FCStyle.fem),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20 * FCStyle.fem,
                              color: const Color(0xff575D63),
                            ),
                          ),
                          SizedBox(
                            height: 10 * FCStyle.fem,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AssetIconPath.appointmentIcon,
                                width: 25 * FCStyle.fem,
                                height: 26.67 * FCStyle.fem,
                                color: ColorPallet.kPrimary,
                              ),
                              SizedBox(
                                width: 10 * FCStyle.fem,
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  color: ColorPallet.kPrimary,
                                  fontSize: 30 * FCStyle.fem,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 50 * FCStyle.fem,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20 * FCStyle.fem,
                              color: const Color(0xff575D63),
                            ),
                          ),
                          SizedBox(
                            height: 10 * FCStyle.fem,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: ColorPallet.kPrimary,
                                size: 32 * FCStyle.fem,
                              ),
                              SizedBox(
                                width: 10 * FCStyle.fem,
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                  color: ColorPallet.kPrimary,
                                  fontSize: 30 * FCStyle.fem,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 50 * FCStyle.fem,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Counselor",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20 * FCStyle.fem,
                              color: const Color(0xff575D63),
                            ),
                          ),
                          SizedBox(
                            height: 10 * FCStyle.fem,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                // width: 303 * FCStyle.fem,
                                padding: EdgeInsets.all(15 * FCStyle.fem),
                                margin:
                                    EdgeInsets.only(right: 20 * FCStyle.fem),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      state.selectedAppointment.counselors[0]
                                          .name
                                          .split(" ")
                                          .first,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24 * FCStyle.fem,
                                        color: ColorPallet.kBlack,
                                      ),
                                    ),
                                    // SvgPicture.asset(
                                    //   AssetIconPath.avatarIcon,
                                    //   excludeFromSemantics: true,
                                    //   height: 50 * FCStyle.fem,
                                    //   color: Color(0xFF5057C3),
                                    // )
                                  ],
                                ),
                              ),
                              state.selectedAppointment.counselors.length >= 2
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      // width: 303 * FCStyle.fem,
                                      padding: EdgeInsets.all(15 * FCStyle.fem),
                                      margin: EdgeInsets.only(
                                          right: 20 * FCStyle.fem),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            state.selectedAppointment
                                                .counselors[1].name
                                                .split(" ")
                                                .first,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24 * FCStyle.fem,
                                              color: ColorPallet.kBlack,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   AssetIconPath.avatarIcon,
                                          //   excludeFromSemantics: true,
                                          //   height: 50 * FCStyle.fem,
                                          //   color: Color(0xFF5057C3),
                                          // )
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              state.selectedAppointment.counselors.length >= 3
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      // width: 303 * FCStyle.fem,
                                      padding: EdgeInsets.all(15 * FCStyle.fem),
                                      margin: EdgeInsets.only(
                                          right: 20 * FCStyle.fem),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            state.selectedAppointment
                                                .counselors[2].name
                                                .split(" ")
                                                .first,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24 * FCStyle.fem,
                                              color: ColorPallet.kBlack,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   AssetIconPath.avatarIcon,
                                          //   excludeFromSemantics: true,
                                          //   height: 50 * FCStyle.fem,
                                          //   color: Color(0xFF5057C3),
                                          // )
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 67 * FCStyle.fem, top: 47 * FCStyle.fem),
                  child: Text(
                    "Before joining the meeting and to help maintain pleasant and productive environment, please try minimize distractions, be attentive and communicate respectfully. Thank you.",
                    style: TextStyle(
                      fontSize: 30 * FCStyle.ffem,
                      color: ColorPallet.kBlack,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 68 * FCStyle.fem,
                    top: 38 * FCStyle.fem,
                  ),
                  child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
                    builder: (context, connectivity) {
                      return ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff5057C3))),
                          onPressed: () {
                            for (var counselor
                                in state.selectedAppointment.counselors) {
                              var properties = TrackEvents().setProperties(
                                  fromDate: '',
                                  toDate: '',
                                  reading: '',
                                  readingDateTime: '',
                                  vital: '',
                                  appointmentDate: DateFormat("MM/dd/yyyy")
                                      .format(state
                                          .selectedAppointment.appointmentDate),
                                  appointmentTime: DateFormat.jm().format(
                                      state.selectedAppointment.startTime),
                                  appointmentCounselors: counselor.name,
                                  appointmentType: 'Upcoming Appointment',
                                  callDuration: '',
                                  readingType: '');
                              TrackEvents().trackEvents(
                                  "Telehealth - Enter Waiting Room Clicked",
                                  properties);
                            }
                            isMeetingTime(state.selectedAppointment) &&
                                    connectivity.hasInternet
                                ? context.read<MeetingBloc>().add(
                                    FetchMeetingDetailsEvent(
                                        state.selectedAppointment.groupUuid))
                                : () {};

                            isMeetingTime(state.selectedAppointment) &&
                                    connectivity.hasInternet
                                ? fcRouter.popAndPush(const WaitingRoomRoute())
                                : FCAlert.showInfo(
                                    "The meeting hasn't started yet.",
                                    duration:
                                        const Duration(milliseconds: 1000));

                            connectivity.hasInternet
                                ? () {}
                                : FCAlert.showInfo(
                                    "No internet, Please check you network connection.",
                                    duration:
                                        const Duration(milliseconds: 1000));
                          },
                          child: Text(
                            'Enter Waiting Room',
                            style: TextStyle(
                                color: ColorPallet.kPrimaryText,
                                fontSize: 26 * FCStyle.ffem,
                                fontWeight: FontWeight.bold),
                          ));
                    },
                  ),
                )
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
