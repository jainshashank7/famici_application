import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import '../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import '../../core/enitity/user.dart';
import '../../feature/care_team/blocs/care_team_bloc.dart';
import '../config/api_config.dart';

class TrackEvents {
  static final TrackEvents _instance = TrackEvents._internal();

  factory TrackEvents() {
    return _instance;
  }

  TrackEvents._internal();

  Mixpanel? mixpanel;
  CareTeamState careTeamState = CareTeamState(members: []);
  ConnectivityState? connectivityState;
  String? region;
  String? city;
  User currentUser = User();

  Future<void> initEventsTrack(
      CareTeamState careTeamState, ConnectivityState connectivityState) async {
    mixpanel = await Mixpanel.init(
        MixpanelTokens.env,
        trackAutomaticEvents: true);
    this.careTeamState = careTeamState;
    this.connectivityState = connectivityState;
    final FlutterSecureStorage _vault = FlutterSecureStorage();
    late User current = User();
    String userJson = await _vault.read(key: 'current_user') ?? '';

    final userJsonData = jsonDecode(userJson ?? "");
    current = User.fromCurrentAuthUserJson(userJsonData);
    currentUser = current;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> address =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placeMark = address.first;
      region = placeMark.administrativeArea ?? "";
      city = placeMark.subAdministrativeArea ?? "";
      print("city $city");
    } catch (err) {
      print(err);
    }

    mixpanel?.registerSuperPropertiesOnce({
      "email": current.email,
      "user_name": current.name,
      "service_coordinator":
          careTeamState.members.isEmpty ? '' : careTeamState.members[0].email,
      "health_care_provider": careTeamState.members.length >= 2
          ? careTeamState.members[1].email
          : '',
      "organization": current.customAttribute2.companyName,
    });
  }

  Map<String, dynamic> setProperties(
      {dynamic fromDate,
      dynamic toDate,
      dynamic reading,
      dynamic readingDateTime,
      dynamic vital,
      dynamic appointmentDate,
      dynamic appointmentTime,
      dynamic appointmentCounselors,
      dynamic appointmentType,
      dynamic callDuration,
      dynamic readingType}) {
    Map<String, dynamic> properties = {
      '_from_date': fromDate,
      '_to_date': toDate,
      '_reading': reading,
      '_reading_datetime': readingDateTime,
      '_vital': vital,
      '_appointmentDate': appointmentDate,
      '_appointmentTime': appointmentTime,
      '_appointmentCounselors': appointmentCounselors,
      '_appointmentType': appointmentType,
      '_readingType': readingType,
      '_callDuration': callDuration,
      // '\$carrier': Platform.isAndroid ? "Android" : "IOS",
      // "\$bluetooth_enabled": connectivityState?.isBluetoothOn,
      // "\$bluetooth_version": "ble",
      // "\$wifi": connectivityState?.isWifiOn,
      // "\$region": region,
      // "\$city": city,
    };
    return properties;
  }

  void trackEvents(String name, Map<String, dynamic> properties) async {
    mixpanel?.track(name, properties: properties);
//     AndroidDeviceInfo? androidDeviceInfo;
//     IosDeviceInfo? iosDeviceInfo;
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     if (Platform.isAndroid) {
//       androidDeviceInfo = await deviceInfo.androidInfo;
//     } else {
//       iosDeviceInfo = await deviceInfo.iosInfo;
//     }
// //Uri.parse('https://flutter-events-miy1.onrender.com/api/events/create'),
//     var response = http.post(
//       Uri.parse('http://10.0.2.2:3000/api/events/create'),
//       // Uri.parse('https://flutter-events-miy1.onrender.com/api/events/create'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<dynamic, dynamic>{
//         "event": name,
//         "email": currentUser.email,
//         "user_name": currentUser.name,
//         "service_coordinator": careTeamState.members.length >= 2
//             ? careTeamState.members[1].email
//             : '',
//         "health_care_provider": careTeamState.members[0].email ?? '',
//         "organization": currentUser.customAttribute2.companyName,
//         "_from_date": properties['_from_date'].toString() ?? '',
//         "_to_date": properties['_to_date'].toString() ?? '',
//         "_reading": properties['_reading'].toString() ?? '',
//         "_reading_datetime": properties['_reading_datetime'].toString() ?? '',
//         "_vital": properties['_vital'] ?? '',
//         "_appointmentDate": properties['_appointmentDate'].toString() ?? '',
//         "_appointmentTime": properties['_appointmentTime'].toString() ?? '',
//         "_appointmentCounselors": properties['_appointmentCounselors'] ?? '',
//         "_appointmentType": properties['_appointmentType'] ?? '',
//         "_callDuration": properties['_callDuration'],
//         "_readingType": properties['_readingType'] ?? '',
//         "distinct_id": "134b6c3c-4989-4f2d-9d55-577e668cf6fc",
//         "app_build_number": packageInfo.buildNumber,
//         "app_release": packageInfo.buildNumber,
//         "app_version": packageInfo.version,
//         "app_version_string": packageInfo.version,
//         "bluetooth_enabled": connectivityState?.isBluetoothOn,
//         "bluetooth_version": "ble",
//         "brand": androidDeviceInfo?.brand,
//         "carrier": "Android",
//         "city": city,
//         "device_id": androidDeviceInfo?.androidId,
//         "had_persisted_distinct_id": false,
//         "has_nfc": false,
//         "has_telephone": true,
//         "insert_id": "e34aa3cafd3ce27f",
//         "lib_version": "2.1.1",
//         "manufacturer": androidDeviceInfo?.manufacturer,
//         "model": androidDeviceInfo?.model,
//         "mp_api_endpoint": "api.mixpanel.com",
//         "mp_api_timestamp_ms": 1685705544270,
//         "os": Platform.operatingSystem,
//         "os_version": Platform.operatingSystemVersion,
//         "region": region,
//         "screen_dpi": 160,
//         "screen_height": 840,
//         "screen_width": 1340,
//         "wifi": connectivityState?.isWifiOn,
//         "time": DateTime.now().millisecondsSinceEpoch.toString(),
//         "mp_country_code": "IN",
//         "mp_lib": "flutter",
//         "mp_processing_time_ms": 0,
//       }),
//     );

//     // 'carrier': Platform.isAndroid ? "Android" : "IOS",
//     // "bluetooth_enabled": connectivityState?.isBluetoothOn,
//     // "bluetooth_version": "ble",
//     // "wifi": connectivityState?.isWifiOn,
//     // "region":region,
//     // "city" : city,
//     // "brand" : androidDeviceInfo?.brand,
//     // "device": androidDeviceInfo?.device,
//     // "distinct_id" : androidDeviceInfo?.androidId,
//     // "manufacturer": androidDeviceInfo?.manufacturer,
//     // "model": androidDeviceInfo?.model,
//     // "is_physical_device":androidDeviceInfo?.isPhysicalDevice,
//     // "display":androidDeviceInfo?.display,
//     print("response : $response");
  }
}
