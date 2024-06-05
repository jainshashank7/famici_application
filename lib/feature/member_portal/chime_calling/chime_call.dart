import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/chat/blocs/call_history_bloc/history_bloc.dart';
import 'package:famici/feature/member_portal/blocs/meeting_bloc.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/enitity/user.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../repositories/auth_repository.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../../../utils/helpers/events_track.dart';
import 'MeetingSessionCreator.dart';
import 'data/Attendee.dart';
import 'data/Attendees.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VideoCallingScreen extends StatefulWidget {
  const VideoCallingScreen({super.key});

  @override
  _VideoCallingScreenState createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  bool meetingStarted = false;
  String _version = 'Unknown';
  String _createMeetingSessionResult = 'CreateMeetingSession: Unknown';
  String _audioVideoStartResult = 'AudioVideo: Unknown';
  String _audioVideoStartLocalVideoResult = 'AudioVideoLocalVideo: Unknown';
  String _audioVideoStartRemoteVideoResult = 'AudioVideoRemoteVideo: Unknown';
  final FlutterSecureStorage _vault = FlutterSecureStorage();
  Attendees _attendees = Attendees();
  bool _isAndroidEmulator = false;
  bool _isIosSimulator = false;
  bool _isMute = true;
  bool _isVideoOff = true;
  bool _isMinimized = true;
  bool _isMeetingEnded = false;
  String userName = "";
  DateTime? startTime;

  final AuthRepository _authRepository = AuthRepository();
  Future<void> updateTimer() async {
    final prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString('sessionId') ?? "";
    String companyId = prefs.getString('companyId') ?? "";
    String clientId = prefs.getString('clientId') ?? "";
    String? accessToken = await _authRepository.generateAccessToken();

    if (accessToken != null &&
        sessionId != "" &&
        clientId != "" &&
        companyId != "") {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Accept": "application/json",
        "content-type": "application/json"
      };
      String createAppSession =
          '${ApiConfig.baseUrl}/integrations/appt-logs/${sessionId}';

      Timer.periodic(const Duration(seconds: 10), (timer) async {
        var responseSession = await http.put(Uri.parse(createAppSession),
            body: jsonEncode({}), headers: headers);
        print('heiiie yeahhh done' + responseSession.body.toString());
        if (_isMeetingEnded) {
          timer.cancel();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    _startChime();
    updateTimer();
  }

  @override
  Widget build(BuildContext context) {
    var chimeViewChildren = List<Widget>.empty(growable: true);
    var localTile;
    bool isLocalTile = false;

    // if (_attendees.length == 0)
    //   chimeViewChildren
    //       .add(Expanded(child: Center(child: Text('No attendees yet.'))));
    // else
    for (int attendeeIndex = 0;
        attendeeIndex < _attendees.length;
        attendeeIndex++) {
      ChimeAttendee attendee = _attendees[attendeeIndex];
      if (attendee.videoView != null) {
        if (attendee.isLocalTile) {
          localTile = Center(child: attendee.videoView);
          isLocalTile = true;
        } else {
          chimeViewChildren.add(Center(child: attendee.videoView));
        }
      }
    }

    final size = MediaQuery.of(context).size;

    if (chimeViewChildren.isEmpty) {
      for (int i = 0; i < 1; i++) {
        chimeViewChildren.add(
          Container(
            width: _isMinimized ? size.width * 0.2 : size.width * 0.25,
            height: _isMinimized ? size.height * 0.2 : size.height * 0.25,
            decoration: BoxDecoration(color: ColorPallet.kPrimaryGrey),
            child: Icon(
              Icons.videocam_off,
              color: ColorPallet.kPrimary,
              size: 75 * FCStyle.fem,
            ),
          ),
        );
      }
    }

    double topPadding = 0;

    if (chimeViewChildren.length == 2) {
      topPadding = _isMinimized ? size.height * 0.31 : size.height * 0.46;
    } else if (chimeViewChildren.length == 3) {
      topPadding = _isMinimized ? size.height * 0.31 : size.height * 0.3;
    }

    var chimeVideoView = Stack(
      children: [
        chimeViewChildren.isNotEmpty
            ? SizedBox(
                width: size.width,
                height: size.height,
                child: chimeViewChildren[0])
            : Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(color: ColorPallet.kPrimaryGrey),
                child: Center(
                  child: Icon(
                    Icons.videocam_off,
                    color: ColorPallet.kPrimary,
                    size: 50 * FCStyle.fem,
                  ),
                ),
              ),
        Positioned(
          right: _isMinimized ? size.width * 0.075 : 0,
          top: _isMinimized ? size.height * 0.56 : size.height * 0.71,
          child: isLocalTile
              ? SizedBox(
                  width: _isMinimized ? size.width * 0.2 : size.width * 0.25,
                  height:
                      _isMinimized ? size.height * 0.25 : size.height * 0.25,
                  child: localTile)
              : Card(
                  borderOnForeground: true,
                  color: Colors.transparent,
                  elevation: 4,
                  child: Container(
                    width: _isMinimized ? size.width * 0.2 : size.width * 0.25,
                    height:
                        _isMinimized ? size.height * 0.25 : size.height * 0.25,
                    decoration: BoxDecoration(color: ColorPallet.kPrimaryGrey),
                    child: Center(
                      child: Icon(
                        Icons.videocam_off,
                        color: ColorPallet.kPrimary,
                        size: 75 * FCStyle.fem,
                      ),
                    ),
                  ),
                ),
        ),
        chimeViewChildren.length - 1 > 0
            ? Positioned(
                right: _isMinimized ? size.width * 0.075 : 0,
                top: topPadding,
                child: Card(
                  borderOnForeground: true,
                  color: Colors.transparent,
                  elevation: 4,
                  child: SizedBox(
                    width: _isMinimized ? size.width * 0.2 : size.width * 0.25,
                    height:
                        _isMinimized ? size.height * 0.7 : size.height * 0.8,
                    child: ListView.builder(
                        itemCount: chimeViewChildren.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                              width: _isMinimized
                                  ? size.width * 0.2
                                  : size.width * 0.25,
                              height: _isMinimized
                                  ? size.height * 0.25
                                  : size.height * 0.25,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: chimeViewChildren[index + 1]));
                        }),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );

    var chimeViewColumn = chimeVideoView;

    Widget content;

    if (_isAndroidEmulator || _isIosSimulator) {
      content = const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
              child: Text(
                  'Chime does not support Android/iOS emulators/simulators.')));
    } else {
      content = BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
        bottomNavbar: _isMinimized ? stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar() : SizedBox(),
        toolbarHeight: 0,
        child: Container(
            height: FCStyle.screenHeight,
            width: FCStyle.screenWidth,
            margin: _isMinimized
                ? const EdgeInsets.only(
                    right: 20, left: 20, top: 15, bottom: 15)
                : EdgeInsets.zero,
            padding: _isMinimized
                ? EdgeInsets.all(25 * FCStyle.fem)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
                color: const Color.fromARGB(229, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: meetingStarted
                ? Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                            height: size.height,
                            width: size.width,
                            child: chimeViewColumn),
                      ),
                      // Positioned(
                      //   left: 0 * FCStyle.fem,
                      //   top: _isMinimized ? 490 * FCStyle.fem : 610 * FCStyle.fem,
                      //   child: Container(
                      //     height: 79 * FCStyle.fem,
                      //     decoration: BoxDecoration(
                      //       color: Color(0x995155C3),
                      //       borderRadius: BorderRadius.only(
                      //         topRight: Radius.circular(20 * FCStyle.fem),
                      //         bottomRight: Radius.circular(20 * FCStyle.fem),
                      //       ),
                      //     ),
                      //     padding: EdgeInsets.fromLTRB(2 * FCStyle.fem,
                      //         20 * FCStyle.fem, 15 * FCStyle.fem, 0 * FCStyle.fem),
                      //     child: Text(
                      //       userName,
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontSize: 28 * FCStyle.ffem,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        left: 0 * FCStyle.fem,
                        top: _isMinimized
                            ? 590 * FCStyle.fem
                            : 710 * FCStyle.fem,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await _handleOnLeftMeeting();
                                var properties = TrackEvents().setProperties(
                                    fromDate: '',
                                    toDate: '',
                                    reading: '',
                                    readingDateTime: '',
                                    vital: '',
                                    appointmentDate: '',
                                    appointmentTime: '',
                                    appointmentCounselors: '',
                                    appointmentType: '',
                                    callDuration: '',
                                    readingType: '');

                                TrackEvents().trackEvents(
                                    'Telehealth Video call - Call End Clicked',
                                    properties);
                              },
                              iconSize: 50,
                              icon: Image.asset(
                                AssetIconPath.callEndIcon,
                              ),
                            ),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (_isVideoOff) {
                                    _audioVideoStartLocalVideo();
                                    _isVideoOff = !_isVideoOff;
                                  } else {
                                    _audioVideoStopLocalVideo();
                                    _isVideoOff = !_isVideoOff;
                                  }
                                  var properties = TrackEvents().setProperties(
                                      fromDate: '',
                                      toDate: '',
                                      reading: '',
                                      readingDateTime: '',
                                      vital: '',
                                      appointmentDate: '',
                                      appointmentTime: '',
                                      appointmentCounselors: '',
                                      appointmentType: '',
                                      callDuration: '',
                                      readingType: '');

                                  setState(() {
                                    _isVideoOff;
                                    TrackEvents().trackEvents(
                                        "Telehealth Video call - Video ${_isVideoOff == false ? 'ON' : 'OFF'} Clicked",
                                        properties);
                                  });
                                },
                                iconSize: 40,
                                icon: _isVideoOff
                                    ? Icon(
                                        Icons.videocam_off,
                                        color: ColorPallet.kPrimary,
                                        size: 50 * FCStyle.fem,
                                      )
                                    : Icon(
                                        Icons.videocam,
                                        color: ColorPallet.kPrimary,
                                        size: 50 * FCStyle.fem,
                                      ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: IconButton(
                                  onPressed: () {
                                    if (_isMute) {
                                      _startAudio();
                                      _isMute = !_isMute;
                                    } else {
                                      _stopAudio();
                                      _isMute = !_isMute;
                                    }
                                    var properties = TrackEvents()
                                        .setProperties(
                                            fromDate: '',
                                            toDate: '',
                                            reading: '',
                                            readingDateTime: '',
                                            vital: '',
                                            appointmentDate: '',
                                            appointmentTime: '',
                                            appointmentCounselors: '',
                                            appointmentType: '',
                                            callDuration: '',
                                            readingType: '');

                                    setState(() {
                                      _isMute;
                                      TrackEvents().trackEvents(
                                          "Telehealth Video call - Mic ${_isMute == true ? 'OFF' : 'ON'} Clicked",
                                          properties);
                                    });
                                  },
                                  icon: _isMute
                                      ? Icon(
                                          Icons.mic_off_rounded,
                                          color: ColorPallet.kPrimary,
                                          size: 50 * FCStyle.fem,
                                        )
                                      : Icon(
                                          Icons.mic,
                                          color: ColorPallet.kPrimary,
                                          size: 50 * FCStyle.fem,
                                        ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: IconButton(
                                  onPressed: () {
                                    var properties = TrackEvents()
                                        .setProperties(
                                            fromDate: '',
                                            toDate: '',
                                            reading: '',
                                            readingDateTime: '',
                                            vital: '',
                                            appointmentDate: '',
                                            appointmentTime: '',
                                            appointmentCounselors: '',
                                            appointmentType: '',
                                            callDuration: '',
                                            readingType: '');

                                    TrackEvents().trackEvents(
                                        "Telehealth Video call - Screen ${_isMinimized == false ? 'Expand' : 'Minimized'} Clicked",
                                        properties);
                                    setState(() {
                                      _isMinimized = !_isMinimized;
                                    });
                                  },
                                  icon: _isMinimized
                                      ? Icon(
                                          Icons.open_in_full_outlined,
                                          color: ColorPallet.kPrimary,
                                          size: 50 * FCStyle.fem,
                                        )
                                      : Icon(
                                          Icons.close_fullscreen_outlined,
                                          color: ColorPallet.kPrimary,
                                          size: 50 * FCStyle.fem,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : LoadingScreen()),
      );
  },
);
    }

    return Column(children: [
      const SizedBox(height: 8),
      Expanded(child: content),
    ]);
  }

  void _startChime() async {
    await _getVersion();

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool isPhysicalDevice = androidInfo.isPhysicalDevice ?? false;
      if (isPhysicalDevice) {
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

  Future<void> _getVersion() async {
    String version;
    try {
      version = "v0.17.1"; //await Chime.version ?? '?';
    } on PlatformException {
      version = 'Failed to get version.';
    }

    if (mounted) {
      setState(() {
        _version = version;
      });
    }
  }

  void _addListener() {
    Chime.eventChannel.receiveBroadcastStream().listen((data) async {
      dynamic event = JsonDecoder().convert(data);
      String eventName = event['Name'];
      dynamic eventArguments = event['Arguments'];
      switch (eventName) {
        case 'OnVideoTileAdded':
          _handleOnVideoTileAdded(eventArguments);
          break;
        case 'OnVideoTileRemoved':
          _handleOnVideoTileRemoved(eventArguments);
          break;
        case 'OnVideoSessionStopped':
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
      // DebugLogger.info('Chime.eventChannel.receiveBroadcastStream().listen()/onDone()');
    }, onError: (e) {
      // DebugLogger.error('Chime.eventChannel.receiveBroadcastStream().listen()/onError()');
    });
  }

  Future<void> _createMeetingSession() async {
    if (await Permission.microphone.request().isGranted == false) {
      _createMeetingSessionResult = 'Need microphone permission.';
      FCAlert.showInfo("Microphone permission needed");
      fcRouter.pop();
      return;
    }

    if (await Permission.camera.request().isGranted == false) {
      _createMeetingSessionResult = 'Need camera permission.';
      FCAlert.showInfo("Camera permission needed");
      fcRouter.pop();
      return;
    }

    String meetingSessionState;

    try {
      meetingSessionState = await MeetingSessionCreator().create() ?? 'OK';

      await _audioVideoStart();
      await _audioVideoStartRemoteVideo();
      await _stopAudio();
      setState(() {
        meetingStarted = true;
      });
      startTime = DateTime.now();
      var properties = TrackEvents().setProperties(
          fromDate: '',
          toDate: '',
          reading: '',
          readingDateTime: startTime,
          vital: '',
          appointmentDate: '',
          appointmentTime: '',
          appointmentCounselors: '',
          appointmentType: '',
          callDuration: '',
          readingType: '');

      TrackEvents().trackEvents("Telehealth Video call - Started", properties);
    } on PlatformException catch (e) {
      meetingSessionState =
          'Failed to create MeetingSession. PlatformException: $e';
    } catch (e) {
      meetingSessionState = 'Failed to create MeetingSession. Error: $e';
    }

    if (mounted) {
      setState(() {
        _createMeetingSessionResult = meetingSessionState;
      });
    }
  }

  Future<void> _startAudio() async {
    try {
      await Chime.unmute();
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<void> _stopAudio() async {
    try {
      await Chime.mute();
    } catch (err) {
      DebugLogger.error(err);
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

    if (mounted) {
      setState(() {
        _audioVideoStartResult = result;
      });
    }
  }

  Future<void> _audioVideoStop() async {
    String result;

    try {
      result = await Chime.audioVideoStop() ?? 'OK';
      fcRouter.replaceAll([HomeRoute()]);
    } on PlatformException catch (e) {
      result = 'AudioVideoStop failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStop failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _audioVideoStartResult = result;
      });
    }
  }

  Future<void> _audioVideoStartLocalVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStartLocalVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStartLocalVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStartLocalVideo failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _audioVideoStartLocalVideoResult = result;
      });
    }
  }

  Future<void> _audioVideoStopLocalVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStopLocalVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStopLocalVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStopLocalVideo failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _audioVideoStartLocalVideoResult = result;
      });
    }
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

    if (mounted) {
      setState(() {
        _audioVideoStartRemoteVideoResult = result;
      });
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

    if (mounted) {
      setState(() {
        _audioVideoStartRemoteVideoResult = result;
      });
    }
  }

  void _handleOnVideoTileAdded(dynamic arguments) async {
    bool isLocalTile = arguments['IsLocalTile'];
    int tileId = arguments['TileId'];
    int videoStreamContentHeight = arguments['VideoStreamContentHeight'];
    int videoStreamContentWidth = arguments['VideoStreamContentWidth'];

    ChimeAttendee? attendee = _attendees.getByTileId(tileId);
    if (attendee != null) {
      // print(
      //     '_handleOnVideoTileAdded called but already mapped. TileId=${attendee.tileId}, ViewId=${attendee.viewId}, VideoView=${attendee.videoView}');
      return;
    }

    // print(
    //     '_handleOnVideoTileAdded: New attendee: TileId=$tileId => creating ChimeDefaultVideoRenderView');
    attendee = ChimeAttendee(tileId, isLocalTile);
    attendee.height = videoStreamContentHeight;
    attendee.width = videoStreamContentWidth;
    _attendees.add(attendee);

    ChimeAttendee nonNullAttendee = attendee;
    setState(() {
      nonNullAttendee.setVideoView(ChimeDefaultVideoRenderView(
          onPlatformViewCreated: (int viewId) async {
        nonNullAttendee.setViewId(viewId);
        // print(
        //     'ChimeDefaultVideoRenderView created. TileId=${nonNullAttendee.tileId}, ViewId=${nonNullAttendee.viewId}, VideoView=${nonNullAttendee.videoView} => binding');
        await Chime.bindVideoView(
            nonNullAttendee.viewId!, nonNullAttendee.tileId);
        // print(
        //     'ChimeDefaultVideoRenderView created. TileId=${nonNullAttendee.tileId}, ViewId=${nonNullAttendee.viewId}, VideoView=${nonNullAttendee.videoView} => bound');
      }));
    });
  }

  void _handleOnVideoTileRemoved(dynamic arguments) async {
    int tileId = arguments['TileId'];

    // print("%%%% cleared");
    // await Chime.clearViewIds();

    ChimeAttendee? attendee = _attendees.getByTileId(tileId);
    if (attendee == null) {
      // print(
      //     'Error: _handleOnVideoTileRemoved: Could not find attendee for TileId=$tileId');
      return;
    }

    // print(
    //     '_handleOnVideoTileRemoved: Found attendee: TileId=${attendee.tileId}, ViewId=${attendee.viewId} => unbinding');

    _attendees.remove(attendee);
    await Chime.unbindVideoView(tileId);

    // await _audioVideoStopRemoteVideo();
    await _audioVideoStartRemoteVideo();

    // if (_isVideoOff) {
    //   await _audioVideoStartLocalVideo();
    //   await _audioVideoStopLocalVideo();
    // } else {
    //   await _audioVideoStopLocalVideo();
    //   await _audioVideoStartLocalVideo();
    // }

    // print(
    //     '_handleOnVideoTileRemoved: Found attendee: TileId=${attendee.tileId}, ViewId=${attendee.viewId} => unbound');

    // setState(() {
    //
    // });
  }

  Future<void> getUserName() async {
    try {
      String userJson = await _vault.read(key: 'current_user') ?? '';

      final userJsonData = jsonDecode(userJson ?? "");
      User current = User.fromCurrentAuthUserJson(userJsonData);
      setState(() {
        userName = current.givenName ?? "";
      });
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<void> _handleOnMeetingEnded() async {
    if (!_isMeetingEnded) {
      await _audioVideoStopRemoteVideo();
      fcRouter.replaceAll([HomeRoute()]);
      FCAlert.showInfo("Meeting Ended");
      _isMeetingEnded = true;

      DateTime endTime = DateTime.now();
      var properties = TrackEvents().setProperties(
        fromDate: '',
        toDate: '',
        reading: '',
        readingDateTime: endTime,
        vital: '',
        appointmentDate: '',
        appointmentTime: '',
        appointmentCounselors: '',
        appointmentType: '',
        callDuration: endTime.difference(startTime!).inMinutes,
        readingType: '',
      );
      TrackEvents().trackEvents("Telehealth Video call Ended", properties);
    }
  }

  Future<void> _handleOnLeftMeeting() async {
    if (!_isMeetingEnded) {
      await _audioVideoStopRemoteVideo();
      await _audioVideoStop();
      await _audioVideoStopLocalVideo();
      fcRouter.replaceAll([HomeRoute()]);
      FCAlert.showInfo("You left the meeting");
      _isMeetingEnded = true;

      DateTime endTime = DateTime.now();
      var properties = TrackEvents().setProperties(
        fromDate: '',
        toDate: '',
        reading: '',
        readingDateTime: endTime,
        vital: '',
        appointmentDate: '',
        appointmentTime: '',
        appointmentCounselors: '',
        appointmentType: '',
        callDuration: endTime.difference(startTime!).inMinutes,
        readingType: '',
      );
      TrackEvents().trackEvents("Telehealth Video call Ended", properties);
    }
  }
}
