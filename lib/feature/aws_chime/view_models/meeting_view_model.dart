/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/router/router.dart';
import '../attendee.dart';
import '../chime_api.dart';
import '../interfaces/audio_devices_interface.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../interfaces/video_tile_interface.dart';
import '../logger.dart';
import '../method_channel_coordinator.dart';
import '../response_enums.dart';
import '../video_tile.dart';

class MeetingViewModel extends ChangeNotifier
    implements
        RealtimeInterface,
        VideoTileInterface,
        AudioDevicesInterface,
        AudioVideoInterface {
  String? meetingId;

  String? transactionId;
  JoinInfo? meetingData;
  int counter = 0;
  bool isLoading = false;
  MethodChannelCoordinator? methodChannelProvider;

  String? localAttendeeId;
  String? remoteAttendeeId;
  String? contentAttendeeId;

  String? selectedAudioDevice;
  List<String?> deviceList = [];

  AudioPlayer audioPlayer = AudioPlayer();

  // AttendeeId is the key
  Map<String, Attendee> currAttendees = {};
  bool attendeeLeave = false;
  bool isReceivingScreenShare = false;
  bool isMeetingActive = false;
  Timer? callTimer;
  String? phoneNumber;
  String? dtmsSettings;
  String? dtmsEnabled;
  String? audioSource;
  bool playAudio = false;
  bool callAnswered = false;

  MeetingViewModel(BuildContext context) {
    methodChannelProvider =
        Provider.of<MethodChannelCoordinator>(context, listen: false);
  }

  //
  // ————————————————————————— Initializers —————————————————————————
  //

  void intializeMeetingData(JoinInfo meetData) {
    isMeetingActive = true;
    meetingData = meetData;
    meetingId = meetData.meeting.externalMeetingId;
    transactionId = meetData.transactionId;
    notifyListeners();
  }

  void initializeLocalAttendee() {
    if (meetingData == null) {
      logger.e(Response.null_meeting_data);
      return;
    }
    localAttendeeId = meetingData!.attendee.attendeeId;

    if (localAttendeeId == null) {
      logger.e(Response.null_local_attendee);
      return;
    }
    currAttendees[localAttendeeId!] =
        Attendee(localAttendeeId!, meetingData!.attendee.externalUserId);
    notifyListeners();
  }

  //
  // ————————————————————————— Interface Methods —————————————————————————
  //

  @override
  void attendeeDidJoin(Attendee attendee) async {
    String? attendeeIdToAdd = attendee.attendeeId;
    if (_isAttendeeContent(attendeeIdToAdd)) {
      logger.i("Content detected");
      contentAttendeeId = attendeeIdToAdd;
      if (contentAttendeeId != null) {
        currAttendees[contentAttendeeId!] = attendee;
        logger.i("Content added to the meeting");
      }
      notifyListeners();
      return;
    }

    if (attendeeIdToAdd != localAttendeeId) {
      callAnswered = true;
      await audioPlayer.setReleaseMode(ReleaseMode.release);
      await audioPlayer.stop();
      remoteAttendeeId = attendeeIdToAdd;
      if (remoteAttendeeId == null) {
        logger.e(Response.null_remote_attendee);
        return;
      }
      currAttendees[remoteAttendeeId!] = attendee;
      logger.e(
        "HELLLO ::: ${currAttendees[remoteAttendeeId]}",
      );
      logger.i(
          "${formatExternalUserId(currAttendees[remoteAttendeeId]?.externalUserId)} has joined the meeting.");
      notifyListeners();
      callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        counter++;
      });
      if (dtmsEnabled == "true") {
        await ChimeApi()
            .sendDigitsWithDelays(jsonDecode(dtmsSettings!), transactionId!);
      }
    }
  }

  // Used for both leave and drop callbacks
  @override
  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    final attIdToDelete = attendee.attendeeId;
    currAttendees.remove(attIdToDelete);
    if (didDrop) {
      logger.i(
          "${formatExternalUserId(attendee.externalUserId)} has dropped from the meeting");
    } else {
      logger.i(
          "${formatExternalUserId(attendee.externalUserId)} has left the meeting");
    }
    callTimer?.cancel();
    stopMeeting();
    counter = 0;
    notifyListeners();
  }

  @override
  void attendeeDidMute(Attendee attendee) {
    _changeMuteStatus(attendee, mute: true);
  }

  @override
  void attendeeDidUnmute(Attendee attendee) {
    _changeMuteStatus(attendee, mute: false);
  }

  @override
  void videoTileDidAdd(String attendeeId, VideoTile videoTile) {
    currAttendees[attendeeId]?.videoTile = videoTile;
    if (videoTile.isContentShare) {
      isReceivingScreenShare = true;
      notifyListeners();
      return;
    }
    currAttendees[attendeeId]?.isVideoOn = true;
    notifyListeners();
  }

  @override
  void videoTileDidRemove(String attendeeId, VideoTile videoTile) {
    if (videoTile.isContentShare) {
      currAttendees[contentAttendeeId]?.videoTile = null;
      isReceivingScreenShare = false;
    } else {
      currAttendees[attendeeId]?.videoTile = null;
      currAttendees[attendeeId]?.isVideoOn = false;
    }
    notifyListeners();
  }

  @override
  Future<void> initialAudioSelection() async {
    MethodChannelResponse? device = await methodChannelProvider
        ?.callMethod(MethodCallOption.initialAudioSelection);
    if (device == null) {
      logger.e(Response.null_initial_audio_device);
      return;
    }
    logger.i("Initial audio device selection: ${device.arguments}");
    selectedAudioDevice = device.arguments;
    notifyListeners();
  }

  @override
  Future<void> listAudioDevices() async {
    if(playAudio){
    await audioPlayer.play(UrlSource(audioSource!));
    await audioPlayer.setReleaseMode(ReleaseMode.loop);}
    MethodChannelResponse? devices = await methodChannelProvider
        ?.callMethod(MethodCallOption.listAudioDevices);

    if (devices == null) {
      logger.e(Response.null_audio_device_list);
      return;
    }
    final deviceIterable = devices.arguments.map((device) => device.toString());

    final devList = List<String?>.from(deviceIterable.toList());
    logger.d("Devices available: $devList");
    deviceList = devList;
    notifyListeners();
  }

  @override
  void updateCurrentDevice(String device) async {
    MethodChannelResponse? updateDeviceResponse = await methodChannelProvider
        ?.callMethod(MethodCallOption.updateAudioDevice, device);

    if (updateDeviceResponse == null) {
      logger.e(Response.null_audio_device_update);
      return;
    }

    if (updateDeviceResponse.result) {
      logger.i("${updateDeviceResponse.arguments} to: $device");
      selectedAudioDevice = device;
      notifyListeners();
    } else {
      logger.e("${updateDeviceResponse.arguments}");
    }
  }

  @override
  void audioSessionDidStop() {
    logger.i("Audio session stopped by AudioVideoObserver.");
    _resetMeetingValues();
  }

  //
  // —————————————————————————— Methods ——————————————————————————————————————
  //

  void _changeMuteStatus(Attendee attendee, {required bool mute}) {
    final attIdToggleMute = attendee.attendeeId;
    currAttendees[attIdToggleMute]?.muteStatus = mute;
    if (mute) {
      logger
          .i("${formatExternalUserId(attendee.externalUserId)} has been muted");
    } else {
      logger.i(
          "${formatExternalUserId(attendee.externalUserId)} has been unmuted");
    }
    notifyListeners();
  }

  void sendLocalMuteToggle() async {
    if (!currAttendees.containsKey(localAttendeeId)) {
      logger.e("Local attendee not found");
      return;
    }

    if (currAttendees[localAttendeeId]!.muteStatus) {
      MethodChannelResponse? unmuteResponse =
          await methodChannelProvider?.callMethod(MethodCallOption.unmute);
      if (unmuteResponse == null) {
        logger.e(Response.unmute_response_null);
        return;
      }

      if (unmuteResponse.result) {
        logger.i(
            "${unmuteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
        notifyListeners();
      } else {
        logger.e(
            "${unmuteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
      }
    } else {
      MethodChannelResponse? muteResponse =
          await methodChannelProvider?.callMethod(MethodCallOption.mute);
      if (muteResponse == null) {
        logger.e(Response.mute_response_null);
        return;
      }

      if (muteResponse.result) {
        logger.i(
            "${muteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
        notifyListeners();
      } else {
        logger.e(
            "${muteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
      }
    }
  }

  void sendLocalVideoTileOn() async {
    if (!currAttendees.containsKey(localAttendeeId)) {
      logger.e("Local attendee not found");
      return;
    }

    if (currAttendees[localAttendeeId]!.isVideoOn) {
      MethodChannelResponse? videoStopped = await methodChannelProvider
          ?.callMethod(MethodCallOption.localVideoOff);
      if (videoStopped == null) {
        logger.e(Response.video_stopped_response_null);
        return;
      }

      if (videoStopped.result) {
        logger.i(videoStopped.arguments);
      } else {
        logger.e(videoStopped.arguments);
      }
    } else {
      MethodChannelResponse? videoStart = await methodChannelProvider
          ?.callMethod(MethodCallOption.localVideoOn);
      if (videoStart == null) {
        logger.e(Response.video_start_response_null);
        return;
      }

      if (videoStart.result) {
        logger.i(videoStart.arguments);
      } else {
        logger.e(videoStart.arguments);
      }
    }
  }

  void stopMeeting() async {
    await audioPlayer.setReleaseMode(ReleaseMode.release);
    await audioPlayer.stop();
    currAttendees = {};
    var data =
        await ChimeApi().endMeeting(meetingData?.meeting.meetingId ?? "");
    log("DATATATA ::: $data");
    MethodChannelResponse? stopResponse =
        await methodChannelProvider?.callMethod(MethodCallOption.stop);
    if (stopResponse == null) {
      logger.e(Response.stop_response_null);
      return;
    }
    fcRouter.popAndPush(const HomeRoute());
    logger.i(stopResponse.arguments);
  }

  //
  // —————————————————————————— Helpers ——————————————————————————————————————
  //

  void _resetMeetingValues() {
    meetingId = null;
    meetingData = null;
    localAttendeeId = null;
    remoteAttendeeId = null;
    contentAttendeeId = null;
    selectedAudioDevice = null;
    deviceList = [];
    currAttendees = {};
    isReceivingScreenShare = false;
    isMeetingActive = false;
    logger.i("Meeting values reset");
    notifyListeners();
  }

  String formatExternalUserId(String? externalUserId) {
    List<String>? externalUserIdArray = externalUserId?.split("#");
    if (externalUserIdArray == null) {
      return "UNKNOWN";
    }
    String extUserId =
        externalUserIdArray.length == 2 ? externalUserIdArray[1] : "UNKNOWN";
    return extUserId;
  }

  bool _isAttendeeContent(String? attendeeId) {
    List<String>? attendeeIdArray = attendeeId?.split("#");
    return attendeeIdArray?.length == 2;
  }
}
