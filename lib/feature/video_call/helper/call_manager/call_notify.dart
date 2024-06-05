part of 'call_manager.dart';

class CallChannel {
  static const String incoming = 'incoming_call_channel';
  static const String active = 'active_call_channel';
  static const String missed = 'missed_call_channel';
}

enum CallAction {
  decline,
  answer,
  unknown,
}

extension CallActionStringExt on String {
  CallAction toAction() {
    return CallAction.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => CallAction.unknown,
    );
  }
}

class CallNotify {
  static final AwesomeNotifications _notification = AwesomeNotifications();

  static Future<void> receiveIncomingCallAction(
    ReceivedAction receivedAction,
  ) async {
    switch (receivedAction.buttonKeyPressed.toAction()) {
      case CallAction.decline:
        CallNotifyManager.declineIncoming(receivedAction.payload);
        break;
      case CallAction.answer:
        CallNotifyManager.answerIncoming(receivedAction.payload);
        break;
      default:
        DebugLogger.warning(receivedAction.payload);
        break;
    }
  }

  static Future<void> notifyIncomingCall(
    CallNotification call, {
    bool canAnswer = true,
    isBackgroundSwitch = false,
  }) async {
    if (!isBackgroundSwitch && call.isRinging) {
      await Future.delayed(Duration(milliseconds: 300));
    }
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: CallChannel.incoming,
        groupKey: call.id,
        title: 'Incoming Call',
        body: '${call.callerName} is calling...',
        category: NotificationCategory.Call,
        largeIcon: call.callerPhotoUrl.isNotEmpty
            ? call.callerPhotoUrl
            : 'asset://assets/icons/user_avatar.png',
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        locked: true,
        criticalAlert: true,
        backgroundColor: ColorPallet.kCardBackground,
        payload: call.toJson(),
      ),
      actionButtons: [
        NotificationActionButton(
          enabled: canAnswer,
          key: CallAction.answer.name,
          label: CallAction.answer.name.toUpperCase(),
          actionType: ActionType.Default,
          color: canAnswer ? Colors.green : Colors.grey,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: CallAction.decline.name,
          label: CallAction.decline.name.toUpperCase(),
          actionType: ActionType.SilentAction,
          isDangerousOption: true,
          autoDismissible: true,
        )
      ],
    );
  }

  static Future<void> notifyActiveCall(CallNotification call) async {
    ActiveCall().save(call);
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: CallChannel.active,
        groupKey: call.id,
        title: 'Call in progress',
        body: '${call.callerName} is in call',
        category: NotificationCategory.Progress,
        largeIcon: call.callerPhotoUrl.isNotEmpty
            ? call.callerPhotoUrl
            : 'asset://assets/icons/user_avatar.png',
        wakeUpScreen: false,
        fullScreenIntent: false,
        autoDismissible: false,
        locked: true,
        criticalAlert: false,
        backgroundColor: ColorPallet.kCardBackground,
        payload: call.toJson(),
      ),
    );
  }

  static Future<void> notifyMissedCall(CallNotification call) async {
    await _notification.createNotification(
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: CallChannel.missed,
        groupKey: call.id,
        title: 'Missed Call',
        body: 'Missed call from ${call.callerName}',
        category: NotificationCategory.Message,
        largeIcon: call.callerPhotoUrl.isNotEmpty
            ? call.callerPhotoUrl
            : 'asset://assets/icons/user_avatar.png',
        wakeUpScreen: true,
        autoDismissible: true,
        backgroundColor: ColorPallet.kCardBackground,
      ),
    );
  }

  // static Future<void> dismissNotificationById(String id) async {
  //   try {
  //     await _notification.dismissNotificationsByGroupKey(id);
  //   } catch (er) {
  //     log(er.toString());
  //     return;
  //   }
  // }

  static Future<void> dismissActiveCallNotification() async {
    try {
      ActiveCall().clear();
      await _notification.dismissNotificationsByChannelKey(
        CallChannel.active,
      );
    } catch (er) {
      log(er.toString());
      return;
    }
  }

  static Future<void> dismissIncomingCallNotification() async {
    try {
      await _notification.dismissNotificationsByChannelKey(
        CallChannel.incoming,
      );
    } catch (er) {
      log(er.toString());
      return;
    }
  }

  static Future<void> dismissMissedCallNotification() async {
    try {
      await _notification.dismissNotificationsByChannelKey(
        CallChannel.missed,
      );
    } catch (er) {
      log(er.toString());
      return;
    }
  }
}
