import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../feature/my_apps/entities/link.dart';
import 'amplify_service.dart';

class MyAppRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  Future<List<UrlLink>> getLinks({
    String? familyId = '',
  }) async {
    String graphQLDocument = '''
      query getLinks (\$familyId: ID!){
        getLinks( familyId: \$familyId) {
          items {
            createdBy
            createdAt
            description
            familyId
            link
            linkId
          }
        }
      }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return [];
    } else {
      List<dynamic> links = List.from(
        jsonDecode(response.data)['getLinks']['items'],
      );
      return List<UrlLink>.from(links.map((e) => UrlLink.fromJson(e)));
    }
  }
}
