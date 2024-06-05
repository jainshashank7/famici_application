import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/router/router.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../../../utils/logger/logger.dart';
import '../chime_calling/MeetingSessionData.dart';

part 'meeting_event.dart';

part 'meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  MeetingBloc({
    required User me,
  })  : _me = me,
        super(MeetingState.initial()) {
    on<FetchMeetingDetailsEvent>(_onFetchMeetingDetailsEvent);
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();
  MeetingSessionData meetingSessionData = MeetingSessionData();

  Future<FutureOr<void>> _onFetchMeetingDetailsEvent(
      FetchMeetingDetailsEvent event, Emitter<MeetingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String groupUuid = event.uuid;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String crateMeeting =
          '${ApiConfig.baseUrl}/integrations/chime-tablet/create-meeting/$groupUuid';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Accept": "application/json",
        "content-type": "application/json"
      };

      //Todo:  call first create session api
      String createAppSession = '${ApiConfig.baseUrl}/integrations/appt-logs';
      var responseSession = await http.post(Uri.parse(createAppSession),
          body: jsonEncode({"groupUuid": groupUuid}), headers: headers);
    
      Map<String, dynamic> jsonResponse = jsonDecode(responseSession.body);

      bool success = jsonResponse['sucess'];
      if (success == true) {
        // Success is true, continue to retrieve the sessionId

        int sessionId = jsonResponse['sessionId'];

        prefs.setString("sessionId", sessionId.toString());
        prefs.setString("clientId", clientId);
        prefs.setString("companyId", companyId);
      }
      bool firstSession = true;
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (timer.tick <= 450) {
          var response =
              await http.get(Uri.parse(crateMeeting), headers: headers);

          if (response.body != 'false' && firstSession) {
            firstSession = false;
            MeetingState m = MeetingState.fromJson(jsonDecode(response.body));

            meetingSessionData.setSessionData(m);

            String createAttendee =
                '${ApiConfig.baseUrl}/integrations/chime-tablet/${m.meeting.meetingId}/create-attendee/${m.attendee.externalUserId}';

            await http.get(Uri.parse(createAttendee), headers: headers);

            String waitingRoomUrl =
                '${ApiConfig.baseUrl}/integrations/chime-tablet/wait-list/${m.meeting.meetingId}/${m.attendee.externalUserId}';

            await http.put(Uri.parse(waitingRoomUrl),
                headers: headers,
                body: jsonEncode({"name": _me.name ?? "No Name"}));

            // this will you admittance response // it continues to run in the background
            bool stop = false;
            while (!stop) {
              try {
                var waitRespGet =
                    await http.get(Uri.parse(waitingRoomUrl), headers: headers);
                var data = jsonDecode(waitRespGet.body);
                if (data[0]["admittance"] == 1) {
                  //Todo second api with sessionId #joined
                  String createJoinSession =
                      '${ApiConfig.baseUrl}/integrations/appt-logs/${prefs.getString('sessionId')}';
                  var responseSession = await http.put(
                      Uri.parse(createJoinSession),
                      body: jsonEncode({"status": "joined"}),
                      headers: headers);
                 
                  stop = true;
                }
              } catch (err) {
                DebugLogger.error(err);
              }

              Logger.log("is still in waiting room $stop");
              Future.delayed(const Duration(microseconds: 1500));
            }

            // Future.delayed(const Duration(seconds: 5));
            fcRouter.popAndPush(const FullVideoCallingRoute());

            timer.cancel();
            // FCAlert

            // To get the attendee list
            // String attendeeList =
            //     '${ChimeConfig.baseUrl}/integrations/chime-tablet/${m.meeting.meetingId}/${m.attendee.attendeeId}';
            //
            // var resp = await http.get(Uri.parse(attendeeList), headers: headers);
            //
            // print(resp.body);
          }
        } else {
          timer.cancel();
        }
      });

      //  else {
      //   var initialState = MeetingState.initial();
      //   emit(state.copyWith(
      //       groupUuid: initialState.groupUuid,
      //       attendee: initialState.attendee,
      //       meeting: initialState.meeting,
      //       people: initialState.people));
      //   FCAlert.showInfo("The meeting hasn't started yet.",
      //       duration: const Duration(milliseconds: 1000));
      // }
    } else {
      Logger.error("Access token is null");
    }
  }
}
