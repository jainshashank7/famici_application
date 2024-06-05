import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../../../utils/barrel.dart';
import '../blocs/sigle_user_chat/single_user_chat_bloc.dart';

class TypingVoiceMessage extends StatelessWidget {
  const TypingVoiceMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
      builder: (context, userChatState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ConnectStrings.speakNow.tr(),
              style: FCStyle.textStyle.copyWith(
                color: ColorPallet.kWhite,
                fontWeight: FontWeight.w600,
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
            SizedBox(width: FCStyle.xLargeFontSize * 6),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ConnectStrings.recording.tr(),
                  style: FCStyle.textStyle.copyWith(
                    color: ColorPallet.kWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: FCStyle.defaultFontSize,
                  ),
                ),
                SizedBox(height: 8.0),
                StreamBuilder(
                    stream: userChatState.recorder.onProgress,
                    builder: (
                      context,
                      AsyncSnapshot<RecordingDisposition> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Text("");
                      }

                      String time =
                          snapshot.data?.duration.toString().substring(0, 7) ??
                              '';
                      return Text(
                        time,
                        style: FCStyle.textStyle
                            .copyWith(color: ColorPallet.kWhite),
                      );
                    })
              ],
            )
          ],
        );
      },
    );
  }
}
