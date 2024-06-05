import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/blocs/theme_bloc/theme_cubit.dart';
import '../../../utils/barrel.dart';
import '../blocs/calendar/calendar_bloc.dart';

class MiniCalendar extends StatelessWidget {
  MiniCalendar({
    Key? key,
  }) : super(key: key);

  final DateTime _today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, calendarState) {
            return SizedBox(
              width: 520.w,
              height: 400.h,
              child: Column(
                children: [
                  Expanded(
                    child: TableCalendar(
                      key: Key(calendarState.currentDate.toString()),
                      firstDay: DateTime(1970),
                      lastDay: DateTime(2100),
                      focusedDay: calendarState.currentDate,
                      currentDay: _today,
                      selectedDayPredicate: (date) {
                        bool isToday = DateFormat().add_yMMMMd().format(date) ==
                            DateFormat().add_yMMMMd().format(_today);
                        return !isToday &&
                            DateFormat().add_yMMMMd().format(date) ==
                                DateFormat()
                                    .add_yMMMMd()
                                    .format(calendarState.currentDate);
                      },
                      headerVisible: true,
                      availableGestures: AvailableGestures.none,
                      calendarStyle: CalendarStyle(
                        rangeHighlightScale: 3.sp,
                        rangeHighlightColor: ColorPallet.kCalendarRow,
                      ),
                      rangeStartDay: _today.subtract(Duration(
                        days: _today.weekday - 1,
                      )),
                      rangeEndDay: _today.add(Duration(
                        days: DateTime.daysPerWeek - _today.weekday,
                      )),
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        headerPadding: EdgeInsets.only(bottom: 16.h),
                        headerMargin: EdgeInsets.zero,
                        leftChevronMargin: EdgeInsets.zero,
                        rightChevronMargin: EdgeInsets.zero,
                        titleTextFormatter: (date, day) {
                          return DateFormat.yMMM().format(date);
                        },
                        titleTextStyle: FCStyle.textStyle.copyWith(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: CalendarControlButton(
                          icon: Icons.chevron_left_rounded,
                          onPressed: () {
                            calendarState.pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                        rightChevronIcon: CalendarControlButton(
                          icon: Icons.chevron_right_rounded,
                          onPressed: () {
                            calendarState.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                      shouldFillViewport: true,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarFormat: CalendarFormat.month,
                      onCalendarCreated: (controller) {
                        context.read<CalendarBloc>().add(
                              PageControllerChanged(controller),
                            );
                      },
                      onDaySelected: (date, date2) {
                        context.read<CalendarBloc>().add(CurrentDateChanged(
                              date,
                            ));
                      },
                      calendarBuilders: CalendarBuilders(
                        withinRangeBuilder: (context, date, day) {
                          return Center(
                            child: Container(
                              height: 56.sp,
                              width: 56.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPallet.kPrimaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        rangeStartBuilder: (context, date, day) {
                          return Center(
                            child: Container(
                              height: 58.sp,
                              width: 58.sp,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0, 0.5, 0.5, 1],
                                  colors: [
                                    ColorPallet.kCalendarRow,
                                    ColorPallet.kCalendarRow,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  tileMode: TileMode.repeated,
                                ),
                                shape: BoxShape.circle,
                                // color: ColorPallet.kCalendarRow,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPallet.kPrimaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        rangeEndBuilder: (context, date, day) {
                          return Center(
                            child: Container(
                              height: 58.sp,
                              width: 58.sp,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  stops: [0, 0.5, 0.5, 1],
                                  colors: [
                                    ColorPallet.kCalendarRow,
                                    ColorPallet.kCalendarRow,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  tileMode: TileMode.repeated,
                                ),
                                shape: BoxShape.circle,
                                // color: ColorPallet.kCalendarRow,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPallet.kPrimaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        dowBuilder: (context, day) {
                          final text = DateFormat.E().format(day);
                          return Center(
                            child: Text(
                              text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorPallet.kPrimaryTextColor,
                              ),
                            ),
                          );
                        },
                        selectedBuilder: (context, day, date) {
                          DateTime rangeStart = _today.subtract(Duration(
                            days: _today.weekday - 1,
                          ));

                          if (DateFormat().add_yMd().format(day) ==
                              DateFormat().add_yMd().format(rangeStart)) {
                            return Center(
                              child: Container(
                                height: 58.sp,
                                width: 58.sp,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [0, 0.5, 0.5, 1],
                                    colors: [
                                      ColorPallet.kCalendarRow,
                                      ColorPallet.kCalendarRow,
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                    tileMode: TileMode.repeated,
                                  ),
                                  shape: BoxShape.circle,
                                  // color: ColorPallet.kCalendarRow,
                                ),
                                child: Container(
                                  height: 58.sp,
                                  width: 58.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeState.isDark
                                        ? ColorPallet.kWhite.withOpacity(0.6)
                                        : ColorPallet.kFadedGreen
                                            .withOpacity(0.6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      DateFormat.d().format(day),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeState.isDark
                                            ? ColorPallet.kBrown
                                            : ColorPallet.kPrimaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          DateTime rangeEnd = _today.add(Duration(
                            days: DateTime.daysPerWeek - _today.weekday,
                          ));

                          if (DateFormat().add_yMd().format(day) ==
                              DateFormat().add_yMd().format(rangeEnd)) {
                            return Center(
                              child: Container(
                                height: 58.sp,
                                width: 58.sp,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    stops: [0, 0.5, 0.5, 1],
                                    colors: [
                                      ColorPallet.kCalendarRow,
                                      ColorPallet.kCalendarRow,
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                    tileMode: TileMode.repeated,
                                  ),
                                  shape: BoxShape.circle,
                                  // color: ColorPallet.kCalendarRow,
                                ),
                                child: Container(
                                  height: 58.sp,
                                  width: 58.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeState.isDark
                                        ? ColorPallet.kWhite.withOpacity(0.6)
                                        : ColorPallet.kFadedGreen
                                            .withOpacity(0.6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      DateFormat.d().format(day),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeState.isDark
                                            ? ColorPallet.kBrown
                                            : ColorPallet.kPrimaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Center(
                            child: Container(
                              height: 58.sp,
                              width: 58.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeState.isDark
                                    ? ColorPallet.kWhite.withOpacity(0.6)
                                    : ColorPallet.kFadedGreen.withOpacity(0.6),
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(day),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeState.isDark
                                        ? ColorPallet.kBrown
                                        : ColorPallet.kPrimaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        todayBuilder: (context, day, date) {
                          return Center(
                            child: Container(
                              height: 58.sp,
                              width: 58.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeState.isDark
                                    ? ColorPallet.kWhite
                                    : ColorPallet.kBrown,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(day),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeState.isDark
                                        ? ColorPallet.kBrown
                                        : ColorPallet.kWhite,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        disabledBuilder: (context, day, date) {
                          return SizedBox.shrink();
                        },
                        defaultBuilder: (context, day, date) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.all(2),
                              height: FCStyle.xLargeFontSize * 2,
                              width: FCStyle.xLargeFontSize * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(day),
                                  style: TextStyle(
                                    color: ColorPallet.kPrimaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        outsideBuilder: (context, day, day1) {
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CalendarControlButton extends StatelessWidget {
  const CalendarControlButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.elevation,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData? icon;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      minDistance: 3,
      style: FCStyle.buttonCardStyle.copyWith(
        boxShape: NeumorphicBoxShape.circle(),
        depth: elevation,
      ),
      padding: EdgeInsets.all(6.0),
      margin: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorPallet.kGreen,
        ),
        child: Icon(
          icon ?? Icons.add_rounded,
          size: 80.sp,
          color: ColorPallet.kWhite,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
