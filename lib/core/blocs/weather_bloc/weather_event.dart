part of 'weather_bloc.dart';

abstract class WheatherEvent extends Equatable {
  const WheatherEvent();

  @override
  List<Object> get props => [];
}

class StartTimeAndLocationStream extends WheatherEvent {
  @override
  String toString() {
    return 'StartTimeAndLocationStream event';
  }
}

class FetchWeather extends WheatherEvent {
  @override
  String toString() {
    return 'fetch weather event';
  }
}
