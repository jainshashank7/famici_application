import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:famici/utils/barrel.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  List<MediaItem> mediaQueue = [];
  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  get instance => _player;

  AudioSource _getSourceUrl(MediaItem item) {
    StorageType resourceType = storageType(item.extras?[CollectionKey.url]);
    if (resourceType == StorageType.local) {
      return AudioSource.uri(Uri.file(item.extras?[CollectionKey.url]));
    } else if (resourceType == StorageType.network) {
      return AudioSource.uri(Uri.parse(item.extras?[CollectionKey.url]));
    } else if (resourceType == StorageType.asset) {
      return AudioSource.uri(Uri.parse(item.extras?[CollectionKey.url]));
    }

    return AudioSource.uri(Uri.parse('error sound'));
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    mediaQueue = [mediaItem];
    await _player.setAudioSource(_getSourceUrl(mediaItem));
    play();
  }

  @override
  Future<void> addQueueItems(List<MediaItem> playlist) async {
    mediaQueue = playlist;
    _player.setAudioSource(ConcatenatingAudioSource(
      children: playlist.map((item) => _getSourceUrl(item)).toList(),
    ));
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    mediaQueue.add(mediaItem);
    _player.setAudioSource(
      ConcatenatingAudioSource(
        children: mediaQueue.map((item) => _getSourceUrl(item)).toList(),
      ),
      initialIndex: _player.currentIndex ?? 0,
      initialPosition: _player.position,
    );
  }

  @override
  Future<void> updateMediaItem(MediaItem audio) async => mediaItem.add(audio);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    _player.stop();
    _player.seek(Duration.zero);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    if (mediaQueue.isNotEmpty && (event.currentIndex ?? -1) > -1) {
      mediaQueue[event.currentIndex ?? 0] =
          mediaQueue[event.currentIndex ?? 0].copyWith(
        duration: Duration(seconds: _player.duration?.inSeconds ?? 0),
      );
      updateMediaItem(mediaQueue[event.currentIndex ?? 0]);
    }
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}

class AudioServiceHandler {
  static final AudioServiceHandler _instance = AudioServiceHandler._internal();

  factory AudioServiceHandler() {
    return _instance;
  }

  AudioServiceHandler._internal();

  static final AudioPlayerHandler _player = AudioPlayerHandler();
  static late AudioHandler handler;
  static bool isInitialized = false;

  static Future<bool> initialize() async {
    if (!isInitialized) {
      handler = await AudioService.init(
        builder: () => _player,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
          androidNotificationChannelName: 'FC Audio Player',
          androidNotificationOngoing: true,
          // androidNotificationIcon: 'mipmap/launcher_icon',
          // androidShowNotificationBadge: true,
          // androidNotificationChannelDescription: "FC Audio Player",
        ),
      );
    }
    isInitialized = true;
    return isInitialized;
  }

  static AudioPlayer get player => _player.instance;

  static AudioPlayer newPlayer() {
    return AudioPlayer();
  }
}
