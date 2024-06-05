import 'dart:async';

import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:famici/feature/notification/entities/notification.dart';
import 'package:famici/utils/barrel.dart';

class NotificationRepository {
  factory NotificationRepository() {
    return _singleton;
  }
  static final NotificationRepository _singleton =
      NotificationRepository._internal();

  final StreamController _memory = StreamController.broadcast();
  final StreamController _medication = StreamController.broadcast();
  final StreamController _events = StreamController.broadcast();
  final StreamController _reminders = StreamController.broadcast();
  final StreamController _dashboardBuilder = StreamController.broadcast();

  NotificationRepository._internal() {
    FirebaseMessaging.onMessage.listen(handleReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(handleReceived);
  }

  handleReceived(RemoteMessage message) async {
    DebugLogger.info(message.data);
    print("Inside handleRecived nr" );
    if (_isMedication(message.data['type'])) {
      Notification notification = Notification.fromRawJson(
        message.data['data'],
      );
      if (notification.notificationId.isNotEmpty) {
        _medication.sink.add(notification);
      }
    } else if (_isEvents(message.data['type'])) {
      Notification notification = Notification.fromRawJson(
        message.data['data'],
      );
      if (notification.notificationId.isNotEmpty) {
        _events.sink.add(notification);
      }
    } else if (_isMemories(message.data['type'])) {
      Notification notification = Notification.fromRawJson(
        message.data['data'],
      );
      if (notification.notificationId.isNotEmpty) {
        _memory.sink.add(notification);
      }
    } else if (_isActivityReminders(message.data['type'])) {
      Notification notification = Notification.fromRawJson(
        message.data['data'],
      );
      if (notification.notificationId.isNotEmpty) {
        _reminders.sink.add(notification);
      }
    } else if (message.data['type'] ==
        NotificationType.dashboardBuilderUpdated) {
      print("Notification Content ::: ${message.data['data']}");
      Notification notification =
          Notification.fromRawJson(message.data['data']);
      if (notification.notificationId.isNotEmpty) {
        _dashboardBuilder.sink.add(notification);
      }
    }
  }

  bool _isMedication(String? type) {
    if (type == NotificationType.medicationAdd) {
      return true;
    } else if (type == NotificationType.medicationRemove) {
      return true;
    } else if (type == NotificationType.medicationUpdate) {
      return true;
    }
    return false;
  }

  bool _isEvents(String? type) {
    if (type == NotificationType.eventAdd) {
      return true;
    } else if (type == NotificationType.eventRemove) {
      return true;
    } else if (type == NotificationType.eventUpdate) {
      return true;
    }
    return false;
  }

  bool _isMemories(String? type) {
    if (type == NotificationType.requestMemories) {
      return true;
    } else if (type == NotificationType.shareMemories) {
      return true;
    }
    return false;
  }

  bool _isActivityReminders(String? type) {
    if (type == NotificationType.activityReminder) {
      return true;
    }
    return false;
  }

  Stream get medication => _medication.stream;
  Stream get appointments => _events.stream;
  Stream get memories => _memory.stream;
  Stream get reminders => _reminders.stream;
  Stream get dashboardBuilder => _dashboardBuilder.stream;
}
