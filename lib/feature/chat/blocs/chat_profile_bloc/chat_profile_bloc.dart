import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:famici/feature/care_team/blocs/care_team_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/enitity/user.dart';
import '../../../../core/local_database/local_db.dart';
import '../../../../core/offline/entity/conversations.dart';
import '../../../../core/offline/local_database/users_db.dart';
import '../../entities/conversation.dart';
import '../../entities/message.dart';
import '../../repository/chat_service/chat_service.dart';
import '../../repository/chat_service/local_chat_service.dart';

part 'chat_profile_event.dart';

part 'chat_profile_state.dart';

class ChatProfilesBloc extends Bloc<ChatProfilesEvent, ChatProfilesState> {
  ChatProfilesBloc({required User me, required CareTeamBloc careTeamBloc})
      : _me = me,
        _careTeamBloc = careTeamBloc,
        super(ChatProfilesState.initial()) {
    on<FetchingChatProfiles>(_onFetchingChatProfiles);
  }

  final User _me;
  final CareTeamBloc _careTeamBloc;

  final Database _localDb = LocalDatabaseFactory.instance;

  final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
  final ChatService _chatService = ChatService();
  final LocalChatService _localChat = LocalChatService();
  late List<Message> messages;

  Future<FutureOr<void>> _onFetchingChatProfiles(
      FetchingChatProfiles event, Emitter<ChatProfilesState> emit) async {
    late List<String> providersNames = [];
    late List<String> senderIds = [];
    late List<String> providerImage = [];
    List<String> finalConversations = [];

    if (_me.familyId != null) {
      try {
        List<String> conversationIds = [];

        if (await ConnectivityWrapper.instance.isConnected) {
          try {
            conversationIds =
                await _chatService.findAllConversations(_me.familyId ?? "");
          } catch (err) {
            DebugLogger.error(err);
          }
        } else {
          conversationIds =
              await dbFactory.getConversationsByUserId(_me.id ?? "");
        }

        for (var element in conversationIds) {
          Conversation id = Conversation(conversationId: element);
          _localChat.addConversation(id);

          if (await _isConnectedToInternet()) {
            messages = await _chatService.findMessages(
              element,
            );
            if (messages.isNotEmpty) {
              _localChat.addBulkMessage(messages);
            }
          }
        }

        for (var id in conversationIds) {
          List<Map<String, dynamic>> response = await _localDb.rawQuery(
              'select sentBy from messages where conversationId = \'$id\' limit 1;');

          if (response.isNotEmpty) {
            String userId = response[0]['sentBy'];

            List<Map<String, dynamic>> nameResponse = await _localDb.rawQuery(
                'select email  from users where id = \'$userId\' limit 1;');

            try {
              if (nameResponse.isNotEmpty) {
                senderIds.add(userId);
                String email = nameResponse[0]['email'];
                finalConversations.add(id);

                List<CareTeamMember> members = _careTeamBloc.state.members;

                final member = members.firstWhere(
                  (member) => member.email == email,
                );

                providersNames.add(member.firstName ?? "");
                providerImage.add(member.profileUrl ?? "");
              }
            } catch (err) {
              DebugLogger.error(err);
            }
          }
        }

        emit(state.copyWith(
            conversations: finalConversations,
            providerImage: providerImage,
            providersNames: providersNames,
            senderIds: senderIds));

        ConversationTable conversationData = ConversationTable(
            userId: _me.id ?? "dummyId", conversationIds: conversationIds);

        dbFactory.insertConversation(conversationData);
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }
}
