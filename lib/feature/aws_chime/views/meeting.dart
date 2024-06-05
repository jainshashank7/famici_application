/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/barrel.dart';
import 'package:famici/feature/aws_chime/views/screenshare.dart';

import '../../../../core/screens/home_screen/widgets/calling_screen.dart';
import '../chime_api.dart';
import '../logger.dart';
import '../view_models/meeting_view_model.dart';
import 'style.dart';

class MeetingViewScreen extends StatefulWidget {
  const MeetingViewScreen({Key? key}) : super(key: key);

  @override
  State<MeetingViewScreen> createState() => _MeetingViewScreenState();
}

class _MeetingViewScreenState extends State<MeetingViewScreen> {
  bool isLoop = true;
  Timer? _timer1;
  // Timer? _timer2;
  // int _counter = 0;
  bool isAnswered = false;
  var onSpeaker = false;
  var onMute = false;

  bool meetingStarted = false;

  @override
  void initState() {
    super.initState();
    _timer1 = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isAnswered) {
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
    // _timer2?.cancel();
  }

  // void startDisplaying() {
  //   setState(() {
  //     isAnswered = true;
  //     _counter = 0;
  //   });
  //   _timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       _counter++;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingViewModel>(context);
    final orientation = MediaQuery.of(context).orientation;

