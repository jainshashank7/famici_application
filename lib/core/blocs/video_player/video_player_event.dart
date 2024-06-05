part of 'video_player_bloc.dart';

abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();
}

class SyncVideoToPlayer extends VideoPlayerEvent {
  const SyncVideoToPlayer(
    this.videoUrl, {
    bool? autoPlay,
  }) : autoPlay = autoPlay ?? false;

  final String videoUrl;
  final bool autoPlay;

  @override
  List<Object?> get props => [videoUrl];

  @override
  String toString() {
    return ''' 
     SyncingVideoToPlayer : $videoUrl
     ''';
  }
}

class PlayVideo extends VideoPlayerEvent {
  @override
  List<Object?> get props => [];
}

class PauseVideo extends VideoPlayerEvent {
  @override
  List<Object?> get props => [];
}

class StopVideo extends VideoPlayerEvent {
  @override
  List<Object?> get props => [];
}

class SeekVideoTo extends VideoPlayerEvent {
  final Duration position;

  const SeekVideoTo(this.position);
  @override
  List<Object?> get props => [position];
}

class UpdatePlayerValues extends VideoPlayerEvent {
  final VideoPlayerValue? values;

  const UpdatePlayerValues(this.values);
  @override
  List<Object?> get props => [values];
}

class SyncAndPlayVideo extends VideoPlayerEvent {
  const SyncAndPlayVideo(this.videoUrl);

  final String videoUrl;

  @override
  List<Object?> get props => [videoUrl];

  @override
  String toString() {
    return ''' 
     Syncing and play : $videoUrl
     ''';
  }
}
