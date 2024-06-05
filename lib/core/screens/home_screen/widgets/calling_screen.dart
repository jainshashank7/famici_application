import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:debug_logger/debug_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eggnstone_amazon_chime/sdk/Chime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famici/core/router/router.dart';
import 'package:http/http.dart' as http;


List<Map<String, String>> digitsAndDelaysMapList = [
  {'digit': '1', 'delay': '5000'},
  {'digit': '1', 'delay': '15000'},
  {'digit': '', 'delay': ''},
  {'digit': '', 'delay': ''}
];
String dialOutApi =
    "https://mr39vfd5ml.execute-api.us-east-1.amazonaws.com/prod/dial";
String updateCallApi =
    "https://mr39vfd5ml.execute-api.us-east-1.amazonaws.com/prod/update";

var headers = {
  "Authorization":
  "eyJraWQiOiJjUWRZeFk3TDlxUVJscG5tK3V5dkFBXC9CVVVJRmYrT3RRZ0tKblFlVnJJWT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJiNWY5NzQ3MC1hMzk2LTRhMjQtYmIwYy04NzM1ZjFmMjNlMDYiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfWDduQ1BSSXRUIiwiY29nbml0bzp1c2VybmFtZSI6ImI1Zjk3NDcwLWEzOTYtNGEyNC1iYjBjLTg3MzVmMWYyM2UwNiIsIm9yaWdpbl9qdGkiOiI2MjAyZThhZC1jYTAyLTQ1YjAtOGEwMS1lNDllMWVkY2I1OWQiLCJhdWQiOiI0aXZsZWlwcjIwaThiYzBoYjhjdGc0YjRwdiIsImV2ZW50X2lkIjoiOWFkOTZhZGEtOThjNy00OGRmLWFhMjktNjU2OTMzZmIzMTYwIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE3MTA1MTE0OTEsImV4cCI6MTcxMDUxNTA5MSwiaWF0IjoxNzEwNTExNDkxLCJqdGkiOiJiYzQ2MWRjMS0yMmY2LTQwZTAtOWVmMi1hZDA1NjRiYzBkZTQiLCJlbWFpbCI6ImFzaHV0b3NoLm5hbWRldi45QGdtYWlsLmNvbSJ9.VGJ-nwiY0kwu6jEyJO0qbqPdFd0580YYinQGrEOY6fHJELlNnluPnGXE4jVxJehEJB_V6p6Wxu0sZVehv7QE-_faIwWUEUVUle2ibZOBGkQy-2FaO5TOKKeLLSXrMI630CfQq-eHeP_Ig1yuWNdkZhUYnERfctTIYKgFgVHMhBRqQpIVcANshWafMIB09JWMqZlWizeWluIIf06VGlHGe1CmbD_MGydet9OA4C1Fxw1fhDfqKoT5kqAxeLkjUMkrDPH4d6gHMuH3dCkWwT0iw_6AAEHuVzAgxNe8NRNcbOPMh6jgNFYqIZ7tbqWdtPLYmlW0HZeOWfoSi886iSxuJw",
  "Accept": "application/json",
  "content-type": "application/json"
};

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {

  bool isLoop = true;
  Timer? _timer1;
  Timer? _timer2;
  int _counter = 0;
  bool isAnswered = false;
  var onSpeaker = false;
  var onMute = false;

  bool meetingStarted = false;

  bool _isAndroidEmulator = false;
  bool _isIosSimulator = false;
  bool _isMute = false;
  var transactionId;
  var meetingId;

  bool _dtmsFlag = false;

  bool _isMeetingEnded = false;

  @override
  void initState() {
    super.initState();
    _startChime();
    _timer1 = Timer.periodic(Duration(seconds: 1), (timer) {
      if(isAnswered) {
        timer.cancel();
      }
      setState(() {
        isLoop = !isLoop;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer1?.cancel();
    _timer2?.cancel();
  }

  void _startDisplaying() {
    setState(() {
      isAnswered = true;
      _counter = 0;
    });
    _timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });
    });
  }

  // Future<void> updateTimer() async {
  //   String? accessToken = await _authRepository.generateAccessToken();
  //   print('access token :: $accessToken');
  //   if (accessToken != null) {
  //     var headers = {
  //       // "Authorization": accessToken,
  //       'Authorization':
  //           'eyJraWQiOiJjUWRZeFk3TDlxUVJscG5tK3V5dkFBXC9CVVVJRmYrT3RRZ0tKblFlVnJJWT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJiNWY5NzQ3MC1hMzk2LTRhMjQtYmIwYy04NzM1ZjFmMjNlMDYiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfWDduQ1BSSXRUIiwiY29nbml0bzp1c2VybmFtZSI6ImI1Zjk3NDcwLWEzOTYtNGEyNC1iYjBjLTg3MzVmMWYyM2UwNiIsIm9yaWdpbl9qdGkiOiJmYmZjNzRiNi1hZDhkLTQ2MWEtODRmNy0zNjZiNmE4MDVlYWUiLCJhdWQiOiI0aXZsZWlwcjIwaThiYzBoYjhjdGc0YjRwdiIsImV2ZW50X2lkIjoiNmE0MGJkNWEtNjZlOS00ODlmLWFhM2MtZGNmMzMzZDIwNGVlIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE3MDk5MzIxOTUsImV4cCI6MTcwOTkzNTc5NSwiaWF0IjoxNzA5OTMyMTk1LCJqdGkiOiIxOTA1YmQyZS1iODVkLTRmYWItOWY0ZS1jZmNjYjViYjEyMWMiLCJlbWFpbCI6ImFzaHV0b3NoLm5hbWRldi45QGdtYWlsLmNvbSJ9.Z7zgYsxlK8mvW_3yavRnM9iIkU1vF8zuwhcUwrTZRHLR5ivQs_YhbWbxSY20ndO2OMoy6zG43yEj1o0x2NlNPVilrwZ2BPJ8-FkM8haRIEuP6PukY-H8Ru_Id3a4lcp4RXGASgFCHGXlmsk_xdNZHfvoLCIxpYMNT4mh7kOqq2pXjKwf5tuKKI5eRWEzt0mV3PrGjCag0SRcrSyxrei7BCwTm6ilP7xn3qMPmKYX3Jq7dK9pJFDZfEjY2dEufomIp6DFEQLxFSUtKp4Ts5gD1A6a-zlxEr-UmSqsGq5NFxzhL4NekcrM3pBg5emNGu9-KAbn3ubj11UFHoftgIuAnQ',
  //       "Accept": "application/json",
  //       "content-type": "application/json"
  //     };
  //     String createAppSession =
  //         'https://mr39vfd5ml.execute-api.us-east-1.amazonaws.com/prod/dial';

  //     var responseSession = await http.post(Uri.parse(createAppSession),
  //         body: jsonEncode({"toNumber": "+919111530281"}), headers: headers);
  //     print('heiiie yeahhh done' + jsonEncode(jsonDecode(responseSession.body)["responseInfo"]).toString());
  //   }
  // }

  Future<void> _getVersion() async {
    String version;
    try {
      version = "v0.17.1"; //await Chime.version ?? '?';
    } on PlatformException {
      version = 'Failed to get version.';
    }

    if (mounted) {}
  }

  void _startChime() async {
    await _getVersion();

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool isPhysicalDevice = androidInfo.isPhysicalDevice ?? false;
      if (isPhysicalDevice) {
        print('going inside createMeeting');
        _addListener();
        await _createMeetingSession();
      } else {
        setState(() {
          _isAndroidEmulator = true;
        });
      }
    } else if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        _addListener();
        await _createMeetingSession();
      } else {
        setState(() {
          _isIosSimulator = true;
        });
      }
    } else {
      _addListener();
      await _createMeetingSession();
    }
  }

  Future<void> _stopAudio() async {
    try {
      await Chime.mute();
    } catch (err) {
      // DebugLogger.error(err);
    }
  }

  Future<void> _audioVideoStart() async {
    String result;

    try {
      result = await Chime.audioVideoStart() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStart failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStart failed: Error: $e';
    }

    if (mounted) {}
  }
  Future<void> _audioVideoStop() async {
    String result;

    try {
      result = await Chime.audioVideoStop() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStart failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStart failed: Error: $e';
    }

    if (mounted) {}
  }

  Future<void> _createMeetingSession() async {
    String meetingSessionState;

    try {

      String createAppSession =
          'https://mr39vfd5ml.execute-api.us-east-1.amazonaws.com/prod/dial';
      var responseSession = await http.post(Uri.parse(createAppSession),
          body: jsonEncode({"toNumber": '+919340016492'}), headers: headers); //
      Map<String, dynamic> jsonResponse = jsonDecode(responseSession.body);

      print('meeting start :: ${jsonResponse['responseInfo']}');

      transactionId =
      jsonResponse['dialInfo']['SipMediaApplicationCall']['TransactionId'];
      DebugLogger.warning("TransactionID ::: $transactionId");
      meetingId = jsonResponse['responseInfo']['Meeting']['MeetingId'];

      // var value = await service.createMeeting(
      //   // clientRequestToken: UUID.getUUID(),
      //   meetingHostId:jsonResponse['responseInfo']['Meeting']['MeetingId'],
      //   externalMeetingId: jsonResponse['responseInfo']['Meeting']['ExternalMeetingId'],
      //   mediaRegion: jsonResponse['responseInfo']['Meeting']['MediaRegion'],
      //   // notificationsConfiguration: AWSCHIME.MeetingNotificationConfiguration().snsTopicArn,
      // );
      // DebugLogger.warning(value);
      // DebugLogger.warning(value.meeting);
      var value = await Chime.createMeetingSession(
        meetingId: jsonResponse['responseInfo']['Meeting']['MeetingId'] ?? '',
        //currentMeeting.meeting.meetingId,
        externalMeetingId:
        jsonResponse['responseInfo']['Meeting']['ExternalMeetingId'] ?? '',
        mediaRegion:
        jsonResponse['responseInfo']['Meeting']['MediaRegion'] ?? '',
        mediaPlacementAudioHostUrl: jsonResponse['responseInfo']['Meeting']
        ['MediaPlacement']['AudioHostUrl'] ??
            '',
        mediaPlacementAudioFallbackUrl: jsonResponse['responseInfo']['Meeting']
        ['MediaPlacement']['AudioFallbackUrl'] ??
            '',
        mediaPlacementSignalingUrl: jsonResponse['responseInfo']['Meeting']
        ['MediaPlacement']['SignalingUrl'] ??
            '',
        mediaPlacementTurnControlUrl: jsonResponse['responseInfo']['Meeting']
        ['MediaPlacement']['TurnControlUrl'] ??
            '',
        attendeeId:
        jsonResponse['responseInfo']['Attendee']['AttendeeId'] ?? '',
        externalUserId:
        jsonResponse['responseInfo']['Attendee']['ExternalUserId'] ?? '',
        joinToken: jsonResponse['responseInfo']['Attendee']['JoinToken'] ?? '',
      );
      DebugLogger.info(value);
      meetingSessionState = value ?? 'OK';
      print('checking meeting start');

      setState(() {
        meetingStarted = true;
      });

      print('meetingState :: $value');
      _addListener();
      await _audioVideoStart();
      _audioVideoStartRemoteVideo().then((value) {
        // setState(() {
        //   isAnswered = true;
        // });
        Future.delayed(Duration(seconds: 7),(){
          _startDisplaying();
          if (_dtmsFlag) {
            print("SENDING DIGITS WITH DELAYs");
            sendDigitsWithDelays(digitsAndDelaysMapList, transactionId);
          }
        });
      });
      // await _stopAudio();

    } on PlatformException catch (e) {
      meetingSessionState =
      'Failed to create MeetingSession. PlatformException: $e';
      DebugLogger.debug('Failed to create MeetingSession. Error: $e');
    } catch (e) {
      DebugLogger.debug('Failed to create MeetingSession. Error: $e');
      meetingSessionState = 'Failed to create MeetingSession. Error: $e';
    }

    if (mounted) {}
  }

  Future<void> sendDigitsWithDelays(
      List<Map<String, String>> digitsAndDelays, String transactionId) async {
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
    // event.preventDefault(); // This is for a browser event, which isn't relevant in Flutter
    try {
      var response = await http.post(Uri.parse(updateCallApi),
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

  Future<void> handleEnd(String meetingId) async {
    try {
      await _audioVideoStop();
      var response = await http.post(Uri.parse(updateCallApi),
          body: jsonEncode({
            'update': 'end',
            'meetingId': meetingId,
          }),headers: headers);
      var updateResponse = jsonDecode(response.body);
      print('updateResponseEndMeeting: $updateResponse');
    } catch (e) {
      DebugLogger.error("GOT ERROR WHILE MAKIN END CALL UPDATE ::: ${e}");
    }
  }

  void _addListener() {
    Chime.eventChannel.receiveBroadcastStream().listen((data) async {
      print('WebSocket :: ${data.toString()}');
      dynamic event = JsonDecoder().convert(data);
      String eventName = event['Name'];
      dynamic eventArguments = event['Arguments'];
      DebugLogger.info("EVENT NAME ;;;; ${eventName}");
      switch (eventName) {
      // case 'OnVideoTileAdded':
      //   _handleOnVideoTileAdded(eventArguments);
      //   break;
      // case 'OnVideoTileRemoved':
      //   _handleOnVideoTileRemoved(eventArguments);
      //   break;
        case 'OnVideoSessionStopped':
          DebugLogger.debug("VIDEO SESSION STOPPED");
          _handleOnMeetingEnded();
          break;
        default:
        // print(
        //     'Chime.eventChannel.receiveBroadcastStream().listen()/onData()');
        // print('Warning: Unhandled event: $eventName');
        // print('Data: $data');
          break;
      }
    }, onDone: () {
      DebugLogger.info(
          'Chime.eventChannel.receiveBroadcastStream().listen()/onDone()');
    }, onError: (e) {
      DebugLogger.error(
          'Chime.eventChannel.receiveBroadcastStream().listen()/onError()');
    }, cancelOnError: false);
  }

  Future<void> _handleOnMeetingEnded() async {
    if (!_isMeetingEnded) {
      print("INSIDE Handle Meeting Ended");
      await _audioVideoStopRemoteVideo();
      _isMeetingEnded = true;

      DateTime endTime = DateTime.now();
      Navigator.pop(context);
      fcRouter.replaceAll([HomeRoute()]);
    }
  }

  Future<void> _audioVideoStopRemoteVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStopRemoteVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStopRemoteVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStopRemoteVideo failed: Error: $e';
    }

    if (mounted) {}
  }

  Future<void> _audioVideoStartRemoteVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStartRemoteVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStartRemoteVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStartRemoteVideo failed: Error: $e';
    }

    if (mounted) {}
  }

  Future<void> _startAudio() async {
    try {
      await Chime.unmute();
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/calling_background.png"),
              opacity: 0.9,
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              margin: EdgeInsets.only(bottom: 0.02 * height),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: isAnswered
                  ? 0.18 * width
                  : isLoop
                      ? 0.18 * width
                      : 0.16 * width,
              height: 0.22 * width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFFE0EEFF),
                  border: Border.all(
                    color: const Color(0XFF5155C3),
                    width: 2,
                  )),
              child: Center(
                child: Container(
                    padding: EdgeInsets.only(bottom: 0.025 * width),
                    width: 0.15 * width,
                    height: 0.2 * width,
                    decoration: BoxDecoration(
                        color: const Color(0XFF5155C3), shape: BoxShape.circle),
                    child: Image.asset(
                      "assets/avatar/icons/support_agent.png",
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            Text(
              "Support Agent",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: height / 25,
              ),
            ),
            SizedBox(
              height: 0.01 * height,
            ),
            isAnswered
                ? Text(
                    _counter > 3599 ? "${Duration(seconds: _counter).inHours.toString().padLeft(2, '0')}:${Duration(seconds: _counter).inMinutes.remainder(60).toString().padLeft(2, '0')}:${Duration(seconds: _counter).inSeconds.remainder(60).toString().padLeft(2, '0')}" : "${Duration(seconds: _counter).inMinutes.toString().padLeft(2, '0')}:${Duration(seconds: _counter).inSeconds.remainder(60).toString().padLeft(2, '0')}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: height / 35,
                    ),
                  )
                : Text(
                    "Calling...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: height / 35,
                    ),
                  ),
            isAnswered
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            onSpeaker = !onSpeaker;
                          });
                        },
                        child: Button(
                            color: onSpeaker ? Color(0XFF5155C3) : Colors.white,
                            heading: onSpeaker ? "Phone" : "Speaker",
                            icon: "assets/avatar/icons/speaker_icon.svg",
                            iconColor: onSpeaker ? Colors.white : Color(0XFF5155C3)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (onMute) {
                              _startAudio();
                              onMute = !onMute;
                            } else {
                              _stopAudio();
                              onMute = !onMute;
                            }
                            // onMute ? _startAudio(): _stopAudio();
                            // onMute = !onMute;
                          });
                        },
                        child: Button(
                          color: onMute ? Color(0XFF5155C3) : Colors.white,
                          heading: onMute ? "UnMute" : "Mute",
                          icon: onMute ? "assets/avatar/icons/mute_mic.svg" : "assets/avatar/icons/unmute_mic.svg",
                          iconColor: onMute ? Colors.white : Color(0XFF5155C3),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // setState(() {
                            meetingId != null ? handleEnd(meetingId).then((value) => Navigator.pop(context)): Navigator.pop(context);
                          // });
                        },
                        child: Button(
                            color: Color(0XFFAC2734),
                            heading: "End Call",
                            icon: "assets/avatar/icons/end_call.svg",
                            iconColor: Colors.white),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      meetingId != null ? handleEnd(meetingId).then((value) => Navigator.pop(context)): Navigator.pop(context);
                      // setState(() {
                      //   fcRouter.pop();
                      // });
                    },
                    child: Button(
                        color: Color(0XFFAC2734),
                        heading: "End Call",
                        icon: "assets/avatar/icons/end_call.svg",
                        iconColor: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}


class Button extends StatelessWidget {
  Color color;
  Color iconColor;
  String icon;
  String heading;

  Button(
      {required this.color,
        required this.iconColor,
        required this.icon,
        required this.heading,
        super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(
                0.025 * width, 0.1 * height, 0.025 * width, 0.025 * height),
            padding: EdgeInsets.all(0.015 * width),
            width: 0.08 * width,
            height: 0.08 * width,
            decoration:
            BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.16)),
            ]),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              icon,
              color: iconColor,
              height: 0.045 * width,
              width: 0.045 * width,
            )),
        Text(
          heading,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: height / 35,
          ),
        ),
      ],
    );
  }
}


