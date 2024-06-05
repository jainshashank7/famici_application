import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:famici/feature/notification/entities/dosage_item.dart';
import 'package:famici/feature/notification/helper/remote_message_archive.dart';

import '../../../core/router/router_delegate.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/helpers/notification_helper.dart';
import '../../health_and_wellness/my_medication/entity/selected_medication_details.dart';
import '../../video_call/helper/call_manager/call_manager.dart';
import '../entities/notification.dart';
import 'appointment_notification_helper.dart';

class MedicationChannel {
  static const String receiver = "medication_channel";
  static const String reminder = "medication_reminder_channel";
}

bool isMedication(String? type) {
  if (type == NotificationType.medicationAdd) {
    return true;
  } else if (type == NotificationType.medicationRemove) {
    return true;
  } else if (type == NotificationType.medicationUpdate) {
    return true;
  }
  return false;
}

class MedicationNotificationHelper {
  static final AwesomeNotifications _notification = AwesomeNotifications();

  static Future<void> syncMedicationNotification(RemoteMessage message) async {
    if (message.data['type'] == NotificationType.medicationAdd ||
        message.data['type'] == NotificationType.medicationUpdate) {
      String _me = await LoggedUser().read();
      Notification _notification = Notification.fromRawJson(
        message.data['data'],
      );

      print("timetimetime  inside helper");

      if (_me != _notification.senderContactId) {
        MedicationNotificationHelper.notify(_notification);
      }
      MedicationNotificationHelper.schedule(_notification);
    } else if (message.data['type'] == NotificationType.medicationRemove) {
      String _me = await LoggedUser().read();
      Notification _notification = Notification.fromRawJson(
        message.data['data'],
      );
      if (_me != _notification.senderContactId) {
        MedicationNotificationHelper.notify(_notification);
      }
      MedicationNotificationHelper.removeScheduled(_notification);
    }

    try {
      RemoteMessageArchive().save(message);
    } catch (err) {}
  }

