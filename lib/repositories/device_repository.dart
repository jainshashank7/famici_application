import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:famici/feature/vitals/entities/new_manual_reading.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';

import '../core/enitity/user_device.dart';
import '../feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import '../utils/barrel.dart';
import 'amplify_service.dart';

class DeviceRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  Future<List<VitalDevice>> fetchMyDevices({
    required String? familyId,
    required String? userId,
  }) async {
    String graphQLDocument =
        '''query GetDevices(\$familyId:ID!, \$contactId:ID!,) {
             getDevices(familyId:\$familyId, contactId:\$contactId) {
                  vitalTypeIds
                  updatedAt
                  lastActivityAt
                  hardwareId
                  familyId
                  deviceName
                  deviceId
                  createdAt
                  contactId
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

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return VitalDevice.fromJsonList(jsonDecode(resp.data)['getDevices']);
  }

  Future<VitalDevice> register({
    required String? familyId,
    required VitalDevice? device,
  }) async {
    String graphQLDocument =
        '''mutation RegisterDevice (\$familyId:ID!, \$device:DeviceInput!){
            registerDevice(familyId:\$familyId, device:\$device) {
              contactId
              createdAt
              deviceId
              deviceName
              familyId
              hardwareId
              lastActivityAt
              updatedAt
              vitalTypeIds
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "device": device?.toRegisterJson(),
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return VitalDevice.fromJson(jsonDecode(response.data)['registerDevice']);
  }

  Future<VitalDevice> removeDevice({
    required String? deviceId,
  }) async {
    String graphQLDocument = '''mutation UnRegisterDevice(\$deviceId:ID!){
            unRegisterDevice(deviceId:\$deviceId) {
              deviceName
              lastActivityAt
              contactId
              createdAt
              deviceId
              familyId
              hardwareId
              updatedAt
              vitalTypeIds
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "deviceId": deviceId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return VitalDevice.fromJson(jsonDecode(response.data)['unRegisterDevice']);
  }

  Future<dynamic> saveDeviceReading({
    required String? familyId,
    required VitalDevice device,
    bool? isManual = false,
  }) async {
    String graphQLDocument =
        '''mutation AddVitalReading(\$deviceId: ID!,\$hardwareId: ID!,\$familyId: ID!,\$vitalReading:VitalReadingInput!,\$vitalTypeId: ID!) {
              addVitalReading(deviceId: \$deviceId, hardwareId:\$hardwareId, familyId: \$familyId, vitalReading: \$vitalReading, vitalTypeId: \$vitalTypeId) {
                latestReading {
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
                readingCount
                vitalTypeId
              }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "deviceId": device.deviceId,
        "familyId": familyId,
        "hardwareId": device.hardwareId,
        "vitalReading": {
          "isManual": isManual,
          "reading": device.lastReading?.toRawJson(),
          "readAt": device.readAt
        },
        "vitalTypeId": device.deviceType.name,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return VitalDevice.fromReadingJson(
      jsonDecode(response.data)['addVitalReading']['latestReading'],
    );
  }

  Future<dynamic> addManualReadings({
    required String? familyId,
    required Vital vital,
    required List<NewManualReading> readings,
    bool? isManual = false,
  }) async {
    String graphQLDocument =
        '''mutation AddBulkVitalReadings(\$hardwareId: ID!,\$familyId: ID!,\$vitalReadings:[VitalReadingInput!]!,\$vitalTypeId: ID!) {
              addBulkVitalReadings(hardwareId:\$hardwareId, familyId: \$familyId, vitalReadings: \$vitalReadings, vitalTypeId: \$vitalTypeId) {
                readingCount
                vitalTypeId
                latestReading {
                  contactId
                  createdAt
                  deviceId
                  familyId
                  isManual
                  hardwareId
                  readAt
                  reading
                  readingId
                  vitalTypeId
                }
              }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "hardwareId": 'manual_reading_$familyId',
        "vitalReadings": readings
            .map((e) => {
                  "isManual": isManual,
                  "reading": e.toReading().toRawJson(),
                  "readAt": e.readAt
                })
            .toList(),
        "vitalTypeId": vital.vitalType.name,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return VitalDevice.fromReadingJson(
      jsonDecode(response.data)['addBulkVitalReadings']['latestReading'],
    );
  }

  Future<UserDevice> createUserDevice(UserDevice device) async {
    String graphQLDocument =
        '''mutation CreateUserDevice (\$userDevice:UserDeviceInput!){
            createUserDevice(userDevice: \$userDevice) {
                contactId
                createdAt
                deviceName
                deviceType
                metadata
                updatedAt
                userDeviceId
              }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "userDevice": device.toDeviceInput(),
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return UserDevice.fromJson(jsonDecode(response.data)['createUserDevice']);
  }

  Future<dynamic> updateDeviceStatus(
    String deviceId,
    DeviceStatus status,
  ) async {
    String graphQLDocument =
        '''mutation SetUserDeviceStatus (\$userDeviceId:ID!,\$deviceStatus:UserDeviceStatusInput){
            setUserDeviceStatus(userDeviceId: \$userDeviceId, deviceStatus:\$deviceStatus ) {
              wifi
              userDeviceId
              contactId
              bluetooth
              battery
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "userDeviceId": deviceId,
        "deviceStatus": status.toStatusInput(),
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return DeviceStatus.fromJson(
      jsonDecode(response.data)['setUserDeviceStatus'],
    );
  }
}
