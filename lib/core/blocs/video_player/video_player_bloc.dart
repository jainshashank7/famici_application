import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(VideoPlayerState.initial()) {
    on<SyncVideoToPlayer>(_onSyncVideoToPlayer);
    on<PlayVideo>(_onPlayVideo);
    on<PauseVideo>(_onPauseVideo);
    on<UpdatePlayerValues>(_onUpdatePlayerValues);
    on<SyncAndPlayVideo>(_onSyncAndPlayVideo);
    on<SeekVideoTo>(_onSeekTo);
  }

  Future<void> _onSyncVideoToPlayer(SyncVideoToPlayer event, emit) async {
    VideoPlayerController? _existingPlayer = state.videoPlayer;

    await _existingPlayer?.pause();

    VideoPlayerController _newVideoPlayer = VideoPlayerController.network(
      event.videoUrl,
    );
    await _newVideoPlayer.initialize();
    _newVideoPlayer.addListener(() {
      VideoPlayerController? _player = state.videoPlayer;
      if (!isClosed) {
        add(UpdatePlayerValues(_player?.value));
      }
    });
    if (event.autoPlay) {
      await _newVideoPlayer.play();
    }
    emit(state.copyWith(videoPlayer: _newVideoPlayer));
  }

  Future<void> _onSyncAndPlayVideo(SyncAndPlayVideo event, emit) async {
    VideoPlayerController? _existingPlayer = state.videoPlayer;
    bool _isSimilar = _existingPlayer?.dataSource == event.videoUrl;

    if (_isSimilar) {
      _existingPlayer?.play();
      emit(state.copyWith(videoPlayer: _existingPlayer));
    } else {
      if (!isClosed) {
        add(SyncVideoToPlayer(event.videoUrl));
      }
    }
  }

  Future<void> _onPlayVideo(PlayVideo event, emit) async {
    VideoPlayerController? _existingPlayer = state.videoPlayer;
    bool _isInitialized = _existingPlayer?.value.isInitialized ?? false;
    bool _isPlaying = _existingPlayer?.value.isPlaying ?? false;
    if (_isInitialized && !_isPlaying) {
      await _existingPlayer?.play();
    }
    emit(state.copyWith(videoPlayer: _existingPlayer));
  }

  Future<void> _onPauseVideo(PauseVideo event, emit) async {
    VideoPlayerController? _existingPlayer = state.videoPlayer;
    bool _isInitialized = _existingPlayer?.value.isInitialized ?? false;
    bool _isPlaying = _existingPlayer?.value.isPlaying ?? false;

    if (_isInitialized && _isPlaying) {
      await _existingPlayer?.pause();
    }
    emit(state.copyWith(videoPlayer: _existingPlayer));
  }

  Future<void> _onUpdatePlayerValues(UpdatePlayerValues event, emit) async {
    emit(state.copyWith(playerValue: event.values));
  }

  Future<void> _onSeekTo(SeekVideoTo event, emit) async {
    VideoPlayerController? _existing = state.videoPlayer;

    if (_existing?.value.isInitialized ?? false) {
      await _existing?.seekTo(event.position);
      emit(state.copyWith(videoPlayer: _existing));
    }
  }
}
