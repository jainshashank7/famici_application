part of 'video_player_bloc.dart';

class VideoPlayerState extends Equatable {
  const VideoPlayerState({
    required this.videoPlayer,
    required this.playerValue,
  });

  final VideoPlayerController? videoPlayer;
  final VideoPlayerValue playerValue;

  factory VideoPlayerState.initial() {
    return VideoPlayerState(
      videoPlayer: null,
      playerValue: VideoPlayerValue(duration: Duration(seconds: 0)),
    );
  }

  VideoPlayerState copyWith({
    VideoPlayerController? videoPlayer,
    VideoPlayerValue? playerValue,
  }) {
    return VideoPlayerState(
      videoPlayer: videoPlayer ?? this.videoPlayer,
      playerValue: playerValue ?? this.playerValue,
    );
  }

  @override
  List<Object?> get props => [videoPlayer, playerValue];
}
