import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/chat/blocs/sigle_user_chat/single_user_chat_bloc.dart';

import '../../../core/blocs/theme_bloc/theme_cubit.dart';
import '../../../shared/icons/barrel.dart';
import '../../../utils/barrel.dart';

class RecordingButton extends StatelessWidget {
  const RecordingButton({
    Key? key,
    required SingleUserChatBloc userChatBloc,
  })  : _userChatBloc = userChatBloc,
        super(key: key);

  final SingleUserChatBloc _userChatBloc;

  Widget getPrefix(RecordingStatus status) {
    if (status == RecordingStatus.recording) {
      return Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: MicrophoneIcon(
          disableThemeChange: true,
          isDark: true,
        ),
      );
    } else if (status == RecordingStatus.initial) {
      return Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: MicrophoneIcon(),
      );
    }
    return SizedBox.shrink();
  }

  Widget getSuffix(RecordingStatus status) {
    if (status == RecordingStatus.done) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorPallet.kWhite,
        ),
      );
    }
    return SizedBox.shrink();
  }

  void onPressed(RecordingStatus status) {
    if (status == RecordingStatus.initial) {
      _userChatBloc.add(StartVoiceRecording());
    } else if (status == RecordingStatus.recording) {
      _userChatBloc.add(StopVoiceRecording());
    } else if (status == RecordingStatus.done) {
      _userChatBloc.add(SendVoiceRecording());
    }
  }

  Widget label(RecordingStatus status) {
    if (status == RecordingStatus.initial) {
      return Text(
        ConnectStrings.tapToSpeak.tr(),
        style: FCStyle.textStyle.copyWith(
          fontSize: FCStyle.mediumFontSize,
        ),
      );
    }
    if (status == RecordingStatus.recording) {
      return Text(
        ConnectStrings.stopRecording.tr(),
        style: FCStyle.textStyle.copyWith(
          fontSize: FCStyle.mediumFontSize,
          color: ColorPallet.kWhite,
        ),
      );
    } else if (status == RecordingStatus.done) {
      return Text(
        ConnectStrings.sendAudio.tr(),
        style: FCStyle.textStyle.copyWith(
          fontSize: FCStyle.mediumFontSize,
          color: ColorPallet.kWhite,
        ),
      );
    }
    return SizedBox.shrink();
  }

  Color getColor(RecordingStatus status) {
    if (status == RecordingStatus.done) {
      return ColorPallet.kGreen;
    } else if (status == RecordingStatus.recording) {
      return ColorPallet.kRed;
    }
    return ColorPallet.kCardBackground.withOpacity(
      0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder(
          bloc: _userChatBloc,
          builder: (context, SingleUserChatState userChatState) {
            return Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Neumorphic(
                  margin: EdgeInsets.zero,
                  style: FCStyle.primaryButtonStyle.copyWith(
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    color: Colors.transparent,
                    border: NeumorphicBorder.none(),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: getColor(userChatState.recordingStatus),
                      elevation: 3,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20,
                      ),
                      side: BorderSide.none,
                    ),
                    clipBehavior: Clip.hardEdge,
                    onPressed: () {
                      onPressed(userChatState.recordingStatus);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getPrefix(userChatState.recordingStatus),
                        label(userChatState.recordingStatus),
                        getSuffix(userChatState.recordingStatus),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
