import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'time_picker_state.dart';

class TimePickerCubit extends Cubit<TimePickerState> {
  TimePickerCubit() : super(TimePickerState.initial());

  void incrementHour() async {
    int hour = state.hour;
    if (hour == 12) {
      hour = 1;
    } else {
      hour = hour + 1;
    }
    emit(state.copyWith(hour: hour));
  }

  void decrementHour() async {
    int hour = state.hour;
    if (hour == 1) {
      hour = 12;
    } else {
      hour = hour - 1;
    }
    emit(state.copyWith(hour: hour));
  }

  void incrementMinute() async {
    int minute = state.minute;
    if (minute == 59) {
      minute = 0;
    } else {
      minute = minute + 1;
    }
    emit(state.copyWith(minute: minute));
  }

  void decrementMinute() async {
    int minute = state.minute;
    if (minute == 0) {
      minute = 59;
    } else {
      minute = minute - 1;
    }
    emit(state.copyWith(minute: minute));
  }

  void togglePeriod() async {
    DayPeriod period = state.period;
    if (period == DayPeriod.am) {
      period = DayPeriod.pm;
    } else {
      period = DayPeriod.am;
    }
    emit(state.copyWith(period: period));
  }
}
