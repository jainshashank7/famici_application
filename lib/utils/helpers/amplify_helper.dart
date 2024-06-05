import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:famici/utils/config/api_config.dart';

import '../../core/blocs/connectivity_bloc/connectivity_bloc.dart';
import '../config/amplifyconfiguration.dart';

class FCAmplify {
  static Future<void> initialize() async {
    bool isConfigured = Amplify.isConfigured;
    if (!isConfigured) {
      AmplifyAuthCognito _auth = AmplifyAuthCognito();
      AmplifyAPI _api = AmplifyAPI();
      AmplifyStorageS3 _storage = AmplifyStorageS3();

      // AmplifyAnalyticsPinpoint _analytics = AmplifyAnalyticsPinpoint();
      await Amplify.addPlugins([
        _auth,
        _api,
        _storage,
        // _analytics,
      ]);

      try {
        await Amplify.configure(AmplifiyEnvConfig.currentEnv);
        await AmplifyApiName.init();
      } catch (err) {
        print('Already configured');
      }
    }
  }
}

class AmplifyApiName {
  static String iam = '';
  static String defaultApi = '';
  static String apiKey = '';
  static String userPool = '';

  static init() async {
    AmplifyConfig config = await Amplify.asyncConfig;
    var apis = config.auth?.awsPlugin?.appSync?.all;
    iam = apis?.keys.firstWhere((key) => key.contains('AWS_IAM')) ?? '';
    defaultApi = apis?.keys.firstWhere((key) => key.contains('Default')) ?? '';
    userPool = apis?.keys.firstWhere((key) => key.contains('USER_POOLS')) ?? '';
    apiKey = apis?.keys.firstWhere((key) => key.contains('API_KEY')) ?? '';
  }
}

final ConnectivityBloc connectivityBloc = ConnectivityBloc();
