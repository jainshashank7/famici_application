import 'package:equatable/equatable.dart';

class MedicationIntakeHistory extends Equatable {
  const MedicationIntakeHistory({
    this.date,
    this.medicationStatus
  });

  final String? medicationStatus;
  final String? date;

  toJson() {
    return <String, dynamic>{
      "date": date,
      "medicationStatus": medicationStatus,
    };
  }

  factory MedicationIntakeHistory.fromJson(json) {
    return MedicationIntakeHistory(
        date: json['date']??"",
        medicationStatus: json['medicationStatus']??""
    );
  }

  MedicationIntakeHistory copyWith({
    String? date,
    String? medicationStatus,
  }) {
    return MedicationIntakeHistory(
      date: date ?? this.date,
      medicationStatus: medicationStatus ?? this.medicationStatus,
    );
  }

  @override
  List<Object?> get props => [
    date,
    medicationStatus
  ];
}

