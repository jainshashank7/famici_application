import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/video_player/video_player_bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:video_player/video_player.dart';

class FCVideoPlayer extends StatefulWidget {
  const FCVideoPlayer({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);
  final String videoUrl;
  @override
  _FCVideoPlayerState createState() => _FCVideoPlayerState();
}

class _FCVideoPlayerState extends State<FCVideoPlayer> {
  // late VideoPlayerController _controller;

  String get videoUrl => widget.videoUrl;

  final VideoPlayerBloc _playerBloc = VideoPlayerBloc();
  @override
  void initState() {
    super.initState();
    _playerBloc.add(SyncVideoToPlayer(videoUrl));
  }

  @override
  void dispose() {
    _playerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder(
          bloc: _playerBloc,
          buildWhen: (VideoPlayerState previous, VideoPlayerState current) {
            return previous.videoPlayer != current.videoPlayer;
          },
          builder: (context, VideoPlayerState state) {
            return InkWell(
              onDoubleTap: state.videoPlayer?.value.isPlaying ?? false
                  ? () {
                      _playerBloc.add(PauseVideo());
                    }
                  : () {
                      _playerBloc.add(SyncAndPlayVideo(videoUrl));
                    },
              child: Center(
                child: state.videoPlayer?.value.isInitialized ?? false
                    ? AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: VideoPlayer(state.videoPlayer!),
                      )
                    : Container(),
              ),
            );
          },
        ),
        BlocBuilder(
          bloc: _playerBloc,
          buildWhen: (VideoPlayerState previous, VideoPlayerState current) {
            return previous.playerValue.isPlaying !=
                current.playerValue.isPlaying;
          },
          builder: (context, VideoPlayerState state) {
            return state.videoPlayer?.value.isPlaying ?? false
                ? SizedBox.shrink()
                : Center(
                    child: NeumorphicButton(
                      minDistance: 4,
                      style: FCStyle.buttonCardStyle.copyWith(
                        boxShape: NeumorphicBoxShape.circle(),
                        color: ColorPallet.kDarkBackGround,
                        border: NeumorphicBorder.none(),
                      ),
                      onPressed: state.videoPlayer?.value.isPlaying ?? false
                          ? () {
                              _playerBloc.add(PauseVideo());
                            }
                          : () {
                              _playerBloc.add(SyncAndPlayVideo(videoUrl));
                            },
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        child: Icon(
                          state.videoPlayer?.value.isPlaying ?? false
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: ColorPallet.kLightBackGround,
                          size: 64,
                        ),
                      ),
                    ),
                  );
          },
        ),
        BlocBuilder(
          bloc: _playerBloc,
          buildWhen: (VideoPlayerState previous, VideoPlayerState current) {
            bool needRebuild = previous.playerValue.position.inSeconds !=
                current.playerValue.position.inSeconds;
            bool hidden =
                previous.playerValue.isPlaying != current.playerValue.isPlaying;
            return needRebuild || hidden;
          },
          builder: (context, VideoPlayerState state) {
            if (!state.playerValue.isPlaying) {
              return SizedBox.shrink();
            }
            return Positioned(
              bottom: 0,
              left: 80,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: Slider(
                    value: state.playerValue.position.inSeconds.toDouble(),
                    min: 0,
                    max: state.videoPlayer?.value.duration.inSeconds
                            .toDouble() ??
                        100.0,
                    onChanged: (value) {
                      _playerBloc
                          .add(SeekVideoTo(Duration(seconds: value.toInt())));
                    }),
              ),
            );
          },
        ),
        Positioned(
          bottom: 8,
          left: 16,
          child: BlocBuilder(
            bloc: _playerBloc,
            buildWhen: (VideoPlayerState previous, VideoPlayerState current) {
              return previous.playerValue.isPlaying !=
                  current.playerValue.isPlaying;
            },
            builder: (context, VideoPlayerState state) {
              if (!state.playerValue.isPlaying) {
                return SizedBox.shrink();
              }
              return NeumorphicButton(
                minDistance: 4,
                style: FCStyle.buttonCardStyle.copyWith(
                  boxShape: NeumorphicBoxShape.circle(),
                  color: ColorPallet.kDarkBackGround,
                  border: NeumorphicBorder.none(),
                ),
                onPressed: state.videoPlayer?.value.isPlaying ?? false
                    ? () {
                        _playerBloc.add(PauseVideo());
                      }
                    : () {
                        _playerBloc.add(SyncAndPlayVideo(videoUrl));
                      },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: Icon(
                    state.videoPlayer?.value.isPlaying ?? false
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: ColorPallet.kLightBackGround,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
