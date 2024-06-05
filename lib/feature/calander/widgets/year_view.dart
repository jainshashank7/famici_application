import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/barrel.dart';
import '../blocs/calendar/calendar_bloc.dart';

class YearlyView extends StatelessWidget {
  const YearlyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, calendarState) {
        return Container(
          width: 1229.w,
          height: 916.h,
          padding: EdgeInsets.only(right: 16.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 28.w,
                ),
                height: 100.h,
                child: DefaultHeader(date: DateTime.now()),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: 12,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 32.w,
                      mainAxisSpacing: 40.h,
                      childAspectRatio: 1229.w / 916.h,
                    ),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            child: MonthListItem(
                              key: Key(DateTime.now().toString()),
                              month: index + 1,
                              year: calendarState.currentDate.year,
                              focusDate: calendarState.currentDate,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DefaultHeader extends StatelessWidget {
  DefaultHeader({
    Key? key,
    DateTime? date,
  })  : date = date ?? DateTime.now(),
        super(key: key);

  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return MonthPageHeader(
          onTitleTapped: () async {
            final selectedDate = DateTime.now();
            context.read<CalendarBloc>().add(CurrentDateChanged(selectedDate));
          },
          backgroundColor: Colors.transparent,
          onPreviousMonth: () {
            final selectedDate =
                state.currentDate.subtract(Duration(days: 365));
            context.read<CalendarBloc>().add(CurrentDateChanged(selectedDate));
          },
          date: date,
          // textColor: ColorPallet.kPrimaryTextColor,
          onNextMonth: () {
            final selectedDate = state.currentDate.add(Duration(days: 365));
            context.read<CalendarBloc>().add(CurrentDateChanged(selectedDate));
          },
          // fontSize: 40.sp,
        );
      },
    );
  }
}

class MonthListItem extends StatelessWidget {
  MonthListItem({
    Key? key,
    this.month = 1,
    this.year,
    DateTime? focusDate,
  })  : _date = DateTime(year ?? DateTime.now().year, month),
        _focusDate = focusDate ?? DateTime.now(),
        super(key: key);

  final int month;
  final int? year;

  final DateTime _date;
  final DateTime _focusDate;
  final DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, ThemeState themeState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0.w, bottom: 8.h),
              child: Text(
                DateFormat().add_MMMM().format(_date).toUpperCase(),
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TableCalendar(
                firstDay: DateTime(_date.year, _date.month, 1),
                lastDay: DateTime(_date.year, _date.month + 1, 0),
                focusedDay: _date.month == _focusDate.year &&
                        _date.year == _focusDate.month
                    ? _focusDate
                    : DateTime(_date.year, _date.month),
                headerVisible: false,
                currentDay: _today,
                selectedDayPredicate: (date) {
                  bool isToday = DateFormat().add_yMMMMd().format(date) ==
                      DateFormat().add_yMMMMd().format(_today);
                  return !isToday &&
                      DateFormat().add_yMMMMd().format(date) ==
                          DateFormat().add_yMMMMd().format(_focusDate);
                },
                onDaySelected: (date, date2) {
                  context.read<CalendarBloc>().add(CurrentDateChanged(
                        date,
                      ));
                },
                availableGestures: AvailableGestures.none,
                calendarStyle: CalendarStyle(),
                shouldFillViewport: true,
                calendarFormat: CalendarFormat.month,
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    final text = DateFormat.E().format(day).characters.first;
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, date) {
                    return Center(
                      child: Container(
                        height: 60.sp,
                        width: 60.sp,
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
                              fontSize: 26.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, date) {
                    return Center(
                      child: Container(
                        height: 60.sp,
                        width: 60.sp,
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
                              fontSize: 26.sp,
                              color: themeState.isDark
                                  ? ColorPallet.kBrown
                                  : ColorPallet.kPrimaryTextColor,
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
                        height: 60.sp,
                        width: 60.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            DateFormat.d().format(day),
                            style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
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
        );
      },
    );
  }
}
