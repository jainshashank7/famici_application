import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:famici/feature/chat/entities/message.dart';

class Conversation extends Equatable {
  Conversation(
      {String? conversationId,
      DateTime? createdAt,
      String? familyId,
      List<String>? participants,
      Map<String, Message>? messages,
      String? tempId,
      String? remoteId})
      : conversationId = conversationId ?? '',
        createdAt = createdAt ?? DateTime.now(),
        familyId = familyId ?? '',
        participants = participants ?? [],
        messages = messages ?? {},
        tempId = tempId ?? '',
        remoteId = remoteId ?? '';

  final String conversationId;
  final DateTime createdAt;
  final String familyId;
  final List<String> participants;
  final Map<String, Message> messages;
  final String tempId;
  final String remoteId;

  Conversation copyWith({
    String? conversationId,
    DateTime? createdAt,
    String? familyId,
    List<String>? participants,
    Map<String, Message>? messages,
    String? tempId,
    String? remoteId,
  }) {
    return Conversation(
      conversationId: conversationId ?? this.conversationId,
      createdAt: createdAt ?? this.createdAt,
      familyId: familyId ?? this.familyId,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      tempId: tempId ?? this.tempId,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  factory Conversation.fromRawJson(String str) {
    return Conversation.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) {
    Map<String, Message> _messages = Map<String, Message>.from(
      (json['messages'] ?? {}).map(
        (key, value) => MapEntry(key, Message.fromJson(value)),
      ),
    );

    return Conversation(
      conversationId: json["conversationId"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
      familyId: json["familyId"],
      participants: List<String>.from(json["participants"].map((x) => x)),
      messages: _messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "conversationId": conversationId,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "familyId": familyId,
      "participants": List<dynamic>.from(participants.map((x) => x)),
      "messages": messages.map((key, value) => MapEntry(key, value.toJson()))
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json["conversationId"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
      familyId: json["familyId"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "conversationId": conversationId,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "familyId": familyId,
    };
  }

  @override
  List<Object?> get props => [
        conversationId,
        familyId,
        createdAt,
        participants,
      ];
}
