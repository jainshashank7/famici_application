part of 'weather_bloc.dart';

enum WeatherStatus { loading, success, failure }

class WheatherState extends Equatable {
  const WheatherState({
    required this.location,
    required this.weather,
    required this.status,
  });

  final String location;

  final Weather weather;
  final WeatherStatus status;
  factory WheatherState.initial() {
    return WheatherState(
      location: '',
      weather: Weather(),
      status: WeatherStatus.loading,
    );
  }

  copyWith({
    String? time,
    String? date,
    String? location,
    Weather? weather,
    WeatherStatus? status,
  }) {
    return WheatherState(
      location: location ?? this.location,
      weather: weather ?? this.weather,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [location, weather, status];

  @override
  String toString() {
    return '';
    // ''' WheatherState : { time : $time , date : $date, location : $location} ,weather : ${weather.current?.tempF}, status : ${status.toString()}''';
  }
}
