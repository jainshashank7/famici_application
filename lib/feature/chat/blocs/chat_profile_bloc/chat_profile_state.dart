part of 'chat_profile_bloc.dart';

class ChatProfilesState extends Equatable {
  const ChatProfilesState({
    required this.conversations,
    required this.providersNames,
    required this.senderIds,
    required this.providerImage,
  });

  final List<String> conversations;
  final List<String> providersNames;
  final List<String> senderIds;
  final List<String> providerImage;

  factory ChatProfilesState.initial() {
    return const ChatProfilesState(
      conversations: [],
      providersNames: [],
      senderIds: [],
      providerImage: [],
    );
  }

  @override
  List<Object?> get props => [ conversations, providersNames, senderIds, providerImage];

  ChatProfilesState fromJson(Map<String, dynamic> json) {
    return ChatProfilesState(
      conversations: List<String>.from(json['conversations']),
      providersNames: List<String>.from(json['providersNames']),
      senderIds: List<String>.from(json['senderIds']),
      providerImage: List<String>.from(json['providerImage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversations': conversations,
      'providersNames': providersNames,
      'senderIds': senderIds,
      'providerImage': providerImage,
    };
  }

  ChatProfilesState copyWith({
    List<String>? conversations,
    List<String>? providersNames,
    List<String>? senderIds,
    List<String>? providerImage,
  }) {
    return ChatProfilesState(
      conversations: conversations ?? this.conversations,
      providersNames: providersNames ?? this.providersNames,
      senderIds: senderIds ?? this.senderIds,
      providerImage: providerImage ?? this.providerImage,
    );
  }
}

