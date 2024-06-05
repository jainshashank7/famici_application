part of 'call_manager.dart';

class CallLog {
  Future<File> _logFile() async {
    Directory dir = await getApplicationSupportDirectory();
    File _file = File("${dir.path}/call_log.txt");
    if (_file.existsSync()) {
      return _file;
    }
    return await _file.create()
      ..writeAsString(jsonEncode({}));
  }

  Future<Map<String, dynamic>> callHistory() async {
    String _logString = await (await _logFile()).readAsString();

    if (_logString.isEmpty) {
      return {};
    }

    Map<String, dynamic> _logs = jsonDecode(_logString);

    return _logs;
  }

  Future<void> save(CallNotification call) async {
    File _allLogFile = await _logFile();

    Map<String, dynamic> _logs = await callHistory();
    _logs[call.id] = call.toRawJson();

    await _allLogFile.writeAsString(jsonEncode(_logs));
    return;
  }

  Future<CallNotification> findById(String id) async {
    Map<String, dynamic> _log = await callHistory();
    if (_log[id] == null) {
      return CallNotification();
    } else if (_log[id]!.isEmpty) {
      return CallNotification();
    }
    return CallNotification.fromRawJson(_log[id]!);
  }

  Future<void> delete(String id) async {
    File _allLogFile = await _logFile();

    Map<String, dynamic> _logs = await callHistory();
    _logs.remove(id);

    await _allLogFile.writeAsString(jsonEncode(_logs));
    return;
  }
}
