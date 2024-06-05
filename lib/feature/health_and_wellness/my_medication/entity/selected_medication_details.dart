import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/dosage.dart';

class SelectedMedicationDetails extends Equatable {
  String? additionalDetails;
  String? durationDays;
  String? endDate;
  String? medicationId;
  String? medicationName;
  String? medicationTypeImageUrl;
  String? medicationTypeId;
  String? nextDosageTime;
  String? remainingDays;
  String? startDate;
  bool? isRemind;
  List<Dosage>? dosageList;
  String? DEA;
  String? ICD10;
  String? SIG;
  String? daw;
  String? daysSupply;
  String? duration;
  String? effectiveDate;
  String? familyId;
  String? height;
  String? heightUnit;
  String? issueTo;
  String? medicationType;
  String? prescriberInfoAddress;
  String? refills;
  String? prescriberName;
  String? prescriberPhone;
  String? supervisor;
  String? weight;
  String? weightUnit;
  String? medicationReminderTime;
  static String createdByUserType = "client";

  SelectedMedicationDetails({
    this.additionalDetails,
    this.durationDays,
    this.endDate,
    this.medicationId,
    this.medicationName,
    this.medicationTypeImageUrl,
    this.medicationTypeId,
    this.nextDosageTime,
    this.remainingDays,
    this.startDate,
    this.isRemind,
    this.dosageList,
    this.DEA,
    this.ICD10,
    this.SIG,
    this.daw,
    this.daysSupply,
    this.duration,
    this.effectiveDate,
    this.familyId,
    this.height,
    this.heightUnit,
    this.issueTo,
    this.medicationType,
    this.prescriberInfoAddress,
    this.refills,
    this.prescriberName,
    this.prescriberPhone,
    this.supervisor,
    this.weight,
    this.weightUnit,
    this.medicationReminderTime,
  });

  factory SelectedMedicationDetails.fromRawJson(String? str) {
    if (str == null) {
      return SelectedMedicationDetails();
    }
    return SelectedMedicationDetails.fromJson(json.decode(str));
  }

  factory SelectedMedicationDetails.fromJson(Map<String, dynamic> json) {
    return SelectedMedicationDetails(
      additionalDetails: json['additionalDetails'],
      durationDays: json['durationDays'],
      endDate: json['endDate'],
      medicationId: json['medicationId'],
      medicationName: json['medicationName'],
      medicationTypeImageUrl: json['medicationTypeImageUrl'],
      medicationTypeId: json['medicationTypeId'],
      nextDosageTime: json['nextDosageTime'],
      remainingDays: json['remainingDays'],
      startDate: json['startDate'],
      isRemind: json['isRemind'],
      dosageList: (json['dosageList'] as List)
          .map((n) => (Dosage.fromJson(n)))
          .toList(),
      DEA: json['DEA'],
      ICD10: json['ICD10'],
      SIG: json['SIG'],
      daw: json['daw'],
      daysSupply: json['daysSupply'],
      duration: json['duration'],
      effectiveDate: json['effectiveDate'],
      familyId: json['familyId'],
      height: json['height'],
      heightUnit: json['heightUnit'],
      issueTo: json['issueTo'],
      medicationType: json['medicationType'],
      prescriberInfoAddress: json['prescriberInfoAddress'],
      refills: json['refills'],
      prescriberName: json['prescriberName'],
      prescriberPhone: json['prescriberPhone'],
      supervisor: json['supervisor'],
      weight: json['weight'],
      weightUnit: json['weightUnit'],
      medicationReminderTime: json['medicationReminderTime'],
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdByUserType'] = createdByUserType;
    data['additionalDetails'] = additionalDetails;
    data['medicationReminderTime'] = medicationReminderTime;
    data['durationDays'] = durationDays;
    data['endDate'] = endDate;
    data['medicationId'] = medicationId;
    data['medicationName'] = medicationName;
    data['medicationTypeImageUrl'] = medicationTypeImageUrl;
    data['medicationTypeId'] = medicationTypeId;
    data['nextDosageTime'] = nextDosageTime;
    data['remainingDays'] = remainingDays;
    data['startDate'] = startDate;
    data['isRemind'] = isRemind;
    data['dosageList'] = dosageList?.map((e) => e.toJson()).toList();
    data['DEA'] = DEA;
    data['ICD10'] = ICD10;
    data['SIG'] = SIG;
    data['daw'] = daw;
    data['daysSupply'] = daysSupply;
    data['durationDays'] = durationDays;
    data['effectiveDate'] = effectiveDate;
    data['familyId'] = familyId;
    data['height'] = height;
    data['heightUnit'] = heightUnit;
    data['issueTo'] = issueTo;
    data['medicationTypeImageUrl'] = medicationTypeImageUrl;
    data['nextDosageTime'] = nextDosageTime;
    data['prescriberInfoAddress'] = prescriberInfoAddress;
    data['refills'] = refills;
    data['prescriberName'] = prescriberName;
    data['prescriberPhone'] = prescriberPhone;
    data['remainingDays'] = remainingDays;
    data['startDate'] = startDate;
    data['supervisor'] = supervisor;
    data['weight'] = weight;
    data['weightUnit'] = weightUnit;
    data['medicationType'] = medicationType;
    return data;
  }

  SelectedMedicationDetails copyWith(
      {String? additionalDetails,
      String? durationDays,
      String? endDate,
      String? medicationId,
      String? medicationName,
      String? medicationTypeImageUrl,
      String? medicationTypeId,
      String? nextDosageTime,
      String? remainingDays,
      String? startDate,
      String? medicationReminderTime,
      String? medicationType,
      bool? isRemind,
      required String createdByUserType,
      List<Dosage>? dosageList}) {
    return SelectedMedicationDetails(
        medicationType: medicationType ?? this.medicationType,
        additionalDetails: additionalDetails ?? this.additionalDetails,
        durationDays: durationDays ?? this.durationDays,
        endDate: endDate ?? this.endDate,
        medicationId: medicationId ?? this.medicationId,
        medicationName: medicationName ?? this.medicationName,
        medicationTypeImageUrl:
            medicationTypeImageUrl ?? this.medicationTypeImageUrl,
        medicationTypeId: medicationTypeId ?? this.medicationTypeId,
        nextDosageTime: nextDosageTime ?? this.nextDosageTime,
        remainingDays: remainingDays ?? this.remainingDays,
        startDate: startDate ?? this.startDate,
        isRemind: isRemind ?? this.isRemind,
        dosageList: dosageList ?? this.dosageList,
        medicationReminderTime:
            medicationReminderTime ?? this.medicationReminderTime);
  }

  @override
  List<Object?> get props => [
        additionalDetails,
        durationDays,
        endDate,
        medicationId,
        medicationName,
        medicationTypeImageUrl,
        medicationTypeId,
        nextDosageTime,
        remainingDays,
        startDate,
        isRemind,
        dosageList,
        medicationReminderTime,
        createdByUserType,
        medicationType
      ];
}
