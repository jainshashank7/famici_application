part of 'single_user_chat_bloc.dart';

abstract class SingleUserChatEvent extends Equatable {}

class StartVoiceRecording extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class StopVoiceRecording extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class DiscardVoiceRecording extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class SendVoiceRecording extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class SendImageMessage extends SingleUserChatEvent {
  final String localPath;

  SendImageMessage(this.localPath);
  @override
  List<Object?> get props => [];
}

class SyncRecordingPath extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class SendTextMessage extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class TextMessageChanged extends SingleUserChatEvent {
  final String text;

  TextMessageChanged(this.text);
  @override
  List<Object?> get props => [];
}

class SyncLatestMessages extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class SetCurrentUserName extends SingleUserChatEvent{
  final String username;

  SetCurrentUserName(this.username);

  @override
  List<Object?> get props => [];
}

class SyncLatestMessagesWithConversation extends SingleUserChatEvent {
  final Conversation conversation;

  SyncLatestMessagesWithConversation(this.conversation);
  @override
  List<Object?> get props => [];
}

class SubscribedToMessagesSingleUserChatEvent extends SingleUserChatEvent {
  final Conversation conversation;

  SubscribedToMessagesSingleUserChatEvent(this.conversation);
  @override
  List<Object?> get props => [];
}

class _MessageReceived extends SingleUserChatEvent {
  final Message message;

  _MessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}

class SyncSessionSingleUserChatEvent extends SingleUserChatEvent {
  final Conversation conversation;

  SyncSessionSingleUserChatEvent(this.conversation);
  @override
  List<Object?> get props => [];
}

class SyncUserSingleUserChatEvent extends SingleUserChatEvent {
  final User contact;

  SyncUserSingleUserChatEvent(this.contact);
  @override
  List<Object?> get props => [];
}

class CloseSessionSingleUserChatEvent extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class SessionInitiateFailedSingleUserChatEvent extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class FetchMoreSingleUserChatEvent extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}

class ResetSingleUserChatEvent extends SingleUserChatEvent {
  @override
  List<Object?> get props => [];
}
