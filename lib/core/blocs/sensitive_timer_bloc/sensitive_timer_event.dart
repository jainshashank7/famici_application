import 'package:flutter/material.dart';

class SensitiveTimerEvent{
  final BuildContext context;
  final int sensitiveScreenTimeOut;
  final int sensitiveAlertTimeOut;
  SensitiveTimerEvent({required this.context, required this.sensitiveScreenTimeOut, required this.sensitiveAlertTimeOut});
}