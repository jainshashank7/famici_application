import 'dart:convert';

import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/utils/how_much_dosage_input.dart';

class Dosage extends Equatable {
  Dosage(
      {this.id,
      this.hasTaken,
      required this.time,
      required this.quantity,
      required this.detail,
      required this.hasQuantity,
      this.hasPrompted,
      this.popUpLabel});

  String? id;
  bool? hasTaken;
  String time;
  HowMuchDosageInput quantity;
  String detail;
  bool hasQuantity;
  bool? hasPrompted;
  String? popUpLabel;

  toJson() {
    return <String, dynamic>{
      "id": id,
      "hasTaken": hasTaken,
      "time": time,
      "quantity": quantity.value,
      "detail": detail,
      "hasQuantity": hasQuantity,
      "hasPrompted": hasPrompted,
      "popUpLabel": popUpLabel
    };
  }

  factory Dosage.fromJson(json) {
    bool hasQuantity = false;
    int quantity = 0;
    try {
      if (json['quantity'] != null) {
        if (json['quantity'].runtimeType != int) {
          quantity = int.parse(json['quantity']);
        }
        hasQuantity = quantity > 0 ? true : false;
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    return Dosage(
        id: json['id'],
        hasTaken: json['hasTaken'],
        time: json['time'],
        quantity: HowMuchDosageInput.dirty(value: json['quantity'].toString()),
        detail: json['detail'] ?? "",
        hasQuantity: hasQuantity,
        hasPrompted: json['hasPrompted'],
        popUpLabel: json['popUpLabel']);
  }

  Dosage copyWith(
      {String? id,
      bool? hasTaken,
      String? time,
      HowMuchDosageInput? quantity,
      String? detail,
      bool? hasQuantity,
      bool? hasPrompted,
      String? popUpLabel}) {
    return Dosage(
        id: id ?? this.id,
        hasTaken: hasTaken ?? this.hasTaken,
        time: time ?? this.time,
        quantity: quantity ?? this.quantity,
        detail: detail ?? this.detail,
        hasQuantity: hasQuantity ?? this.hasQuantity,
        hasPrompted: hasPrompted ?? this.hasPrompted,
        popUpLabel: popUpLabel ?? this.popUpLabel);
  }

  @override
  List<Object?> get props => [
        id,
        time,
        hasTaken,
        quantity,
        detail,
        hasQuantity,
        hasPrompted,
        popUpLabel
      ];
}

Future<List<Dosage>> parseUsersFromJsonListString(dynamic responseBody) async {
  final parsed = jsonDecode(responseBody as String);
  List<dynamic> _listParsedData = parsed['getDosage'] ?? [];
  return _listParsedData.map<Dosage>((json) => Dosage.fromJson(json)).toList();
}
