import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import '../utils/helpers/amplify_helper.dart';
import 'amplify_service.dart';

class PinRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  Future<String> createPin(
    String? email,
    String? pin,
  ) async {
    String graphQLDocument = ''' mutation createPin (\$email: String!,\$pin: ID!){
        createPin (email : \$email,pin:\$pin) 
      }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "email": email,
        "pin": pin,
      },
      apiName: AmplifyApiName.defaultApi,
    );
    return "";
  }


  Future<String?> getUserPin(
      String? email,
      ) async {
    String graphQLDocument = ''' query getPin (\$email: String!){
        getPin (email : \$email){
        pin
        } 
      }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "email": email,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if(response.errors.isNotEmpty){
      return "";
    }
    try{
      Map<String, dynamic> data = jsonDecode(response.data);
      print(response.data);
      return data['getPin']['pin'];
    } catch(err){
      return "";
    }

  }

  Future<String> updatePin(
      String? email,
      String? pin,
      ) async {
    String graphQLDocument = ''' mutation updatePin (\$email: String!,\$pin: ID!){
        updatePin (email : \$email,pin:\$pin) 
      }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "email": email,
        "pin": pin,
      },
      apiName: AmplifyApiName.defaultApi,
    );
    return "";
  }
}
