import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/repositories/user_status_repository/user_status_repository_interface.dart';

import '../../utils/helpers/amplify_helper.dart';
import '../amplify_service.dart';

class UserStatusRepo implements UserStatusRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  final StreamController<HeartBeat> _statusStream =
      StreamController<HeartBeat>.broadcast();

  StreamSubscription? _subscription;

  @override
  Future<void> connect({String? familyId = ''}) async {
    String graphQLDocument =
        '''query Connection(\$presenceStatus:PresenceStatus!,\$familyId:ID!) {
            connection (presenceStatus:\$presenceStatus,familyId:\$familyId)
        }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {"familyId": familyId, "presenceStatus": "Online"},
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      DebugLogger.error(resp.errors.first);
      throw resp.errors.first;
    }
    return;
  }

  @override
  Future<void> disconnect({String? familyId = ''}) async {
    String graphQLDocument =
        '''query Connection(\$presenceStatus:PresenceStatus!,\$familyId:ID!) {
            connection (presenceStatus:\$presenceStatus,familyId:\$familyId)
        }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {"familyId": familyId, "presenceStatus": "Offline"},
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      DebugLogger.error(resp.errors.first);
      throw resp.errors.first;
    }
    return;
  }

  @override
  Future<void> heartBeat({String? familyId = ''}) async {
    //TODO: heartBeat repo
    // String graphQLDocument = '''query Heartbeat(\$familyId: ID!) {
    //        heartbeat(familyId: \$familyId)
    //      }''';
    //
    // GraphQLResponse resp = await _amplifyAPI.query(
    //   document: graphQLDocument,
    //   variables: {
    //     "familyId": familyId,
    //   },
    //   apiName: AmplifyApiName.defaultApi,
    // );
    //
    // if (resp.errors.isNotEmpty) {
    //   DebugLogger.error(resp.errors.first);
    //   throw resp.errors.first;
    // }
    return;
  }

  @override
  Stream<HeartBeat> subscribe({String? familyId = ''}) {
    String graphQLDocument =
        '''subscription SubscribeToUserPresence(\$familyId: ID!) {
           subscribeToUserPresence(familyId: \$familyId) {
              presenceStatus
              contactId
              familyId
            }
         }''';

    _subscription?.cancel();
    _subscription = Amplify.API
        .subscribe(GraphQLRequest(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    ))
        .listen((event) {
      if (event.data != null) {
        _statusStream.add(
          HeartBeat.fromJson(jsonDecode(event.data)['subscribeToUserPresence']),
        );
      }
    });

    return _statusStream.stream;
  }

  @override
  dispose() async {
    _subscription?.cancel();
  }
}
