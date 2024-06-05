// import 'package:equatable/equatable.dart';

// import '../../../calander/entities/appointments_entity.dart';
part of 'history_bloc.dart';

class ManageHistoryState extends Equatable {
  ManageHistoryState({
    required this.log,
  });

  final List<CallHistoryElement> log;
  factory ManageHistoryState.initial() {
    return ManageHistoryState(
      log: [],
    );
  }

  ManageHistoryState copyWith({
    List<CallHistoryElement>? log,
  }) {
    return ManageHistoryState(
      log: log ?? this.log,
    );
  }

  @override
  List<Object?> get props => [log];
}

class CallHistoryElement {
  CallHistoryElement(
      {required this.actualStartTime,
      required this.latestCapturedTime,
      required this.appointmentName,
      required this.apponitmentType});
  String appointmentName;
  DateTime actualStartTime;
  DateTime latestCapturedTime;
  AppointmentType apponitmentType;
  factory CallHistoryElement.initial() {
    return CallHistoryElement(
        appointmentName: '',
        actualStartTime: DateTime.now(),
        latestCapturedTime: DateTime.now(),
        apponitmentType: AppointmentType.unknown);
  }

  CallHistoryElement copyWith({
    String? appointmentName,
    DateTime? actualStartTime,
    DateTime? latestCapturedTime,
    AppointmentType? apponitmentType,
  }) {
    return CallHistoryElement(
        appointmentName: appointmentName ?? this.appointmentName,
        actualStartTime: actualStartTime ?? this.actualStartTime,
        apponitmentType: apponitmentType ?? this.apponitmentType,
        latestCapturedTime: latestCapturedTime ?? this.latestCapturedTime);
  }

  static List<CallHistoryElement> fromJsonList(dynamic jsonList) {
    if (jsonList == null) {
      return [];
    }
    List<CallHistoryElement> m = jsonList
        .map<CallHistoryElement?>((data) {
          if (data['actual_start_time'] != null &&
              data['latest_captured_time'] != null) {
            return CallHistoryElement.fromJson(data);
          } else {
            return null;
          }
        })
        .whereType<CallHistoryElement>()
        .toList();
    return m.reversed.toList();
  }

  factory CallHistoryElement.fromJson(Map<String, dynamic> json) {
    return CallHistoryElement(
      appointmentName: json['appointment'],
      latestCapturedTime:
          DateTime.parse(json['latest_captured_time']).toLocal(),
      actualStartTime: DateTime.parse(json['actual_start_time']).toLocal(),
      apponitmentType: (json['appt_type'] ?? "").toString().toAppointmentType(),
    );
  }

  @override
  List<Object?> get props =>
      [appointmentName, actualStartTime, apponitmentType, latestCapturedTime];
}
