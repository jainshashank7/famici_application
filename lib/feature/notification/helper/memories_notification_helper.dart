import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';

import '../../../utils/config/color_pallet.dart';
import '../../video_call/helper/call_manager/call_manager.dart';
import '../entities/notification.dart';

class MemoriesChannel {
  static const String receiver = 'memories_notification_channel';
}

class MemoriesNotificationHelper {
  static final AwesomeNotifications _notification = AwesomeNotifications();
  static Future<void> notify(Notification notification) async {
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: MemoriesChannel.receiver,
        groupKey: notification.notificationId,
        title: "Memories shared",
        body: notification.title,
        category: NotificationCategory.Social,
        largeIcon: notification.senderPicture.isNotEmpty
            ? notification.senderPicture
            : 'asset://assets/icons/user_avatar.png',
        wakeUpScreen: true,
        autoDismissible: true,
        backgroundColor: ColorPallet.kCardBackground,
      ),
    );
  }

  static Future<void> syncMemoriesNotification(RemoteMessage message) async {
    String _me = await LoggedUser().read();
    Notification notification = Notification.fromRawJson(
      message.data['data'],
    );

    if (_me != notification.senderContactId) {
      await _notification.createNotification(
        content: NotificationContent(
          id: DateTime.now().second,
          channelKey: MemoriesChannel.receiver,
          groupKey: notification.notificationId,
          title: "Memories shared",
          body: notification.title,
          category: NotificationCategory.Social,
          largeIcon: notification.senderPicture.isNotEmpty
              ? notification.senderPicture
              : 'asset://assets/icons/user_avatar.png',
          wakeUpScreen: true,
          autoDismissible: true,
          backgroundColor: ColorPallet.kCardBackground,
          payload: {"data": notification.toRawJson()},
        ),
      );
    }
  }
  static Future<void> receiveDisplayedAction(
      ReceivedNotification action,
      ) async {
    try{
      Notification _notification = Notification.fromRawJson(
        action.payload!['data'],
      );
      final NotificationBloc notificationBloc= BlocProvider.of(fcRouter.navigatorKey.currentContext!);
      notificationBloc.add(SyncMemoryNotificationEvent(_notification));
    }catch(e){
      DebugLogger.error(e);
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
        MemoriesChannel.receiver,
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
}
