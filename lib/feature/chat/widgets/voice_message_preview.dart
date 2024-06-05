import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../shared/icons/barrel.dart';
import '../../../utils/barrel.dart';
import '../../audio_player/waveform_audio_player.dart';
import '../blocs/sigle_user_chat/single_user_chat_bloc.dart';

class PreviewVoiceMessage extends StatefulWidget {
  const PreviewVoiceMessage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<PreviewVoiceMessage> createState() => _PreviewVoiceMessageState();
}

class _PreviewVoiceMessageState extends State<PreviewVoiceMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
      builder: (context, userChatState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WaveformAudioPlayer(
              height: FCStyle.mediumFontSize * 2 + 4,
              width: FCStyle.xLargeFontSize * 15,
              audioUrl: widget.url,
              showDuration: true,
            ),
            SizedBox(width: 16.0),
            Neumorphic(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              style: FCStyle.primaryButtonStyle.copyWith(
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(16.0),
                ),
                color: Colors.transparent,
                border: NeumorphicBorder.none(),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ColorPallet.kCardBackground,
                  elevation: 4,
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  side: BorderSide.none,
                ),
                clipBehavior: Clip.hardEdge,
                onPressed: () {
                  context
                      .read<SingleUserChatBloc>()
                      .add(DiscardVoiceRecording());
                },
                child: TrashIcon(),
              ),
            )
          ],
        );
      },
    );
  }
}
