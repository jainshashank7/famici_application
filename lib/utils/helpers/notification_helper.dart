import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:famici/feature/chat/helpers/message_notification_helper.dart';
import 'package:famici/feature/notification/helper/dashboard_builder_notification_helper.dart';
import 'package:famici/utils/barrel.dart';

import '../../feature/notification/helper/appointment_notification_helper.dart';
import '../../feature/notification/helper/medication_notify_helper.dart';
import '../../feature/notification/helper/memories_notification_helper.dart';
import '../../feature/video_call/helper/call_manager/call_manager.dart';

class NotificationHelper {
  static void initializeNotificationsPlugin() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: CallChannel.incoming,
          channelName: 'Incoming Call Channel',
          channelDescription: 'Channel with call ringtone',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          locked: true,
          criticalAlerts: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          playSound: true,
        ),
        NotificationChannel(
          channelKey: CallChannel.active,
          channelName: 'Active Call Channel',
          channelDescription: 'Active Call Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.Low,
          ledColor: ColorPallet.kPrimaryTextColor,
          locked: true,
          criticalAlerts: false,
          playSound: false,
          channelShowBadge: false,
          enableVibration: false,
        ),
        NotificationChannel(
          channelKey: CallChannel.missed,
          channelName: 'Missed Calls',
          channelDescription: 'Missed Call Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: true,
          criticalAlerts: false,
          playSound: false,
        ),
        NotificationChannel(
            channelKey: MessageChannel.receiver,
            channelName: 'Message',
            channelDescription: 'Family Connect Messaging Channel',
            defaultColor: ColorPallet.kBackground,
            importance: NotificationImportance.High,
            ledColor: ColorPallet.kPrimaryTextColor,
            channelShowBadge: true,
            enableVibration: true,
            locked: true,
            criticalAlerts: false,
            playSound: true,
            defaultRingtoneType: DefaultRingtoneType.Notification),
        NotificationChannel(
          channelKey: MemoriesChannel.receiver,
          channelName: 'Memories',
          channelDescription: 'Family Connect Memories Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: true,
          criticalAlerts: false,
          playSound: false,
        ),
        NotificationChannel(
          channelKey: MedicationChannel.receiver,
          channelName: 'medication',
          channelDescription: 'Family Connect Medication Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: false,
          criticalAlerts: true,
          playSound: true,
          onlyAlertOnce: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
        NotificationChannel(
          channelKey: MedicationChannel.reminder,
          channelName: 'medication Reminder',
          channelDescription: 'Family Connect Medication Reminder Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: false,
          criticalAlerts: true,
          playSound: true,
          onlyAlertOnce: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
        NotificationChannel(
          channelKey: AppointmentChannel.receiver,
          channelName: 'Calendar',
          channelDescription: 'Family Connect Calendar Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: false,
          criticalAlerts: true,
          playSound: true,
          onlyAlertOnce: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
        NotificationChannel(
          channelKey: AppointmentChannel.reminder,
          channelName: 'Calendar Reminder',
          channelDescription: 'Family Connect Calender Reminder Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: false,
          criticalAlerts: true,
          playSound: true,
          onlyAlertOnce: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
        NotificationChannel(
          channelKey: DashboardBuilderNotificationChannel.receiver,
          channelName: 'Dashboard Builder Notification',
          channelDescription: 'Dashboard Builder Notification Channel',
          defaultColor: ColorPallet.kBackground,
          importance: NotificationImportance.High,
          ledColor: ColorPallet.kPrimaryTextColor,
          channelShowBadge: true,
          enableVibration: true,
          locked: false,
          criticalAlerts: true,
          playSound: true,
          onlyAlertOnce: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
      debug: false,
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreated,
      onDismissActionReceivedMethod: onNotificationDismissed,
      onNotificationDisplayedMethod: onNotificationDisplayed,
    );
  }

  // static closeNotificationChannels() async {
  //   await AwesomeNotifications().removeChannel(AppointmentChannel.reminder);
  //   await AwesomeNotifications().removeChannel(AppointmentChannel.receiver);
  //   await AwesomeNotifications().removeChannel(MedicationChannel.reminder);
  //   await AwesomeNotifications().removeChannel(MedicationChannel.receiver);
  //   await AwesomeNotifications().removeChannel(MessageChannel.receiver);
  // }

  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    switch (receivedAction.channelKey) {
      case CallChannel.incoming:
        await CallNotify.receiveIncomingCallAction(receivedAction);
        break;
      case MessageChannel.receiver:
        await MessageNotificationHelper.receiveMessageAction(receivedAction);
        break;
      case MedicationChannel.reminder:
        await MedicationNotificationHelper.receiveMedicationReminderAction(
          receivedAction,
        );
        break;
      case MedicationChannel.receiver:
        await MedicationNotificationHelper.receiveMedicationAction(
            receivedAction);
        break;
      case AppointmentChannel.reminder:
        await AppointmentsNotificationHelper.receiveAppointmentAction(
            receivedAction);
        break;
      case AppointmentChannel.receiver:
        print("Received Action :: ${receivedAction.payload!['data']}");
        await AppointmentsNotificationHelper.receiveAppointmentAction(
            receivedAction);
        break;
      case DashboardBuilderNotificationChannel.receiver:
        print("Received Action :: ${receivedAction.payload!['data']}");
        await DashboardBuilderNotificationHelper.receivedDashboardBuilderAction(
            receivedAction);
        break;
      default:
        break;
    }
  }

  static Future<void> onNotificationCreated(
    ReceivedNotification receivedAction,
  ) async {
    switch (receivedAction.channelKey) {
      case CallChannel.incoming:
        break;
      default:
        break;
    }
  }

  static Future<void> onNotificationDisplayed(
    ReceivedNotification receivedAction,
  ) async {
    switch (receivedAction.channelKey) {
      case MedicationChannel.reminder:
        MedicationNotificationHelper.receiveDisplayedAction(receivedAction);
        break;
      case AppointmentChannel.reminder:
        AppointmentsNotificationHelper.receiveDisplayedAction(receivedAction);
        break;
      case MemoriesChannel.receiver:
        MemoriesNotificationHelper.receiveDisplayedAction(receivedAction);
        break;
      default:
        break;
    }
  }

  static Future<void> onNotificationDismissed(
    ReceivedNotification receivedAction,
  ) async {
    switch (receivedAction.channelKey) {
      case CallChannel.incoming:
        AwesomeNotifications().decrementGlobalBadgeCounter();
        break;
      case CallChannel.active:
        AwesomeNotifications().decrementGlobalBadgeCounter();
        break;
      case CallChannel.missed:
        AwesomeNotifications().decrementGlobalBadgeCounter();
        break;
      case MessageChannel.receiver:
        AwesomeNotifications().decrementGlobalBadgeCounter();
        break;

      case MedicationChannel.reminder:
        await MedicationNotificationHelper.dismissNotification(
          receivedAction,
        );
        break;
      case AppointmentChannel.reminder:
        await MedicationNotificationHelper.dismissNotification(
          receivedAction,
        );
        break;
      case DashboardBuilderNotificationChannel.receiver:
        await DashboardBuilderNotificationHelper.dismissNotification(
            receivedAction);
        break;
      default:
        AwesomeNotifications().decrementGlobalBadgeCounter();
        break;
    }
  }
}

class NotificationType {
  static const String call = 'call-notification';
  static const String message = 'message-notification';
  static const String vitals = "vital-notification";
  static const String medicationAdd = "medication-add-notification";
  static const String medicationRemove = "medication-remove-notification";
  static const String medicationUpdate = "medication-update-notification";
  static const String eventAdd = "mobex-hh-event-add-notification";
  static const String eventRemove = "mobex-hh-event-delete-notification";
  static const String eventUpdate = "mobex-hh-event-update-notification";
  static const String requestMemories = "request-memories-notification";
  static const String shareMemories = "share-memories-notification";
  static const String familyInvite = "family-invite-notification";
  static const String userCreated = "create-contact-notification";
  static const String userDeleted = "delete-contact-notification";
  static const String userUpdated = "update-contact-notification";
  static const String inviteAccepted = "invite-accepted-notification";
  static const String activityReminder = "activity-reminder-notification";
  static const String activityReminderCreated =
      "create-activity-reminder-notification";
  static const String activityReminderDeleted =
      "delete-activity-reminder-notification";
  static const String activityReminderUpdated =
      "update-activity-reminder-notification";
  static const String dashboardBuilderUpdated = "dashboard-build-updated";
}
