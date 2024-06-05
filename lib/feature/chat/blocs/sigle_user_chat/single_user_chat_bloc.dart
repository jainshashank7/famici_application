import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/chat/blocs/chat_cloud_sync/chat_cloud_sync_bloc.dart';
import 'package:famici/feature/chat/entities/conversation.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/entities/message_media_content.dart';
import 'package:famici/feature/chat/repository/chat_service/chat_service.dart';
import 'package:famici/feature/chat/repository/chat_service/local_chat_service.dart';
import 'package:famici/utils/barrel.dart';

part 'single_user_chat_event.dart';

part 'single_user_chat_state.dart';

class SingleUserChatBloc
    extends Bloc<SingleUserChatEvent, SingleUserChatState> {
  SingleUserChatBloc({
    required this.me,
    required ChatCloudSyncBloc chatCloudSyncBloc,
  })  : _chatCloudSyncBloc = chatCloudSyncBloc,
        super(SingleUserChatState.initial()) {
    on<StartVoiceRecording>(_onStartVoiceRecording);
    on<StopVoiceRecording>(_onStopVoiceRecording);
    on<DiscardVoiceRecording>(_onDiscardVoiceRecording);
    on<SendVoiceRecording>(_onSendVoiceRecording);
    on<SyncRecordingPath>(_onSyncRecordingPath);
    on<TextMessageChanged>(_onTextMessageChanged);
    on<SendTextMessage>(_onSendTextMessage);
    on<SyncLatestMessages>(_onSyncLatestMessages);
    on<SyncLatestMessagesWithConversation>(
      _onSyncLatestMessagesWithConversation,
    );
    on<_MessageReceived>(_onMessageReceived);
    on<ResetSingleUserChatEvent>(_onResetSingleUserChatEvent);
    on<SyncUserSingleUserChatEvent>(_onSyncUserSingleUserChatEvent);
    on<CloseSessionSingleUserChatEvent>(_onCloseSessionSingleUserChatEvent);
    on<SyncSessionSingleUserChatEvent>(_onSyncSessionSingleUserChatEvent);
    on<FetchMoreSingleUserChatEvent>(_onFetchMoreSingleUserChatEvent);
    on<SendImageMessage>(_onSendImageMessage);
    on<SessionInitiateFailedSingleUserChatEvent>(
        _onSessionInitiateFailedSingleUserChatEvent);
    on<SubscribedToMessagesSingleUserChatEvent>(
        _onSubscribedToMessagesSingleUserChatEvent);
    on<SetCurrentUserName>(_onSetCurrentUserName);
  }

  final User me;

  final LocalChatService _localChat = LocalChatService();
  final ChatService _chatService = ChatService();
  final ChatCloudSyncBloc _chatCloudSyncBloc;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectivitySubscription;

  Future<void> _onResetSingleUserChatEvent(
    ResetSingleUserChatEvent event,
    emit,
  ) async {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  Future<void> _onStartVoiceRecording(StartVoiceRecording event, emit) async {
    try {
      var status = await Permission.microphone.request();
      if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
        return;
      }
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
      var tempDir = await getTemporaryDirectory();
      String path =
          '${tempDir.path}/flutter_sound_${DateTime.now().millisecondsSinceEpoch}${ext[1]}';

      FlutterSoundRecorder _recorder = state.recorder;

      await _recorder.openRecorder();

      _recorder.setSubscriptionDuration(const Duration(seconds: 1));

      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.defaultCodec,
        audioSource: AudioSource.microphone,
      );

      emit(state.copyWith(
        recordingStatus: RecordingStatus.recording,
        recordedFile: path,
      ));
    } catch (err) {
      emit(state.copyWith(recordingStatus: RecordingStatus.initial));
    }
  }

  Future<void> _onStopVoiceRecording(StopVoiceRecording event, emit) async {
    FlutterSoundRecorder _recorder = state.recorder;
    await _recorder.stopRecorder();
    emit(state.copyWith(recordingStatus: RecordingStatus.done));
  }

  Future<void> _onFetchMoreSingleUserChatEvent(
      FetchMoreSingleUserChatEvent event, emit) async {
    List<Message> _messages = List.from(state.messages);

    if (state.isFetching) {
      return;
    }
    if (state.hasFetchedAll) {
      return;
    }

    emit(state.copyWith(messagesStatus: Status.loading));
    Status _status = Status.success;
    List<Message> _more = state.messages;
    try {
      _more = await _chatService.findMessages(
        state.conversation.conversationId,
        startAt: state.messages.last.messageId,
      );
      if (_more.isEmpty) {
        _more = await _localChat.findMessages(
          state.conversation.conversationId,
          offset: state.messages.length,
          limit: 50,
        );
        if (_more.isEmpty) {
          _status = Status.completed;
        } else {
          await _localChat.addBulkMessage(_more);
        }
      }

      _messages.addAll(_more);
      Map<String, Message> mapOfMessages = {
        for (var e in _messages) e.messageId: e
      };
      List<Message> sorted = mapOfMessages.values.toList();
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(
        messages: sorted,
        messagesStatus: _status,
      ));
    } catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(messages: _messages, messagesStatus: Status.success));
    }
  }

  Future<void> _onSyncUserSingleUserChatEvent(
    SyncUserSingleUserChatEvent event,
    emit,
  ) async {
    emit(state.copyWith(
      //contact: event.contact,
      userChatStatus: UserChatStatus.loading,
    ));
  }

  Future<void> _onCloseSessionSingleUserChatEvent(
    CloseSessionSingleUserChatEvent event,
    emit,
  ) async {
    emit(SingleUserChatState.initial());
  }

  Future<void> _onSessionInitiateFailedSingleUserChatEvent(
    SessionInitiateFailedSingleUserChatEvent event,
    emit,
  ) async {
    emit(state.copyWith(userChatStatus: UserChatStatus.failed));
  }

  Future<void> _onSyncSessionSingleUserChatEvent(
    SyncSessionSingleUserChatEvent event,
    emit,
  ) async {
    emit(state.copyWith(
      conversation: event.conversation,
      userChatStatus: UserChatStatus.ongoing,
    ));
    add(SyncLatestMessagesWithConversation(event.conversation));
  }

  Future<void> _onDiscardVoiceRecording(
    DiscardVoiceRecording event,
    emit,
  ) async {
    String _path = state.recordedFile;
    if (_path.isNotEmpty) {
      File _file = File(_path);
      await _file.delete(recursive: true);
    }
    emit(state.copyWith(
      recordingStatus: RecordingStatus.initial,
      recordedFile: '',
    ));
  }

  Future<void> _onSendVoiceRecording(
    SendVoiceRecording event,
    emit,
  ) async {
    List<Message> _messages = List.from(state.messages);
    Conversation _conversation = state.conversation;
    User contact = state.contact;
    DateTime _sentAt = DateTime.now();

    Message _newMsg = Message(
      sentBy: me.id,
      sentAt: _sentAt,
      type: MessageType.audio,
      data: MediaContent(local: state.recordedFile),
      receipt: Receipt.sent,
      conversationId: _conversation.conversationId,
      receivedBy: contact.id,
      familyId: contact.familyId,
    );
    String tempId = _newMsg.generateTempId();
    _newMsg = _newMsg.copyWith(messageId: tempId, tempId: tempId);
    await _localChat.addMessage(_newMsg);
    _messages.insert(0, _newMsg);
    emit(state.copyWith(
      recordingStatus: RecordingStatus.initial,
      messages: _messages,
    ));
    _chatCloudSyncBloc.add(AddMessageToQueueChatCloudSyncEvent(_newMsg));
  }

  Future<void> _onSendImageMessage(
    SendImageMessage event,
    emit,
  ) async {
    List<Message> _messages = List.from(state.messages);
    Conversation _conversation = state.conversation;
    User contact = state.contact;
    DateTime _sentAt = DateTime.now();

    Message _newMsg = Message(
      sentBy: me.id,
      sentAt: _sentAt,
      type: MessageType.image,
      data: MediaContent(local: event.localPath),
      receipt: Receipt.sent,
      conversationId: _conversation.conversationId,
      receivedBy: contact.id,
      familyId: contact.familyId,
    );
    String tempId = _newMsg.generateTempId();
    _newMsg = _newMsg.copyWith(messageId: tempId, tempId: tempId);
    await _localChat.addMessage(_newMsg);
    _messages.insert(0, _newMsg);
    emit(state.copyWith(
      recordingStatus: RecordingStatus.initial,
      messages: _messages,
    ));
    _chatCloudSyncBloc.add(AddMessageToQueueChatCloudSyncEvent(_newMsg));
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    emit,
  ) async {
    String text = state.text;
    User contact = state.contact;
    List<Message> _messages = List.from(state.messages);
    Conversation _conversation = state.conversation;

    if (text.isNotEmpty) {
      DateTime _sentAt = DateTime.now();

      Message _newMsg = Message(
        sentBy: me.id,
        sentAt: _sentAt,
        type: MessageType.text,
        text: text,
        conversationId: _conversation.conversationId,
        receipt: Receipt.sent,
        receivedBy: contact.id,
        familyId: me.familyId,
      );
      String tempId = _newMsg.generateTempId();
      _newMsg = _newMsg.copyWith(messageId: tempId, tempId: tempId);
      await _localChat.addMessage(_newMsg);
      _messages.insert(0, _newMsg);
      emit(state.copyWith(text: '', messages: _messages));
      _chatCloudSyncBloc.add(AddMessageToQueueChatCloudSyncEvent(_newMsg));
    }
  }

  Future<void> _onSyncRecordingPath(
    SyncRecordingPath event,
    emit,
  ) async {
    emit(state.copyWith(recordingStatus: RecordingStatus.initial));
  }

  Future<void> _onTextMessageChanged(
    TextMessageChanged event,
    emit,
  ) async {
    emit(state.copyWith(text: event.text));
  }

  Future<void> _onSyncLatestMessages(
    SyncLatestMessages event,
    emit,
  ) async {
    emit(state.copyWith(messagesStatus: Status.loading));
    Conversation _conversation = state.conversation;
    // add(SubscribedToMessagesSingleUserChatEvent(event.));
    List<Message> _messages = [];
    DebugLogger.info(_conversation.toJson());
    try {
      _messages = await _chatService.findMessages(
        _conversation.conversationId,
      );
      if (_messages.isNotEmpty) {
        _localChat.addBulkMessage(_messages);
      }
    } catch (err) {
      DebugLogger.error(err);
    }
    try {
      if (_messages.isEmpty) {
        _messages = await _localChat.findMessages(
          _conversation.conversationId,
          limit: 50,
        );
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    Map<String, Message> mapOfMessages = {
      for (var e in _messages) e.messageId: e
    };
    List<Message> sorted = mapOfMessages.values.toList();
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(
      messages: sorted,
      messagesStatus: Status.success,
      userChatStatus: UserChatStatus.ongoing,
    ));
  }

  Future<void> _onSyncLatestMessagesWithConversation(
    SyncLatestMessagesWithConversation event,
    emit,
  ) async {
    emit(state.copyWith(messagesStatus: Status.loading));
    Conversation conversation = event.conversation;
    add(SubscribedToMessagesSingleUserChatEvent(event.conversation));
    List<Message> messages = [];
    DebugLogger.info(conversation.toJson());
    try {
      messages = await _chatService.findMessages(
        conversation.conversationId,
      );
      if (messages.isNotEmpty) {
        _localChat.addBulkMessage(messages);
      }
    } catch (err) {
      DebugLogger.error(err);
    }
    try {
      if (messages.isEmpty) {
        messages = await _localChat.findMessages(
          conversation.conversationId,
          limit: 50,
        );
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    Map<String, Message> mapOfMessages = {
      for (var e in messages) e.messageId: e
    };

    emit(state.copyWith(
      messages: mapOfMessages.values.toList(),
      messagesStatus: Status.success,
      userChatStatus: UserChatStatus.ongoing,
    ));
  }

  Future<void> _onSubscribedToMessagesSingleUserChatEvent(
    SubscribedToMessagesSingleUserChatEvent event,
    emit,
  ) async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    Conversation conversation = event.conversation;
    if (conversation.conversationId.isNotEmpty) {
      _messageSubscription =
          _localChat.subscribedToAllMessages().listen((message) {
        if (message.conversationId == event.conversation.conversationId) {
          add(_MessageReceived(message));
        }
      });
      await _connectivitySubscription?.cancel();
      _connectivitySubscription = null;
      _connectivitySubscription = connectivityBloc.stream.listen((state) {
        if (state.hasInternet) {
          add(SubscribedToMessagesSingleUserChatEvent(event.conversation));
        }
      });
    } else {
      DebugLogger.error('Unable to stream messages without conversation Id');
    }
  }

  Future<void> _onMessageReceived(_MessageReceived event, emit) async {
    List<Message> _messages = List.from(state.messages);

    if (event.message.type == MessageType.receipt) {
      int idx = _messages.indexWhere(
        (e) =>
            e.messageId == event.message.messageId ||
            e.messageId == event.message.tempId,
      );
      if (idx > -1) {
        _messages[idx] = _messages[idx].copyWith(receipt: Receipt.delivered);
      }
    } else if (event.message.isCallReceipt) {
      int idx = _messages.indexWhere(
        (e) => e.tempId == event.message.tempId,
      );
      if (idx > -1) {
        _messages[idx] = _messages[idx].copyWith(receipt: Receipt.delivered);
      } else {
        bool shouldSort = _messages.isNotEmpty &&
            event.message.sentAt.millisecondsSinceEpoch >
                _messages.first.sentAt.millisecondsSinceEpoch;

        _messages.insert(0, event.message);
        if (shouldSort) {
          _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      }
    } else {
      int idx = _messages.indexWhere(
        (e) =>
            e.messageId == event.message.messageId ||
            e.messageId == event.message.tempId ||
            e.tempId == event.message.tempId,
      );
      if (idx > -1) {
        _messages[idx] = _messages[idx].copyWith(receipt: Receipt.delivered);
      } else {
        bool shouldSort = _messages.isNotEmpty &&
            event.message.sentAt.millisecondsSinceEpoch >
                _messages.first.createdAt.millisecondsSinceEpoch;

        _messages.insert(0, event.message);
        if (shouldSort) {
          _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      }
    }

    emit(state.copyWith(messages: _messages));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onSetCurrentUserName(
      SetCurrentUserName event, Emitter<SingleUserChatState> emit) {
    emit(state.copyWith(currentChatUser: event.username));
  }
}
