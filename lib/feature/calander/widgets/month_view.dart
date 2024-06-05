import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:famici/feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';

import '../../../core/enitity/user.dart';
import '../../../core/router/router.dart';
import '../../../utils/barrel.dart';
import '../blocs/calendar/calendar_bloc.dart';
import '../entities/appointments_entity.dart';
import '../views/view_appointment.dart';

class MonthlyView extends StatelessWidget {
  const MonthlyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Container(
          height: 600 * FCStyle.fem,
          width: 1290 * FCStyle.fem,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: MonthView(
            AppDynamicColor: ColorPallet.kPrimary,
            key: Key(DateTime.now().toString()),
            initialMonth: state.currentDate,
            controller: state.eventController,
            width: 1290 * FCStyle.fem,
            // backgroundColor: Colors.transparent,
            // textColor: ColorPallet.kPrimaryTextColor,
            cellAspectRatio: 1.97,
            borderColor: Color.fromARGB(255, 240, 237, 237),
            borderSize: 0.6,
            onPageChange: (date, page) {
              context.read<CalendarBloc>().add(CurrentDateChanged(date));
            },

            cellBuilder: (date, events, isToday, isInMonth) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundColor:
                          isToday ? Colors.blue : Colors.transparent,
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          color: isToday
                              ? Colors.white
                              : isInMonth
                                  ? Colors.black
                                  : Color.fromARGB(60, 0, 0, 0),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (events.isNotEmpty)
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Column(
                              // physics: BouncingScrollPhysics(),
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    events.length > 1 ? 1 : events.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        if (events.length == 1 &&
                                            events[index].event.toString() ==
                                                'providerEvent') {
                                          Appointment _app = context
                                              .read<CalendarBloc>()
                                              .state
                                              .appointments
                                              .firstWhere((app) =>
                                                  app.appointmentId ==
                                                  events[index].id);
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder:
                                                      (BuildContext context, _,
                                                          __) {
                                                    return CalendarAppointmentScreen(
                                                      appointment: _app,
                                                    );
                                                  }));
                                        } else if (events.length == 1 &&
                                            events[index].event.toString() ==
                                                "icalEvent") {
                                          print('this is icalEvent ' +
                                              events[index].toString());
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder:
                                                      (BuildContext context, _,
                                                          __) {
                                                    return CalendarAppointmentScreen(
                                                      calEvent: events[index],
                                                    );
                                                  }));
                                        } else if (events.length == 1 &&
                                            events[index].event.toString() ==
                                                'tabletEvent') {
                                          Reminders? _rem = context
                                              .read<CalendarBloc>()
                                              .state
                                              .rem
                                              ?.firstWhere((rem) =>
                                                  rem.reminderId.toString() ==
                                                  events[index].id);
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder:
                                                      (BuildContext context, _,
                                                          __) {
                                                    return CalendarAppointmentScreen(
                                                      rem: _rem,
                                                    );
                                                  }));
                                        } else if (events.length == 1 &&
                                            events[index].event.toString() ==
                                                'providerReminder') {
                                          ActivityReminder? _activityReminder =
                                              context
                                                  .read<CalendarBloc>()
                                                  .state
                                                  .activityReminder
                                                  ?.firstWhere((rem) =>
                                                      rem.id.toString() ==
                                                      events[index].id);
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder:
                                                      (BuildContext context, _,
                                                          __) {
                                                    return CalendarAppointmentScreen(
                                                        activityReminder:
                                                            _activityReminder);
                                                  }));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context1) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Events on ${DateFormat('MMMM d, y').format(date)}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                content: Container(
                                                  // height: events.length  300,
                                                  constraints: BoxConstraints(
                                                      maxHeight: 300,
                                                      maxWidth: 400),
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                        events.length,
                                                        (index) =>
                                                            GestureDetector(
                                                          onTap: () {
                                                            if (events[index]
                                                                    .event
                                                                    .toString() ==
                                                                'tabletEvent') {
                                                              Reminders _rem = context
                                                                  .read<
                                                                      CalendarBloc>()
                                                                  .state
                                                                  .rem!
                                                                  .firstWhere((rem) =>
                                                                      rem.reminderId
                                                                          .toString() ==
                                                                      events[index]
                                                                          .id);
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(
                                                                      'dialog');
                                                              // fcRouter.navigate(
                                                              //     CalendarAppointmentRoute(
                                                              //         appointment:
                                                              //             _app));
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder:
                                                                          (BuildContext context,
                                                                              _,
                                                                              __) {
                                                                        return CalendarAppointmentScreen(
                                                                          rem:
                                                                              _rem,
                                                                        );
                                                                      }));
                                                            } else if (events[
                                                                        index]
                                                                    .event
                                                                    .toString() ==
                                                                "icalEvent") {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(
                                                                      'dialog');
                                                              print('this is icalEvent ' +
                                                                  events[index]
                                                                      .toString());
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder:
                                                                          (BuildContext context,
                                                                              _,
                                                                              __) {
                                                                        return CalendarAppointmentScreen(
                                                                          calEvent:
                                                                              events[index],
                                                                        );
                                                                      }));
                                                            } else if (events[
                                                                        index]
                                                                    .event
                                                                    .toString() ==
                                                                'providerEvent') {
                                                              Appointment _app = context
                                                                  .read<
                                                                      CalendarBloc>()
                                                                  .state
                                                                  .appointments
                                                                  .firstWhere((ap) =>
                                                                      ap.appointmentId ==
                                                                      events[index]
                                                                          .id);
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(
                                                                      'dialog');
                                                              // fcRouter.navigate(
                                                              //     CalendarAppointmentRoute(
                                                              //         appointment:
                                                              //             _app));
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder:
                                                                          (BuildContext context,
                                                                              _,
                                                                              __) {
                                                                        return CalendarAppointmentScreen(
                                                                          appointment:
                                                                              _app,
                                                                        );
                                                                      }));
                                                            } else if (events[
                                                                        index]
                                                                    .event
                                                                    .toString() ==
                                                                'providerReminder') {
                                                              ActivityReminder? _activityReminder = context
                                                                  .read<
                                                                      CalendarBloc>()
                                                                  .state
                                                                  .activityReminder
                                                                  ?.firstWhere((rem) =>
                                                                      rem.id
                                                                          .toString() ==
                                                                      events[index]
                                                                          .id);
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(
                                                                      'dialog');
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder:
                                                                          (BuildContext context,
                                                                              _,
                                                                              __) {
                                                                        return CalendarAppointmentScreen(
                                                                            activityReminder:
                                                                                _activityReminder);
                                                                      }));
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  events[index]
                                                                      .color,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                            ),
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7.0),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            // ignore: duplicate_ignore
                                                            child: Text(
                                                              '${DateFormat('hh:mm a').format(events[index].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${events[index].title}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: events[index]
                                                                            .titleStyle !=
                                                                        null
                                                                    ? events[
                                                                            index]
                                                                        .titleStyle!
                                                                        .color!
                                                                    : Colors
                                                                        .white,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: events[index].color,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 0.4, horizontal: 0.0),
                                        padding: const EdgeInsets.all(3.0),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            // ignore: duplicate_ignore

                                            // ignore: lines_longer_than_80_chars, lines_longer_than_80_chars
                                            Text(
                                              events[index].startTime !=
                                                      events[index].endTime
                                                  ? '${DateFormat('hh:mm a').format(events[index].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${DateFormat('hh:mm a').format(events[index].endTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}'
                                                  : '${DateFormat('hh:mm a').format(events[index].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
                                              overflow: TextOverflow.clip,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    events[index].titleStyle !=
                                                            null
                                                        ? events[index]
                                                            .titleStyle!
                                                            .color!
                                                        : Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            // ignore: lines_longer_than_80_chars, lines_longer_than_80_chars
                                            Text(
                                              ' ${events[index].title}',
                                              overflow: TextOverflow.clip,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    events[index].titleStyle !=
                                                            null
                                                        ? events[index]
                                                            .titleStyle!
                                                            .color!
                                                        : Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            events.length > 1
                                                ? Text(
                                                    "+${events.length - 1} more",
                                                    style: (TextStyle(
                                                      color: events[index]
                                                          .color
                                                          .accent
                                                          .withAlpha(700),
                                                    )).copyWith(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                  ],
                ),
              );
            },
            // onTodaySelected: (date) {
            //   context.read<CalendarBloc>().add(CurrentDateChanged(date));
            // },

            // cellBuilder: (date, events, isToday, isInMonth) {
            //   return Stack(
            //     children: [
            //       Positioned(
            //         top: 30 * FCStyle.fem,
            //         right: 1.0,
            //         left: 1.0,
            //         bottom: 8.0,
            //         child: ListView.builder(
            //           itemCount: events.length,
            //           itemBuilder: (crx, int idx) {
            //             return InkWell(
            //               onTap: () {
            //                 Appointment _app = context
            //                     .read<CalendarBloc>()
            //                     .state
            //                     .appointments
            //                     .firstWhere(
            //                         (ap) => ap.appointmentId == events[idx].id);
            //                 fcRouter.navigate(
            //                   CalendarAppointmentRoute(
            //                     appointment: _app,
            //                   ),
            //                 );
            //                 // fcRouter.navigate(CalendarAppointmentRoute(
            //                 //   appointmentId: events[idx].id,
            //                 // ));
            //               },
            //               child: Container(
            //                 margin: EdgeInsets.only(bottom: 2),
            //                 decoration: BoxDecoration(
            //                   color: events.first.color,
            //                   borderRadius: BorderRadius.circular(5.0),
            //                 ),
            //                 padding: EdgeInsets.all(2.0),
            //                 child: Row(
            //                   mainAxisSize: MainAxisSize.min,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Flexible(
            //                       child: RichText(
            //                         text: TextSpan(
            //                           style: FCStyle.textStyle.copyWith(
            //                             fontSize: FCStyle.smallFontSize,
            //                           ),
            //                           children: [
            //                             TextSpan(
            //                               text:
            //                                   '${DateFormat('hh:mma').format(events[idx].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${events[idx].title} ',
            //                               // ${DateFormat('hh:mma').format(events[idx].endTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}

            //                               style: FCStyle.textStyle.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white,
            //                                 fontSize: 14 * FCStyle.fem,
            //                               ),
            //                             ),
            //                             // TextSpan(
            //                             //   text: DateFormat('a')
            //                             //       .format(events[idx].startTime!),
            //                             // ),
            //                           ],
            //                         ),
            //                         overflow: TextOverflow.ellipsis,
            //                       ),
            //                     ),
            //                     // Flexible(
            //                     //     child: RichText(
            //                     //   text: TextSpan(
            //                     //     text: events[idx].title,
            //                     //     style: FCStyle.textStyle.copyWith(
            //                     //       color: Colors.white,
            //                     //       fontSize: 14 * FCStyle.fem,
            //                     //     ),
            //                     //   ),
            //                     //   overflow: TextOverflow.ellipsis,
            //                     // ))
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(4.0),
            //         child: Text(
            //           DateFormat().add_d().format(date),
            //           style: FCStyle.textStyle.copyWith(
            //             fontSize: 18 * FCStyle.fem,
            //             color: isInMonth
            //                 ? ColorPallet.kPrimaryTextColor
            //                 : ColorPallet.kPrimaryTextColor.withOpacity(0.3),
            //           ),
            //         ),
            //       ),
            //     ],
            //   );
            // },

            weekDayBuilder: (day) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Color.fromARGB(255, 240, 237, 237),
                )),
                child: Text(
                  weekTitlesFull[day],
                  style: FCStyle.textStyle.copyWith(
                      fontSize: 21 * FCStyle.fem, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              );
            },
            // fontSize: 30 * FCStyle.fem,
            // arrowFromLeft: 40.w,
          ),
        );
      },
    );
  }

  static final List<String> weekTitlesFull = [
    "Monday",
    "Tuesday",
    'Wednesday',
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
}
