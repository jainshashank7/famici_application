import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:debug_logger/debug_logger.dart';

import '../utils/helpers/amplify_helper.dart';
import 'amplify_service.dart';

class DashboardRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  StreamSubscription? _subscription;
  final StreamController<bool> _dashboardStream =
  StreamController<bool>.broadcast();
  StreamSubscription? _subscriptionChange;
  final StreamController<bool> _dashboardChangeStream =
  StreamController<bool>.broadcast();


  Stream<bool> subscribeToDashboardChange(String contactId) {
    String graphQLDocument = '''subscription MySubscription {
                               subscribeToDashboardChange{
                               contactId}
                              }
''';

    _subscriptionChange?.cancel();
    _subscriptionChange = Amplify.API
        .subscribe(GraphQLRequest(
      document: graphQLDocument,
      apiName: AmplifyApiName.defaultApi,
    ))
        .listen((event) {
      if (event.data != null) {
        try {
          Map<String, dynamic> data = json.decode(event.data);
          print("yeah found na "+data.toString());
          String subscribeToKioskNotificationData =
          data['subscribeToDashboardChange']['contactId'];

          // if (subscribeToKioskNotificationData.containsKey('users')) {
          //   List<dynamic>? usersList =
          //       subscribeToKioskNotificationData['users'];

          //   print(usersList);

          //   if (usersList != null && usersList.contains(userId)) {
          print(subscribeToKioskNotificationData);
          print(contactId);
          if(subscribeToKioskNotificationData == contactId)
          {
            print("yeah found only 1 notfication for change");
            _dashboardChangeStream.add(true);
          }
          else{
            print("yeah found no notfication for change");
          }
          //   }
          // }
          print("data for notfication dashboard change" + event.data.toString());
        } catch (err) {
          DebugLogger.error(err);
        }
      }
    });

    return _dashboardChangeStream.stream;
  }
}
