import 'package:famici/feature/video_call/entities/call_notification.dart';

import 'call_service_interface.dart';

class CallService implements ICallService {
  @override
  Stream<CallNotification> receiveActiveCallStatus(String callId) {
    // TODO: implement receiveActiveCallStatus
    throw UnimplementedError();
  }

  @override
  Stream<CallNotification> receiveIncoming() {
    // TODO: implement receiveIncoming
    throw UnimplementedError();
  }

  _startReceivingIncoming() {}

  _startReceivingActiveCallUpdates(String callId) {}

  @override
  Future<CallNotification> addCall(CallNotification call) {
    throw UnimplementedError();
  }

  @override
  Future<CallNotification> removeCall(CallNotification call) {
    throw UnimplementedError();
  }
}
