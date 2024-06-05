import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:famici/core/local_database/local_db.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/chat/helpers/message_archive.dart';

import '../../../core/enitity/user.dart';
import '../../../utils/config/color_pallet.dart';
import '../../video_call/helper/call_manager/call_manager.dart';
import '../entities/message.dart';
import '../repository/local_user_service/local_user_service.dart';

class MessageChannel {
  static const String receiver = 'message_notification_channel';
}

class MessageNotificationHelper {
  static final AwesomeNotifications _notification = AwesomeNotifications();
  static final MessageArchive _archive = MessageArchive();
  static final LoggedUser _meId = LoggedUser();

  static Future<void> syncReceivedMessage(RemoteMessage message) async {
    Message _received = Message.fromRawJson(message.data['data']);

    // print(message.data);

    await LocalDatabaseFactory.createDatabase();
    LocalUserService _userService = LocalUserService();

    User? _sentBy = await _userService.getUser(_received.sentBy);
    Message _withUser = _received.copyWith(userSentBy: _sentBy);
    String me = await _meId.read();

    if (!_withUser.isReceipt &&
        !_withUser.isCallReceipt &&
        _withUser.type != MessageType.unknown &&
        !_withUser.isUploadReceipt &&
        me != _withUser.sentBy) {
      await _archive.save(_withUser);
      await notifyReceivedMessage(_withUser);
    } else {
      await _archive.save(_withUser);
    }
  }

  static Future<void> receiveMessageAction(ReceivedAction action) async {
    fcRouter.navigate(MultipleChatUserRoute());

    // Message _message = Message.fromJson(action.payload!);

    // if (fcRouter.current.name == ChatRoute.name &&
    //     fcRouter.current.name != VideoCallRoute.name) {
    //
    //   fcRouter.replace(ChatRoute(
    //     //contact: _message.userSentBy,
    //     shouldOpenSession: true,
    //   ));
    // } else if (fcRouter.current.name != VideoCallRoute.name) {
    //   fcRouter.navigate(ChatRoute(
    //     //contact: _message.userSentBy,
    //     shouldOpenSession: true,
    //   ));
    // }
  }

  static Future<void> notifyReceivedMessage(Message message) async {
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: MessageChannel.receiver,
        groupKey: message.conversationId,
        title: 'New message from ${message.senderName}',
        body: message.isText ? message.text : '🖼️',
        category: NotificationCategory.Message,
        largeIcon: message.senderPicture.isNotEmpty
            ? message.userSentBy.profileUrl
            : 'asset://assets/icons/user_avatar.png',
        payload: message.toJson(),
        wakeUpScreen: true,
        backgroundColor: ColorPallet.kCardBackground,
      ),
    );
  }

  static Future<void> clearNotification(String conversationId) async {
    await _notification.dismissNotificationsByGroupKey(conversationId);
  }
}
