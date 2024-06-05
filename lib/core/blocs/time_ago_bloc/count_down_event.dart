part of 'count_down_bloc.dart';

abstract class CountDownEvent {}

class SyncTimeAgoStartTime extends CountDownEvent {
  final DateTime time;

  SyncTimeAgoStartTime(this.time);
}

class TimeAgoUpdated extends CountDownEvent {}

class SyncCountDownEndTime extends CountDownEvent {
  final DateTime time;

  SyncCountDownEndTime(this.time);
}

class StartElapsedTimeCalculate extends CountDownEvent {
  final DateTime? time;
  StartElapsedTimeCalculate({this.time});
}

class CountDownUpdated extends CountDownEvent {}

class ElapsedTimeUpdated extends CountDownEvent {}

class StopElapsedTimer extends CountDownEvent {}

class ResetElapsedTimer extends CountDownEvent {}

class StopRemainingTimer extends CountDownEvent {}

class ResetRemainingTimer extends CountDownEvent {}
