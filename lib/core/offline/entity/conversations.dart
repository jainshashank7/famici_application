class ConversationTable {
  final String userId;
  final List<String> conversationIds;

  ConversationTable({required this.userId, required this.conversationIds});

  factory ConversationTable.fromJson(Map<String, dynamic> json) {
    return ConversationTable(
      userId: json['userId'],
      conversationIds: List<String>.from(json['conversationIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'conversationIds': conversationIds,
    };
  }
}
