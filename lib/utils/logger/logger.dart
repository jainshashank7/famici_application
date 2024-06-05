import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static log(dynamic message) {
    if (kDebugMode) {
      print('''Logger :$message''');
    }
  }

  static debug(dynamic message) {
    if (kDebugMode) {
      DebugLogger.debug(message);
    }
  }

  static info(dynamic message) {
    if (kDebugMode) {
      DebugLogger.info(message);
    }
  }

  static warning(dynamic message) {
    if (kDebugMode) {
      DebugLogger.warning(message);
    }
  }

  static error(dynamic message) {
    if (kDebugMode) {
      DebugLogger.error(message);
    }
  }
}
