import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/vitals/entities/vital_history.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../utils/helpers/amplify_helper.dart';
import 'amplify_service.dart';

class VitalsAndWellnessRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  final List<Vital> _vitals = [
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Heart Rate",
      connected: false,
      reading: Reading(),
      vitalId: "12345",
      vitalType: VitalType.heartRate,
      measureUnit: "bpm",
    ),
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Blood Sugar",
      connected: false,
      reading: Reading(),
      vitalId: "12348",
      vitalType: VitalType.gl,
      measureUnit: "mg/dL",
    ),
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Blood Pressure",
      connected: false,
      reading: Reading(),
      vitalType: VitalType.bp,
      measureUnit: "mmHg",
    ),
    Vital(
        isSelected: false,
        time: DateTime.now().millisecondsSinceEpoch,
        name: "Pulse Ox",
        connected: false,
        reading: Reading(),
        measureUnit: "%",
        vitalType: VitalType.spo2),
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Body Temperature",
      connected: false,
      reading: Reading(),
      vitalId: "12347",
      measureUnit: "°F",
      vitalType: VitalType.temp,
    ),
    Vital(
        isSelected: false,
        time: DateTime.now().millisecondsSinceEpoch,
        name: "Fall Detection",
        connected: false,
        reading: Reading(),
        measureUnit: "",
        vitalType: VitalType.fallDetection),
  ];

  final List<Vital> _wellness = [
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Activity",
      connected: false,
      reading: Reading(),
      vitalType: VitalType.activity,
      measureUnit: "Steps",
    ),
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Sleep",
      connected: false,
      reading: Reading(),
      vitalType: VitalType.sleep,
      measureUnit: "Hours",
    ),
    Vital(
      isSelected: false,
      time: DateTime.now().millisecondsSinceEpoch,
      name: "Weight",
      connected: false,
      reading: Reading(),
      vitalType: VitalType.ws,
      measureUnit: "LBS",
    ),
    // Vital(
    //   isSelected: false,
    //   time: DateTime.now().millisecondsSinceEpoch,
    //   name: "How Are You Feeling Today?",
    //   connected: false,
    //   reading: Reading(),
    //   vitalType: VitalType.feelingToday,
    //   measureUnit: "",
    // ),
  ];

  Future<List<Vital>> fetchVitals({
    required String? familyId,
    required String? userId,
  }) async {
    List<Vital> _fetched = await _fetchVital(
      familyId: familyId,
      userId: userId,
    );

    List<String> list_vitals = [];

    for (var vital in _fetched) {
      list_vitals.add(jsonEncode(vital.toJson()));

      int index = _vitals.indexWhere((e) => e.vitalType == vital.vitalType);
      if (index > -1) {
        _vitals[index] = _vitals[index].copyWith(
          time: vital.time,
          reading: vital.reading,
          count: vital.count,
        );
      }
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('${userId}_vitals', list_vitals);

    return _vitals;
  }

  Future<List<Vital>> fetchWellness({
    required String? familyId,
    required String? userId,
  }) async {
    List<Vital> _fetched = await _fetchVital(
      familyId: familyId,
      userId: userId,
    );

    for (var vital in _fetched) {
      int index = _wellness.indexWhere((e) => e.vitalType == vital.vitalType);
      if (index > -1) {
        _wellness[index] = _wellness[index].copyWith(
          time: vital.time,
          reading: vital.reading,
          count: vital.count,
        );
      }
    }
    return _wellness;
  }

  Future<List<Vital>> _fetchVital({
    required String? familyId,
    required String? userId,
  }) async {
    String graphQLDocument =
    '''query GetVitals(\$familyId:ID!, \$contactId:ID!) {
             getVitals(familyId:\$familyId, contactId:\$contactId) {
                readingCount
                vitalTypeId
                latestReading{
                  contactId
                  createdAt
                  deviceId
                  familyId
                  hardwareId
                  isManual
                  readAt
                  reading
                  readingId
                  vitalTypeId
                }
            }
        }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": userId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (jsonDecode(resp.data)['getVitals'] == null) {
      return [];
    } else if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }

    List<dynamic> data = jsonDecode(resp.data)['getVitals'] as List;

    List<Vital> fetched = data.map<Vital>((e) => Vital.fromApiJson(e)).toList();
    return fetched;
  }

  Future<VitalHistory> fetchVitalHistory({
    String? familyId,
    String? contactId,
    Vital? vital,
    String? startDate,
    String? endDate,
  }) async {
    String graphQLDocument = '''
      query GetVitalReadings (\$familyId:ID!, \$contactId:ID!,\$vitalTypeId:ID!,\$startDate:String,\$endDate:String){
        getVitalReadings(familyId:\$familyId, contactId:\$contactId, vitalTypeId: \$vitalTypeId, endDate: \$endDate, startDate: \$startDate) {
          avg
          min {
            readAt
            value
          }
          max {
            readAt
            value
          }
          readings {
            contactId
            createdAt
            deviceId
            familyId
            hardwareId
            isManual
            readAt
            reading
            readingId
            vitalTypeId
          }
        }
      }
    ''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
        "vitalTypeId": vital?.vitalType.name,
        "endDate": endDate,
        "startDate": startDate,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }

    VitalHistory history = VitalHistory.fromJson(
      jsonDecode(resp.data)['getVitalReadings'],
    );

    return history;
  }
}
