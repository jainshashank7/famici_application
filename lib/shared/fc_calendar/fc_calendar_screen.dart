import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_cubit/fc_calendar_cubit.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_cubit/fc_calendar_state.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/calendar_strings.dart';

class FCCalendar extends StatefulWidget {
  const FCCalendar({
    Key? key,
    this.dateTime,
    required this.onChange,
    bool? smallMode,
    bool? previousDatesDisable,
    this.strips,
  })  : _smallMode = smallMode ?? false,
        _previousDatesDisable = previousDatesDisable ?? false,
        super(key: key);

  final DateTime? dateTime;
  final Function(DateTime) onChange;
  final bool _smallMode;
  final bool _previousDatesDisable;
  final List<int>? strips;

  @override
  State<FCCalendar> createState() => _FCCalendarState();
}

class _FCCalendarState extends State<FCCalendar> {
  late FCCalendarCubit _calendarCubit;

  @override
  void initState() {
    _calendarCubit = FCCalendarCubit(widget.dateTime);
    super.initState();
  }

  @override
  void dispose() {
    _calendarCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FCCalendarCubit, FCCalendarState>(
      bloc: _calendarCubit,
      buildWhen: (current, previous) => current.date != previous.date,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget._smallMode
                ? Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      DateFormat("MMMM").format(state.date),
                      style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FCStyle.defaultFontSize),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        NeumorphicButton(
                          minDistance: 4,
                          style: FCStyle.buttonCardStyle.copyWith(
                              shadowLightColor:
                                  ColorPallet.kCardShadowColor.withOpacity(0.4),
                              boxShape: NeumorphicBoxShape.circle(),
                              lightSource: LightSource.top),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPallet.kGreen,
                            ),
                            child: Icon(
                              Icons.chevron_left_sharp,
                              size: FCStyle.xLargeFontSize,
                              color: ColorPallet.kLightBackGround,
                            ),
                          ),
                          onPressed: () => {
                            if (!widget._previousDatesDisable ||
                                state.date.month > DateTime.now().month)
                              {
                                _calendarCubit.decrementMonth(),
                                widget.onChange(_calendarCubit.state.date)
                              }
                          },
                        ),
                        Text(
                          DateFormat('MMMM y')
                              .format(_calendarCubit.state.date),
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: FCStyle.mediumFontSize),
                        ),
                        NeumorphicButton(
                          minDistance: 4,
                          style: FCStyle.buttonCardStyle.copyWith(
                              shadowLightColor:
                                  ColorPallet.kCardShadowColor.withOpacity(0.4),
                              boxShape: NeumorphicBoxShape.circle(),
                              lightSource: LightSource.top),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPallet.kGreen,
                            ),
                            child: Icon(
                              Icons.chevron_right_sharp,
                              size: FCStyle.xLargeFontSize,
                              color: ColorPallet.kLightBackGround,
                            ),
                          ),
                          onPressed: () => {
                            _calendarCubit.incrementMonth(),
                            widget.onChange(_calendarCubit.state.date)
                          },
                        )
                      ]),
            SizedBox(height: 16.0),
            Row(children: [
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.sun.tr().characters.first
                      : CalendarStrings.sun.tr(),
                  selected: false,
                  weekNames: true),
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.mon.tr().characters.first
                      : CalendarStrings.mon.tr(),
                  selected: false,
                  weekNames: true),
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.tue.tr().characters.first
                      : CalendarStrings.tue.tr(),
                  selected: false,
                  weekNames: true),
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.wed.tr().characters.first
                      : CalendarStrings.wed.tr(),
                  selected: false,
                  weekNames: true),
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.thu.tr().characters.first
                      : CalendarStrings.thu.tr(),
                  selected: false,
                  weekNames: true),
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.fri.tr().characters.first
                      : CalendarStrings.fri.tr(),
                  selected: false,
                  weekNames: true),
              CalendarDay(
                  strip1: false,
                  strip2: false,
                  strip3: false,
                  smallMode: widget._smallMode,
                  text: widget._smallMode
                      ? CalendarStrings.sat.tr().characters.first
                      : CalendarStrings.sat.tr(),
                  selected: false,
                  weekNames: true),
            ]),
            for (List week in getMonth(
                widget.strips != null && widget.strips!.isNotEmpty
                    ? widget.dateTime ?? state.date
                    : state.date))
              Column(
                children: [
                  SizedBox(height: widget._smallMode ? 8 : 16.0),
                  Container(
                    decoration: BoxDecoration(
                        color: state.date.year == DateTime.now().year &&
                                state.date.month == DateTime.now().month &&
                                week.contains(DateTime.now().day)
                            ? ColorPallet.kCalendarRow
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Row(children: [
                      for (int day in week)
                        CalendarDay(
                            strip1: day != 0 && widget.strips?[day - 1] != null
                                ? widget.strips![day - 1] & 1 == 1
                                : false,
                            strip2: day != 0 && widget.strips?[day - 1] != null
                                ? widget.strips![day - 1] & 2 == 2
                                : false,
                            strip3: day != 0 && widget.strips?[day - 1] != null
                                ? widget.strips![day - 1] & 4 == 4
                                : false,
                            smallMode: widget._smallMode,
                            text: day == 0 ? "" : day.toString(),
                            selected: widget._smallMode
                                ? state.date.year == DateTime.now().year &&
                                    state.date.month == DateTime.now().month &&
                                    day == DateTime.now().day
                                : day == (_calendarCubit.state.date).day,
                            weekNames: false,
                            onTap: day == 0 ||
                                    (widget._previousDatesDisable &&
                                        DateTime(state.date.year,
                                                state.date.month, day)
                                            .isBefore(DateTime.now()
                                                .subtract(Duration(days: 1))))
                                ? null
                                : () => {
                                      _calendarCubit.changeDay(day),
                                      widget.onChange(_calendarCubit.state.date)
                                    }),
                    ]),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  List getMonth(DateTime _date) {
    Map<String, int> weekNumbers = {
      "Sun": 0,
      "Mon": 1,
      "Tue": 2,
      "Wed": 3,
      "Thu": 4,
      "Fri": 5,
      "Sat": 6
    };

    Map<String, int> monthDates = {
      "Jan": 31,
      "Feb": _date.year % 4 == 0 ? 29 : 28,
      "Mar": 31,
      "Apr": 30,
      "May": 31,
      "Jun": 30,
      "Jul": 31,
      "Aug": 31,
      "Sep": 30,
      "Oct": 31,
      "Nov": 30,
      "Dec": 31
    };

    int? dayOfWeek = weekNumbers[DateFormat('E')
        .format(DateTime.parse(DateFormat('y-MM-01').format(_date)))];

    List month = [];

    if (dayOfWeek != null) {
      month.add([]);
      int week = 0;
      int i = 0;
      for (i = 0;
          i < monthDates[DateFormat("MMM").format(_date)]!.toInt() + dayOfWeek;
          i++) {
        if (i != 0 && i % 7 == 0) {
          month.add([]);
          week++;
        }

        if (week == 0 && i < dayOfWeek) {
          month[week].add(0);
        } else {
          month[week].add(i - dayOfWeek + 1);
        }
      }

      if (i % 7 > 0) {
        for (int j = 0; j < 7 - i % 7; j++) {
          month[week].add(0);
        }
      }
    }

    return month;
  }
}

class CalendarDay extends StatelessWidget {
  const CalendarDay(
      {Key? key,
      required this.text,
      required this.selected,
      required this.weekNames,
      required this.smallMode,
      required this.strip1,
      required this.strip2,
      required this.strip3,
      this.onTap})
      : super(key: key);

  final String text;
  final bool selected;
  final bool weekNames;
  final GestureTapCallback? onTap;
  final bool smallMode;
  final bool strip1;
  final bool strip2;
  final bool strip3;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: weekNames
                ? Text(
                    text,
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: smallMode
                            ? FCStyle.smallFontSize
                            : FCStyle.defaultFontSize),
                  )
                : GestureDetector(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                      height: smallMode ? 16 : 32,
                      width: smallMode ? 32 : 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? ColorPallet.kFadedGreen
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                                color: selected
                                    ? ColorPallet.kCalendarSelectedText
                                    : ColorPallet.kPrimaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: smallMode
                                    ? FCStyle.smallFontSize
                                    : FCStyle.defaultFontSize),
                          ),
                          Column(
                            children: [
                              strip1
                                  ? Container(
                                      child: Icon(Icons.circle,
                                          size: 4, color: ColorPallet.kCyan),
                                      padding: EdgeInsets.only(bottom: 2),
                                    )
                                  : Container(),
                              strip2
                                  ? Container(
                                      child: Icon(Icons.circle,
                                          size: 4, color: ColorPallet.kDarkRed),
                                      padding: EdgeInsets.only(bottom: 2),
                                    )
                                  : Container(),
                              strip3
                                  ? Container(
                                      child: Icon(Icons.circle,
                                          size: 4,
                                          color: ColorPallet.kDarkYellow),
                                      padding: EdgeInsets.only(bottom: 2),
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: onTap,
                  )));
  }
}
