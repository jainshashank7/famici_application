import 'package:equatable/equatable.dart';

// enum WellnessType { unknown, activity, sleep, weight, feelingToday }

// class Wellness {
//   final String? wellnessId;
//   final String? url;
//   final String? name;
//   final bool isSelected;
//   final String? value;
//   final String? measureUnit;
//   final int? time;
//   final bool connected;
//   final WellnessType? wellnessType;
//
//   const Wellness({
//     this.wellnessId,
//     this.name,
//     this.url,
//     this.value,
//     this.time,
//     this.wellnessType,
//     this.measureUnit,
//     bool? isSelected,
//     bool? connected,
//   })  : isSelected = isSelected ?? false,
//         connected = connected ?? false;
//
//   factory Wellness.fromJson(Map<String, dynamic> json) {
//     return Wellness(
//       wellnessId: json['wellnessId'],
//       name: json['name'],
//       url: json['url'],
//       value: json['value'],
//       time: json['time'],
//       connected: json['connected'],
//       measureUnit: json['measureUnit'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['vitalId'] = wellnessId;
//     data['name'] = name;
//     data['url'] = url;
//     data['value'] = value;
//     data['time'] = time;
//     data['connected'] = connected;
//     data['measureUnit'] = measureUnit;
//     return data;
//   }
//
//   Wellness copyWith({
//     String? wellnessId,
//     String? url,
//     String? name,
//     bool? isSelected,
//     String? value,
//     int? time,
//     bool? connected,
//     WellnessType? wellnessType,
//     String? measureUnit,
//   }) {
//     return Wellness(
//         wellnessId: wellnessId ?? this.wellnessId,
//         url: url ?? this.url,
//         name: name ?? this.name,
//         isSelected: isSelected ?? this.isSelected,
//         value: value ?? this.value,
//         time: time ?? this.time,
//         connected: connected ?? this.connected,
//         wellnessType: wellnessType ?? this.wellnessType,
//         measureUnit: measureUnit ?? this.measureUnit);
//   }
// }
