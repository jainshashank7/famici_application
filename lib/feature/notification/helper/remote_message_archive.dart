import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';

class RemoteMessageArchive {
  Future<File> _logFile() async {
    Directory dir = await getApplicationSupportDirectory();
    File _file = File("${dir.path}/notification_archive.txt");
    if (_file.existsSync()) {
      return _file;
    }
    return await _file.create();
  }

  Future<Map<String, dynamic>> _messageArchive() async {
    String _logString = await (await _logFile()).readAsString();

    if (_logString.isEmpty) {
      return {};
    }

    Map<String, dynamic> _logs = jsonDecode(_logString);

    return _logs;
  }

  Future<void> save(RemoteMessage msg) async {
    if (msg.messageId == null) {
      return;
    }
    File _allLogFile = await _logFile();
    try {
      Map<String, dynamic> _logs = await _messageArchive();
      _logs[msg.messageId!] = msg.toMap();

      await _allLogFile.writeAsString(jsonEncode(_logs));
      return;
    } catch (err) {
      Map<String, dynamic> _logs = {};

      await _allLogFile.writeAsString(jsonEncode(_logs));
    }
  }

  Future<RemoteMessage> findById(String id) async {
    Map<String, dynamic> _log = await _messageArchive();
    if (_log[id] == null) {
      return RemoteMessage();
    } else if (_log[id]!.isEmpty) {
      return RemoteMessage();
    }
    return RemoteMessage.fromMap(_log[id]!);
  }

  Future<void> delete(String id) async {
    File _allLogFile = await _logFile();

    Map<String, dynamic> _logs = await _messageArchive();
    _logs.remove(id);

    await _allLogFile.writeAsString(jsonEncode(_logs));
    return;
  }

  Future<Map<String, dynamic>> findAll() async {
    Map<String, dynamic> _log = await _messageArchive();
    return _log;
  }
}
