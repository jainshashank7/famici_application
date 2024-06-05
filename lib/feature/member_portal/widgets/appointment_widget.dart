import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../utils/helpers/events_track.dart';
import '../../calander/entities/appointments_entity.dart';

class AppointmentWidget extends StatelessWidget {
  final Appointment appointment;

  const AppointmentWidget({required this.appointment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, connectivity) {
      return Padding(
        padding: EdgeInsets.only(
            left: 20 * FCStyle.fem,
            top: 20 * FCStyle.fem,
            right: 20 * FCStyle.fem),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20 * FCStyle.fem,
                right: 20 * FCStyle.fem,
                top: 10 * FCStyle.fem,
                bottom: 10 * FCStyle.fem),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 20 * FCStyle.fem, right: 30 * FCStyle.fem),
                  child: SvgPicture.asset(
                    appointment.telehealth == 1
                        ? AssetIconPath.telehealthIcon
                        : AssetIconPath.officeApptIcon,
                    width: 55 * FCStyle.fem,
                    color: ColorPallet.kPrimaryColor,
                  ),
                ),
                Text(
                  getTime(appointment),
                  style: TextStyle(
                      color: ColorPallet.kPrimaryColor,
                      fontSize: 30 * FCStyle.ffem,
                      letterSpacing: 1.25,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      appointment.telehealth == 1
                          ? ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xff5057C3))),
                              onPressed: () {
                                for (var counselor in appointment.counselors) {
                                  var properties = TrackEvents().setProperties(
                                      fromDate: '',
                                      toDate: '',
                                      reading: '',
                                      readingDateTime: '',
                                      vital: '',
                                      appointmentDate: DateFormat("MM/dd/yyyy")
                                          .format(appointment.appointmentDate),
                                      appointmentTime: DateFormat.jm()
                                          .format(appointment.startTime),
                                      appointmentCounselors: counselor.name,
                                      appointmentType: 'Upcoming Appointment',
                                      callDuration: '',
                                      readingType: '');
                                  TrackEvents().trackEvents(
                                      "Appointment - Enter Waiting Room Clicked",
                                      properties);
                                }
                                context.read<CalendarBloc>().add(
                                    SelectedAppointmentDetails(appointment));

                                fcRouter
                                    .navigate(const WaitingRoomOverViewRoute());
                              },
                              child: Text(
                                'Enter Waiting Room',
                                style: TextStyle(
                                    color: ColorPallet.kPrimaryText,
                                    fontSize: 26 * FCStyle.ffem,
                                    fontWeight: FontWeight.bold),
                              ))
                          : ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xff7e7e80))),
                              onPressed: () {},
                              child: Text(
                                'Office Event',
                                style: TextStyle(
                                    color: ColorPallet.kWhite,
                                    fontSize: 26 * FCStyle.ffem,
                                    fontWeight: FontWeight.bold),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String getTime(appointment) {
    DateTime apptDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(appointment.appointmentDate));
    DateTime start = appointment.startTime;

    DateTime startTime = apptDate.add(Duration(
        hours: start.hour, minutes: start.minute, seconds: start.second));

    return DateFormat('EEEE, MMMM dd, yyyy, ' 'at h:mm a')
        .format(startTime)
        .replaceAll("pmt", "at")
        .replaceAll("amt", "at");
  }
}
