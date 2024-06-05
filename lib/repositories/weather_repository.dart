import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:famici/core/enitity/weather.dart';
import 'package:famici/utils/barrel.dart';

class WeatherRepository {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  fetchWeather({
    required double lat,
    required double lon,
  }) async {
    String graphQLDocument = '''
    query GetCurrentWeather(\$query:String!) {
      getCurrentWeather(query: \$query)
    }
    ''';
    GraphQLOperation query = Amplify.API.query(
      request: GraphQLRequest(
        document: graphQLDocument,
        variables: {"query": "$lat,$lon"},
        apiName: AmplifyApiName.iam,
      ),
    );

    GraphQLResponse response = await query.response;
    if (response.errors.isNotEmpty) {
      _crashlytics.recordError(
        response.errors.first,
        StackTrace.fromString(response.errors.first.message),
        reason: response.errors,
      );
      throw response.errors.first;
    }
    return Weather.fromRawJson(jsonDecode(response.data)['getCurrentWeather']);
  }
}
