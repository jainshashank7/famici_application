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
import 'appointment_notification_helper.dart';

class ActivityReminderChannel {
  static const String channel = "activity_reminder_rec_channel";
}

bool isActivityReminder(String? type) {
  if (type == NotificationType.activityReminder) {
    return true;
  } else if (type == NotificationType.activityReminderCreated) {
    return true;
  } else if (type == NotificationType.activityReminderDeleted) {
    return true;
  } else if (type == NotificationType.activityReminderUpdated) {
    return true;
  }
  return false;
}

class ActivityReminderNotificationHelper {
  static final AwesomeNotifications _notifications = AwesomeNotifications();

  static Future<void> syncActivityReminderNotification(
      RemoteMessage message) async {
    try {
      await RemoteMessageArchive().save(message);
    } catch (err) {}

    if (message.data['type'] == NotificationType.activityReminder ||
        message.data['type'] == NotificationType.activityReminderCreated ||
        message.data['type'] == NotificationType.activityReminderUpdated) {
      String _me = await LoggedUser().read();
      Notification _notification =
          Notification.fromRawJson(message.data['data']);

      bool show = !_notification.body.isSilent;
      show = show && _me != _notification.senderContactId;
      if (show) {
        ActivityReminderNotificationHelper.notify(_notification);
      }
      AppointmentsNotificationHelper.schedule(_notification);
    } else if (message.data['type'] ==
        NotificationType.activityReminderDeleted) {
      String _me = await LoggedUser().read();
      Notification _notification =
          Notification.fromRawJson(message.data['data']);
      if (_me != _notification.senderContactId) {
        ActivityReminderNotificationHelper.notify(_notification);
      }
      AppointmentsNotificationHelper.removeScheduled(_notification);
    }
  }

  static Future<void> notify(Notification notification) async {
    final l10n = await RruleL10nEn.create();
    notification = notification.copyWith(groupKey: notification.notificationId);
    await _notifications.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: AppointmentChannel.receiver,
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

    Future.delayed(const Duration(seconds:5), () {
      print("activated 123");

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

  static Future<void> receivedActivityReminderAction(
      ReceivedAction action) async {
    try {
      Notification _notification = Notification.fromRawJson(
        action.payload!['data'],
      );

      Future.delayed(const Duration(seconds: 15), () {
        print("activated 123");

        AppointmentsNotificationHelper.dismissGroupKey(
          action.groupKey!,
        );
      });

      if (fcRouter.current.name == CalenderRoute.name) {
        fcRouter.replace(const CalenderRoute());
      } else {
        fcRouter.navigate(const CalenderRoute());
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
