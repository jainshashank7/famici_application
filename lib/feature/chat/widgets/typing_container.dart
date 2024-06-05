import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../utils/barrel.dart';
import '../blocs/sigle_user_chat/single_user_chat_bloc.dart';

class TypingContainer extends StatelessWidget {
  const TypingContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  background(RecordingStatus status) {
    if (status == RecordingStatus.recording) {
      return ColorPallet.kGreen;
    }
    return ColorPallet.kBackground;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
      buildWhen: (prv, curr) => prv.recordingStatus != curr.recordingStatus,
      builder: (context, userChatState) {
        return Neumorphic(
          margin: EdgeInsets.zero,
          style: FCStyle.primaryButtonStyle.copyWith(
            boxShape: NeumorphicBoxShape.rect(),
            color: background(userChatState.recordingStatus),
          ),
          child: Container(
            // height: FCStyle.largeFontSize * 3
            constraints: BoxConstraints(
              minHeight: FCStyle.xLargeFontSize * 2 + 12,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 36.0,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
