import 'dart:async';
import 'dart:convert';

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:http/http.dart' as http;
import 'package:famici/core/enitity/barrel.dart';

import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_key.dart';

class DataFetcher {
  static final DataFetcher _instance = DataFetcher._internal();

  factory DataFetcher() {
    return _instance;
  }

  DataFetcher._internal();

  // Timer? _timer = null;
  var headers;
  List<String> prevSettings = [];
  final AuthRepository _authRepository = AuthRepository();

  // void start() {
  //   _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
  //     fetchData().then((newSettings) {
  //       if (!listEquals(prevSettings, newSettings)) {
  //         scheduleNotifications();
  //         prevSettings = newSettings;
  //       }
  //     });
  //   });
  // }

  // void stop() {
  //   _timer?.cancel();
  // }

  Future<List<String>> fetchData() async {
    if (await _isConnectedToInternet()) {
      String? accessToken = await _authRepository.generateAccessToken();

      if (accessToken != null) {
        var header = {
          "x-api-key": ApiKey.webManagementConsoleApi,
          "Authorization": accessToken ?? "",
        };
        User user = await _authRepository.currentUser();

        String companySettingsUrl =
            "https://dev-api.mobexhealth.com/integrations/settings/${user.customAttribute2.companyId}/188";

        var response =
            await http.get(Uri.parse(companySettingsUrl), headers: header);

        List<String> newSettings = extractValues(response.body);
        prevSettings = newSettings;

        return newSettings;
      }
    }
    return [];
  }

  List<String> extractValues(String jsonString) {
    List<String> values = [];
    Map<String, dynamic> decodedJson = json.decode(jsonString);
    List info = decodedJson['info'];
    for (var i = 0; i < info.length; i++) {
      List value = jsonDecode(info[i]['value']);
      for (var j = 0; j < value.length; j++) {
        values.add(value[j]['value']);
      }
    }
    return values;
  }

  // void scheduleNotifications() {
  //   Notification dats = Notification();
  //   print("settings are changed");
  // }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

// List<String> getCurrentSettings() {
//   return prevSettings;
// }
}
