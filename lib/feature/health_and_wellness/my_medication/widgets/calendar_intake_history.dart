import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/blocs/add_medication/add_medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../add_medication/utils/calendar_utils.dart';

class FCCalendarIntakeHistory extends StatefulWidget {
  const FCCalendarIntakeHistory({Key? key}) : super(key: key);

  @override
  _FCCalendarIntakeHistoryState createState() =>
      _FCCalendarIntakeHistoryState();
}

class _FCCalendarIntakeHistoryState extends State<FCCalendarIntakeHistory> {
  late final PageController _pageController;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  // List<DateTime> temporaryListSelectedDays = [
  //   DateTime.parse("2022-01-22 00:00:00.000Z"),
  //   DateTime.parse("2022-01-23 00:00:00.000Z"),
  //   DateTime.parse("2022-01-24 00:00:00.000Z"),
  //   DateTime.parse("2022-01-25 00:00:00.000Z"),
  //   DateTime.parse("2022-01-26 00:00:00.000Z"),
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
        builder: (context, state) {
      return Stack(
        children: [
          Column(
            children: [
              ValueListenableBuilder<DateTime>(
                valueListenable: _focusedDay,
                builder: (context, value, _) {
                  return _CalendarHeader(
                    focusedDay: value,
                    clearButtonVisible: canClearSelection,
                    onTodayButtonTap: () {
                      setState(() => _focusedDay.value = DateTime.now());
                    },
                    onClearButtonTap: () {
                      setState(() {
                        _rangeStart = null;
                        _rangeEnd = null;
                        _selectedDays.clear();
                      });
                    },
                    onLeftArrowTap: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      context.read<MedicationBloc>().add(
                          ChangeDateOfIntakeHistory(
                              DateFormat("MM").format(DateTime(
                                  _focusedDay.value.year,
                                  _focusedDay.value.month - 1,
                                  _focusedDay.value.day)),
                              DateFormat("y").format(DateTime(
                                  _focusedDay.value.year,
                                  _focusedDay.value.month - 1,
                                  _focusedDay.value.day))));
                    },
                    onRightArrowTap: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      context.read<MedicationBloc>().add(
                          ChangeDateOfIntakeHistory(
                              DateFormat("MM").format(DateTime(
                                  _focusedDay.value.year,
                                  _focusedDay.value.month + 1,
                                  _focusedDay.value.day)),
                              DateFormat("y").format(DateTime(
                                  _focusedDay.value.year,
                                  _focusedDay.value.month + 1,
                                  _focusedDay.value.day))));
                    },
                  );
                },
              ),
              TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay.value,
                headerVisible: false,
                selectedDayPredicate: (day) => _selectedDays.contains(day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                availableGestures: AvailableGestures.none,

                calendarStyle: CalendarStyle(

                    // selectedDecoration: BoxDecoration(
                    //   color: ColorPallet.kSimpleLightGreen,
                    //   shape: BoxShape.circle
                    // ),
                    // selectedTextStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                    // cellMargin: EdgeInsets.zero,
                    // cellPadding: EdgeInsets.zero,cellAlignment: Alignment.center,
                    ),
                // holidayPredicate: (day) {
                //   // Every 20th day of the month will be treated as a holiday
                //   return day.day == 20;
                // },
                //onDaySelected: _onDaySelected,
                // onRangeSelected: _onRangeSelected,
                daysOfWeekHeight: 34 * FCStyle.fem,
                rowHeight: FCStyle.xLargeFontSize,
                daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextFormatter: (date, locale) =>
                        DateFormat.E(locale).format(date)[0],
                    weekdayStyle: TextStyle(
                        color: Color.fromARGB(255, 182, 185, 188),
                        fontSize: 22 * FCStyle.fem),
                    weekendStyle: TextStyle(
                        color: Color.fromARGB(255, 182, 185, 188),
                        fontSize: 22 * FCStyle.fem)),
                onCalendarCreated: (controller) => _pageController = controller,
                onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() => _calendarFormat = format);
                  }
                },

                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    // if (day.weekday == DateTime.sunday) {}
                    final text = DateFormat.E().format(day);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                              color: Color.fromARGB(255, 182, 185, 188),
                              fontSize: 22 * FCStyle.fem,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, day1) {
                    for (int i = 0;
                        i < state.selectedIntakeHistoryList.length;
                        i++) {
                      print('Hey this is medication h ' +
                          state.selectedIntakeHistoryList[i].medicationStatus
                              .toString() +
                          ' date ' +
                          state.selectedIntakeHistoryList[i].date.toString());
                      if (state.selectedIntakeHistoryList[i].date ==
                          DateFormat("yyyy-MM-dd").format(day)) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(2),
                            height: 50 * FCStyle.fem,
                            width: 50 * FCStyle.fem,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.selectedIntakeHistoryList[i]
                                        .medicationStatus!
                                        .toLowerCase()
                                        .contains("missed")
                                    ? ColorPallet.kFadedRed
                                    : state.selectedIntakeHistoryList[i]
                                            .medicationStatus!
                                            .toLowerCase()
                                            .contains("partially")
                                        ? Color.fromARGB(255, 89, 91, 196)
                                        : state.selectedIntakeHistoryList[i]
                                                .medicationStatus!
                                                .toLowerCase()
                                                .contains("fully")
                                            ? Color.fromARGB(255, 76, 188, 154)
                                            : ColorPallet.kPrimary
                                                .withOpacity(0.2),
                                border: state.selectedIntakeHistoryList[i]
                                        .medicationStatus!
                                        .toLowerCase()
                                        .contains("future")
                                    ? Border.all(
                                        width: 1, color: ColorPallet.kPrimary)
                                    : Border.all(color: Colors.transparent)),
                            child: Center(
                              child: Text(
                                DateFormat.d().format(day),
                                style: TextStyle(
                                  color: state.selectedIntakeHistoryList[i]
                                              .medicationStatus!
                                              .toLowerCase()
                                              .contains(
                                                  "medication completed") ||
                                          state.selectedIntakeHistoryList[i]
                                              .medicationStatus!
                                              .toLowerCase()
                                              .contains("future")
                                      ? ColorPallet.kPrimary
                                      : Colors.white,
                                  fontSize: 22 * FCStyle.fem,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return Center(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        height: 50 * FCStyle.fem,
                        width: 50 * FCStyle.fem,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPallet.kPrimary.withOpacity(0.2)),
                        child: Center(
                          child: Text(
                            DateFormat.d().format(day),
                            style: TextStyle(
                              color: ColorPallet.kPrimary,
                              fontSize: 22 * FCStyle.fem,
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
                  selectedBuilder: (context, day, focusedDay) {
                    if (focusedDay.month == DateTime.now().month) {
                      for (int i = 0;
                          i < state.selectedIntakeHistoryList.length;
                          i++) {
                        if (state.selectedIntakeHistoryList[i].date ==
                            DateFormat("yyyy-MM-dd").format(day)) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.all(2),
                              height: 50 * FCStyle.fem,
                              width: 50 * FCStyle.fem,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: state.selectedIntakeHistoryList[i]
                                          .medicationStatus!
                                          .toLowerCase()
                                          .contains("missed")
                                      ? ColorPallet.kFadedRed
                                      : state.selectedIntakeHistoryList[i]
                                              .medicationStatus!
                                              .toLowerCase()
                                              .contains("partially")
                                          ? Color.fromARGB(255, 89, 91, 196)
                                          : state.selectedIntakeHistoryList[i]
                                                  .medicationStatus!
                                                  .toLowerCase()
                                                  .contains("fully")
                                              ? Color.fromARGB(
                                                  255, 76, 188, 154)
                                              : ColorPallet.kPrimary
                                                  .withOpacity(0.4),
                                  border: state.selectedIntakeHistoryList[i]
                                          .medicationStatus!
                                          .toLowerCase()
                                          .contains("future")
                                      ? Border.all(
                                          width: 1, color: ColorPallet.kPrimary)
                                      : Border.all(color: Colors.transparent)),
                              child: Center(
                                child: Text(
                                  DateFormat.d().format(day),
                                  style: TextStyle(
                                      color: state.selectedIntakeHistoryList[i]
                                                  .medicationStatus!
                                                  .toLowerCase()
                                                  .contains("future") ||
                                              state.selectedIntakeHistoryList[i]
                                                  .medicationStatus!
                                                  .toLowerCase()
                                                  .contains(
                                                      "medication completed")
                                          ? ColorPallet.kPrimary
                                          : Colors.white,
                                      fontSize: 22 * FCStyle.fem,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      return Center(
                        child: Container(
                          margin: EdgeInsets.all(2),
                          height: 50 * FCStyle.fem,
                          width: 50 * FCStyle.fem,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              DateFormat.d().format(day),
                              style: TextStyle(
                                  color: ColorPallet.kPrimary,
                                  fontSize: 22 * FCStyle.fem,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
          state.status == MedicationStatus.intakeHistoryLoading
              ? Positioned.fill(
                  child: AbsorbPointer(
                  absorbing: true,
                  child: Shimmer.fromColors(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              CupertinoIcons.calendar,
                              size: FCStyle.blockSizeVertical * 25,
                            ),
                          ),
                        ],
                      ),
                      baseColor: ColorPallet.kWhite,
                      highlightColor: ColorPallet.kPrimaryGrey),
                ))
              : Container(),
        ],
      );
    });
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Text(
              headerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 30 * FCStyle.fem,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: onLeftArrowTap,
                customBorder: CircleBorder(),
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.chevron_left,
                      size: 30,
                      weight: 700,
                      color: ColorPallet.kPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: onRightArrowTap,
                customBorder: CircleBorder(),
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.chevron_right,
                      size: 30,
                      weight: 700,
                      color: ColorPallet.kPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
