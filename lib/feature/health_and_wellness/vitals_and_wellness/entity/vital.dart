import 'package:equatable/equatable.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';

class Vital {
  final String? vitalId;
  final String? url;
  final String? name;
  final bool isSelected;
  final Reading reading;
  final String? measureUnit;
  final int? time;
  final bool connected;
  final VitalType vitalType;
  final List<VitalDevice> connectedDevices;
  final int count;

  Vital({
    this.vitalId,
    this.name,
    this.url,
    Reading? reading,
    this.time,
    VitalType? vitalType,
    this.measureUnit,
    bool? isSelected,
    bool? connected,
    List<VitalDevice>? connectedDevices,
    this.count = 0,
  })  : isSelected = isSelected ?? false,
        connected = connected ?? false,
        reading = reading ?? Reading(),
        connectedDevices = connectedDevices ?? const [],
        vitalType = vitalType ?? VitalType.unknown;

  factory Vital.fromJson(Map<String, dynamic> json) {
    return Vital(
      vitalId: json['vitalId'],
      name: json['name'],
      url: json['url'],
      reading: Reading.fromRawJson(json['reading']),
      time: json['time'],
      connected: json['connected'],
      measureUnit: json['measureUnit'],
      connectedDevices: [],
      count: json['readingCount'],
      vitalType: (json['vitalTypeId'] ?? '').toString().toVitalType(),
    );
  }

  factory Vital.fromApiJson(Map<String, dynamic> json) {
    final data = json['latestReading'];
    final count = json['readingCount'];
    return Vital(
      vitalId: data['vitalId'],
      name: data['name'],
      url: data['url'],
      reading: Reading.fromRawJson(data['reading']),
      time: data['time'],
      connected: data['connected'],
      measureUnit: data['measureUnit'],
      connectedDevices: [],
      count: count ?? 0,
      vitalType: (data['vitalTypeId'] ?? '').toString().toVitalType(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vitalId'] = vitalId;
    data['name'] = name;
    data['url'] = url;
    data['reading'] = reading.toRawJson();
    data['time'] = time;
    data['connected'] = connected;
    data['measureUnit'] = measureUnit;
    data['vitalTypeId'] = vitalType.name;
    data['readingCount'] = count;
    return data;
  }

  Vital copyWith({
    String? vitalId,
    String? url,
    String? name,
    bool? isSelected,
    Reading? reading,
    int? time,
    bool? connected,
    VitalType? vitalType,
    String? measureUnit,
    List<VitalDevice>? connectedDevices,
    int? count,
  }) {
    return Vital(
      vitalId: vitalId ?? this.vitalId,
      url: url ?? this.url,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      reading: reading ?? this.reading,
      time: time ?? this.time,
      connected: connected ?? this.connected,
      vitalType: vitalType ?? this.vitalType,
      measureUnit: measureUnit ?? this.measureUnit,
      connectedDevices: connectedDevices ?? this.connectedDevices,
      count: count ?? this.count,
    );
  }
}
