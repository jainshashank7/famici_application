part of 'time_picker_cubit.dart';

class TimePickerState {
  TimePickerState({
    required this.hour,
    required this.minute,
    required this.period,
  });

  final int hour;
  final int minute;
  final DayPeriod period;

  factory TimePickerState.initial() {
    return TimePickerState(hour: 1, minute: 0, period: DayPeriod.am);
  }

  TimePickerState copyWith({
    int? hour,
    int? minute,
    DayPeriod? period,
  }) {
    return TimePickerState(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      period: period ?? this.period,
    );
  }
}
