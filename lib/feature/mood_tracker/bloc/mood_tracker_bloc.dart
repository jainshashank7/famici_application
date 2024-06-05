import 'dart:async';
import 'dart:convert';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;


import '../../../core/enitity/user.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../screens/emoji_class.dart';

part 'mood_tracker_event.dart';

part 'mood_tracker_state.dart';

class MoodTrackerBloc extends Bloc<MoodTrackerEvent, MoodTrackerState> {
  MoodTrackerBloc({required User me})
      : _me = me,
        super(MoodTrackerState.initial()) {
    on<CreateMoodTrackerRecord>(_onCreateMoodTrackerRecord);
    on<UpdateEmoticon>(_onUpdateEmoticon);
    on<ChangeEmoji>(_onChangeEmoji);
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();

  Future<FutureOr<void>> _onCreateMoodTrackerRecord(
      CreateMoodTrackerRecord event, Emitter<MoodTrackerState> emit) async {
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };

      print(
          "This is createmoodrecord ::: emoticon ${state.emoticon} , tags: ${event.tags} , notes : ${event.notes}");

      var body = jsonEncode({
        "emoticons": [state.emoticon.title],
        "reasons": event.tags,
        "notes": event.notes
      });

      var responseM = await http.post(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/starkid/moodtracker/createmoodrecord/'),
          headers: headers,
          body: body);

      DebugLogger.info(responseM.statusCode);
      DebugLogger.info(responseM.body);
    }
  }

  FutureOr<void> _onUpdateEmoticon(
      UpdateEmoticon event, Emitter<MoodTrackerState> emit) {
    emit(state.copyWith(emoticon: event.emoticon));
  }


  FutureOr<void> _onChangeEmoji(ChangeEmoji event, Emitter<MoodTrackerState> emit) {

    List<EmojiWithTitle> emojiList = state.emojiList;
    emojiList[11]  = EmojiWithTitle(
        emoji: event.emoji,
        title: event.title,
        category: "negative");

    emit(state.copyWith(emojiList: emojiList));
  }



}
