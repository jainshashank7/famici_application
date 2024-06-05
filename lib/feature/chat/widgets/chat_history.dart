import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/chat/blocs/sigle_user_chat/single_user_chat_bloc.dart';

import '../../../core/enitity/user.dart';
import '../../../utils/barrel.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import '../entities/message.dart';
import 'chat_bubble.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >
          0.8 * _controller.position.maxScrollExtent) {
        context.read<SingleUserChatBloc>().add(FetchMoreSingleUserChatEvent());
      }
    });
  }

  Widget separatorBuilder(context, int idx) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 24.0,
      ),
      child: SizedBox(),
    );
  }

  bool shouldShowDate(List<Message> messages, int index) {
    if (index == messages.length - 1) {
      return true;
    } else if (index - 1 > -1) {
      return messages[index].sentAt.day != messages[index + 1].sentAt.day;
    }
    return false;
  }

  EdgeInsets get contentPadding {
    return EdgeInsets.only(
      bottom: FCStyle.largeFontSize * 3 + 16.0,
      top: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
      builder: (context, chatState) {
        if (chatState.isFetching) {
          return Column(children: [LoadingScreen()]);
        }
        return Container(
          height: FCStyle.screenHeight * 0.9,
          margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
          decoration: BoxDecoration(
              color: Color.fromARGB(229, 255, 255, 255),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView.separated(
              padding: contentPadding,
              reverse: true,
              separatorBuilder: separatorBuilder,
              controller: _controller,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: chatState.messages.length,
              itemBuilder: (context, int index) {
                return ChatBubble(
                  message: chatState.messages[index],
                  userId: Provider.of<User>(context, listen: false).id,
                  showTopDate: shouldShowDate(chatState.messages, index),
                  username: chatState.currentChatUser,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
