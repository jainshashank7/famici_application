import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/chat/entities/message_media_content.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Message extends Equatable {
  final String messageId;
  final String conversationId;
  final MediaContent data;
  final String text;
  final MessageType type;
  final DateTime sentAt;
  final DateTime receivedAt;
  final String sentBy;
  final String senderPicture;
  final String senderName;
  final String receivedBy;
  final DateTime createdAt;
  final String familyId;
  final String tempId;
  final User userSentBy;
  final Receipt receipt;
  final int readAt;

  Message({
    String? messageId,
    String? conversationId,
    MediaContent? data,
    String? text,
    MessageType? type,
    DateTime? sentAt,
    DateTime? receivedAt,
    String? sentBy,
    String? senderPicture,
    String? senderName,
    String? receivedBy,
    DateTime? createdAt,
    String? familyId,
    String? tempId,
    User? userSentBy,
    Receipt? receipt,
    int? readAt
  })  : messageId = messageId ?? '',
        conversationId = conversationId ?? '',
        data = data ?? MediaContent(),
        type = type ?? MessageType.unknown,
        sentAt = sentAt ?? DateTime.now(),
        receivedAt = receivedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        sentBy = sentBy ?? '',
        receivedBy = receivedBy ?? '',
        familyId = familyId ?? '',
        userSentBy = userSentBy ?? User(),
        tempId = tempId ?? DateTime.now().toString(),
        receipt = receipt ?? Receipt.sent,
        text = text ?? '',
        senderName = senderName ?? '',
        senderPicture = senderPicture ?? '',
        readAt = readAt??0;

  Message copyWith({
    String? messageId,
    String? conversationId,
    MediaContent? data,
    String? text,
    MessageType? type,
    DateTime? sentAt,
    DateTime? receivedAt,
    String? sentBy,
    String? receivedBy,
    String? familyId,
    String? tempId,
    User? userSentBy,
    Receipt? receipt,
    String? senderPicture,
    String? senderName,
    int? readAt
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      data: data ?? this.data,
      text: text ?? this.text,
      type: type ?? this.type,
      sentAt: sentAt ?? this.sentAt,
      receivedAt: receivedAt ?? this.receivedAt,
      sentBy: sentBy ?? this.sentBy,
      familyId: familyId ?? this.familyId,
      tempId: tempId ?? this.tempId,
      receivedBy: receivedBy ?? this.receivedBy,
      userSentBy: userSentBy ?? this.userSentBy,
      receipt: receipt ?? this.receipt,
      senderName: senderName ?? this.senderName,
      senderPicture: senderPicture ?? this.senderPicture,
      readAt: readAt ?? this.readAt
    );
  }

  factory Message.fromRawJson(String? str) {
    if (str == null || str.isEmpty) {
      return Message();
    }
    return Message.fromJson(jsonDecode(str));
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    DateTime _sentAt = DateTime.now();

    if (json['sentAt'] != null) {
      if (json['sentAt'].runtimeType == int) {
        _sentAt = DateTime.fromMillisecondsSinceEpoch(json['sentAt']);
      } else {
        _sentAt = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json['sentAt']) ?? _sentAt.millisecondsSinceEpoch,
        );
      }
    }

    DateTime _createdAt = DateTime.now();
    if (json['createdAt'] != null) {
      if (json['createdAt'].runtimeType == int) {
        _createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
      } else {
        _createdAt = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json['createdAt']) ?? _sentAt.millisecondsSinceEpoch,
        );
      }
    }

    return Message(
      messageId: json['messageId'],
      conversationId: json['conversationId'],
      type: ((json['type'] ?? "") as String).toMessageType(),
      familyId: json['familyId'],
      sentBy: json['sentBy'],
      data: (json['data'] is String)
          ? MediaContent.fromRawJson(json['data'])
          : MediaContent.fromJson(json['data']),
      text: json['text'],
      tempId: json['tempId'],
      sentAt: _sentAt,
      createdAt: _createdAt,
      userSentBy: json['userSentBy'] != null
          ? User.fromMap(jsonDecode(json['userSentBy']))
          : User(),
      receipt: Receipt.delivered,
      senderName: json['senderName'],
      senderPicture: json['senderPicture'],
      readAt: json['readAt']
    );
  }

  Map<String, String> toJson() {
    return {
      "conversationId": conversationId,
      "createdAt": "${createdAt.millisecondsSinceEpoch}",
      "data": data.toRawJson(),
      "text": text,
      "familyId": familyId,
      "messageId": messageId,
      "sentBy": sentBy,
      "sentAt": "${sentAt.millisecondsSinceEpoch}",
      "type": type.name,
      "tempId": tempId,
      "userSentBy": jsonEncode(userSentBy.toMap()),
      "receipt": receipt.name,
      "senderName": senderName,
      "senderPicture": senderPicture,
    };
  }

  Map<String, dynamic> toMessageInput() {
    return {
      "tempId": tempId,
      "sentAt": sentAt.millisecondsSinceEpoch,
      "data": data.toRawJson(),
      "text": text,
      "type": type.name.capitalize(),
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toMap() {
    return {
      "tempId": tempId,
      "messageId": messageId,
      "conversationId": conversationId,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "data": data.toRawJson(),
      "text": text,
      "familyId": familyId,
      "receivedBy": receivedBy,
      "sentBy": sentBy,
      "sentAt": sentAt.millisecondsSinceEpoch,
      "type": type.name,
      "receipt": receipt.name,
      "readAt":readAt
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      tempId: map['tempId'],
      conversationId: map['conversationId'],
      messageId: map['messageId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      data: (map['data'] is String)
          ? MediaContent.fromRawJson(map['data'])
          : MediaContent.fromJson(map['data']),
      text: map['text'],
      familyId: map['familyId'],
      receivedBy: map['receivedBy'],
      sentBy: map['sentBy'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sentAt']),
      type: (map['type'] ?? '').toString().toMessageType(),
      receipt: (map['receipt'] ?? "").toString().toReceipt(),
      readAt: map['readAt'],
    );
  }

  String generateTempId() {
    return '${conversationId}_${sentBy}_${uuid.v4()}';
  }

  bool get isCallReceipt => type == MessageType.callReceipt;
  bool get isText => type == MessageType.text;
  bool get isAudio => type == MessageType.audio;
  bool get isImage => type == MessageType.image;
  bool get isReceipt => type == MessageType.receipt;
  bool get isUploadReceipt => type == MessageType.uploadReceipt;

  @override
  List<Object?> get props => [
        messageId,
        conversationId,
        data,
        type,
        sentAt,
        receivedAt,
        sentBy,
        receivedBy,
        familyId,
        tempId,
        receipt,
        text,
        readAt
      ];

  bool get isMissedReceipt {
    bool isMissed = false;
    isMissed = data.type == CallReceiptType.missed;
    return isMissed;
  }

  static List<Message> fromJsonList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    return List<Message>.from(list.map((e) => Message.fromJson(e)));
  }
}

enum MessageType {
  text,
  audio,
  image,
  pdf,
  video,
  unknown,
  callReceipt,
  receipt,
  uploadReceipt,
}

extension MessageTypeExt on String {
  MessageType toMessageType() {
    return MessageType.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => MessageType.unknown,
    );
  }
}

enum Receipt {
  sent,
  delivered,
  failed,
  unknown,
}

extension ReceiptExt on String {
  Receipt toReceipt() {
    return Receipt.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => Receipt.unknown,
    );
  }

  String capitalize() {
    if (isEmpty) {
      return '';
    } else if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
    return toUpperCase();
  }
}

enum CallReceiptType { missedResponse, missed, declined, ended, unknown }

extension CallReceiptTypeExt on String {
  CallReceiptType toCallReceipt() {
    return CallReceiptType.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => CallReceiptType.unknown,
    );
  }
}
