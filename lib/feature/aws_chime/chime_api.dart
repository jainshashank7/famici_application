/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:convert';
import 'dart:developer';
import 'package:debug_logger/debug_logger.dart';
import 'package:famici/repositories/auth_repository.dart';

import '../../utils/config/api_config.dart';
import 'package:http/http.dart' as http;

import 'logger.dart';

class ChimeApi {
  final String _baseUrl = ApiConfig.apiUrl;
  final String _region = ApiConfig.region;
  final AuthRepository _authRepository = AuthRepository();

  Future<ApiResponse?> join(String phoneNumber) async {
    String accessToken = await _authRepository.generateAccessToken() ?? "";
    String url = "${_baseUrl}/dial?env=${ApiConfig.callEnv}&token=$accessToken";

    log(url);
    var reqBody = {
      "toNumber": phoneNumber
    };

    try {
      final http.Response response = await http.post(Uri.parse(url),body: jsonEncode(reqBody));

      logger.d("STATUS: ${response.statusCode} ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        logger.i("POST - join api call successful!");
        Map<String, dynamic> joinInfoMap = jsonDecode(response.body);
        log("JOIN INFO MAP ::: ${joinInfoMap}");
        JoinInfo joinInfo = JoinInfo.fromJson(joinInfoMap);
        return ApiResponse(response: true, content: joinInfo);
      }
    } catch (e) {
      logger.e("join request Failed. Status: ${e.toString()}");
      return ApiResponse(response: false, error: e.toString());
    }
    return null;
  }

  Future<String?> endMeeting(String meetingId)async {
    String accessToken = await _authRepository.generateAccessToken() ?? "";
    String url = "${_baseUrl}/update?env=${ApiConfig.callEnv}&token=$accessToken";

    print("HERE IS THE MEETING ID :::: $meetingId");
    var reqBody = {
      "update":"end",
      "meetingId" : meetingId,
    };

    try{
      http.Response response = await http.post(Uri.parse(url),body: jsonEncode(reqBody));
      logger.d("STATUS: ${response.statusCode} ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.statusCode.toString();
      }

    }catch(err){
      logger.e("End Meeting Request Failed :: ${err.toString()}");
      return err.toString();
    }
    return null;
  }

  Future<void> sendDigitsWithDelays(
      List<dynamic> digitsAndDelays, String transactionId) async {
    DebugLogger.warning(digitsAndDelays);
    for (var data in digitsAndDelays) {
      var digit = data['digit'];
      var delay = data['delay'];

      if (digit != null && delay != null) {
        print('Waiting $delay ms before sending digit $digit');
        await Future.delayed(Duration(milliseconds: int.parse(delay)));
        print('Sending digit $digit after $delay ms');
        handleSendDigit(digit, transactionId);
      }
    }
  }
  void handleSendDigit(String digit, String transactionId) async {
    try {

      String accessToken =await _authRepository.generateAccessToken()?? "";
      String url = "${_baseUrl}/update?env=${ApiConfig.callEnv}&token=$accessToken";
      var headers = {
        "Accept": "application/json",
        "content-type": "application/json"
      };
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'update': 'digit',
            'digit': digit,
            'transactionId': transactionId,
          }),
          headers: headers);
      var updateResponse = jsonDecode(response.body);
      print('updateResponse: $updateResponse');
      // updateAlert('Sent: $digit', 'success', 1000); // Assuming updateAlert is a function you have elsewhere
    } catch (e) {
      DebugLogger.error("GOT ERROR In sending Digits ::: ${e}");
    }
  }
  Map<String, dynamic> joinInfoToJSON(JoinInfo info) {
    Map<String, dynamic> flattenedJSON = {
      "MeetingId": info.meeting.meetingId,
      "ExternalMeetingId": info.meeting.externalMeetingId,
      "MediaRegion": info.meeting.mediaRegion,
      "AudioHostUrl": info.meeting.mediaPlacement.audioHostUrl,
      "AudioFallbackUrl": info.meeting.mediaPlacement.audioFallbackUrl,
      "SignalingUrl": info.meeting.mediaPlacement.signalingUrl,
      "TurnControlUrl": info.meeting.mediaPlacement.turnControllerUrl,
      "ExternalUserId": info.attendee.externalUserId,
      "AttendeeId": info.attendee.attendeeId,
      "JoinToken": info.attendee.joinToken
    };

    return flattenedJSON;
  }
}

class JoinInfo {
  final Meeting meeting;

  final AttendeeInfo attendee;

  final String transactionId;

  JoinInfo(this.meeting, this.attendee,this.transactionId);

  factory JoinInfo.fromJson(Map<String, dynamic> json) {
    return JoinInfo(Meeting.fromJson(json), AttendeeInfo.fromJson(json),json["dialInfo"]["SipMediaApplicationCall"]["TransactionId"]);
  }
}

class Meeting {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;

  Meeting(this.meetingId, this.externalMeetingId, this.mediaRegion, this.mediaPlacement);

  factory Meeting.fromJson(Map<String, dynamic> json) {
    // TODO zmauricv: Look into JSON Serialization Solutions
    var meetingMap = json['responseInfo']['Meeting'];

    log("MEeting Map ${meetingMap}");

    return Meeting(
      meetingMap['MeetingId'],
      meetingMap['ExternalMeetingId'],
      meetingMap['MediaRegion'],
      MediaPlacement.fromJson(json),
    );
  }
}

class MediaPlacement {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControllerUrl;

  MediaPlacement(this.audioHostUrl, this.audioFallbackUrl, this.signalingUrl, this.turnControllerUrl);

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    var mediaPlacementMap = json['responseInfo']['Meeting']['MediaPlacement'];
    return MediaPlacement(mediaPlacementMap['AudioHostUrl'], mediaPlacementMap['AudioFallbackUrl'],
        mediaPlacementMap['SignalingUrl'], mediaPlacementMap['TurnControlUrl']);
  }
}

class AttendeeInfo {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;

  AttendeeInfo(this.externalUserId, this.attendeeId, this.joinToken);

  factory AttendeeInfo.fromJson(Map<String, dynamic> json) {
    var attendeeMap = json['responseInfo']['Attendee'];

    return AttendeeInfo(attendeeMap['ExternalUserId'], attendeeMap['AttendeeId'], attendeeMap['JoinToken']);
  }
}

class ApiResponse {
  final bool response;
  final JoinInfo? content;
  final String? error;

  ApiResponse({required this.response, this.content, this.error});
}
