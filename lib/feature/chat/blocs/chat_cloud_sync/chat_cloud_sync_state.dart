part of 'chat_cloud_sync_bloc.dart';

class ChatCloudSyncState {
  ChatCloudSyncState({
    required this.offlineMessages,
    required this.offlineConversations,
  });

  factory ChatCloudSyncState.initial() {
    return ChatCloudSyncState(
      offlineConversations: {},
      offlineMessages: {},
    );
  }

  final Map<String, Message> offlineMessages;
  final Map<String, Conversation> offlineConversations;

  ChatCloudSyncState copyWith({
    Map<String, Message>? offlineMessages,
    Map<String, Conversation>? offlineConversations,
  }) {
    return ChatCloudSyncState(
      offlineMessages: offlineMessages ?? this.offlineMessages,
      offlineConversations: offlineConversations ?? this.offlineConversations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "offlineMessages": offlineMessages.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      "offlineConversations": offlineConversations.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  factory ChatCloudSyncState.fromJson(Map<String, dynamic> json) {
    Map<String, Conversation> _conversations = Map<String, Conversation>.from(
      ((json['offlineConversations'] ?? {}) as Map).map(
        (key, value) => MapEntry(key, Conversation.fromJson(value)),
      ),
    );
    Map<String, Message> _messages = Map<String, Message>.from(
      ((json['offlineMessages'] ?? {}) as Map).map(
        (key, value) => MapEntry(key, Message.fromJson(value)),
      ),
    );

    return ChatCloudSyncState(
      offlineMessages: _messages,
      offlineConversations: _conversations,
    );
  }
}
