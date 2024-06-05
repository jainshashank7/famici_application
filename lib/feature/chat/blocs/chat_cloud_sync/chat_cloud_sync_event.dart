part of 'chat_cloud_sync_bloc.dart';

@immutable
abstract class ChatCloudSyncEvent {}

class AddMessageToQueueChatCloudSyncEvent extends ChatCloudSyncEvent {
  final Message message;

  AddMessageToQueueChatCloudSyncEvent(this.message);
}

class CreateConversationChatCloudSyncEvent extends ChatCloudSyncEvent {
  final Conversation conversation;

  CreateConversationChatCloudSyncEvent(this.conversation);
}

class StartSyncingChatCloudSyncEvent extends ChatCloudSyncEvent {}

class SyncNextItemChatCloudSyncEvent extends ChatCloudSyncEvent {}
