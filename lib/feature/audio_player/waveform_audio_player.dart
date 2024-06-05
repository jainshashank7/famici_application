import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/audio_player/bloc/audio_player_bloc.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/utils/barrel.dart';

class WaveformAudioPlayer extends StatefulWidget {
  const WaveformAudioPlayer({
    Key? key,
    required this.audioUrl,
    this.showDuration = false,
    this.height,
    this.width,
    this.duration = 1.0,
  }) : super(key: key);
  final String audioUrl;
  final bool showDuration;
  final double? height;
  final double? width;
  final double? duration;

  // final double? currentPosition;
  // final VoidCallback? onPressed;
  // final bool isPlaying;
  @override
  _WaveformAudioPlayerState createState() => _WaveformAudioPlayerState();
}

class _WaveformAudioPlayerState extends State<WaveformAudioPlayer> {
  final AudioPlayerBloc mpb = AudioPlayerBloc();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    mpb.add(SyncAudio(
      MediaItem(
        id: DateTime.now().toString(),
        album: "Recording",
        title: "Recording",
        artist: "me",
        extras: {
          CollectionKey.url: widget.audioUrl,
        },
      ),
    ));
    mpb.add(TogglePlayPauseAudio());
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && mpb.state.isPlaying) {
        mpb.add(TogglePlayPauseAudio());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: mpb,
      builder: (context, AudioPlayerState state) {
        return SizedBox(
          width: widget.width ?? FCStyle.mediumFontSize * 14,
          // height: widget.height ?? FCStyle.mediumFontSize * 3,
          child: Row(
            children: [
              ElevatedButton(
                focusNode: _focusNode,
                style: ElevatedButton.styleFrom(
                  primary: ColorPallet.kBlack,
                  elevation: 3,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8.0),
                ),
                onPressed: () {
                  _focusNode.requestFocus();
                  mpb.add(TogglePlayPauseAudio());
                },
                child: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: ColorPallet.kWhite,
                  size: 50 * FCStyle.fem,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: SizedBox(
                  height: widget.height ?? FCStyle.mediumFontSize * 3,
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              (state.position / state.duration),
                              (state.position / state.duration)
                            ],
                            colors: [ColorPallet.kBlue, ColorPallet.kGrey],
                          ).createShader(rect);
                        },
                        child: Container(
                          height: widget.height ?? 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image.asset(AssetImagePath.waveFormImage)
                                  .image,
                              repeat: ImageRepeat.repeatX,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 24.0,
                          child: SliderTheme(
                            data: Theme.of(context).sliderTheme.copyWith(
                                  overlayShape: SliderComponentShape.noThumb,
                                  thumbColor: Colors.transparent,
                                  thumbShape: SliderComponentShape.noThumb,
                                  disabledThumbColor: Colors.transparent,
                                  activeTrackColor: Colors.transparent,
                                  inactiveTrackColor: Colors.transparent,
                                  trackHeight: 32,
                                ),
                            child: Slider(
                              value: state.position,
                              max: state.duration,
                              onChanged: (double value) {
                                mpb.add(SeekAudioTrack(value: value));
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              widget.showDuration
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        Duration(
                          seconds: state.duration.toInt(),
                        ).toString().substring(2, 7),
                        style: FCStyle.textStyle.copyWith(
                          color: ColorPallet.kPrimaryTextColor,
                        ),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        );
      },
    );
  }
}
