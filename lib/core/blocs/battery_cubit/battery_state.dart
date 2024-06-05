part of 'battery_cubit.dart';

class BatteryState extends Equatable {
  const BatteryState({required this.percentage});
  final int percentage;

  factory BatteryState.initial() {
    return BatteryState(percentage: 0);
  }

  BatteryState copyWith({int? percentage}) {
    return BatteryState(
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  List<Object> get props => [percentage];

  @override
  String toString() {
    return '{BatteryState : { percentage : ${percentage.toString()}}}';
  }
}
