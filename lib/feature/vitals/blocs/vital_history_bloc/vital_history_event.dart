part of 'vital_history_bloc.dart';

@immutable
abstract class VitalHistoryEvent {}

class SyncListOfVitals extends VitalHistoryEvent {
  final List<Vital> vitals;
  SyncListOfVitals(this.vitals);
}

class SyncHistoricData extends VitalHistoryEvent {}

class SyncSelectedVital extends VitalHistoryEvent {
  final VitalType vitalType;
  final bool isRefreshed;
  SyncSelectedVital(
    this.vitalType, {
    this.isRefreshed = false,
  });
}

class SyncSelectedDate extends VitalHistoryEvent {
  final DateTime startDate;
  final DateTime endDate;
  final bool shouldRefresh;
  final bool mergeTempToSelected;
  SyncSelectedDate(this.startDate,this.endDate, {this.shouldRefresh = true, this.mergeTempToSelected=false});
}
