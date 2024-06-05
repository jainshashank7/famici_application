import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/blocs/add_medication/add_medication_bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:table_calendar/table_calendar.dart';

import '../add_medication/utils/calendar_utils.dart';

class FCCalendarSetDosageDuration extends StatefulWidget {
  const FCCalendarSetDosageDuration({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  _FCCalendarSetDosageDurationState createState() =>
      _FCCalendarSetDosageDurationState();
}

class _FCCalendarSetDosageDurationState
    extends State<FCCalendarSetDosageDuration> {
  late final PageController _pageController;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void setSelectedRange(){
    setState(() {
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
      _rangeStart=widget.addMedicationBloc.state.startDate;
      _rangeEnd =widget.addMedicationBloc.state.endDate;
    });

  }

  @override
  void initState() {
    super.initState();
    _selectedDays.add(_focusedDay.value);
    setSelectedRange();
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
      widget.addMedicationBloc.add(OnDoseDurationSelected(
          _rangeStart ?? DateTime.now(), _rangeEnd ??_rangeStart?? DateTime.now()));
    });
    if(end==null){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              },
              onRightArrowTap: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
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
          calendarStyle: CalendarStyle(
            markerDecoration:
                BoxDecoration(color: ColorPallet.kSimpleLightGreen),
            rangeHighlightColor: Colors.transparent,
            rangeHighlightScale: 0,
            withinRangeTextStyle: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            rangeStartTextStyle: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            rangeEndTextStyle: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            rangeStartDecoration: BoxDecoration(
                color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
            withinRangeDecoration: BoxDecoration(
                color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
            rangeEndDecoration: BoxDecoration(
                color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
            isTodayHighlighted: false,
            todayDecoration: BoxDecoration(
                color: ColorPallet.kBrightGreen, shape: BoxShape.circle),
          ),
          // holidayPredicate: (day) {
          //   // Every 20th day of the month will be treated as a holiday
          //   return day.day == 20;
          // },
          //onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onCalendarCreated: (controller) => _pageController = controller,
          onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() => _calendarFormat = format);
            }
          },
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              if (day.weekday == DateTime.sunday) {}
              final text = DateFormat.E().format(day);

              return Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.blockSizeVertical*2.2,
                      fontWeight: FontWeight.bold),
                ),
              );
            },
            defaultBuilder: (context, day, day1) {
              return Container(
                alignment: Alignment.center,
                height:FCStyle.blockSizeVertical*10,
                child: Text(
                  DateFormat.d().format(day),
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.bold),
                ),
              );
            },
            outsideBuilder: (context, day, day1) {
              return Container();
            },
            selectedBuilder: (context, day, focusedDay){
              if(_rangeStart!.isBefore(day) && _rangeEnd!.isAfter(day)) {
                return  Container(
                alignment: Alignment.center,
                height:FCStyle.blockSizeVertical*10,
                decoration: BoxDecoration(
                    color: ColorPallet.kSimpleLightGreen, shape: BoxShape.circle),
                child: Text(
                  DateFormat.d().format(day),
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.bold),
                ),
              );
              }
              return  Container(
                alignment: Alignment.center,
                height:FCStyle.blockSizeVertical*10,
                child: Text(
                  DateFormat.d().format(day),
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
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
      padding: const EdgeInsets.only(top: 20, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kCardBackground,
                boxShadow: [
                  BoxShadow(
                    color: ColorPallet.kBlack,
                    spreadRadius: -6,
                    offset: Offset(0, 5),
                    blurRadius: 20,
                  ),
                ]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kBrightGreen,
              ),
              child: GestureDetector(
                key: FCElementID.calendarPreviousMonthButton,
                onTap: onLeftArrowTap,
                child: Icon(
                  Icons.chevron_left,
                  color: ColorPallet.kWhite,
                  size: FCStyle.blockSizeHorizontal*5,
                ),
              ),
            ),
          ),
          SizedBox(
            width: FCStyle.blockSizeHorizontal*5,
          ),
          Text(
            headerText,
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.largeFontSize,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            key: FCElementID.calendarCurrentPageButton,
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              key: FCElementID.calendarClearButton,
              icon: Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          SizedBox(
            width: FCStyle.blockSizeHorizontal*4,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kCardBackground,
                boxShadow: [
                  BoxShadow(
                    color: ColorPallet.kBlack,
                    spreadRadius: -6,
                    offset: Offset(0, 5),
                    blurRadius: 20,
                  ),
                ]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kBrightGreen,
              ),
              child: GestureDetector(
                key: FCElementID.calendarNextMonthButton,
                onTap: onRightArrowTap,
                child: Icon(
                  Icons.chevron_right,
                  color: ColorPallet.kWhite,
                  size: FCStyle.blockSizeHorizontal*5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
