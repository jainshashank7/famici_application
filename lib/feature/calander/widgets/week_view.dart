import 'package:calendar_view/calendar_view.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/enitity/user.dart';
import '../../../core/router/router.dart';
import '../../../utils/barrel.dart';
import '../blocs/calendar/calendar_bloc.dart';
import '../blocs/manage_reminders/manage_reminders_bloc.dart';
import '../entities/appointments_entity.dart';
import '../views/view_appointment.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (previous, current) =>
          previous.currentDate != current.currentDate,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.zero,
          height: 900.h,
          width: 1290 * FCStyle.fem,
          child: WeekView(
            AppDynamicColor: ColorPallet.kPrimary,
            scrollOffset: 290,
            key: Key(DateTime.now().toString()),
            controller: state.eventController,
            initialDay: state.currentDate,
            eventArranger: MergeEventArranger(),

            eventTileBuilder: (date, events, boundary, start, end) {
              // if(events.length > 2){
              //   return InkWell(
              //     onTap: () {
              //       Appointment _app = context
              //           .read<CalendarBloc>()
              //           .state
              //           .appointments
              //           .firstWhere(
              //               (ap) => ap.appointmentId == events.first.id);
              //       fcRouter.navigate(
              //         CalendarAppointmentRoute(
              //           appointment: _app,
              //         ),
              //       );
              //     },
              //     child: RoundedEventTile(
              //       borderRadius: BorderRadius.circular(6.0),
              //       time:
              //           '${DateFormat('hh:mma').format(events[0].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
              //       title: events[0].title,
              //       titleStyle: events[0].titleStyle ??
              //           TextStyle(
              //             fontSize: 12,
              //             color: events[0].color.accent,
              //           ),
              //       descriptionStyle: events[0].descriptionStyle,
              //       totalEvents: events.length,
              //       padding: EdgeInsets.all(7.0),
              //       backgroundColor: events[0].color,
              //     ),
              //   );
              // }
              if (events.isNotEmpty) {
                return InkWell(
                  onTap: () {
                    if (events.length > 1)
                      showDialog(
                        context: context,
                        builder: (BuildContext context1) {
                          return AlertDialog(
                            title: Text(
                                "Events on ${DateFormat('MMMM d, y').format(date)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            content: Container(
                              // height: events.length  300,
                              constraints: const BoxConstraints(
                                  maxHeight: 300, maxWidth: 400),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    events.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        if (events[index].event.toString() ==
                                            'providerEvent') {
                                          Appointment _app = context
                                              .read<CalendarBloc>()
                                              .state
                                              .appointments
                                              .firstWhere((ap) =>
                                                  ap.appointmentId ==
                                                  events[index].id);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
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
                                        } else if (events[index]
                                                .event
                                                .toString() ==
                                            "icalEvent") {
                                          print('this is icalEvent ' +
                                              events[index].toString());
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
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
                                        } else {
                                          Reminders _rem = context
                                              .read<CalendarBloc>()
                                              .state
                                              .rem!
                                              .firstWhere((rem) =>
                                                  rem.reminderId.toString() ==
                                                  events[index].id);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                          // fcRouter.navigate(
                                          //     CalendarAppointmentRoute(
                                          //         appointment:
                                          //             _app));
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
                                        }
                                      },
                                      child: Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 300),
                                        decoration: BoxDecoration(
                                          color: events[index].color,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        padding: const EdgeInsets.all(7.0),
                                        alignment: Alignment.centerLeft,

                                        // ignore: duplicate_ignore

                                        // ignore: lines_longer_than_80_chars, lines_longer_than_80_chars
                                        child: Text(
                                          '${DateFormat('hh:mm a').format(events[index].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${events[index].title}',
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                events[index].titleStyle != null
                                                    ? events[index]
                                                        .titleStyle!
                                                        .color!
                                                    : Colors.white,
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
                    else if (events.first.event.toString() == 'providerEvent') {
                      Appointment _app = context
                          .read<CalendarBloc>()
                          .state
                          .appointments
                          .firstWhere(
                              (ap) => ap.appointmentId == events.first.id);
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return CalendarAppointmentScreen(
                              appointment: _app,
                            );
                          }));
                    } else if (events.first.event.toString() == "icalEvent") {
                      print('this is icalEvent ' + events.first.toString());
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return CalendarAppointmentScreen(
                              calEvent: events.first,
                            );
                          }));
                    } else {
                      Reminders? _rem = context
                          .read<CalendarBloc>()
                          .state
                          .rem
                          ?.firstWhere((rem) =>
                              rem.reminderId.toString() == events.first.id);
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return CalendarAppointmentScreen(
                              rem: _rem,
                            );
                          }));
                    }
                  },
                  child: RoundedEventTile(
                    borderRadius: BorderRadius.circular(6.0),
                    time: events[0].startTime != events[0].endTime
                        ? '${DateFormat('hh:mm a').format(events[0].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${DateFormat('hh:mm a').format(events[0].endTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}'
                        : '${DateFormat('hh:mm a').format(events[0].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',

                    // '${DateFormat('hh:mm a').format(events[0].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${DateFormat('hh:mm a').format(events[0].endTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',

                    title: events[0].title,
                    titleStyle: events[0].titleStyle ??
                        TextStyle(
                          fontSize: 12,
                          color: events[0].color.accent,
                        ),
                    descriptionStyle: events[0].descriptionStyle,
                    totalEvents: events.length,
                    padding: const EdgeInsets.all(7.0),
                    backgroundColor: events[0].color,
                  ),
                );
              } else
                return Container();
            },
            // eventTileBuilder: (date, events, boundary, start, end) {
            //   return InkWell(
            //     onTap: () {
            //       Appointment _app = context
            //           .read<CalendarBloc>()
            //           .state
            //           .appointments
            //           .firstWhere((ap) => ap.appointmentId == events.first.id);
            //       fcRouter.navigate(
            //         CalendarAppointmentRoute(
            //           appointment: _app,
            //         ),
            //       );
            //       // fcRouter.navigate(
            //       //   CalendarAppointmentRoute(
            //       //     appointmentId: events.first.id,
            //       //   ),
            //       // );
            //     },
            //     borderRadius: BorderRadius.circular(16.0),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: events.first.color,
            //         borderRadius: BorderRadius.circular(16.0),
            //       ),
            //       padding: EdgeInsets.all(8.0),
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Flexible(
            //             child: Text(
            //               DateFormat(time12hFormat).format(start),
            //               style: FCStyle.textStyle.copyWith(
            //                   color: ColorPallet.kBackground,
            //                   fontSize: 20.sp,
            //                   fontWeight: FontWeight.bold,
            //                   overflow: TextOverflow.ellipsis),
            //             ),
            //           ),
            //           Flexible(
            //             child: Text(
            //               events.first.title,
            //               overflow: TextOverflow.ellipsis,
            //               style: FCStyle.textStyle.copyWith(
            //                 color: ColorPallet.kBackground,
            //                 fontSize: 28.sp,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   );
            // },
            weekDayBuilder: (date) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 12 * FCStyle.fem),
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Color.fromARGB(255, 240, 237, 237),
                )),
                child: Column(
                  children: [
                    Text(
                      DateFormat().add_EEEE().format(date),
                      style: TextStyle(
                          fontSize: 19 * FCStyle.fem,
                          color: Color.fromARGB(255, 143, 146, 161)),
                    ),
                    Text(
                      DateFormat().add_d().format(date),
                      style: FCStyle.textStyle
                          .copyWith(fontSize: 23 * FCStyle.fem),
                    ),
                  ],
                ),
              );
            },
            // onTodaySelected: (date) {
            //   context.read<CalendarBloc>().add(CurrentDateChanged(date));
            // },
            onPageChange: (date, page) {
              context.read<CalendarBloc>().add(CurrentDateChanged(date));
            },
            width: 1290 * FCStyle.fem,
            weekTitleHeight: 48,
            showLiveTimeLineInAllDays: false,
            heightPerMinute: 0.97,
            onEventTap: (events, date) =>
                DebugLogger.info("hii" + events.toString()),
            timeLineBuilder: (date) => Container(
              child: Text(
                DateFormat('h a')
                    .format(date)
                    .replaceAll('am', 'AM')
                    .replaceAll('pm', 'PM'),
                style: FCStyle.textStyle.copyWith(
                    fontSize: 25 * FCStyle.fem,
                    color: Color.fromARGB(255, 143, 146, 161)),
                textAlign: TextAlign.start,
              ),
            ),
            // bulletRadius: 30.h,
            // arrowFromLeft: 0,
            timeLineWidth: 180.w,
            timeLineOffset: 0,
            liveTimeIndicatorSettings: HourIndicatorSettings(
              height: 2.0,
              color: ColorPallet.kRed,
              offset: -40.w,
            ),
            hourIndicatorSettings: HourIndicatorSettings(
              color: Color.fromARGB(255, 240, 237, 237),
            ),
            backgroundColor: Colors.transparent,
            // textColor: ColorPallet.kPrimaryTextColor,
            // fontSize: 40.sp,
          ),
        );
      },
    );
  }
}
