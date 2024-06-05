import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:famici/feature/chat/entities/conversation.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/repository/chat_service/chat_service_interface.dart';
import 'package:famici/utils/barrel.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/local_database/local_db.dart';

class LocalChatService implements IChatService {
  static final LocalChatService _singleton = LocalChatService._internal();
  factory LocalChatService() {
    return _singleton;
  }
  LocalChatService._internal();

  final StreamController<Message> _messages =
  StreamController<Message>.broadcast();

  StreamSubscription? _messageFeed;
  StreamSubscription? _messageFromFeed;
  StreamSubscription? _messageFromApiFeed;
  final Database _localDb = LocalDatabaseFactory.instance;
  StreamSubscription? _apiMessageSubscription;

  final _amplifyAPI = Amplify.API;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  final StreamController<Message> _messagesFrom =
  StreamController<Message>.broadcast();

  @override
  Future<Conversation> addConversation(Conversation conversation) async {
    await _localDb.insert(
      DBTable.conversations,
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return conversation;
  }
  @override
  Future<Conversation> getFirstConversation(String familyId)async {
    return Conversation();
  }

  @override
  Future<Message> addMessage(Message message) async {
    int test = await _localDb.insert(
      DBTable.messages,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return message;
  }

  Future<void> addBulkMessage(List<Message> messages) async {
    Batch _batch = _localDb.batch();
    for (Message msg in messages) {
      _batch.insert(
        DBTable.messages,
        msg.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await _batch.commit();
  }



  @override
  Future<void> dispose() async {
    _messageFeed?.cancel();
    _messageFeed = null;
    _messageFromFeed?.cancel();
    _messageFromFeed = null;
    _apiMessageSubscription?.cancel();
    _apiMessageSubscription = null;
  }

  @override
  Future<List<String>> findAllConversations(String familyId) async {
    List<Map<String, dynamic>> _rawMessages = await _localDb.query(
      DBTable.conversations,
      orderBy: 'createdAt DESC'
    );
    List<String> conversationIds = [];
    for (var element in _rawMessages) {
      conversationIds.add(element['conversationId']);
    }

    return conversationIds;
  }

  @override
  Future<Conversation> findConversation(String conversationId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> findMessages(
      String conversationId, {
        int limit = 100,
        int offset = 0,
      }) async {

    await _localDb.delete(
      DBTable.messages,
      where: 'conversationId = ? AND createdAt <= ?',
      whereArgs: [conversationId, DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch ],
    );

    List<Map<String, dynamic>> _rawMessages = await _localDb.query(
      DBTable.messages,
      orderBy: 'createdAt DESC',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      limit: limit,
      offset: offset,
    );

    List<Message> _messages = List<Message>.from(
      _rawMessages.map((e) => Message.fromMap(e)),
    );
    return _messages;
  }

  Future<List<Message>> findAllMessages({
    int limit = 100,
    int offset = 0,
  }) async {
    List<Map<String, dynamic>> _rawMessages = await _localDb.query(
      DBTable.messages,
      orderBy: 'createdAt DESC',
      limit: limit,
      offset: offset,
    );

    List<Message> _messages = List<Message>.from(
      _rawMessages.map((e) => Message.fromMap(e)),
    );
    return _messages;
  }

  @override
  Stream<Message> receiveMessagesFrom(
      String conversationId, {
        String contactId = '',
      }) {
    return _messagesFrom.stream;
  }

  @override
  Stream<Message> subscribedToAllMessages() {
    // _startReceivingMessages();
    return _messages.stream;
  }

  @override
  Future<void> updateMessage(Message message) async {
    await _localDb.transaction((txn) async {
      Batch _batch = txn.batch();
      if (message.type == MessageType.receipt) {
        var _rawMsg = await txn.query(
          DBTable.messages,
          where: 'tempId = ?',
          whereArgs: [message.tempId],
        );

        if (_rawMsg.isNotEmpty) {
          Message _existing = Message.fromMap(_rawMsg.first).copyWith(
            messageId: message.messageId,
            receipt: Receipt.delivered,
          );
          _batch.insert(
            DBTable.messages,
            _existing.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } else {
        _batch.insert(
          DBTable.messages,
          message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await _batch.commit();
    });

    return;
  }

  //helpers
  void _startReceivingMessages() async {
    await _messageFeed?.cancel();
    _messageFeed = null;
    _messageFeed = FirebaseMessaging.onMessage.listen((event) async {
      if (event.data['type'] == NotificationType.message) {
        Message _received = Message.fromRawJson(event.data['data']);

        await _localDb.transaction((txn) async {
          Batch _batch = txn.batch();

          if (_received.type == MessageType.receipt) {
            var _existingRaw = await txn.query(
              DBTable.messages,
              where: 'tempId = ?',
              whereArgs: [_received.tempId],
            );
            if (_existingRaw.isNotEmpty) {
              Message _existing = Message.fromMap(_existingRaw.first).copyWith(
                messageId: _received.messageId,
                receipt: Receipt.delivered,
              );

              _batch.insert(
                DBTable.messages,
                _existing.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          } else if (_received.isUploadReceipt) {
            DebugLogger.debug(_received.toJson());
          } else {
            _batch.insert(
              DBTable.messages,
              _received.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          await _batch.commit(noResult: true);
        });

        _messages.add(_received);
      }
    });
  }

  void _startReceivingMessagesFrom(
      String conversationId,
      String contactId,
      ) async {
    await _messageFromFeed?.cancel();
    _messageFromFeed = null;

    DebugLogger.error(contactId);

    String _graphQLDocument =
    '''subscription subscribeToConversation(\$receivedBy: ID!) {
           subscribeToConversation(receivedBy: \$receivedBy){
              conversationId
              createdAt
              data
              receivedAt
              messageId
              receivedBy
              sentAt
              sentBy
              tempId
              text
              type
            }
         }''';

    _messageFromFeed = _amplifyAPI
        .subscribe(GraphQLRequest(
      document: _graphQLDocument,
      variables: {
        "receivedBy": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    ))
        .listen((event) async {
      if (event.data != null) {
        Message _received = Message.fromJson(
          jsonDecode(event.data)['subscribeToConversation'],
        );
        if (_received.conversationId == conversationId) {
          _messages.sink.add(_received);
        }
      }
    }, onError: (err) {
      try {
        _crashlytics.recordError(err, StackTrace.fromString(_graphQLDocument));
      } catch (crash) {
        DebugLogger.error(crash);
      }
      DebugLogger.error(err);
    });
  }

  Future<Message?> findMessageByTempId(
      String tempId,
      ) async {
    List<Map<String, dynamic>> _rawMessages = await _localDb.query(
      DBTable.messages,
      where: 'tempId = ?',
      whereArgs: [tempId],
      limit: 1,
    );
    if (_rawMessages.isEmpty) {
      return null;
    }
    return Message.fromMap(_rawMessages.first);
  }

  Stream<Message> subscribe({String? contactId = ''}) {
    String _graphQLDocument =
    '''subscription subscribeToConversation(\$receivedBy: ID!) {
           subscribeToConversation(receivedBy: \$receivedBy){
              conversationId
              createdAt
              data
              receivedAt
              messageId
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

    _apiMessageSubscription?.cancel();
    _apiMessageSubscription = null;
    _apiMessageSubscription = _amplifyAPI
        .subscribe(GraphQLRequest(
      document: _graphQLDocument,
      variables: {
        "receivedBy": contactId,
      },
      apiName: AmplifyApiName.defaultApi,
    ))
        .listen((event) async {
      if (event.data != null) {
        Message _received = Message.fromJson(
          jsonDecode(event.data)['subscribeToConversation'],
        );

        await _localDb.transaction((txn) async {
          Batch _batch = txn.batch();

          if (_received.type == MessageType.receipt) {
            var _existingRaw = await txn.query(
              DBTable.messages,
              where: 'tempId = ?',
              whereArgs: [_received.tempId],
            );
            if (_existingRaw.isNotEmpty) {
              Message _existing = Message.fromMap(_existingRaw.first).copyWith(
                messageId: _received.messageId,
                receipt: Receipt.delivered,
              );

              _batch.insert(
                DBTable.messages,
                _existing.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          } else if (_received.isUploadReceipt) {
            DebugLogger.debug(_received.toJson());
          } else {
            _batch.insert(
              DBTable.messages,
              _received.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          await _batch.commit(noResult: true);
        });

        _messages.add(_received);
      }
    }, onError: (err) {
      try {
        _crashlytics.recordError(err, StackTrace.fromString(_graphQLDocument));
        DebugLogger.error(err);
      } catch (crash) {
        DebugLogger.error(crash);
      }
    });

    return _messages.stream;
  }
}
