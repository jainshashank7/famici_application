import 'package:equatable/equatable.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/dosage.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/utils/how_much_dosage_input.dart';

class Medication extends Equatable {
  Medication(
      {this.date,
      this.imgUrl,
      this.medicationId,
      this.medicationName,
      this.nextDosage,
      this.previousDosage,
      required this.createdByUserType});

  final String? date;
  final String? imgUrl;
  String? medicationId;
  final String? medicationName;
  final Dosage? nextDosage;
  final Dosage? previousDosage;
  final String createdByUserType;

  toJson() {
    return <String, dynamic>{
      "date": date,
      "imgUrl": imgUrl,
      "medicationId": medicationId,
      "medicationName": medicationName,
      "nextDosage": nextDosage,
      "previousDosage": previousDosage,
      "createdByUserType": createdByUserType
    };
  }

  factory Medication.fromJson(json) {
    return Medication(
      createdByUserType: json['createdByUserType'] == null
          ? 'provider'
          : json['createdByUserType'],
      date: json['date'] ?? "",
      imgUrl: json['imageUrl'] ?? "",
      medicationId: json['medicationId'],
      medicationName: json['medicationName'] ?? "",
      nextDosage: json['nextDosage'] != null
          ? Dosage.fromJson(json['nextDosage'])
          : Dosage(
              time: "",
              quantity: HowMuchDosageInput.pure(),
              detail: "",
              hasQuantity: false),
      previousDosage: json['previousDosage'] != null
          ? Dosage.fromJson(json['previousDosage'])
          : Dosage(
              time: "",
              quantity: HowMuchDosageInput.pure(),
              detail: "",
              hasQuantity: false),
    );
  }

  Medication copyWith(
      {String? date,
      String? imgUrl,
      String? medicationId,
      String? medicationName,
      Dosage? nextDosage,
      Dosage? previousDosage,
      required String createdByUserType}) {
    return Medication(
        date: date ?? this.date,
        imgUrl: imgUrl ?? this.imgUrl,
        medicationId: medicationId ?? this.medicationId,
        medicationName: medicationName ?? this.medicationName,
        nextDosage: nextDosage ?? this.nextDosage,
        previousDosage: previousDosage ?? this.previousDosage,
        createdByUserType: createdByUserType ?? this.createdByUserType);
  }

  @override
  List<Object?> get props => [
        date,
        imgUrl,
        medicationId,
        medicationName,
        nextDosage,
        previousDosage,
        createdByUserType
      ];

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'imgUrl': imgUrl,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'nextDosage': nextDosage,
      'previousDosage': previousDosage,
      'createdByUserType': createdByUserType
    };
  }
}
