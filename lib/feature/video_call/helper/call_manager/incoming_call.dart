part of 'call_manager.dart';

class IncomingCall {
  final StreamController<CallNotification> _controller =
      StreamController<CallNotification>.broadcast();

  Future<File> _file() async {
    Directory dir = await getApplicationSupportDirectory();
    File _file = File("${dir.path}/incoming.txt");

    if (_file.existsSync()) {
      return _file;
    }
    return await _file.create();
  }

  Future<File> save(CallNotification call) async {
    File _active = await _file();
    return await _active.writeAsString(call.toRawJson(), mode: FileMode.write);
  }

  Future<CallNotification> read() async {
    try {
      File _active = await _file();
      String callString = await _active.readAsString();
      return CallNotification.fromRawJson(callString);
    } catch (e) {
      return CallNotification();
    }
  }

  Future<void> clear() async {
    try {
      await save(CallNotification());
      return;
    } catch (e) {
      return;
    }
  }

  bool _shouldNotify(FileSystemEvent event) {
    switch (event.type) {
      case FileSystemEvent.create:
        return true;
      case FileSystemEvent.modify:
        return true;
      case FileSystemEvent.delete:
        return true;
      default:
        return false;
    }
  }

  Stream<CallNotification> get incoming {
    _file().then((active) {
      active.watch().listen((event) {
        if (_shouldNotify(event)) {
          _controller.sink.add(
            CallNotification.fromRawJson(File(event.path).readAsStringSync()),
          );
        }
      });
    });

    return _controller.stream;
  }
}
