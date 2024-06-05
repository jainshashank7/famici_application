part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class PlayAudio extends AudioPlayerEvent {
  @override
  String toString() => 'Play synced audio track';
}

class SeekAudioTrack extends AudioPlayerEvent {
  final double value;

  const SeekAudioTrack({required this.value});
  @override
  List<Object> get props => [value];
  @override
  String toString() => 'seek audio track';
}

class TogglePlayPauseAudio extends AudioPlayerEvent {
  @override
  String toString() => 'Play Pause toggle audio';
}

class SyncAudio extends AudioPlayerEvent {
  final MediaItem audio;

  const SyncAudio(this.audio);

  @override
  String toString() => 'Sync audio to play';
}

class SyncAndPlayAudio extends AudioPlayerEvent {
  final MediaItem audio;
  final bool isVoice;
  const SyncAndPlayAudio(
    this.audio, {
    this.isVoice = false,
  });

  @override
  String toString() => 'Sync audio to play';
}

class PlayNext extends AudioPlayerEvent {
  @override
  String toString() => 'Play to next';
}

class PlayPrevious extends AudioPlayerEvent {
  @override
  String toString() => 'Play previous';
}

class ListenToPlaybackState extends AudioPlayerEvent {
  final PlaybackState state;

  const ListenToPlaybackState(this.state);
  @override
  String toString() => 'Listen to playback state';
}

class ListenToDuration extends AudioPlayerEvent {
  final Duration? duration;

  const ListenToDuration(this.duration);
  @override
  String toString() => 'Play next video';
}

class ListenToPosition extends AudioPlayerEvent {
  final Duration? position;

  const ListenToPosition(this.position);
  @override
  String toString() => 'Play next video';
}

class ListenToVolumeChange extends AudioPlayerEvent {
  final double? volume;

  const ListenToVolumeChange(this.volume);
  @override
  String toString() => 'Play next video';
}

class ListenToIndex extends AudioPlayerEvent {
  final int? index;

  const ListenToIndex(this.index);
  @override
  String toString() => 'Play next video';
}

class ListenToPlayStream extends AudioPlayerEvent {
  final bool? isPlaying;

  const ListenToPlayStream(this.isPlaying);
  @override
  String toString() => 'Play next video';
}
