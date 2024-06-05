import 'package:intl/intl.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/enitity/user.dart';
import '../../chat/entities/conversation.dart';
import '../../chat/entities/message.dart';
import '../../chat/entities/message_media_content.dart';
import '../../chat/repository/chat_service/chat_service.dart';

class CallReceiptIssuer {
  final ChatService _chatService = ChatService();

  saveMissedReply(
      String callId,
      User me,
      User caller,
      String body,
      ) async {
    Conversation _conversation =
    await _chatService.addConversation(Conversation(
      remoteId: caller.id,
      familyId: me.familyId,
    ));

    DateTime _date = DateTime.now();
    Message msg = Message();
    Message _newMsg = Message(
      messageId: callId,
      tempId: msg.generateTempId(),
      sentBy: me.id,
      sentAt: _date,
      type: MessageType.callReceipt,
      data: MediaContent(
        callerTitle: "Missed Call Response",
        calleeTitle: "Missed Call Response sent!\n ${body}",
        time: DateFormat(time12hFormat).format(_date),
        caller: caller.id,
        body: body,
        type: CallReceiptType.missedResponse,
      ),
      conversationId: _conversation.conversationId,
      receipt: Receipt.sent,
    );
    await _chatService.addMessage(_newMsg);
  }

  saveCanceled(
      String callId,
      String calleeId,
      String callerId,
      String familyId,
      String me,
      ) async {
    Conversation _conversation = await _chatService.addConversation(
      Conversation(
        remoteId: me == calleeId ? callerId : calleeId,
        familyId: familyId,
      ),
    );

    DateTime _date = DateTime.now();
    Message _newMsg = Message(
      messageId: callId,
      tempId: callId,
      sentBy: callerId,
      sentAt: _date,
      type: MessageType.callReceipt,
      data: MediaContent(
        callerTitle: "Call Cancelled",
        calleeTitle: "Missed Call",
        time: DateFormat(time12hFormat).format(_date),
        caller: callerId,
        type: CallReceiptType.missed,
      ),
      conversationId: _conversation.conversationId,
      receipt: Receipt.sent,
    );

    await _chatService.addMessage(_newMsg);
  }

  saveNoAnswer(
      String callId,
      String calleeId,
      String callerId,
      String familyId,
      String me,
      ) async {
    Conversation _conversation = await _chatService.addConversation(
      Conversation(
        remoteId: me == calleeId ? callerId : calleeId,
        familyId: familyId,
      ),
    );

    DateTime _date = DateTime.now();
    Message _newMsg = Message(
      messageId: callId,
      tempId: callId,
      sentBy: callerId,
      sentAt: _date,
      type: MessageType.callReceipt,
      data: MediaContent(
        callerTitle: "No answer",
        calleeTitle: "Missed Call",
        time: DateFormat(time12hFormat).format(_date),
        caller: callerId,
        type: CallReceiptType.missed,
      ),
      conversationId: _conversation.conversationId,
      receipt: Receipt.sent,
    );

    String tempId = _newMsg.generateTempId();
    _newMsg = _newMsg.copyWith(messageId: tempId, tempId: tempId);
    await _chatService.addMessage(_newMsg);
  }

  saveDecline(
      String callId,
      String calleeId,
      String callerId,
      String familyId,
      String me,
      ) async {
    Conversation _conversation = await _chatService.addConversation(
      Conversation(
        remoteId: me == calleeId ? callerId : calleeId,
        familyId: familyId,
      ),
    );

    DateTime _date = DateTime.now();
    Message _newMsg = Message(
      messageId: callId,
      tempId: callId,
      sentBy: callerId,
      sentAt: _date,
      type: MessageType.callReceipt,
      data: MediaContent(
        callerTitle: "Call Declined",
        calleeTitle: "Call Declined",
        time: DateFormat(time12hFormat).format(_date),
        caller: callerId,
        type: CallReceiptType.declined,
      ),
      conversationId: _conversation.conversationId,
      receipt: Receipt.sent,
    );

    await _chatService.addMessage(_newMsg);
  }

  saveEnded(
      String callId,
      String calleeId,
      String callerId,
      String familyId,
      String me,
      ) async {
    Conversation _conversation = await _chatService.addConversation(
      Conversation(
        remoteId: me == calleeId ? callerId : calleeId,
        familyId: familyId,
      ),
    );

    DateTime _date = DateTime.now();
    Message _newMsg = Message(
      messageId: callId,
      tempId: callId,
      sentBy: callerId,
      sentAt: _date,
      type: MessageType.callReceipt,
      data: MediaContent(
        callerTitle: "Call Ended",
        calleeTitle: "Call Ended",
        time: DateFormat(time12hFormat).format(_date),
        caller: callerId,
        type: CallReceiptType.ended,
      ),
      conversationId: _conversation.conversationId,
      receipt: Receipt.sent,
    );

    await _chatService.addMessage(_newMsg);
  }
}
