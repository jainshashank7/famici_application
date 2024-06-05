import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../entities/message.dart';

class MessageArchive {
  Future<File> _logFile() async {
    Directory dir = await getApplicationSupportDirectory();
    File _file = File("${dir.path}/message_archive.txt");
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

  Future<void> save(Message msg) async {
    File _allLogFile = await _logFile();
    try {
      Map<String, dynamic> _logs = await _messageArchive();
      _logs[msg.messageId] = msg.toRawJson();

      await _allLogFile.writeAsString(jsonEncode(_logs));
      return;
    } catch (err) {
      Map<String, dynamic> _logs = {};

      await _allLogFile.writeAsString(jsonEncode(_logs));
    }
  }

  Future<Message> findById(String id) async {
    Map<String, dynamic> _log = await _messageArchive();
    if (_log[id] == null) {
      return Message();
    } else if (_log[id]!.isEmpty) {
      return Message();
    }
    return Message.fromRawJson(_log[id]!);
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
