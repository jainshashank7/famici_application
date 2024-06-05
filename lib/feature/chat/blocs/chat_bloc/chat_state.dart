part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState(
      {required this.conversations,
      required this.usersWithConversations,
      required this.isAppBackground,
      required this.chatUsers,
      required this.currentUserId});

  final Map<String, Conversation> conversations;
  final Map<String, String> usersWithConversations;
  final bool isAppBackground;
  final List<String> chatUsers;
  final String currentUserId;

  factory ChatState.initial() {
    return ChatState(
        conversations: {},
        usersWithConversations: {},
        isAppBackground: false,
        chatUsers: [],
        currentUserId: "");
  }

  ChatState copyWith(
      {Map<String, Conversation>? conversations,
      Map<String, String>? usersWithConversations,
      bool? isAppBackground,
      String? currentUserId}) {
    return ChatState(
        conversations: conversations ?? this.conversations,
        usersWithConversations:
            usersWithConversations ?? this.usersWithConversations,
        isAppBackground: isAppBackground ?? this.isAppBackground,
        chatUsers: chatUsers,
        currentUserId: currentUserId ?? this.currentUserId);
  }

  Map<String, dynamic> toJson() {
    return {
      "conversations": conversations.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      "usersWithConversations": usersWithConversations,
    };
  }

  factory ChatState.fromJson(Map<String, dynamic>? json) {
    Map<dynamic, dynamic> dynamicConversation = (json?['conversations'] ?? {});

    Map<String, Conversation> _conversations = <String, Conversation>{};
    if (dynamicConversation.isNotEmpty) {
      _conversations = Map<String, Conversation>.from(dynamicConversation.map(
        (key, value) => MapEntry(key, Conversation.fromJson(value)),
      ));
    }

    Map<String, String> _userWithChats = Map<String, String>.from(
      json?['usersWithConversations'] ?? <String, String>{},
    );
    return ChatState(
        conversations: _conversations,
        usersWithConversations: _userWithChats,
        isAppBackground: false,
        chatUsers: [],
        currentUserId: "");
  }

  @override
  List<Object?> get props => [
        conversations.map((key, value) => MapEntry(key, value.toJson())),
        usersWithConversations,
        isAppBackground
      ];
}
