import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:famici/feature/chat/entities/chat_media_response.dart';
import 'package:famici/feature/chat/entities/conversation.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/repository/chat_service/chat_service_interface.dart';

import '../../../../repositories/amplify_service.dart';
import '../../../../utils/helpers/amplify_helper.dart';

class ChatService implements IChatService {
  final AmplifyService _amplifyAPI = AmplifyService();

  @override
  Future<Conversation> addConversation(Conversation conversation) async {
    String graphQLDocument =
        '''query GetConversation (\$familyId: ID!,\$contactId: ID!) {
            getConversation (familyId:\$familyId, contactId: \$contactId) {
                  conversationId
                  createdAt
                  familyId
                  participants
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": conversation.familyId,
        "contactId": conversation.remoteId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return Conversation.fromJson(jsonDecode(response.data)['getConversation']);
  }

  @override
  Future<Conversation> getFirstConversation(String familyId) async {
    //initially the client wants to show only one chat in the tablet. so implementing that, backend is
    //sending that conversation in first item in conversation list: More details to contact Aruna

    String graphQLDocument = '''query GetConversations (\$familyId: ID!) {
            getConversations (familyId:\$familyId)
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }
    return Conversation(
        conversationId: jsonDecode(response.data)['getConversations'][0]);
  }

  @override
  Future<Message> addMessage(Message message) async {
    String graphQLDocument =
        '''mutation SendMessage(\$conversationId: ID!, \$message: MessageInput!) {
            sendMessage(conversationId: \$conversationId, message: \$message) {
              conversationId
              createdAt
              data
              messageId
              receivedAt
              receivedBy
              sentAt
              sentBy
              tempId
              text
              type
              senderName
              senderPicture
            }
        }''';
    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "conversationId": message.conversationId,
        "message": message.toMessageInput(),
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }

    return Message.fromJson(jsonDecode(response.data)['sendMessage']);
  }

  Future<Message> addMediaMessage(Message message) async {
    String graphQLDocument =
        '''mutation SendMessage(\$conversationId: ID!, \$message: MessageInput!) {
            sendMessage(conversationId: \$conversationId, message: \$message) {
              conversationId
              createdAt
              data
              messageId
              receivedAt
              receivedBy
              sentAt
              sentBy
              tempId
              text
              type
              senderName
              senderPicture
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "conversationId": message.conversationId,
        "message": message.toMessageInput(),
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }

    return Message.fromJson(jsonDecode(response.data)['sendMessage']);
  }

  @override
  Future<void> dispose() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> findAllConversations(String familyId) async {
    String graphQLDocument = '''query GetConversations (\$familyId: ID!) {
            getConversations (familyId:\$familyId)
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }

    List<dynamic> data = jsonDecode(response.data)['getConversations'];

    List<String> conversations = [];
    for (var i = 0; i < data.length; i++) {
      try {
        conversations.add(jsonDecode(response.data)['getConversations'][i]);
      } catch (err) {
        DebugLogger.error(err);
      }
    }

    return conversations;
  }

  @override
  Future<Conversation> findConversation(String conversationId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> findMessages(
    String conversationId, {
    int? limit = 50,
    String? startAt = '',
    String? order = "Desc",
  }) async {
    if(conversationId == "" ){
      return [];
    }
    String graphQLDocument =
        '''query GetMessages(\$conversationId: ID!, \$sortOrder: SortOrder,\$limit:Int, \$lastMessageId:String) {
            getMessages(conversationId: \$conversationId, sortOrder: \$sortOrder,limit:\$limit,lastMessageId:\$lastMessageId) {
              messageId
              conversationId
              tempId
              text
              sentBy
              sentAt
              receivedAt
              receivedBy
              data
              type
              createdAt
              readAt
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "conversationId": conversationId,
        "sortOrder": order,
        "limit": limit,
        "lastMessageId": startAt,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }

    return Message.fromJsonList(jsonDecode(response.data)['getMessages']);
  }

  @override
  Stream<Message> receiveMessagesFrom(String conversationId) {
    throw UnimplementedError();
  }

  @override
  Stream<Message> subscribedToAllMessages() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(Message message) {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }

  Future<ChatMedia> getMediaUploadUrl(Message msg) async {
    String graphQLDocument = '''
    mutation UploadMedia(\$familyId:ID!,\$type:UploadType!,\$metadata:UploadMetadataInput) {
      uploadMedia(familyId: \$familyId, type: \$type, metadata: \$metadata) {
        contactId
        createdAt
        familyId
        type
        uploadId
        media {
          bucket
          key
          mediaId
          uploadUrl
        }
      }
    }
    ''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "type": "Chat",
        "familyId": msg.familyId,
        "metadata": {
          "conversationId": msg.conversationId,
          "tempId": msg.tempId,
          "mimeType": msg.type.name.capitalize(),
        }
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return ChatMedia();
    } else {
      ChatMediaResponse data = ChatMediaResponse.fromJson(
        jsonDecode(response.data)['uploadMedia'],
      );
      return data.media.first;
    }
  }

  Future<bool> sendReadReceipt(
      String conversationId, List<String?> messageIds) async {
    String graphQLDocument =
        '''mutation SendReadReceipt(\$conversationId: ID!, \$messageIds: [ID!]!) {
            sendReadReceipt(conversationId: \$conversationId, messageIds: \$messageIds){
                messageId
                conversationId
                tempId
                text
                senderName
                senderPicture
                sentBy
                sentAt
                receivedAt
                readAt
                receivedBy
                data
                type
                createdAt
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "conversationId": conversationId,
        "messageIds": messageIds,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    }

    return jsonDecode(response.data)['sendReadReceipt'] ==
        "Successfully updated";
  }
}
