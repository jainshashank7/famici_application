part of 'audio_player_bloc.dart';

class AudioPlayerState {
  AudioPlayerState({
    required this.isReady,
    required this.isPlaying,
    required this.isSuffling,
    required this.loopMode,
    required this.volume,
    required this.isBuffering,
    required this.duration,
    required this.position,
    required this.currentIndex,
    required this.isVideoInitialized,
    required this.isFullScreen,
    required this.didExitFullScreen,
  });

  bool isReady;
  bool isPlaying;
  bool isSuffling;
  LoopMode loopMode;
  double volume;
  bool isBuffering;
  double duration;
  double position;
  int currentIndex;
  bool isVideoInitialized;
  bool isFullScreen;
  bool didExitFullScreen;

  factory AudioPlayerState.initial() {
    return AudioPlayerState(
      isReady: false,
      isPlaying: false,
      isSuffling: false,
      loopMode: LoopMode.off,
      volume: 0,
      isBuffering: false,
      position: 0,
      duration: 0,
      currentIndex: -1,
      isVideoInitialized: false,
      isFullScreen: false,
      didExitFullScreen: false,
    );
  }

  AudioPlayerState copyWith({
    bool? isReady,
    bool? isPlaying,
    bool? isSuffling,
    LoopMode? loopMode,
    double? volume,
    bool? isBuffering,
    double? duration,
    double? position,
    int? currentIndex,
    bool? isVideoInitialized,
    bool? isFullScreen,
    bool? didExitFullScreen,
  }) {
    return AudioPlayerState(
      isReady: isReady ?? this.isReady,
      isPlaying: isPlaying ?? this.isPlaying,
      isSuffling: isSuffling ?? this.isSuffling,
      loopMode: loopMode ?? this.loopMode,
      volume: volume ?? this.volume,
      isBuffering: isBuffering ?? this.isBuffering,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      currentIndex: currentIndex ?? this.currentIndex,
      isVideoInitialized: isVideoInitialized ?? this.isVideoInitialized,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      didExitFullScreen: didExitFullScreen ?? this.didExitFullScreen,
    );
  }
}
