import 'package:audio_service/audio_service.dart';
import 'package:famici/feature/audio_player/bloc/audio_player_bloc.dart';

import '../../../utils/constants/assets_paths.dart';
import '../../../utils/constants/constants.dart';

class CallRinging {
  static final CallRinging _singleton = CallRinging._internal();

  factory CallRinging() {
    return _singleton;
  }

  CallRinging._internal();

  static final AudioPlayerBloc _ringingPlayer = AudioPlayerBloc();

  static Future<void> start() async {
    if (_ringingPlayer.state.isPlaying) {
      await stop();
    }
    _ringingPlayer.add(SyncAndPlayAudio(
      MediaItem(
          id: AudioSoundPath.ringing,
          title: AudioSoundPath.ringing,
          extras: {
            CollectionKey.url: AudioSoundPath.ringing,
          }),
      isVoice: true,
    ));
  }

  static Future<void> stop() async {
    _ringingPlayer.forceStop();
  }
}
