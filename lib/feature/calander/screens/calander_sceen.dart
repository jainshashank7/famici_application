import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/calander/widgets/this_week_appointments.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:famici/shared/fc_back_button.dart';
import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../widgets/barrel.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late CalendarBloc _calendarBloc;

  @override
  void initState() {
    _calendarBloc = context.read<CalendarBloc>();
    context.read<NotificationBloc>().add(DismissAllEventsNotificationEvent());
    _calendarBloc.add(RefreshCalendarDetailsEvent());
    // _calendarBloc.add(deleteICal("a31104cc-3b76-497f-b9df-5e8fb4dfcc64"));
    // _calendarBloc.add(updateICal(ICalURL(
    //     name: 'Google Calendar',
    //     color: Color.fromARGB(255, 0, 0, 0),
    //     id: '4deef2f7-9eb0-4f76-837c-c3baf9a7357c',
    //     url:
    //         "https://calendar.google.com/calendar/ical/ishanirwani%40gmail.com/public/basic.ics")));
    // _calendarBloc.add(LoadAllICals());
    // _calendarBloc.add(deleteICal("70279744-3051-4582-8fc0-5da0ee295ab6"));
    // _calendarBloc.add(deleteICal("7c128a05-b317-422a-9711-5d4ccc582141"));
    // _calendarBloc.add(deleteICal("538c31a5-b98c-4c36-98e3-f925725a9fc6"));

    super.initState();
  }

  @override
  void dispose() {
    _calendarBloc.add(ResetCalendarEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, ThemeState themeState) {
        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
            toolbarHeight: 140.h,
            leading: const FCBackButton(),
            title: Center(
              child: Text(
                'Calendar',
                style: FCStyle.textStyle
                    .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
              ),
            ),
            // trailing: FCMaterialButton(
            //   defaultSize: false,
            //   child: SizedBox(
            //     height: 100.h,
            //     width: 340.w,
            //     child: Center(
            //       child: Text(
            //         'Create Appointment',
            //         style: FCStyle.textStyle.copyWith(fontSize: 30.sp),
            //       ),
            //     ),
            //   ),
            //   onPressed: () {
            //     fcRouter.navigate(CreateAppointmentRoute());
            //   },
            // ),
            topRight: Row(
              children: [
                Container(
                  width: 60,
                  child: ElevatedButton(
                    // borderRadius: BorderRadius.circular(10),
                    // color: Colors.white,
                    onPressed: () {
                      context.read<CalendarBloc>().add(RefreshICals());
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: BorderSide(color: ColorPallet.kTertiary),
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        elevation: MaterialStatePropertyAll(20),
                        shadowColor: MaterialStatePropertyAll(
                            Color.fromARGB(87, 41, 72, 152)),
                        alignment: Alignment.center,
                        backgroundColor: MaterialStatePropertyAll(
                            ColorPallet.kTertiary.withOpacity(0.2))),
                    // defaultSize: false,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sync,
                          color: ColorPallet.kTertiary,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 130,
                  child: ElevatedButton(
                    // borderRadius: BorderRadius.circular(10),
                    // color: Colors.white,
                    onPressed: () {
                      fcRouter.navigate(CreateAppointmentRoute());
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        elevation: MaterialStatePropertyAll(20),
                        shadowColor: MaterialStatePropertyAll(
                            Color.fromARGB(87, 41, 72, 152)),
                        alignment: Alignment.center,
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    // defaultSize: false,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            VitalIcons.addDevice,
                            color: ColorPallet.kPrimary,
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Create',
                            textAlign: TextAlign.center,
                            style: FCStyle.textStyle.copyWith(
                                fontFamily: 'roboto',
                                fontSize: 25 * FCStyle.fem,
                                fontWeight: FontWeight.w600,
                                color: ColorPallet.kPrimary),
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
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
              // padding: EdgeInsets.only(
              //     right: 53 * FCStyle.fem,
              //     left: 0,
              //     top: 35 * FCStyle.fem,
              //     bottom: 43 * FCStyle.fem),
              padding: EdgeInsets.only(
                  top: 17 * FCStyle.fem,
                  left: 30 * FCStyle.fem,
                  right: 30 * FCStyle.fem),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     MiniCalendar(),
                      //     ThisWeekAppointments(
                      //       onTap: () {},
                      //     ),
                      //   ],
                      // ),

                      BlocBuilder<CalendarBloc, CalendarState>(
                        buildWhen: (prv, curr) =>
                            prv.currentView != curr.currentView,
                        builder: (context, state) {
                          if (state.isDaily) {
                            return DailyView();
                          } else if (state.isWeekly) {
                            return WeeklyView();
                          } else if (state.isMonthly) {
                            return MonthlyView();
                          } else if (state.isYearly) {
                            return YearlyView();
                          }

                          return Container();
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      child: BlocBuilder<CalendarBloc, CalendarState>(
                        buildWhen: (prv, curr) =>
                            prv.currentView != curr.currentView,
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.only(left: 320.sp),
                            child: CalendarViewToggle(
                              selected: state.currentView,
                              onChange: (value) {
                                context
                                    .read<CalendarBloc>()
                                    .add(CurrentCalendarViewChanged(value));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ));
  },
);
      },
    );
  }
}
