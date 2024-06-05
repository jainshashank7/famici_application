import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../shared/barrel.dart';
import '../../../utils/barrel.dart';
import '../blocs/sigle_user_chat/single_user_chat_bloc.dart';

class TypingTextMessage extends StatefulWidget {
  const TypingTextMessage({
    Key? key,
  }) : super(key: key);

  @override
  State<TypingTextMessage> createState() => _TypingTextMessageState();
}

class _TypingTextMessageState extends State<TypingTextMessage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context.read<SingleUserChatBloc>().state.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleUserChatBloc, SingleUserChatState>(
      listenWhen: (curr, prv) => curr.text != prv.text,
      listener: (context, state) {
        if (state.text.isEmpty) {
          _controller.clear();
        }
      },
      builder: (context, userChatState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: FCStyle.xLargeFontSize * 12,
              child: FCTextFormField(
                maxLines: 2,
                minLines: 1,
                contentPadding: EdgeInsets.symmetric(
                  vertical: FCStyle.defaultFontSize,
                  horizontal: 24.0,
                ),
                // initialValue: userChatState.text,
                textEditingController: _controller,
                textInputFormatters: [LengthLimitingTextInputFormatter(1024)],
                onChanged: (message) {
                  context
                      .read<SingleUserChatBloc>()
                      .add(TextMessageChanged(message));
                },
              ),
            ),
            SizedBox(width: FCStyle.mediumFontSize * 2),
            Neumorphic(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              style: FCStyle.primaryButtonStyle,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ColorPallet.kGreen.withOpacity(0.8),
                  elevation: 3,
                  padding: EdgeInsets.symmetric(
                    vertical: FCStyle.defaultFontSize + 2,
                    horizontal: FCStyle.mediumFontSize * 2,
                  ),
                ),
                onPressed: () {
                  context.read<SingleUserChatBloc>().add(SendTextMessage());
                },
                child: Text(
                  CommonStrings.send.tr(),
                  style: FCStyle.textStyle.copyWith(
                    color: ColorPallet.kLightBackGround,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
