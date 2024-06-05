import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'count_down_event.dart';
part 'count_down_state.dart';

class CountDownBloc extends Bloc<CountDownEvent, CountDownState> {
  CountDownBloc() : super(CountDownState.initial());

  StreamSubscription? _timeSubscription;
  StreamSubscription? _countDownSubscription;
  StreamSubscription? _elapsedTimeSubscription;

  @override
  Stream<CountDownState> mapEventToState(CountDownEvent event) async* {
    if (event is SyncTimeAgoStartTime) {
      yield* _mapSyncTimeAgoStartEventToState(event.time);
    } else if (event is TimeAgoUpdated) {
      yield* _mapTimeAgoUpdatedEventToState();
    } else if (event is SyncCountDownEndTime) {
      yield* _mapSyncCountDownEndTimeEventToState(event.time);
    } else if (event is CountDownUpdated) {
      yield* _mapCountDownUpdatedEventToState();
    } else if (event is StartElapsedTimeCalculate) {
      yield* _mapStartElapsedTimeCalculateEventToState(event.time);
    } else if (event is ElapsedTimeUpdated) {
      yield* _mapElapsedTimeUpdatedEventToState();
    } else if (event is StopElapsedTimer) {
      yield* _mapElapsedTimerStoppedEventToState();
    } else if (event is ResetElapsedTimer) {
      yield* _mapResetElapsedTimerToState();
    } else if (event is StopRemainingTimer) {
      yield* _mapRemainingTimerStoppedEventToState();
    } else if (event is ResetRemainingTimer) {
      yield* _mapResetRemainingTimerToState();
    }
  }

  Stream<CountDownState> _mapSyncTimeAgoStartEventToState(
    DateTime startTime,
  ) async* {
    emit(state.copyWith(startTime: startTime));
    add(TimeAgoUpdated());
    _timeSubscription?.cancel();
    _timeSubscription = null;
    _timeSubscription ??= Stream.periodic(Duration(seconds: 1)).listen((event) {
      add(TimeAgoUpdated());
    });
  }

  Stream<CountDownState> _mapTimeAgoUpdatedEventToState() async* {
    int _updatedTime = state.startTime.millisecondsSinceEpoch;

    String timeAgoString = timeago.format(DateTime.now().subtract(Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch - _updatedTime,
    )));

    emit(state.copyWith(timeAgo: timeAgoString));
  }

  Stream<CountDownState> _mapSyncCountDownEndTimeEventToState(
    DateTime endTime,
  ) async* {
    emit(state.copyWith(endTime: endTime, remaining: Duration.zero));
    add(CountDownUpdated());
    _countDownSubscription?.cancel();
    _countDownSubscription = null;
    _countDownSubscription ??= Stream.periodic(Duration(seconds: 1)).listen(
      (event) {
        add(CountDownUpdated());
      },
    );
  }

  Stream<CountDownState> _mapCountDownUpdatedEventToState() async* {
    DateTime _endTime = state.endTime;
    DateTime _now = DateTime.now();
    Duration remaining = _endTime.difference(_now);
    emit(state.copyWith(remaining: remaining));
  }

  Stream<CountDownState> _mapStartElapsedTimeCalculateEventToState(
    DateTime? startTime,
  ) async* {
    emit(state.copyWith(
      startTime: startTime ?? DateTime.now(),
      elapsed: Duration.zero,
    ));
    add(ElapsedTimeUpdated());
    _elapsedTimeSubscription?.cancel();
    _elapsedTimeSubscription = null;
    _elapsedTimeSubscription ??= Stream.periodic(Duration(seconds: 1)).listen(
      (event) {
        add(ElapsedTimeUpdated());
      },
    );
  }

  Stream<CountDownState> _mapElapsedTimeUpdatedEventToState() async* {
    DateTime _startTime = state.startTime;
    DateTime _now = DateTime.now();
    Duration elapsed = _now.difference(_startTime);
    emit(state.copyWith(elapsed: elapsed));
  }

  Stream<CountDownState> _mapElapsedTimerStoppedEventToState() async* {
    _elapsedTimeSubscription?.cancel();
    _elapsedTimeSubscription = null;
  }

  Stream<CountDownState> _mapResetElapsedTimerToState() async* {
    _elapsedTimeSubscription?.cancel();
    _elapsedTimeSubscription = null;
    emit(state.copyWith(elapsed: Duration.zero));
  }

  Stream<CountDownState> _mapRemainingTimerStoppedEventToState() async* {
    _countDownSubscription?.cancel();
    _countDownSubscription = null;
  }

  Stream<CountDownState> _mapResetRemainingTimerToState() async* {
    _countDownSubscription?.cancel();
    _countDownSubscription = null;
    emit(state.copyWith(elapsed: Duration.zero));
  }

  @override
  Future<void> close() {
    _timeSubscription?.cancel();
    _countDownSubscription?.cancel();
    _elapsedTimeSubscription?.cancel();
    _countDownSubscription = null;
    _timeSubscription = null;
    _elapsedTimeSubscription = null;
    return super.close();
  }
}
