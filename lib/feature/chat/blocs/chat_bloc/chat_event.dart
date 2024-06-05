part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {}

class SubscribedToMessagesChatEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class _HandleReceivedMessageChatEvent extends ChatEvent {
  final Message message;
  // final String conversationId;

  _HandleReceivedMessageChatEvent(this.message);
  @override
  List<Object?> get props => [];
}

class ViewUserMessagesChatEvent extends ChatEvent {
  final String conversationId;
  final bool screenOpened;

  ViewUserMessagesChatEvent(
     this.conversationId,
      {
        this.screenOpened = false,
      });
  @override
  List<Object?> get props => [];
}

class SyncArchivedMessages extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ResetChatBloc extends ChatEvent {
  @override
  List<Object?> get props => [];
}
class CheckMessageSubscriptionEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ResubscribeChatEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}
class ChangeBackGroundStateChatEvent extends ChatEvent {
  final bool isAppBackground;

  ChangeBackGroundStateChatEvent(this.isAppBackground);

  @override
  List<Object?> get props => [];
}
