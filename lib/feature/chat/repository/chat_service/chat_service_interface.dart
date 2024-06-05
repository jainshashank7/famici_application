import 'package:famici/core/enitity/barrel.dart';

import '../../entities/conversation.dart';
import '../../entities/message.dart';

abstract class IChatService {
  Future<Conversation> addConversation(Conversation conversation);
  Future<Conversation> getFirstConversation(String familyId);
  Future<Message> addMessage(Message message);
  Future<Conversation> findConversation(String conversationId);
  Future<List<String>> findAllConversations(String familyId);
  Future<void> updateMessage(Message message);
  Future<List<Message>> findMessages(String conversationId);

  Stream<Message> subscribedToAllMessages();
  Stream<Message> receiveMessagesFrom(String conversationId);
  Future<void> dispose();
}
