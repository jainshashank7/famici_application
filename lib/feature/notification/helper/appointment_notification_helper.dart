import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';
import 'package:famici/feature/calander/screens/appointment_notify_screen.dart';
import 'package:famici/feature/notification/entities/notification_body.dart';
import 'package:famici/feature/notification/helper/remote_message_archive.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/router/router_delegate.dart';
import '../../calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import '../../calander/screens/event_notify_screen.dart';
import '../../video_call/helper/call_manager/call_manager.dart';
import '../entities/notification.dart';
import 'appointment_company_settings_fetcher.dart';

class AppointmentChannel {
  static const String receiver = "appointment_channel";
  static const String reminder = "appointment_reminder_channel";
}

bool isAppointments(String? type) {
  if (type == NotificationType.eventAdd) {
    return true;
  } else if (type == NotificationType.eventUpdate) {
    return true;
  } else if (type == NotificationType.eventRemove) {
    return true;
  }
  return false;
}

class AppointmentsNotificationHelper {
  static final AwesomeNotifications _notification = AwesomeNotifications();
  static final DataFetcher companySettingsFetcher = DataFetcher();

  static Future<void> syncAppointmentNotification(RemoteMessage message) async {
    try {
      await RemoteMessageArchive().save(message);
    } catch (err) {}

    if (message.data['type'] == NotificationType.eventAdd ||
        message.data['type'] == NotificationType.eventUpdate) {
      String _me = await LoggedUser().read();
      Notification _notification = Notification.fromRawJson(
        message.data['data'],
      );

      bool show = !_notification.body.isSilent;
      show = show && _me != _notification.senderContactId;
      if (show) {
        AppointmentsNotificationHelper.notify(_notification);
      }
      AppointmentsNotificationHelper.schedule(_notification);
    } else if (message.data['type'] == NotificationType.eventRemove) {
      String _me = await LoggedUser().read();
      Notification _notification = Notification.fromRawJson(
        message.data['data'],
      );
      if (_me != _notification.senderContactId) {
        AppointmentsNotificationHelper.notify(_notification);
      }
      AppointmentsNotificationHelper.removeScheduled(_notification);
    }
  }

  static Future<void> notify(Notification notification) async {
    final l10n = await RruleL10nEn.create();
    notification = notification.copyWith(groupKey: notification.notificationId);
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: AppointmentChannel.receiver,
        groupKey: notification.notificationId,
        title: getTitle(notification.type, notification),
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
  }

  static String getTitle(String? type, Notification notification) {
    if (type == NotificationType.eventAdd) {
      return "You have a new appointment";
    } else if (type == NotificationType.eventRemove) {
      return "Appointment removed";
    } else if (type == NotificationType.eventUpdate) {
      return "Appointment updated";
    }
    return '';
  }

  static String getBody(String? type, Notification notification, l10n) {
    final startDate = notification.body.daytApptStart;
    final time = DateFormat(time12hFormat).format(startDate);
    final date = DateFormat(dateFormat).format(startDate);

    String bodyPrefix = '${notification.body.appointment} at $time on $date';

    if (type == NotificationType.eventAdd) {
      return bodyPrefix;
    } else if (type == NotificationType.eventRemove) {
      return '$bodyPrefix has been removed.';
    } else if (type == NotificationType.eventUpdate) {
      return '$bodyPrefix has been updated.';
    }
    return '';
  }

  static Future<dynamic> scheduleByDate({
    required groupKey,
    required DateTime startDate,
    required Notification notification,
    required DateTime eventTime,
  }) async {
    final saved = notification.copyWith(
      body: notification.body.copyWith(
        daytApptStart: startDate,
        id: groupKey,
      ),
    );
    await _notification.createNotification(
      content: NotificationContent(
        id: groupKey,
        channelKey: AppointmentChannel.reminder,
        groupKey: 'appointment_schedule_$groupKey',
        title: "Appointment Reminder",
        body:
            'You have ${notification.body.appointment} at ${DateFormat(time12hFormat).format(eventTime.toLocal())}',
        category: NotificationCategory.Alarm,
        backgroundColor: ColorPallet.kCardBackground,
        payload: {"data": saved.toRawJson()},
        wakeUpScreen: true,
        autoDismissible: false,
        criticalAlert: true,
        locked: true,
      ),
      schedule: NotificationCalendar.fromDate(
        date: startDate,
        repeats: false,
      ),
    );

    DebugLogger.info('appointment_schedule_$groupKey created');
    return;
  }

