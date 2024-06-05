import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:famici/utils/constants/constants.dart';
import 'package:famici/utils/helpers/audio_player_handler.dart';
import 'package:video_player/video_player.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  AudioPlayerBloc({
    bool enableBackgroundPlay = false,
  })  : _enableBackgroundPlay = enableBackgroundPlay,
        _audioPlayer = enableBackgroundPlay
            ? AudioServiceHandler.player
            : AudioServiceHandler.newPlayer(),
        _audioHandler = AudioServiceHandler.handler,
        super(AudioPlayerState.initial()) {
    on<SyncAudio>(_onSyncSongToState);
    on<SyncAndPlayAudio>(_onSyncAndPlayAudio);
    on<SeekAudioTrack>(_onSeekSongEventToState);
    on<TogglePlayPauseAudio>(_onTogglePlayPauseSongToState);
    on<ListenToPlaybackState>(_onListenToPlaybackState);
    on<ListenToPosition>(_onPositionChange);
    on<ListenToDuration>(_onDurationStream);
    on<ListenToVolumeChange>(_onVolumeChange);
    on<ListenToIndex>(_onIndexChange);
    on<ListenToPlayStream>(_onPlayStream);
    initializeListeners();
  }

  //audio bloc
  final AudioHandler _audioHandler;
  late StreamSubscription _playerState;
  final AudioPlayer _audioPlayer;
  late StreamSubscription _durationStream;
  late StreamSubscription _positionStream;
  late StreamSubscription _volumeStream;
  late StreamSubscription _indexStream;
  late StreamSubscription _playStream;
  final bool _enableBackgroundPlay;
  bool isInitialized = false;

  AudioSession? audioSession;
  StreamSubscription? _audioSessionStream;

  @override
  Future<void> close() {
    _playerState.cancel();
    _audioPlayer.dispose();
    _durationStream.cancel();
    _positionStream.cancel();
    _volumeStream.cancel();
    _indexStream.cancel();
    _playStream.cancel();
    return super.close();
  }

  Future<bool> initializeListeners() async {
    if (_enableBackgroundPlay) {
      _playerState = _audioHandler.playbackState
          .listen((state) => add(ListenToPlaybackState(state)));
    } else {
      _playerState = _audioPlayer.playerStateStream.listen((event) {
        PlaybackState _state = PlaybackState(
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[event.processingState]!,
          playing: event.playing,
        );
        add(ListenToPlaybackState(_state));
      });
    }

    _durationStream = _audioPlayer.durationStream
        .listen((duration) => add(ListenToDuration(duration)));
    _positionStream = _audioPlayer.positionStream
        .listen((position) => add(ListenToPosition(position)));
    _volumeStream = _audioPlayer.volumeStream
        .listen((volume) => add(ListenToVolumeChange(volume)));
    _indexStream = _audioPlayer.currentIndexStream
        .listen((index) => add(ListenToIndex(index)));
    _playStream = _audioPlayer.playingStream
        .listen((isPlaying) => add(ListenToPlayStream(isPlaying)));

    isInitialized = true;
    return isInitialized;
  }

  void _onListenToPlaybackState(ListenToPlaybackState event, emit) {
    PlaybackState playerState = event.state;
    AudioProcessingState process = playerState.processingState;
    bool isPlaying = playerState.playing &&
        !(process == AudioProcessingState.completed) &&
        !(process == AudioProcessingState.idle);
    emit(state.copyWith(
      isPlaying: isPlaying,
      isReady: process == AudioProcessingState.ready,
      isBuffering: process == AudioProcessingState.buffering,
    ));
  }

  void _onPositionChange(ListenToPosition event, emit) {
    emit(state.copyWith(position: event.position?.inSeconds.toDouble()));
  }

  void _onDurationStream(ListenToDuration event, emit) {
    emit(state.copyWith(duration: event.duration?.inSeconds.toDouble()));
  }

  void _onVolumeChange(ListenToVolumeChange event, emit) {
    emit(state.copyWith(volume: event.volume));
  }

  void _onIndexChange(ListenToIndex event, emit) {
    emit(state.copyWith(currentIndex: event.index ?? -1));
  }

  void _onPlayStream(ListenToPlayStream event, emit) {
    emit(state.copyWith(isPlaying: event.isPlaying ?? false));
  }

  //controls

  void _onSyncAndPlayAudio(SyncAndPlayAudio event, emit) async {
    audioSession ??= await AudioSession.instance;
    if (event.isVoice) {
      await audioSession?.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.videoChat,
      ));
      _audioPlayer.setVolume(0.1);
    } else {
      await audioSession?.configure(AudioSessionConfiguration.music());
    }

    _audioSessionStream ??=
        audioSession?.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Another app started playing audio and we should duck.
            _audioPlayer.pause();
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            // Another app started playing audio and we should pause.
            _audioPlayer.pause();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // The interruption ended and we should unduck.

            break;
          case AudioInterruptionType.pause:
          // The interruption ended and we should resume.
          case AudioInterruptionType.unknown:
            // The interruption ended but we should not resume.
            break;
        }
      }
    });

    // Activate the audio session before playing audio.
    if (await audioSession!.setActive(true)) {
      if (_enableBackgroundPlay) {
        await _audioHandler.playMediaItem(event.audio);
      } else {
        if (event.isVoice) {
          await _audioPlayer.setAsset(event.audio.extras?[CollectionKey.url]);
          _audioPlayer.setLoopMode(LoopMode.one);
        } else {
          await _audioPlayer.setAudioSource(
            AudioSource.uri(
              Uri.parse(event.audio.extras?[CollectionKey.url]),
            ),
          );
        }

        await _audioPlayer.play();
      }
    } else {
      // The request was denied and the app should not play audio
    }

    // emit(state.copyWith(isPlaying: true));
  }

  Future<void> _onSyncSongToState(SyncAudio event, emit) async {
    if (_enableBackgroundPlay) {
      List<MediaItem> queue = _audioHandler.queue.value;
      queue.add(event.audio);
      await _audioHandler.addQueueItems(queue);
    } else {
      List<AudioSource> _queue = _audioPlayer.sequence ?? [];
      final position = _audioPlayer.position;
      _queue.add(
          AudioSource.uri(Uri.parse(event.audio.extras?[CollectionKey.url])));
      ConcatenatingAudioSource newS = ConcatenatingAudioSource(
        children: _queue,
      );
      _audioPlayer.setAudioSource(newS, initialPosition: position);
      if (_audioPlayer.playing) {
        await _audioPlayer.play();
      }
    }
  }

  Future<void> _onSeekSongEventToState(
    SeekAudioTrack event,
    emit,
  ) async {
    _audioPlayer.seek(
      Duration(seconds: event.value.toInt()),
      index: state.currentIndex,
    );
  }

  void _onTogglePlayPauseSongToState(TogglePlayPauseAudio event, emit) async {
    bool _isPlaying = state.isPlaying;
    bool _hasAudioToPlay = state.currentIndex > -1;
    if (_hasAudioToPlay) {
      if (_isPlaying) {
        if (_enableBackgroundPlay) {
          _audioHandler.pause();
        } else {
          _audioPlayer.pause();
        }
      } else {
        if (_enableBackgroundPlay) {
          _audioHandler.play();
        } else {
          if (_audioPlayer.position.inSeconds ==
              _audioPlayer.duration?.inSeconds) {
            _audioPlayer.seek(Duration(seconds: 0));
          }
          _audioPlayer.play();
        }
      }
    }
  }

  Future<void> forceStop() async {
    try {
      await _audioHandler.stop();
      await _audioPlayer.stop();
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
