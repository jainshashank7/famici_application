import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rrule/rrule.dart';
import 'package:famici/feature/notification/entities/notification.dart';
import 'package:famici/feature/notification/helper/remote_message_archive.dart';
import 'package:famici/feature/video_call/helper/call_manager/call_manager.dart';
import 'package:famici/utils/helpers/notification_helper.dart';

import '../../../core/router/router_delegate.dart';
import '../../../utils/config/color_pallet.dart';
import '../repositories/notification_repository.dart';
import 'appointment_notification_helper.dart';

class DashboardBuilderNotificationChannel {
  static const String receiver = "dashboard_builder_notification_channel";
}

class DashboardBuilderNotificationHelper {
  static final AwesomeNotifications _notifications = AwesomeNotifications();

  static Future<void> syncDashboardBuilderNotification(
      RemoteMessage message) async {
    try {
      await RemoteMessageArchive().save(message);
    } catch (err) {}

    print("Inside handleRecived d b n");
    if (message.data['type'] == NotificationType.dashboardBuilderUpdated) {
      String _me = await LoggedUser().read();
      Notification _notification =
          Notification.fromRawJson(message.data['data']);

      bool show = !_notification.body.isSilent;
      show = show && _me != _notification.senderContactId;
      if (show) {
        DashboardBuilderNotificationHelper.notify(_notification);
      }
    }
  }

  static Future<void> notify(Notification notification) async {
    final l10n = await RruleL10nEn.create();
    notification = notification.copyWith(groupKey: notification.notificationId);
    await _notifications.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: DashboardBuilderNotificationChannel.receiver,
        groupKey: notification.notificationId,
        title: notification.title,
        body: getBody(notification.type, notification, l10n),
        category: NotificationCategory.Alarm,
        largeIcon: notification.senderPicture.isNotEmpty
            ? notification.senderPicture
            : 'asset://assets/icons/user_avatar.png',
        wakeUpScreen: true,
        autoDismissible: true,
        payload: {"data": notification.toRawJson()},
        backgroundColor: ColorPallet.kCardBackground,
      ),
    );

    Future.delayed(const Duration(seconds: 5), () {
      AppointmentsNotificationHelper.dismissGroupKey(
        notification.notificationId,
      );
    });
  }

  static String getBody(String? type, Notification notification, l10n) {
    return '';
  }

  static Future<void> dismissById(String notificationId) async {
    try {
      await _notifications.dismissNotificationsByGroupKey(
        notificationId,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> dismissAll() async {
    try {
      await _notifications.dismissNotificationsByChannelKey(
        AppointmentChannel.receiver,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> dismissGroupKey(String groupKey) async {
    try {
      await _notifications.dismissNotificationsByGroupKey(
        groupKey,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> receivedDashboardBuilderAction(
      ReceivedAction action) async {
    try {
      Notification _notification = Notification.fromRawJson(
        action.payload!['data'],
      );

      Future.delayed(const Duration(seconds: 15), () {
        AwesomeNotifications().dismissNotificationsByGroupKey(
          action.groupKey!,
        );
      });

      if (fcRouter.current.name == HomeRoute.name) {
        fcRouter.replace(const HomeRoute());
      } else {
        fcRouter.navigate(const HomeRoute());
      }
    } catch (err) {
      return;
    }
  }

  static Future<void> dismissNotification(
    ReceivedNotification action,
  ) async {
    try {
      Notification notification = Notification.fromRawJson(
        action.payload!['data'],
      );

      AwesomeNotifications().dismissNotificationsByGroupKey(
        notification.groupKey,
      );
      AwesomeNotifications().dismissNotificationsByGroupKey(
        notification.groupKey,
      );
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