  static Future<void> notify(Notification notification) async {
    notification = notification.copyWith(groupKey: notification.notificationId);
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: MedicationChannel.receiver,
        groupKey: notification.notificationId,
        title: getTitle(notification.type),
        body: notification.title,
        category: NotificationCategory.Alarm,
        largeIcon: notification.senderPicture.isNotEmpty
            ? notification.senderPicture
            : 'asset://assets/icons/user_avatar.png',
        wakeUpScreen: true,
        autoDismissible: true,
        locked: false,
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

  static String getTitle(String? type) {
    if (type == NotificationType.medicationAdd) {
      return "New medication added";
    } else if (type == NotificationType.medicationRemove) {
      return "Medication removed";
    } else if (type == NotificationType.medicationUpdate) {
      return "Medication updated";
    }
    return '';
  }

  static Future<void> schedule(Notification notification) async {
    await removeScheduled(notification);
    for (DosageItem dosage in notification.body.dosageList) {
      try {
        if (notification.body.isRemind) {
          DateTime _time = notification.body.reminderTime;
          print("ist notfisdfh");
          print(_time);
          notification = notification.copyWith(
            groupKey: dosage.id,
          );
          try {
            await _notification.dismissNotificationsByGroupKey(
              notification.groupKey,
            );
          } catch (err) {
            DebugLogger.error(err);
          }

          _notification.createNotification(
            content: NotificationContent(
              id: DateTime.now().second,
              channelKey: MedicationChannel.reminder,
              groupKey: notification.groupKey,
              title: "Medication Reminder",
              body: "Take ${notification.body.medicationName}",
              category: NotificationCategory.Alarm,
              wakeUpScreen: true,
              autoDismissible: false,
              criticalAlert: true,
              locked: true,
              backgroundColor: ColorPallet.kCardBackground,
              payload: {"data": notification.toRawJson()},
            ),
            schedule: NotificationCalendar(
              year: _time.year,
              month: _time.month,
              day: _time.day,
              hour: _time.hour,
              minute: _time.minute,
              timeZone: await FlutterNativeTimezone.getLocalTimezone(),
              repeats: false,
            ),
          );
        }
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  static Future<void> dismissById(String notificationId) async {
    try {
      await _notification.dismissNotificationsByGroupKey(
        notificationId,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> dismissAll() async {
    try {
      await _notification.dismissNotificationsByChannelKey(
        MedicationChannel.receiver,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> dismissGroupKey(String groupKey) async {
    try {
      await _notification.dismissNotificationsByGroupKey(
        groupKey,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> dismissScheduleGroupKey(String groupKey) async {
    try {
      await _notification.dismissNotificationsByGroupKey(
        groupKey,
      );
    } catch (er) {
      return;
    }
  }

  static Future<void> dismissNotification(
    ReceivedNotification action,
  ) async {
    Notification _notification = Notification.fromRawJson(
      action.payload!['data'],
    );

    AwesomeNotifications().dismissNotificationsByGroupKey(
      _notification.groupKey,
    );
  }

  static Future<void> receiveMedicationReminderAction(
    ReceivedAction action,
  ) async {
    Notification _notification = Notification.fromRawJson(
      action.payload!['data'],
    );

    AwesomeNotifications().dismissNotificationsByGroupKey(
      _notification.groupKey,
    );
  }

  static Future<void> receiveMedicationAction(ReceivedAction action) async {
    Notification _notification = Notification.fromRawJson(
      action.payload!['data'],
    );
    AwesomeNotifications().dismissNotificationsByGroupKey(
      _notification.notificationId,
    );
    if (fcRouter.current.name == MyMedicineRoute.name) {
      fcRouter.replace(MyMedicineRoute());
    } else {
      fcRouter.navigate(MyMedicineRoute());
    }
  }

  static Future<void> receiveDisplayedAction(
      ReceivedNotification action) async {
    if (action.summary == "local") {
      if (action.groupKey != null) {
        Future.delayed(Duration(seconds: 15), () {
          AwesomeNotifications().dismissNotificationsByGroupKey(
            action.groupKey!,
          );
        });
      }

      DebugLogger.info(action.payload!['data']);

      SelectedMedicationDetails medicationDetails =
          SelectedMedicationDetails.fromRawJson(action.payload!['data']);

      if (medicationDetails.medicationName != null &&
          medicationDetails.medicationName!.isNotEmpty) {
        fcRouter.navigate(
            LocalMedicationNotifyRoute(medicationDetails: medicationDetails));
      }
    } else {
      Notification _notification = Notification.fromRawJson(
        action.payload!['data'],
      );

      _notification.toRawJson();

      Future.delayed(Duration(seconds: 15), () {
        AwesomeNotifications().dismissNotificationsByGroupKey(action.groupKey!);
      });
      fcRouter.push(MedicationNotifyRoute(
        notification: _notification,
      ));
    }
  }

  static Future<void> removeScheduled(Notification notification) async {
    for (DosageItem dosage in notification.body.dosageList) {
      try {
        try {
          await _notification.cancelNotificationsByGroupKey(dosage.id);
        } catch (err) {
          DebugLogger.error(err);
        }
      } catch (err) {
        DebugLogger.error(err);
      }
    }
    for (String id in notification.body.deletedDosages) {
      try {
        try {
          await _notification.cancelNotificationsByGroupKey(id);
        } catch (err) {
          DebugLogger.error(err);
        }
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  static Future<void> createLocalNotification(
      SelectedMedicationDetails medication, DateTime time) async {
    await AwesomeNotifications()
        .cancelSchedulesByGroupKey(medication.medicationId!);
    print("timetimetime $time");
    _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: MedicationChannel.reminder,
        groupKey: medication.medicationId,
        title: "Medication Reminder",
        body: "Take ${medication.medicationName}",
        category: NotificationCategory.Alarm,
        wakeUpScreen: true,
        autoDismissible: false,
        criticalAlert: true,
        locked: true,
        backgroundColor: ColorPallet.kCardBackground,
        payload: {"data": medication.toRawJson()},
        summary: "local",
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        timeZone: await FlutterNativeTimezone.getLocalTimezone(),
        repeats: false,
      ),
    );
  }
}
