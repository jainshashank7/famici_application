import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../core/enitity/invite_status.dart';
import 'amplify_service.dart';

class UserRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() {
    return _singleton;
  }

  UserRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();

  Future<List<User>> fetchContacts({required String familyId}) async {
    String graphQLDocument =
        '''query GetContacts(\$familyId:ID!, \$limit:Int!) {
              getContacts(familyId:\$familyId, limit:\$limit) {
                items {
                  config {
                      champConnectId
                      medicationDisclaimer
                  }
                  phone
                  role
                  isFamilyOrFriend
                  viewMedication
                  viewVitals
                  viewReminders
                  isEmergencyContact
                  relationship
                  note
                  createdAt
                  updatedAt
                  contactId
                  email
                  familyId
                  familyName
                  givenName
                  name
                  activeStatus
                  presenceStatus
                  invite {
                    createdAt
                    createdBy
                    expireAt
                    familyName
                    givenName
                    status
                    username
                  }
                  picture {
                      bucket
                      key
                      url
                    }
                 }
              }
        }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "limit": 300,
      },
      apiName: AmplifyApiName.defaultApi,
    );


    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }

    return parseContactsFromJsonListString(resp.data);
  }

  Future<dynamic> createContact({required User contact}) async {
    String graphQLDocument =
        '''mutation CreateContact (\$aliasType: AliasType!,\$familyId: ID!,\$contact: ContactInput!) {
            createContact (aliasType: \$aliasType,familyId:\$familyId, contact: \$contact) {
                config {
                  champConnectId
                  medicationDisclaimer
                }
                contactId
                familyId
                givenName
                familyName
                name
                activeStatus
                presenceStatus
                phone
                email
                role
                picture{
                  bucket
                  key
                  url
                }
                invite {
                  familyName
                  status
                  createdAt
                  expireAt
                  username
                  createdBy
                  givenName
                }
                isFamilyOrFriend
                viewMedication
                viewVitals
                viewReminders
                isEmergencyContact
                relationship
                note
                createdAt
                updatedAt
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        //"aliasType": contact.isEmailPrimary ? 'Email' : 'Phone',
        "aliasType": 'Phone',
        "familyId": contact.familyId,
        "contact": contact.toJsonContact()
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return User.fromJsonContact(jsonDecode(response.data)['createContact']);
  }

  Future<User> updateContact({
    required User contact,
  }) async {
    String graphQLDocument =
        '''mutation updateContact(\$contactId: ID!, \$familyId: ID!,  \$contact: UpdateContactInput!) {
            updateContact(contactId: \$contactId, familyId:\$familyId,  contact: \$contact) {
                config {
                  champConnectId
                  medicationDisclaimer
                }
                contactId
                familyId
                givenName
                familyName
                name
                activeStatus
                phone
                email
                role
                picture{
                  bucket
                  key
                  url
                }
                invite {
                  createdAt
                  createdBy
                  expireAt
                  familyName
                  givenName
                  status
                  username
                }
                isFamilyOrFriend
                viewMedication
                viewVitals
                viewReminders
                isEmergencyContact
                relationship
                note
                createdAt
                updatedAt
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": contact.familyId,
        "contactId": contact.id,
        "contact": contact.toJsonContact()
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return User.fromJsonContact(jsonDecode(response.data)['updateContact']);
  }

  Future<bool> deleteContact({
    required String familyId,
    required String contactId,
  }) async {
    String graphQLDocument =
        '''mutation deleteContact(\$contactId: ID!, \$familyId: ID!) {
            deleteContact(contactId: \$contactId, familyId:\$familyId)
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"familyId": familyId, "contactId": contactId},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isEmpty) {
      return true;
    } else {
      throw response.errors.first;
    }
  }

  Future<bool> removeContactPicture({
    required String familyId,
    required String contactId,
  }) async {
    String graphQLDocument =
        '''mutation RemoveContactPicture(\$contactId: ID!, \$familyId: ID!) {
            removeContactPicture(contactId: \$contactId, familyId:\$familyId){
              phone
              role
              isFamilyOrFriend
              viewMedication
              viewVitals
              viewReminders
              isEmergencyContact
              relationship
              note
              status
              createdAt
              updatedAt
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    return response.errors.isEmpty;
  }

  Future<String> syncChampVideoToken({
    required String? familyId,
    required String? contactId,
  }) async {
    String graphQLDocument =
        '''query GetChampConnectToken (\$familyId: ID!,\$contactId: ID!) {
            getChampConnectToken (familyId:\$familyId, contactId: \$contactId) {
                 token
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return jsonDecode(response.data)['getChampConnectToken']?['token'];
  }

  Future<InviteStatus> fetchInviteStatus({
    required String? familyId,
    required String? contactId,
  }) async {
    String graphQLDocument =
        '''query GetInviteStatus (\$familyId: ID!,\$contactId: ID!) {
            getInviteStatus (familyId:\$familyId, contactId: \$contactId) {
                contactId
                createdAt
                createdBy
                expireAt
                familyId
                familyName
                givenName
                status
                username
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return InviteStatus.fromJson(
      jsonDecode(response.data)['getInviteStatus'],
    );
  }

  Future<InviteStatus> sendContactInvite({
    required String? familyId,
    required String? contactId,
  }) async {
    String graphQLDocument =
        '''mutation ResendContactInvite (\$familyId: ID!,\$contactId: ID!) {
            resendContactInvite (familyId:\$familyId, contactId: \$contactId) {
                contactId
                createdAt
                createdBy
                expireAt
                familyId
                familyName
                givenName
                status
                username
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
        "contactId": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return InviteStatus.fromJson(
      jsonDecode(response.data)['resendContactInvite'],
    );
  }
}
