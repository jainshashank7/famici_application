import 'package:famici/feature/video_call/entities/call_notification.dart';

abstract class ICallService {
  Stream<CallNotification> receiveIncoming();

  Stream<CallNotification> receiveActiveCallStatus(String callId);

  Future<CallNotification> addCall(CallNotification call);

  Future<CallNotification> removeCall(CallNotification call);
}
