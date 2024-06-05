import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';

import '../../../core/enitity/user.dart';
import '../../../core/router/router_delegate.dart';
import '../../../utils/barrel.dart';
import '../blocs/calendar/calendar_bloc.dart';
import '../blocs/manage_reminders/manage_reminders_bloc.dart';
import '../views/view_appointment.dart';

class DailyView extends StatelessWidget {
  const DailyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Container(
          height: 900.h,
          width: 1290 * FCStyle.fem,
          child: DayView(
            AppDynamicColor: ColorPallet.kPrimary,
            key: Key(DateTime.now().toString()),
            initialDay: state.currentDate,
            controller: state.eventController,
            scrollOffset: 290,
            // eventTileBuilder: (date, events, boundary, start, end) {
            //   print('coma' + events.length.toString());
            //   if (events.isNotEmpty)
            //     return InkWell(
            //       onTap: () {
            //         if (events.length > 4)
            //           showDialog(
            //             context: context,
            //             builder: (BuildContext context) {
            //               Appointment _app;
            //               return AlertDialog(
            //                 title: Text(
            //                     "Events on ${DateFormat('MMMM d, y').format(date)}",
            //                     textAlign: TextAlign.center,
            //                     style: TextStyle(fontWeight: FontWeight.bold)),
            //                 content: Container(
            //                   // height: events.length  300,
            //                   constraints: BoxConstraints(maxHeight: 300),
            //                   child: SingleChildScrollView(
            //                     physics: BouncingScrollPhysics(),
            //                     child: Column(
            //                       mainAxisSize: MainAxisSize.min,
            //                       children: List.generate(
            //                         events.length,
            //                         (index) => GestureDetector(
            //                           onTap: () {
            //                             Appointment _app = context
            //                                 .read<CalendarBloc>()
            //                                 .state
            //                                 .appointments
            //                                 .firstWhere((ap) =>
            //                                     ap.appointmentId ==
            //                                     events[index].id);
            //                             Navigator.of(context,
            //                                     rootNavigator: true)
            //                                 .pop('dialog');
            //                             fcRouter
            //                                 .navigate(CalendarAppointmentRoute(
            //                               appointment: _app,
            //                             ));
            //                           },
            //                           child: Container(
            //                             decoration: BoxDecoration(
            //                               color: events[index].color,
            //                               borderRadius:
            //                                   BorderRadius.circular(4.0),
            //                             ),
            //                             margin: EdgeInsets.symmetric(
            //                                 vertical: 5, horizontal: 10),
            //                             padding: const EdgeInsets.all(7.0),
            //                             alignment: Alignment.center,
            //                             child: Row(
            //                               children: [
            //                                 // ignore: duplicate_ignore
            //                                 Expanded(
            //                                   // ignore: lines_longer_than_80_chars, lines_longer_than_80_chars
            //                                   child: Text(
            //                                     '${DateFormat('hh:mma').format(events[index].startTime!).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${events[index].title}',
            //                                     overflow: TextOverflow.clip,
            //                                     maxLines: 1,
            //                                     style: TextStyle(
            //                                       fontWeight: FontWeight.bold,
            //                                       color: Colors.white,
            //                                       fontSize: 16,
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         else {
            //           Appointment _app = context
            //               .read<CalendarBloc>()
            //               .state
            //               .appointments
            //               .firstWhere(
            //                   (ap) => ap.appointmentId == events.first.id);
            //           fcRouter.navigate(
            //             CalendarAppointmentRoute(
            //               appointment: _app,
            //             ),
            //           );
            //         }
            //       },
            //       child: events.length > 4
            //           ? Expanded(
            //               child: Row(
            //                 children: [
            //                   for (int i = 0; i < 3; i++)
            //                     RoundedEventTile(
            //                       borderRadius: BorderRadius.circular(6.0),
            //                       time:
            //                           '${DateFormat('hh:mma').format(start).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
            //                       title: events[i].title,
            //                       titleStyle: events[i].titleStyle ??
            //                           TextStyle(
            //                             fontSize: 12,
            //                             color: events[i].color.accent,
            //                           ),
            //                       descriptionStyle: events[i].descriptionStyle,
            //                       totalEvents: events.length,
            //                       padding: EdgeInsets.all(7.0),
            //                       backgroundColor: events[i].color,
            //                     ),
            //                   Text(' moree '),
            //                 ],
            //               ),
            //             )
            //           : Expanded(
            //               child: Row(children: [
            //                 for (int i = 0; i < events.length; i++)
            //                   RoundedEventTile(
            //                     padding: EdgeInsets.symmetric(
            //                         vertical: (1100 *
            //                             FCStyle.fem /
            //                             events.length /
            //                             2)),
            //                     borderRadius: BorderRadius.circular(6.0),
            //                     time:
            //                         '${DateFormat('hh:mma').format(start).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
            //                     title: events[i].title,
            //                     titleStyle: events[i].titleStyle ??
            //                         TextStyle(
            //                           fontSize: 12,
            //                           color: events[i].color.accent,
            //                         ),
            //                     descriptionStyle: events[i].descriptionStyle,
            //                     totalEvents: events.length,
            //                     backgroundColor: events[i].color,
            //                   ),
            //               ]),
            //             ),
            //     );
            //   else
            //     return Container();
            // },

            width: 1290 * FCStyle.fem,
            eventTileBuilder: (date, events, boundary, start, end) {
              return InkWell(
                onTap: () {
                  if (events.first.event.toString() == 'providerEvent') {
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
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return CalendarAppointmentScreen(
                            calEvent: events.first,
                          );
                        }));
                  } else {
                    Reminders _app = context
                        .read<CalendarBloc>()
                        .state
                        .rem!
                        .firstWhere((ap) =>
                            ap.reminderId.toString() == events.first.id);
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return CalendarAppointmentScreen(
                            rem: _app,
                          );
                        }));
                  }
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: events.first.color,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${DateFormat('hh:mm a').format(start).replaceAll('am', 'AM').replaceAll('pm', 'PM')} - ${DateFormat('hh:mm a').format(end).replaceAll('am', 'AM').replaceAll('pm', 'PM')}',
                          overflow: TextOverflow.ellipsis,
                          style: FCStyle.textStyle.copyWith(
                            color: events[0].titleStyle != null
                                ? events[0].titleStyle!.color!
                                : Colors.white,
                            fontSize: 20.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          events.first.title,
                          overflow: TextOverflow.ellipsis,
                          style: FCStyle.textStyle.copyWith(
                            color: events[0].titleStyle != null
                                ? events[0].titleStyle!.color!
                                : Colors.white,
                            fontSize: 28.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            eventArranger: SideEventArranger(),
            onPageChange: (date, page) {
              context.read<CalendarBloc>().add(CurrentDateChanged(date));
            },
            timeLineBuilder: (date) => Container(
              child: Text(
                DateFormat('h a')
                    .format(date)
                    .replaceAll('am', 'AM')
                    .replaceAll('pm', 'PM'),
                style: FCStyle.textStyle.copyWith(
                    fontSize: 25 * FCStyle.fem,
                    color: Color.fromARGB(255, 143, 146, 161)),
                textAlign: TextAlign.center,
              ),
            ),
            showVerticalLine: false,
            showLiveTimeLineInAllDays: false,
            heightPerMinute: 1,
            // onTodaySelected: (date) {
            //   context.read<CalendarBloc>().add(CurrentDateChanged(date));
            // },
            // timeLineBuilder: (date) => Padding(
            //   padding: EdgeInsets.only(right: FCStyle.xLargeFontSize + 8),
            //   child: Text(
            //     DateFormat('h a').format(date),
            //     style: FCStyle.textStyle.copyWith(
            //       fontSize: 25.sp,
            //     ),
            //     textAlign: TextAlign.end,
            //   ),
            // ),
            // bulletRadius: 30.h,
            // arrowFromLeft: 30.w,
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
            // textColor: ColorPallet.kPrimaryTextColor,
            // fontSize: 40.sp,
          ),
        );
      },
    );
  }
}
