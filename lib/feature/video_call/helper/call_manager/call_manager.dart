import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:famici/feature/video_call/helper/callkeep.dart';

import '../../../../core/enitity/barrel.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../entities/call_notification.dart';

part 'active_call.dart';

part 'call_log.dart';

part 'call_notify.dart';

part 'incoming_call.dart';

part 'logged_user.dart';

class CallNotifyManager {
  static final ActiveCall _activeRepo = ActiveCall();
  static final IncomingCall _incomingRepo = IncomingCall();
  static final CallLog _callLogRepo = CallLog();

  static Future<void> syncIncomingCall(
    RemoteMessage message,
  ) async {
    CallNotification call = CallNotification.fromJson(message.data);
    bool isCall = call.type == 'call-notification';

    if (isCall) {
      CallNotification _ringingCall = await _incomingRepo.read();
    }
  }

  static Future<void> startCallRinging(
    CallNotification call, {
    bool canRing = true,
  }) async {
    CallNotification _activeCall = await _activeRepo.read();
    bool canAnswer = _activeCall.id.isEmpty;

    if (canRing) {
      await _incomingRepo.save(call);
      await CallNotify.notifyIncomingCall(call, canAnswer: canAnswer);

      //timeout call
      Duration timeOut = Duration(minutes: 1, seconds: 30) -
          (DateTime.now().difference(call.createdAt));

      if (timeOut > Duration.zero) {
        Future.delayed(timeOut, () async {
          CallNotification _incoming = await _incomingRepo.read();
          if (_incoming.id == call.id) {}
        });
      }

      //end timeout method
      return;
    }
  }

  static Future<void> clearIncomingCall(
    CallNotification call,
  ) async {
    CallNotification _ringingCall = await _incomingRepo.read();

    bool shouldNotifyMissed = call.isMissed;

    if (shouldNotifyMissed) {
      bool isRingingCall = _ringingCall.id == call.id;
      bool canShowMissed = _ringingCall.id.isEmpty;
      if (isRingingCall) {
        await CallNotify.dismissIncomingCallNotification();
        await CallNotify.notifyMissedCall(_ringingCall);
      } else if (canShowMissed) {
        await CallNotify.dismissIncomingCallNotification();
        CallNotification _call = await _callLogRepo.findById(call.id);
        await CallNotify.notifyMissedCall(_call);
      }
      await callKeep.clearIncoming();
    } else {
      await CallNotify.dismissIncomingCallNotification();
    }
  }

  static Future<void> clearActiveCall(
    CallNotification call,
  ) async {
    CallNotification _activeCall = await _activeRepo.read();

    if (_activeCall.id.isNotEmpty && _activeCall.id == call.id) {
      if (call.isCompleted) {
        _activeRepo.clear();
      }
    }
  }

  static Future<void> declineIncoming(Map<String, dynamic>? payload) async {
    try {
      CallNotification call = CallNotification.fromJson(
        payload ?? {},
      );
      await callKeep.clearIncoming();
    } catch (err) {}
  }

  static Future<void> answerIncoming(Map<String, dynamic>? payload) async {
    try {
      await callKeep.clearIncoming();
      CallNotification call = CallNotification.fromJson(
        payload ?? {},
      );
      await _activeRepo.save(call);
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