  static Future<void> schedule(Notification notification) async {
    try {
      List<ScheduleEvent> schedule = notification.body.schedule;

      await removeExistingScheduleList(schedule);

      List<String> times = await companySettingsFetcher.fetchData();

      for (ScheduleEvent event in schedule) {
        final notificationWithGroupKey = notification.copyWith(
          groupKey: 'appointment_schedule_${event.id}',
        );

        await scheduleByDate(
          groupKey: event.id,
          startDate: event.startDate,
          notification: notificationWithGroupKey,
          eventTime: event.startDate,
        );

        for (String time in times) {
          // TODO : type string is not sub type of int error
          if (time == "30m") {
            final notificationWithGroupKey = notification.copyWith(
              groupKey: 'appointment_schedule_${event.id * 10}',
            );
            DateTime meetingTime =
                event.startDate.subtract(Duration(minutes: 30));
            if (meetingTime.isAfter(DateTime.now())) {
              int id = event.id * 10;
              await scheduleByDate(
                groupKey: id,
                startDate: meetingTime,
                notification: notificationWithGroupKey,
                eventTime: event.startDate,
              );
            }
          } else if (time == "1d") {
            final notificationWithGroupKey = notification.copyWith(
              groupKey: 'appointment_schedule_${event.id * 100}',
            );
            DateTime meetingTime = event.startDate.subtract(Duration(days: 1));
            if (meetingTime.isAfter(DateTime.now())) {
              int id = event.id * 100;
              await scheduleByDate(
                groupKey: id,
                startDate: meetingTime,
                notification: notificationWithGroupKey,
                eventTime: event.startDate,
              );
            }
          }
        }
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  static Future<void> removeExistingScheduleList(
    List<ScheduleEvent> schedule,
  ) async {
    try {
      for (ScheduleEvent event in schedule) {
        await _notification.cancelSchedulesByGroupKey(
          'appointment_schedule_${event.id}',
        );
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    try {
      for (ScheduleEvent event in schedule) {
        await _notification.cancelSchedulesByGroupKey(
          'appointment_schedule_${event.id * 10}',
        );
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    try {
      for (ScheduleEvent event in schedule) {
        await _notification.cancelSchedulesByGroupKey(
          'appointment_schedule_${event.id * 100}',
        );
      }
    } catch (err) {
      DebugLogger.error(err);
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
        AppointmentChannel.receiver,
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

  static Future<void> receiveAppointmentAction(ReceivedAction action) async {
    try {
      Notification _notification = Notification.fromRawJson(
        action.payload!['data'],
      );

      print("it is triggered 123");

      Future.delayed(const Duration(seconds: 15), () {
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

  static Future<void> removeScheduled(Notification notification) async {
    try {
      List<ScheduleEvent> schedule = notification.body.schedule;

      for (var event in schedule) {
        await _notification.cancelNotificationsByGroupKey(
          'appointment_schedule_${event.id}',
        );
      }
    } catch (err) {
      DebugLogger.error(err);
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

  static Future<void> receiveDisplayedAction(
    ReceivedNotification action,
  ) async {
    if (action.summary == "reminder/event_local") {
      try {
        // Future.delayed(const Duration(seconds: 30), () {
        //   dismissNotification(action);
        // });

        Reminders reminder =
            Reminders.fromJson(jsonDecode(action.payload!['data'] ?? ""));

        Future.delayed(const Duration(seconds: 15), () {
          dismissNotification(action);
        });
        fcRouter.pushWidget(EventNotifyScreen(
          reminder: reminder,
        ));
      } catch (err) {
        return;
      }
    } else {
      try {
        Notification notification = Notification.fromRawJson(
          action.payload!['data'],
        );
        Future.delayed(const Duration(seconds: 15), () {
          dismissNotification(action);
        });

        fcRouter.pushWidget(AppointmentNotifyScreen(
          notification: notification,
        ));
      } catch (err) {
        return;
      }
    }
  }

  static Future<void> createEventNotification(Reminders reminder) async {

    DateTime endTime = reminder.endTime.toLocal();
    DateTime time = reminder.startTime.toLocal();
    DebugLogger.debug("createEventNotification:: ${reminder.title} ${reminder.reminderId}  ${time.toString()}");

    // await AwesomeNotifications()
    //     .cancelSchedulesByGroupKey(reminder.reminderId.toString());
    // print("this is create reminder heyyyyyyy u should work  :((()))" +
    //     reminder.startTime.toString() +
    //     ' ' +
    //     time.toString() +
    //     ' ' +
    //     reminder.title +
    //     '   this is time zone  ' +
    //     reminder.reminderId.toString());

     await _notification.createNotification(
      content: NotificationContent(
        id: reminder.reminderId,
        channelKey: AppointmentChannel.reminder,
        groupKey: reminder.reminderId.toString(),
        title: reminder.title,
        body: reminder.note,
        category: NotificationCategory.Alarm,
        wakeUpScreen: true,
        autoDismissible: false,
        criticalAlert: true,
        locked: true,
        backgroundColor: ColorPallet.kCardBackground,
        payload: {"data": reminder.toRawJson()},
        summary: "reminder/event_local",
      ),
      schedule: NotificationCalendar(
        hour: reminder.allDay ? 8 : time.hour,
        minute: reminder.allDay ? 0 : time.minute,
        day: time.day,
        month: time.month,
        year: time.year,
        timeZone: await AwesomeNotifications.localTimeZoneIdentifier,
        repeats: false,
      ),
    );
  }
}
