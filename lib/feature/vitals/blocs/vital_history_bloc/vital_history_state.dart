part of 'vital_history_bloc.dart';

class VitalHistoryState extends Equatable {
  const VitalHistoryState({
    required this.vitals,
    required this.selectedVital,
    required this.status,
    required this.history,
    required this.lineChartBarData,
    required this.tempStartDate,
    required this.tempEndDate,
    required this.startDate,
    required this.endDate,
    required this.chart,
  });

  final List<Vital> vitals;
  final Vital selectedVital;
  final VitalHistory history;
  final Status status;
  final LineChartBarData lineChartBarData;
  final DateTime tempStartDate;
  final DateTime tempEndDate;
  final DateTime startDate;
  final DateTime endDate;
  final LineChartData chart;

  factory VitalHistoryState.initial() {
    return VitalHistoryState(
      vitals: [],
      selectedVital: Vital(),
      status: Status.initial,
      history: VitalHistory(),
      lineChartBarData: LineChartBarData(),
      tempStartDate: DateTime.now(),
      tempEndDate: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      chart: LineChartData(),
    );
  }

  VitalHistoryState copyWith({
    List<Vital>? vitals,
    Vital? selectedVital,
    Status? status,
    VitalHistory? history,
    LineChartBarData? lineChartBarData,
    DateTime? tempStartDate,
    DateTime? tempEndDate,
    DateTime? startDate,
    DateTime? endDate,
    LineChartData? chart,
  }) {
    return VitalHistoryState(
      vitals: vitals ?? this.vitals,
      selectedVital: selectedVital ?? this.selectedVital,
      status: status ?? this.status,
      history: history ?? this.history,
      lineChartBarData: lineChartBarData ?? this.lineChartBarData,
      tempStartDate: tempStartDate ?? this.tempStartDate,
      tempEndDate: tempEndDate ?? this.tempEndDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      chart: chart ?? this.chart,
    );
  }

  @override
  List<Object?> get props => [
        vitals,
        selectedVital,
        history,
        status,
        lineChartBarData,
        tempStartDate,
        tempEndDate,
        startDate,
        endDate,
        chart
      ];
}
