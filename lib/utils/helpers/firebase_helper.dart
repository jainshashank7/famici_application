import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:famici/feature/chat/helpers/message_notification_helper.dart';
import 'package:famici/feature/notification/helper/activity_reminder_notification_helper.dart';
import 'package:famici/feature/notification/helper/appointment_notification_helper.dart';
import 'package:famici/feature/notification/helper/dashboard_builder_notification_helper.dart';
import 'package:famici/feature/notification/helper/medication_notify_helper.dart';
import 'package:famici/feature/notification/helper/memories_notification_helper.dart';
import 'package:famici/feature/video_call/helper/callkeep.dart';
import 'package:famici/utils/barrel.dart';

import '../../feature/video_call/helper/call_manager/call_manager.dart';
import '../../firebase_options.dart';

class FirebaseHelper {
  static Future<void> initializeFirebasePlugins() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isAndroid) PathProviderAndroid.registerWith();

  print("got the data");

  if (message.data['type'] == NotificationType.call) {
    CallNotifyManager.syncIncomingCall(message);
  } else if (message.data['type'] == NotificationType.message) {
    MessageNotificationHelper.syncReceivedMessage(message);
  } else if (isMedication(message.data['type'])) {
    MedicationNotificationHelper.syncMedicationNotification(message);
  } else if (isAppointments(message.data['type'])) {
    AppointmentsNotificationHelper.syncAppointmentNotification(message);
  } else if (message.data['type'] == NotificationType.shareMemories) {
    MemoriesNotificationHelper.syncMemoriesNotification(message);
  } else if (isActivityReminder(message.data['type'])) {
    ActivityReminderNotificationHelper.syncActivityReminderNotification(
        message);
  } else if(message.data['type'] == NotificationType.dashboardBuilderUpdated){
    DashboardBuilderNotificationHelper.syncDashboardBuilderNotification(message);
  }
}
