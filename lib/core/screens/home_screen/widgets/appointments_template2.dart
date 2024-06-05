import 'package:card_swiper/card_swiper.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/calander/blocs/appointment/appointment_bloc.dart';

import '../../../../feature/calander/blocs/calendar/calendar_bloc.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../router/router_delegate.dart';
import '../../loading_screen/loading_screen.dart';

class AppointmentsTemplate2 extends StatefulWidget {
  const AppointmentsTemplate2({super.key});

  @override
  State<AppointmentsTemplate2> createState() => _AppointmentsTemplate2State();
}

class _AppointmentsTemplate2State extends State<AppointmentsTemplate2> {
  List<Color> color = const [
    Color(0xff4CBC9A),
    Color(0xffAC2734),
    Color(0xff5155C3),
  ];
  // Color color1 = const Color(0xff5155C3);
  // Color color2 = const Color(0xffFFD0D8);
  // Color color3 = const Color(0xffCAF2E9);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (prev, cur) =>
          prev.appointmentsThisWeek.length != cur.appointmentsThisWeek.length ||
          prev.isLoadingThisWeekAppointments !=
              cur.isLoadingThisWeekAppointments ||
          prev.remindersThisWeek != cur.remindersThisWeek ||
          prev.activityReminderThisWeek != cur.activityReminderThisWeek,
      builder: (context, calendarState) {
        if (calendarState.isLoadingThisWeekAppointments) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.36,
            width: MediaQuery.of(context).size.width * 0.20,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/appointment_group.svg',
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: LoadingScreen(
                    height: FCStyle.xLargeFontSize * 2,
                    width: FCStyle.xLargeFontSize * 2,
                  ),
                )
              ],
            ),
          );
        }

        if (calendarState.appointmentsThisWeek.isEmpty &&
            calendarState.remindersThisWeek.isEmpty &&
            calendarState.activityReminderThisWeek.isEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.36,
            width: MediaQuery.of(context).size.width * 0.20,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/appointment_group.svg',
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: FCStyle.xLargeFontSize * 3,
                    width: FCStyle.xLargeFontSize * 3.5,
                    child: Text(
                      "No appointments for today",
                      style: FCStyle.textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          );
        }

        List<ContainerItem> combinedList = [];

        combinedList
            .addAll(calendarState.appointmentsThisWeek.map((appointment) {
          return ContainerItem(
              DateTime(
                appointment.appointmentDate.year,
                appointment.appointmentDate.month,
                appointment.appointmentDate.day,
                appointment.startTime.hour,
                appointment.startTime.minute,
              ),
              "APPOINTMENT",
              appointment.appointmentName,
              appointment.appointmentDate);
        }));

        combinedList.addAll(calendarState.remindersThisWeek.map((reminder) {
          return ContainerItem(reminder.startTime, reminder.itemType.name, reminder.title,
              reminder.startTime);
        }));

        combinedList.addAll(
            calendarState.activityReminderThisWeek.map((activityReminder) {
          return ContainerItem(
              activityReminder.reminderDateTime,
              "ACTIVITY REMINDER",
              activityReminder.title,
              activityReminder.reminderDateTime);
        }));
        combinedList.sort((a, b) => a.time.compareTo(b.time));
        context
            .read<AppointmentBloc>()
            .add(AddAppointmentData(items: combinedList));
        // DebugLogger.info(" LENGHT :::: ${combinedList.length}");
        return BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, appointmentState) {
          // DebugLogger.info(" LENGHT :::: ${appointmentState.items.length}");
          return Swiper(
            loop: true,
            layout: SwiperLayout.CUSTOM,
            itemCount: 3,
            customLayoutOption: CustomLayoutOption(startIndex: 0, stateCount: 5)
              ..addScale([0.7,0.7, 1,0.7, 0], Alignment.center)
              ..addOpacity([0.35,0.35, 1,0, 0])
              ..addTranslate([
                Offset(MediaQuery.of(context).size.width * 0.065, 0),
                Offset(-MediaQuery.of(context).size.width * 0.065, 0),
                Offset(0, 0),
                Offset(MediaQuery.of(context).size.width * 0.09, 0),
                Offset(0, 0),
              ]),
            scrollDirection: Axis.horizontal,
            // allowImplicitScrolling: true,
            // autoplay: true,
            // duration: 2000,
            // autoplayDelay: 1000,
            itemHeight: MediaQuery.of(context).size.height * 0.4,
            itemWidth: MediaQuery.of(context).size.width * 0.17,
            onIndexChanged: (index) {
              print("INDEXXXX: ${index}");
              context.read<AppointmentBloc>().add(IncreaseIndex(index: 1));
            },
            itemBuilder: (context, index) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width * 0.20,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/images/appointment_box.svg',
                        color: color[index],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            appointmentState
                                .items[appointmentState.currentIndex].itemType,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                  child: Text(
                                DateFormat('MMM d, y').format(appointmentState
                                    .items[appointmentState.currentIndex].time),
                                style: TextStyle(
                                    color: color[index],
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            // textDirection: TextDirection.LTR.value,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${DateFormat('hh:mm').format(appointmentState.items[appointmentState.currentIndex].time)}',
                                // "${ appointmentState.items[appointmentState.currentIndex].time
                                //     .hour}:${ appointmentState.items[appointmentState.currentIndex].time.minute}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.06127),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.0034,
                              ),
                              Text(
                                '${DateFormat('a').format(appointmentState.items[appointmentState.currentIndex].time).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02451),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                            child: Text(
                              appointmentState
                                  .items[appointmentState.currentIndex].itemName,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}

class ContainerItem {
  final DateTime time;
  final String itemType;
  final String itemName;
  final DateTime itemDate;

  ContainerItem(this.time, this.itemType, this.itemName, this.itemDate);
}
