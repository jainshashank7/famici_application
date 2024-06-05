import 'dart:async';

import 'package:famici/feature/video_call/entities/call_notification.dart';
import 'package:famici/feature/video_call/helper/background_state.dart';

import 'call_manager/call_manager.dart';

class _CallKeep {
  static final _CallKeep _singleton = _CallKeep._internal();
  factory _CallKeep() {
    return _singleton;
  }
  _CallKeep._internal() {
    _incomingRepo.incoming.listen(_handleIncoming);
    _activeRepo.active.listen(_handleActive);
  }

  final StreamController<CallNotification> _incomingController =
      StreamController<CallNotification>.broadcast();

  final ActiveCall _activeRepo = ActiveCall();
  final IncomingCall _incomingRepo = IncomingCall();
  final CallLog _callLog = CallLog();
  final BackGroundState _backGroundState = BackGroundState();

  Future<bool> isInBackground() async {
    return await _backGroundState.read();
  }

  CallNotification _active = CallNotification();

  CallNotification _incoming = CallNotification();

  _createIncoming(CallNotification call) async {
    if (_incoming.id.isEmpty) {
      await _incomingRepo.save(call);
    }
  }

  syncIncoming(CallNotification call) async {
    if (call.isRinging) {
      await _createIncoming(call);
    } else if (call.isMissed) {
      await _handleMissed(call);
    }
  }

  clearIncoming() async {
    CallNotification _call = await _incomingRepo.read();
    if (_call.id.isNotEmpty) {
      _incoming = CallNotification();
      _incomingRepo.clear();
    }
  }

  answer() {
    if (_active.id.isEmpty) {
      _active = _incoming.copyWith();
      _activeRepo.save(_active);
      _incomingRepo.clear();
      _incoming = CallNotification();
    }
  }

  _handleMissed(CallNotification call) {
    if (_incoming.id.isNotEmpty) {
      _incomingController.add(call);
      _incoming = CallNotification();

      Future.delayed(Duration(seconds: 1), () {
        _incomingRepo.clear();
      });
    }
  }

  decline() {
    if (_incoming.id.isNotEmpty) {
      _incomingRepo.clear();
      _incoming = CallNotification();
    }
  }

  endActive() {
    if (_active.id.isNotEmpty) {
      _activeRepo.clear();
      _active = CallNotification();
    }
  }

  Stream<CallNotification> get incomingStream => _incomingController.stream;

  _handleIncoming(CallNotification event) async {
    if (event.id.isNotEmpty &&
        (_incoming.id.isEmpty || _incoming.id == event.id) &&
        _active.id != event.id) {
      _incoming = event.copyWith();
      _incomingController.add(event);
    } else {
      _incoming = CallNotification();
      _incomingController.add(_incoming);
    }
  }

  _handleActive(CallNotification event) async {
    if (event.id.isNotEmpty) {
      _incomingController.add(_incoming);
      _active = event.copyWith();
    } else {
      _active = CallNotification();
    }
  }

  CallNotification get active => _active;

  Future<CallNotification> readIncomingCall() async {
    CallNotification _call = await _incomingRepo.read();
    _incoming = _call;
    return _incoming;
  }

  Future<CallNotification> readActiveCall() async {
    CallNotification _call = await _activeRepo.read();
    _active = _call;
    return _active;
  }

  CallNotification get incoming => _incoming;

  setBackground() async {
    _backGroundState.setBackground();
  }

  setForeground() async {
    _backGroundState.setForeground();
  }
}

//global export

final _CallKeep callKeep = _CallKeep();
