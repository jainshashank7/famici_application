import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_cubit/fc_calendar_cubit.dart';
import 'package:famici/shared/fc_num_selector.dart';
import 'package:famici/utils/barrel.dart';

class FCTimePicker extends StatefulWidget {
  const FCTimePicker({Key? key, this.dateTime, required this.onChange})
      : super(key: key);

  final DateTime? dateTime;
  final Function(DateTime) onChange;

  @override
  State<FCTimePicker> createState() => _FCTimePickerState();
}

class _FCTimePickerState extends State<FCTimePicker> {
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
    return Row(
      children: [
        FCNumSelector(
            onIncrement: () => {
                  _calendarCubit.incrementHour(),
                  widget.onChange(_calendarCubit.state.date),
                },
            onDecrement: () => {
                  _calendarCubit.decrementHour(),
                  widget.onChange(_calendarCubit.state.date),
                },
            value: DateFormat('hh').format(_calendarCubit.state.date)),
        FCNumSelector(
            onIncrement: () => {
                  _calendarCubit.incrementMinute(),
                  widget.onChange(_calendarCubit.state.date),
                },
            onDecrement: () => {
                  _calendarCubit.decrementMinute(),
                  widget.onChange(_calendarCubit.state.date),
                },
            value: DateFormat('mm').format(_calendarCubit.state.date)),
        FCNumSelector(
            onIncrement: () => {
                  _calendarCubit.incrementAMPM(),
                  widget.onChange(_calendarCubit.state.date),
                },
            onDecrement: () => {
                  _calendarCubit.decrementAMPM(),
                  widget.onChange(_calendarCubit.state.date),
                },
            value: DateFormat('aa').format(_calendarCubit.state.date))
      ],
    );
  }
}
