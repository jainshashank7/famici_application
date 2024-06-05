import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:famici/feature/app_info/entity/app_support_info.dart';

import '../utils/helpers/amplify_helper.dart';
import 'amplify_service.dart';

class ConfigService {
  final AmplifyService _amplifyAPI = AmplifyService();

  final AmplifyAuthCognito _cognito = AmplifyAuthCognito();

  Future<void> saveDeviceToken({String? deviceToken}) async {
    String graphQLDocument = '''mutation AddDeviceToken(\$deviceToken:String!) {
             addDeviceToken(deviceToken:\$deviceToken)
        }''';

    GraphQLResponse resp = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "deviceToken": deviceToken,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return;
  }

  Future<AppSupportInfo> getAppInformation() async {
    String graphQLDocument = '''query GetAppInformation {
            getAppInformation {
              help {
                documentName
                documentUrl
              }
              privacy {
                documentName
                documentUrl
              }
              terms {
                documentName
                documentUrl
              }
              version
            }
          }
        ''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return AppSupportInfo.fromJson(jsonDecode(resp.data)['getAppInformation']);
  }

  Future<void> saveLocaleAndTimeZone({String? locale, String? timezone}) async {
    List<AuthUserAttribute> attributes = [];

    attributes.add(AuthUserAttribute(
      userAttributeKey: CognitoUserAttributeKey.zoneinfo,
      value: timezone ?? '',
    ));
    attributes.add(AuthUserAttribute(
      userAttributeKey: CognitoUserAttributeKey.locale,
      value: locale ?? '',
    ));

    try {
      var zone = await _cognito.updateUserAttributes(
        // request: UpdateUserAttributesRequest(
          attributes: attributes,
        // ),
      );
     
    } catch (e) {
      DebugLogger.error(e.toString());
    }
  }
}
