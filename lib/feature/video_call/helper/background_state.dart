import 'dart:convert';
import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:path_provider/path_provider.dart';

class BackGroundState {
  Future<File> _file() async {
    Directory dir = await getApplicationSupportDirectory();
    try {
      File _file = File("${dir.path}/bg_state.txt");

      if (_file.existsSync()) {
        return _file;
      }
      return await _file.create();
    } catch (err) {
      DebugLogger.error(err);
      return File("${dir.path}/bg_state.txt");
    }
  }

  setBackground() async {
    try {
      File _active = await _file();
      return await _active.writeAsString(jsonEncode({"state": true}),
          mode: FileMode.write);
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  setForeground() async {
    try {
      File _active = await _file();
      return await _active.writeAsString(jsonEncode({"state": false}),
          mode: FileMode.write);
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  read() async {
    try {
      File _active = await _file();
      return jsonDecode(await _active.readAsString())['state'] ?? false;
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
