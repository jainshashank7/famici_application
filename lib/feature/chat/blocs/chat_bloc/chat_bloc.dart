import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/feature/chat/blocs/chat_cloud_sync/chat_cloud_sync_bloc.dart';
import 'package:famici/feature/chat/blocs/sigle_user_chat/single_user_chat_bloc.dart';
import 'package:famici/feature/chat/entities/conversation.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/helpers/message_archive.dart';
import 'package:famici/feature/chat/helpers/message_notification_helper.dart';
import 'package:famici/feature/chat/repository/chat_service/chat_service.dart';
import 'package:famici/feature/chat/repository/chat_service/local_chat_service.dart';
import 'package:famici/feature/chat/repository/local_user_service/local_user_service.dart';
import 'package:famici/feature/video_call/blocs/user_db_bloc/user_db_bloc.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';

import '../../../../core/enitity/user.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../notification/blocs/notification_bloc/notification_bloc.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  ChatBloc({
    required User me,
    required SingleUserChatBloc singleUserChatBloc,
    required ChatCloudSyncBloc chatCloudSyncBloc,
    required NotificationBloc notificationBloc,
    required UserDbBloc userDbBloc,
    required ConnectivityBloc connectivityBloc,
  })  : _me = me,
        _singleUserChatBloc = singleUserChatBloc,
        _chatCloudSyncBloc = chatCloudSyncBloc,
        _notificationBloc = notificationBloc,
        _userDbBloc = userDbBloc,
        _connectivityBloc = connectivityBloc,
        super(ChatState.initial()) {
    on<SubscribedToMessagesChatEvent>(_onSubscribedMessagesChatEvent);
    on<_HandleReceivedMessageChatEvent>(_onHandleReceivedMessageChatEvent);
    on<ViewUserMessagesChatEvent>(_onViewUserMessagesChatEvent);
    on<SyncArchivedMessages>(_onSyncArchivedMessages);
    on<ResetChatBloc>(_onResetChatBlocChatEvent);
    on<ResubscribeChatEvent>(_onResubscribeChatEvent);
    on<ChangeBackGroundStateChatEvent>(_onChangeBackGroundStateChatEvent);
    on<CheckMessageSubscriptionEvent>(_onCheckMessageSubscriptionEvent);

    _connectivityBloc.add(ListenToConnectivityStatus());
    _connectivityBloc.add(CheckInternetConnectivity());

    _connectivityBloc.stream.listen((state) {
      Future.delayed(Duration(seconds: 0), () {
        add(ResubscribeChatEvent());
      });
    });
  }

  final LocalChatService _localChat = LocalChatService();
  final ChatService _chatService = ChatService();
  final LocalUserService _userService = LocalUserService();
  final MessageArchive _messageArchive = MessageArchive();
  final User _me;
  final SingleUserChatBloc _singleUserChatBloc;
  final ChatCloudSyncBloc _chatCloudSyncBloc;
  final NotificationBloc _notificationBloc;
  final UserDbBloc _userDbBloc;
  final ConnectivityBloc _connectivityBloc;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionListener;

  Future<void> _onCheckMessageSubscriptionEvent(
    CheckMessageSubscriptionEvent event,
    emit,
  ) async {
    if (_messageSubscription == null) {
      add(SubscribedToMessagesChatEvent());
    }
  }

  Future<void> _onResetChatBlocChatEvent(
    ResetChatBloc event,
    emit,
  ) async {
    emit(ChatState.initial());
    _singleUserChatBloc.add(ResetSingleUserChatEvent());
  }

  Future<void> _onResubscribeChatEvent(
    ResubscribeChatEvent event,
    emit,
  ) async {
    if (_me.id == null || _me.id!.isEmpty) {
      return;
    } else if (!_connectivityBloc.state.hasInternet) {
      _messageSubscription?.cancel();
      _messageSubscription = null;
      return;
    }

    await _messageSubscription?.cancel();
    _messageSubscription = null;
    add(SubscribedToMessagesChatEvent());
  }

  Future<void> _onSubscribedMessagesChatEvent(
    SubscribedToMessagesChatEvent event,
    emit,
  ) async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    _messageSubscription =
        _localChat.subscribe(contactId: _me.id).listen((message) {
      add(_HandleReceivedMessageChatEvent(message));
    }, onError: (err) async {
      await _messageSubscription?.cancel();
      _messageSubscription = null;
    });
    _chatCloudSyncBloc.add(StartSyncingChatCloudSyncEvent());
    _chatCloudSyncBloc.add(SyncNextItemChatCloudSyncEvent());
  }

  Future<void> _onChangeBackGroundStateChatEvent(
    ChangeBackGroundStateChatEvent event,
    emit,
  ) async {
    emit(state.copyWith(isAppBackground: event.isAppBackground));
  }

  Future<void> _onHandleReceivedMessageChatEvent(
    _HandleReceivedMessageChatEvent event,
    emit,
  ) async {

    Message _received = event.message;
    bool appStateIsBackground = state.isAppBackground;
    bool isOpenedChat = _singleUserChatBloc.state.conversation.conversationId ==
        _received.conversationId;
    if (!isOpenedChat && !_received.isCallReceipt && !_received.isReceipt) {
      if (event.message.sentBy != _me.id) {
        User? _user = Map.from(_userDbBloc.state.fcUsers)[event.message.sentBy];

        _notificationBloc.add(MessageReceivedNotificationEvent(event.message));

        if (!appStateIsBackground) {
          MessageNotificationHelper.notifyReceivedMessage(
            _received.copyWith(userSentBy: _user),
          );
        }
      }
    } else if (_received.isUploadReceipt) {
      Message? _updatable = await _localChat.findMessageByTempId(
        event.message.tempId,
      );
      if (_updatable != null) {
        _chatService.addMessage(_updatable.copyWith(
          data: _received.data,
        ));
      }
    } else if (!_received.isCallReceipt && !_received.isReceipt) {
      await _localChat.addMessage(event.message);
      add(ViewUserMessagesChatEvent(state.currentUserId));
      if (!isOpenedChat) {
        _notificationBloc.add(
          MessageReceivedNotificationEvent(_received),
        );
      }
    } else if (!isOpenedChat &&
        _received.isCallReceipt &&
        _received.isMissedReceipt) {
      if (_received.sentBy != _me.id) {
        _notificationBloc.add(
          MessageReceivedNotificationEvent(event.message),
        );
      }
    }
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  Future<void> _onViewUserMessagesChatEvent(
    ViewUserMessagesChatEvent event,
    emit,
  ) async {
    //family connect chat methods
    //_singleUserChatBloc.add(SyncUserSingleUserChatEvent(event.user));
    _singleUserChatBloc.add(SyncUserSingleUserChatEvent(User()));

    if (fcRouter.current.name != ChatRoute.name) {
      fcRouter.navigate(ChatRoute(//contact: event.user
          ));
    }

    try {
      //family connect chat methods
      // Map<String, String> _userToConversation = Map.from(
      //   state.usersWithConversations,
      // );
      emit(state.copyWith(
        currentUserId: event.conversationId,
      ));

      Map<String, Conversation> _conversations = Map.from(state.conversations);
      Conversation? _conversation;

      //family connect chat methods
      // if (_userToConversation[event.user.id] == null) {
      //
      //   Conversation _created = await _chatService.addConversation(Conversation(
      //     remoteId: event.user.id,
      //     familyId: _me.familyId,
      //   ));
      //
      //   _localChat.addConversation(_created);
      //   _conversations[_created.conversationId] = _created;
      //
      //   _userToConversation[event.user.id!] = _created.conversationId;
      //   _conversation = _created;
      // } else {
      //   _conversation = _conversations[_userToConversation[event.user.id]];
      // }

      Conversation _created =
          Conversation(conversationId: event.conversationId);

      // await _chatService.getFirstConversation(_me.familyId!);
      // List<String> conversations = await _chatService.findAllConversations(_me.familyId!);

      List<Message> _messages;

      if (await _isConnectedToInternet()) {
        _messages = await _chatService.findMessages(
          _created.conversationId,
        );
      } else {
        _messages = await _localChat.findMessages(event.conversationId);
      }

      _localChat.addConversation(_created);
      if (_messages.isNotEmpty) {
        _localChat.addBulkMessage(_messages);
        List<String> _messageIds = [];
        _messages.map((e) {
          if (e.readAt == 0) {
            _messageIds.add(e.messageId);
          }
        }).toList();
        if (_messageIds.isNotEmpty) {
          bool sentReadReceipt = await _chatService.sendReadReceipt(
              _created.conversationId, _messageIds);
        }
      }
      _conversations[_created.conversationId] = _created;
      _conversation = _created;


      _notificationBloc
          .add(AllMessageRemovedNotificationEvent(_created.conversationId ));
      MessageNotificationHelper.clearNotification(_created.conversationId);

      _singleUserChatBloc.add(SyncSessionSingleUserChatEvent(_conversation));
      emit(state.copyWith(
        conversations: _conversations,
      ));

    } on GraphQLResponseError catch (err) {
      fcRouter.pop();
      FCAlert.showError(err.message);
      _singleUserChatBloc.add(SessionInitiateFailedSingleUserChatEvent());
    } catch (err) {

      fcRouter.pop();
      _singleUserChatBloc.add(SessionInitiateFailedSingleUserChatEvent());
    }
  }

  Future<void> _onSyncArchivedMessages(
    SyncArchivedMessages event,
    emit,
  ) async {
    Map<String, dynamic> _archived = await _messageArchive.findAll();
    if (_archived.isNotEmpty) {
      for (var msg in _archived.values) {
        Message _message = Message.fromRawJson(msg);
        if (_message.isReceipt) {
          await _localChat.updateMessage(_message);
        } else if (_message.isCallReceipt) {
          _notificationBloc.add(MessageReceivedNotificationEvent(_message));
          await _localChat.updateMessage(_message);
        } else if (_message.isUploadReceipt) {
          Message? _toBeSent = await _localChat.findMessageByTempId(
            _message.tempId,
          );
          if (_toBeSent != null) {
            _chatCloudSyncBloc
                .add(AddMessageToQueueChatCloudSyncEvent(_toBeSent.copyWith(
              data: _message.data,
            )));
            await _localChat.updateMessage(_toBeSent);
          }
        } else if (_message.type != MessageType.unknown) {
          await _localChat.addMessage(_message);
          if (_singleUserChatBloc.state.conversation.conversationId ==
              _message.conversationId) {
            if (_message.sentBy != _me.id) {
              _notificationBloc.add(MessageReceivedNotificationEvent(_message));
            }
            _singleUserChatBloc.add(SyncLatestMessages());
          }
        }
        await _messageArchive.delete(_message.messageId);
      }
    }
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    return ChatState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _localChat.dispose();
    _messageSubscription?.cancel();
    _connectionListener?.cancel();
    return super.close();
  }
}
