part of 'call_manager.dart';

class LoggedUser {
  Future<File> _file() async {
    Directory dir = await getApplicationSupportDirectory();
    File _file = File("${dir.path}/me.txt");
    if (_file.existsSync()) {
      return _file;
    }
    return await _file.create();
  }

  Future<File> save(String me) async {
    File _savedMe = await _file();
    await _savedMe.delete();
    await _savedMe.create();
    return await _savedMe.writeAsString(me, mode: FileMode.write);
  }

  Future<String> read() async {
    try {
      File _savedMe = await _file();
      return _savedMe.readAsString();
    } catch (e) {
      return '';
    }
  }

  Future<void> clear() async {
    try {
      await save('');
      return;
    } catch (e) {
      return;
    }
  }
}
