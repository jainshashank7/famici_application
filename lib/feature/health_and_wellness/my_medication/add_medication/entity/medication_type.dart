import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:famici/utils/barrel.dart';

class MedicationType extends Equatable {
  const MedicationType(
      {this.medicationTypeId,
      this.imageUrl,
      this.hasQuantity,
      this.medicationType,
      this.quantityLabel});

  final String? medicationTypeId;
  final String? imageUrl;
  final bool? hasQuantity;
  final String? medicationType;
  final String? quantityLabel;

  toJson() {
    return <String, dynamic>{
      "medicationTypeId": medicationTypeId,
      "medicationType": medicationType,
      "imageUrl": imageUrl,
      "hasQuantity": hasQuantity,
      "quantityLabel": quantityLabel,
    };
  }

  factory MedicationType.fromJson(json) {
    return MedicationType(
      medicationTypeId: json['medicationTypeId'],
      medicationType: json['medicationType'],
      imageUrl: json['imageUrl'],
      hasQuantity: json['hasQuantity'],
      quantityLabel: json['quantityLabel'],
    );
  }

  MedicationType copyWith({
    String? medicationTypeId,
    String? imageUrl,
    bool? hasQuantity,
    String? medicationType,
    String? quantityLabel,
  }) {
    return MedicationType(
      medicationTypeId: medicationTypeId ?? this.medicationTypeId,
      medicationType: medicationType ?? this.medicationType,
      imageUrl: imageUrl ?? this.imageUrl,
      hasQuantity: hasQuantity ?? this.hasQuantity,
      quantityLabel: imageUrl ?? this.quantityLabel,
    );
  }

  @override
  List<Object?> get props =>
      [medicationTypeId, medicationType, imageUrl, hasQuantity, quantityLabel];
}

Future<List<MedicationType>> parseUsersFromJsonListString(
    dynamic responseBody) async {
  final parsed = jsonDecode(responseBody as String);
  List<dynamic> _listParsedData = parsed['getMedicationTypes'] ?? [];
  return _listParsedData
      .map<MedicationType>((json) => MedicationType.fromJson(json))
      .toList();
}