    if (!meetingProvider.isMeetingActive) {
      Navigator.maybePop(context);
    }

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
              width: meetingProvider.currAttendees.length >=2
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
            meetingProvider.currAttendees.length >=2 && meetingProvider.callAnswered
                ? Text(
                    meetingProvider.counter > 3599
                        ? "${Duration(seconds: meetingProvider.counter).inHours.toString().padLeft(2, '0')}:${Duration(seconds: meetingProvider.counter).inMinutes.remainder(60).toString().padLeft(2, '0')}:${Duration(seconds: meetingProvider.counter).inSeconds.remainder(60).toString().padLeft(2, '0')}"
                        : "${Duration(seconds: meetingProvider.counter).inMinutes.toString().padLeft(2, '0')}:${Duration(seconds: meetingProvider.counter).inSeconds.remainder(60).toString().padLeft(2, '0')}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: height / 35,
                    ),
                  )
                : meetingProvider.isMeetingActive ? Text(
                    "Calling...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: height / 35,
                    ),
                  ) : Text(
              "Call Ended",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: height / 35,
              ),
            ),
            meetingProvider.currAttendees.length >=2 && meetingProvider.callAnswered ?
            Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showAudioDeviceDialog(meetingProvider, context);
                          // setState(() {
                          //   onSpeaker = !onSpeaker;
                          // });
                        },
                        child: Button(
                            color: onSpeaker ?const  Color(0XFF5155C3) : Colors.white,
                            heading: onSpeaker ? "Phone" : "Speaker",
                            icon: "assets/avatar/icons/speaker_icon.svg",
                            iconColor:
                                onSpeaker ? Colors.white : const Color(0XFF5155C3)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            meetingProvider.sendLocalMuteToggle();
                            // if (onMute) {
                            //   onMute = !onMute;
                            // } else {
                            //   onMute = !onMute;
                            // }
                            // // onMute ? _startAudio(): _stopAudio();
                            onMute = !onMute;
                          });
                        },
                        child: Button(
                          color: onMute ? const Color(0XFF5155C3) : Colors.white,
                          heading: onMute ? "UnMute" : "Mute",
                          icon: onMute
                              ? "assets/avatar/icons/mute_mic.svg"
                              : "assets/avatar/icons/unmute_mic.svg",
                          iconColor: onMute ? Colors.white : const Color(0XFF5155C3),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          var data = await ChimeApi().endMeeting(meetingProvider.meetingData?.meeting.meetingId ?? "");
                          log("DATATATA ::: $data");
                          Navigator.pop(context);
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
                    onTap: () async {
                      // await meetingProvider.audioPlayer.stop();
                      // var data = await ChimeApi().endMeeting(
                      //     meetingProvider.meetingData?.meeting.meetingId ?? "");
                      // log("DATATATA ::: $data");
                      meetingProvider.stopMeeting();
                      // meetingId != null ? handleEnd(meetingId).then((value) => Navigator.pop(context)): Navigator.pop(context);
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

  //
  Widget meetingBody(Orientation orientation, MeetingViewModel meetingProvider,
      BuildContext context) {
    if (orientation == Orientation.portrait) {
      return meetingBodyPortrait(meetingProvider, orientation, context);
    } else {
      return meetingBodyLandscape(meetingProvider, orientation, context);
    }
  }

  //
  Widget meetingBodyPortrait(MeetingViewModel meetingProvider,
      Orientation orientation, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: displayVideoTiles(meetingProvider, orientation, context),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              "Attendees",
              style: TextStyle(fontSize: Style.titleSize),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: displayAttendees(meetingProvider, context),
          ),
          WillPopScope(
            onWillPop: () async {
              meetingProvider.stopMeeting();
              return true;
            },
            child: const Spacer(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: SizedBox(
              height: 50,
              width: 300,
              child: leaveMeetingButton(meetingProvider, context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> displayAttendees(
      MeetingViewModel meetingProvider, BuildContext context) {
    List<Widget> attendees = [];
    if (meetingProvider.currAttendees
        .containsKey(meetingProvider.localAttendeeId)) {
      attendees.add(localListInfo(meetingProvider, context));
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        attendees.add(remoteListInfo(meetingProvider));
      }
    }

    return attendees;
  }

  Widget localListInfo(MeetingViewModel meetingProvider, BuildContext context) {
    return ListTile(
      title: Text(
        meetingProvider.formatExternalUserId(meetingProvider
            .currAttendees[meetingProvider.localAttendeeId]?.externalUserId),
        style: const TextStyle(
          color: Colors.black,
          fontSize: Style.fontSize,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.headphones),
            iconSize: Style.iconSize,
            color: Colors.blue,
            onPressed: () {
              showAudioDeviceDialog(meetingProvider, context);
            },
          ),
          IconButton(
            icon: Icon(localMuteIcon(meetingProvider)),
            iconSize: Style.iconSize,
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            color: Colors.blue,
            onPressed: () {
              meetingProvider.sendLocalMuteToggle();
            },
          ),
          IconButton(
            icon: Icon(localVideoIcon(meetingProvider)),
            iconSize: Style.iconSize,
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            constraints: const BoxConstraints(),
            color: Colors.blue,
            onPressed: () {
              meetingProvider.sendLocalVideoTileOn();
            },
          ),
        ],
      ),
    );
  }

  Widget remoteListInfo(MeetingViewModel meetingProvider) {
    return (ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            child: Icon(
              remoteMuteIcon(meetingProvider),
              size: Style.iconSize,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
            child: Icon(
              remoteVideoIcon(meetingProvider),
              size: Style.iconSize,
            ),
          ),
        ],
      ),
      title: Text(
        meetingProvider.formatExternalUserId(meetingProvider
            .currAttendees[meetingProvider.remoteAttendeeId]?.externalUserId),
        style: const TextStyle(fontSize: Style.fontSize),
      ),
    ));
  }

  //
  Widget meetingBodyLandscape(MeetingViewModel meetingProvider,
      Orientation orientation, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: displayVideoTiles(meetingProvider, orientation, context),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Attendees",
                style: TextStyle(fontSize: Style.titleSize),
              ),
              Column(
                children: displayAttendeesLanscape(meetingProvider, context),
              ),
              WillPopScope(
                onWillPop: () async {
                  meetingProvider.stopMeeting();
                  return true;
                },
                child: const Spacer(),
              ),
              leaveMeetingButton(meetingProvider, context),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> displayAttendeesLanscape(
      MeetingViewModel meetingProvider, BuildContext context) {
    List<Widget> attendees = [];
    if (meetingProvider.currAttendees
        .containsKey(meetingProvider.localAttendeeId)) {
      attendees.add(localListInfoLandscape(meetingProvider, context));
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        attendees.add(remoteListInfoLandscape(meetingProvider));
      }
    }

    return attendees;
  }

  Widget localListInfoLandscape(
      MeetingViewModel meetingProvider, BuildContext context) {
    return SizedBox(
      width: 500,
      child: ListTile(
        title: Text(
          meetingProvider.formatExternalUserId(meetingProvider
              .currAttendees[meetingProvider.localAttendeeId]?.externalUserId),
          style: const TextStyle(
            color: Colors.black,
            fontSize: Style.fontSize,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.headphones),
              iconSize: Style.iconSize,
              color: Colors.blue,
              onPressed: () {
                showAudioDeviceDialog(meetingProvider, context);
              },
            ),
            IconButton(
              icon: Icon(localMuteIcon(meetingProvider)),
              iconSize: Style.iconSize,
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              color: Colors.blue,
              onPressed: () {
                meetingProvider.sendLocalMuteToggle();
              },
            ),
            IconButton(
              icon: Icon(localVideoIcon(meetingProvider)),
              iconSize: Style.iconSize,
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              constraints: const BoxConstraints(),
              color: Colors.blue,
              onPressed: () {
                meetingProvider.sendLocalVideoTileOn();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget remoteListInfoLandscape(MeetingViewModel meetingProvider) {
    return SizedBox(
      width: 500,
      child: ListTile(
        title: Text(
          meetingProvider.formatExternalUserId(meetingProvider
              .currAttendees[meetingProvider.remoteAttendeeId]?.externalUserId),
          style: const TextStyle(
            color: Colors.black,
            fontSize: Style.fontSize,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              child: Icon(
                remoteMuteIcon(meetingProvider),
                size: Style.iconSize,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.iconPadding),
              child: Icon(
                remoteVideoIcon(meetingProvider),
                size: Style.iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  void openFullscreenDialog(
      BuildContext context, int? params, MeetingViewModel meetingProvider) {
    Widget contentTile;

    if (Platform.isIOS) {
      contentTile = UiKitView(
        viewType: "videoTile",
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      contentTile = PlatformViewLink(
        viewType: 'videoTile',
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final AndroidViewController controller =
              PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'videoTile',
            layoutDirection: TextDirection.ltr,
            creationParams: params,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged,
          );
          controller
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      contentTile = const Text("Unrecognized Platform.");
    }

    if (!meetingProvider.isReceivingScreenShare) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MeetingViewScreen()));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                        onDoubleTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MeetingViewScreen())),
                        child: contentTile),
                  ),
                ),
              ],
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  List<Widget> displayVideoTiles(MeetingViewModel meetingProvider,
      Orientation orientation, BuildContext context) {
    Widget screenShareWidget = Expanded(
        child: videoTile(meetingProvider, context,
            isLocal: false, isContent: true));
    Widget localVideoTile =
        videoTile(meetingProvider, context, isLocal: true, isContent: false);
    Widget remoteVideoTile =
        videoTile(meetingProvider, context, isLocal: false, isContent: false);

    if (meetingProvider.currAttendees
        .containsKey(meetingProvider.contentAttendeeId)) {
      if (meetingProvider.isReceivingScreenShare) {
        return [screenShareWidget];
      }
    }

    List<Widget> videoTiles = [];

    if (meetingProvider
            .currAttendees[meetingProvider.localAttendeeId]?.isVideoOn ??
        false) {
      if (meetingProvider
              .currAttendees[meetingProvider.localAttendeeId]?.videoTile !=
          null) {
        videoTiles.add(localVideoTile);
      }
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        if ((meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]
                    ?.isVideoOn ??
                false) &&
            meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]
                    ?.videoTile !=
                null) {
          videoTiles.add(Expanded(child: remoteVideoTile));
        }
      }
    }

    if (videoTiles.isEmpty) {
      const Widget emptyVideos = Text("No video detected");
      if (orientation == Orientation.portrait) {
        videoTiles.add(
          emptyVideos,
        );
      } else {
        videoTiles.add(
          const Center(
            widthFactor: 2.5,
            child: emptyVideos,
          ),
        );
      }
    }

    return videoTiles;
  }

  Widget contentVideoTile(
      int? paramsVT, MeetingViewModel meetingProvider, BuildContext context) {
    Widget videoTile;
    if (Platform.isIOS) {
      videoTile = UiKitView(
        viewType: "videoTile",
        creationParams: paramsVT,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      videoTile = PlatformViewLink(
        viewType: 'videoTile',
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final AndroidViewController controller =
              PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'videoTile',
            layoutDirection: TextDirection.ltr,
            creationParams: paramsVT,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged,
          );
          controller
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      videoTile = const Text("Unrecognized Platform.");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 200,
        height: 230,
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenShare(paramsVT: paramsVT)));
          },
          child: videoTile,
        ),
      ),
    );
  }

  Widget videoTile(MeetingViewModel meetingProvider, BuildContext context,
      {required bool isLocal, required bool isContent}) {
    int? paramsVT;

    if (isContent) {
      if (meetingProvider.contentAttendeeId != null) {
        if (meetingProvider
                .currAttendees[meetingProvider.contentAttendeeId]?.videoTile !=
            null) {
          paramsVT = meetingProvider
              .currAttendees[meetingProvider.contentAttendeeId]
              ?.videoTile
              ?.tileId as int;
          return contentVideoTile(paramsVT, meetingProvider, context);
        }
      }
    } else if (isLocal) {
      paramsVT = meetingProvider
          .currAttendees[meetingProvider.localAttendeeId]?.videoTile?.tileId;
    } else {
      paramsVT = meetingProvider
          .currAttendees[meetingProvider.remoteAttendeeId]?.videoTile?.tileId;
    }

    Widget videoTile;
    if (Platform.isIOS) {
      videoTile = UiKitView(
        viewType: "videoTile",
        creationParams: paramsVT,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      videoTile = PlatformViewLink(
        viewType: 'videoTile',
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final AndroidViewController controller =
              PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'videoTile',
            layoutDirection: TextDirection.ltr,
            creationParams: paramsVT,
            creationParamsCodec: const StandardMessageCodec(),
          );
          controller
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      videoTile = const Text("Unrecognized Platform.");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 200,
        height: 230,
        child: videoTile,
      ),
    );
  }

  void showAudioDeviceDialog(
      MeetingViewModel meetingProvider, BuildContext context) async {
    String? device = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Choose Audio Device"),
            elevation: 40,
            titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: Style.fontSize,
                fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            children:
                getSimpleDialogOptionsAudioDevices(meetingProvider, context),
          );
        });
    if (device == null) {
      logger.w("No device chosen.");
      return;
    }

    meetingProvider.updateCurrentDevice(device);
  }

  List<Widget> getSimpleDialogOptionsAudioDevices(
      MeetingViewModel meetingProvider, BuildContext context) {
    List<Widget> dialogOptions = [];
    FontWeight weight;
    for (var i = 0; i < meetingProvider.deviceList.length; i++) {
      if (meetingProvider.deviceList[i] ==
          meetingProvider.selectedAudioDevice) {
        weight = FontWeight.bold;
      } else {
        weight = FontWeight.normal;
      }
      dialogOptions.add(
        SimpleDialogOption(
          child: Text(
            meetingProvider.deviceList[i] as String,
            style: TextStyle(color: Colors.black, fontWeight: weight),
          ),
          onPressed: () {
            logger.i("${meetingProvider.deviceList[i]} was chosen.");
            Navigator.pop(context, meetingProvider.deviceList[i]);
          },
        ),
      );
    }
    return dialogOptions;
  }

  Widget leaveMeetingButton(
      MeetingViewModel meetingProvider, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.red),
      onPressed: () async {
        await meetingProvider.audioPlayer.stop();
        meetingProvider.stopMeeting();
        // fcRouter.popAndPush(const HomeRoute());
      },
      child: const Text("Leave Meeting"),
    );
  }

  IconData localMuteIcon(MeetingViewModel meetingProvider) {
    if (!meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]!.muteStatus) {
      return Icons.mic;
    } else {
      return Icons.mic_off;
    }
  }

  IconData remoteMuteIcon(MeetingViewModel meetingProvider) {
    if (!meetingProvider
        .currAttendees[meetingProvider.remoteAttendeeId]!.muteStatus) {
      return Icons.mic;
    } else {
      return Icons.mic_off;
    }
  }

  IconData localVideoIcon(MeetingViewModel meetingProvider) {
    if (meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]!.isVideoOn) {
      return Icons.videocam;
    } else {
      return Icons.videocam_off;
    }
  }

  IconData remoteVideoIcon(MeetingViewModel meetingProvider) {
    if (meetingProvider
        .currAttendees[meetingProvider.remoteAttendeeId]!.isVideoOn) {
      return Icons.videocam;
    } else {
      return Icons.videocam_off;
    }
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
                BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
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
