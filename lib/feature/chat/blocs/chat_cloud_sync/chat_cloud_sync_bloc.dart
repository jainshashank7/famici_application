import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/feature/chat/entities/chat_media_response.dart';
import 'package:famici/feature/chat/entities/conversation.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/entities/message_media_content.dart';
import 'package:famici/feature/chat/repository/chat_service/chat_service.dart';
import 'package:famici/feature/chat/repository/chat_service/local_chat_service.dart';
import 'package:famici/repositories/barrel.dart';

part 'chat_cloud_sync_event.dart';
part 'chat_cloud_sync_state.dart';

class ChatCloudSyncBloc
    extends HydratedBloc<ChatCloudSyncEvent, ChatCloudSyncState> {
  ChatCloudSyncBloc({
    required ConnectivityBloc connectivityBloc,
  })  : _connectivityBloc = connectivityBloc,
        super(ChatCloudSyncState.initial()) {
    on<StartSyncingChatCloudSyncEvent>(_onStartSyncingChatCloudSyncEvent);
    on<SyncNextItemChatCloudSyncEvent>(_onSyncNextItemChatCloudSyncEvent);
    on<AddMessageToQueueChatCloudSyncEvent>(
        _onAddMessageToQueueChatCloudSyncEvent);
  }

  StreamSubscription? _connectivityStream;
  final ConnectivityBloc _connectivityBloc;
  final ChatService _chatService = ChatService();
  final MediaRepository _mediaRepo = MediaRepository();
  final LocalChatService _localChat = LocalChatService();
  Future<void> _onStartSyncingChatCloudSyncEvent(
    StartSyncingChatCloudSyncEvent event,
    emit,
  ) async {
    _connectivityStream = _connectivityBloc.stream.listen((event) {
      if (event.hasInternet) {
        add(SyncNextItemChatCloudSyncEvent());
      }
    });
  }

  Future<void> _onAddMessageToQueueChatCloudSyncEvent(
    AddMessageToQueueChatCloudSyncEvent event,
    emit,
  ) async {
    Map<String, Message> _offlineMessages = Map.from(state.offlineMessages);
    if (_connectivityBloc.state.hasInternet) {
      try {
        if (event.message.type == MessageType.text) {
          await _chatService.addMessage(event.message);
        } else if (event.message.type == MessageType.audio) {
          ChatMedia data = await _chatService.getMediaUploadUrl(event.message);

          dynamic resp = await _mediaRepo.uploadAudio(
            audioUrl: event.message.data.local,
            uploadUrl: data.uploadUrl,
          );
          MediaContent _msgData = event.message.data;
          _msgData = _msgData.copyWith(
            key: data.key,
            bucketName: data.bucket,
            mediaId: data.mediaId,
          );

          await _localChat.updateMessage(event.message.copyWith(
            data: _msgData,
          ));
        } else if (event.message.type == MessageType.image) {
          ChatMedia data = await _chatService.getMediaUploadUrl(event.message);
          dynamic resp = await _mediaRepo.uploadPictureToSend(
            imageUrl: event.message.data.local,
            uploadUrl: data.uploadUrl,
          );
          MediaContent _msgData = event.message.data;
          _msgData = _msgData.copyWith(
            key: data.key,
            bucketName: data.bucket,
            mediaId: data.mediaId,
          );
          await _localChat.updateMessage(event.message.copyWith(
            data: _msgData,
          ));
        }
      } catch (err) {
        _offlineMessages[event.message.messageId] = event.message;
        emit(state.copyWith(offlineMessages: _offlineMessages));
      }
    } else {
      _offlineMessages[event.message.messageId] = event.message;
      emit(state.copyWith(offlineMessages: _offlineMessages));
    }
  }

  Future<void> _onSyncNextItemChatCloudSyncEvent(
    SyncNextItemChatCloudSyncEvent event,
    emit,
  ) async {
    if (_connectivityBloc.state.hasInternet) {
      Map<String, Message> _offlineMessages = Map.from(state.offlineMessages);
      Map<String, Conversation> _conversations = Map.from(
        state.offlineConversations,
      );

      if (_offlineMessages.isNotEmpty) {
        try {
          MapEntry<String, Message> _entry = _offlineMessages.entries.first;

          if (_entry.value.type == MessageType.text) {
            await _chatService.addMessage(_entry.value);
          } else if (_entry.value.type == MessageType.audio) {
            await _chatService.addMediaMessage(_entry.value);
          }
          await _chatService.addMessage(_entry.value);
          _offlineMessages.remove(_entry.key);
          emit(state.copyWith(offlineMessages: _offlineMessages));
          add(SyncNextItemChatCloudSyncEvent());
        } catch (err) {
          add(SyncNextItemChatCloudSyncEvent());
        }
      }
    }
  }

  @override
  Future<void> close() {
    _connectivityStream?.cancel();
    return super.close();
  }

  @override
  ChatCloudSyncState? fromJson(Map<String, dynamic> json) {
    return ChatCloudSyncState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ChatCloudSyncState state) {
    return state.toJson();
  }
}
