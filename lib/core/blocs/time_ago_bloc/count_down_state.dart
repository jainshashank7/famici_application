part of 'count_down_bloc.dart';

class CountDownState {
  CountDownState({
    required this.timeAgo,
    required this.startTime,
    required this.remaining,
    required this.endTime,
    required this.elapsed,
  });

  String timeAgo;
  Duration remaining;
  Duration elapsed;
  DateTime endTime;
  DateTime startTime;
  factory CountDownState.initial() {
    return CountDownState(
      timeAgo: '',
      startTime: DateTime.now(),
      remaining: Duration.zero,
      elapsed: Duration.zero,
      endTime: DateTime.now(),
    );
  }

  CountDownState copyWith({
    String? timeAgo,
    DateTime? startTime,
    Duration? remaining,
    DateTime? endTime,
    Duration? elapsed,
  }) {
    return CountDownState(
      timeAgo: timeAgo ?? this.timeAgo,
      startTime: startTime ?? this.startTime,
      remaining: remaining ?? this.remaining,
      endTime: endTime ?? this.endTime,
      elapsed: elapsed ?? this.elapsed,
    );
  }
}
