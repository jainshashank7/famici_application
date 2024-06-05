import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/home_screen/home_screen.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/repositories/auth_repository.dart';

import '../core/screens/home_screen/widgets/web_view_for_calls.dart';
import '../core/screens/template/kiosk/entity/main_module_item.dart';
import '../feature/aws_chime/method_channel_coordinator.dart';
import '../feature/aws_chime/view_models/join_meeting_view_model.dart';
import '../feature/aws_chime/view_models/meeting_view_model.dart';
import '../feature/kiosk_generic/widgets/kiosk_scaffold.dart';

class CallingCard extends StatelessWidget {
  bool isVertical;
  String text;
  String link;
  String image;
  Color? color;
  Color? textColor;
  String phoneNumber;
  String dtmsSettings;
  String dtmsEnabled;
  bool isAudioEnabled;
  String audioFileId;

  CallingCard({
    required this.isVertical,
    required this.text,
    required this.link,
    required this.image,
    required this.color,
    required this.textColor,
    required this.phoneNumber,
    required this.dtmsSettings,
    required this.dtmsEnabled,
    required this.isAudioEnabled,
    required this.audioFileId,
    super.key,
  });

  String icon = "assets/avatar/icons/phone_icon.svg";

  @override
  Widget build(BuildContext context) {
    final joinMeetingProvider = Provider.of<JoinMeetingViewModel>(context);
    final methodChannelProvider =
        Provider.of<MethodChannelCoordinator>(context);
    final meetingProvider = Provider.of<MeetingViewModel>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    print("this is a image $color $textColor");

    return GestureDetector(
      onTap: () async {
        var audioFile = audioFileId != ""? await getDocumentUrl(audioFileId) : "";
        log("AUDIO FILE ::: $audioFile");
        fcRouter.push(LoadingRoute());
        if (!joinMeetingProvider.joinButtonClicked) {
          // Prevent multiple clicks
          joinMeetingProvider.joinButtonClicked = true;
          meetingProvider.isLoading = true;

          // Hide Keyboard
          FocusManager.instance.primaryFocus?.unfocus();
          methodChannelProvider.initializeObservers(meetingProvider);
          methodChannelProvider.initializeMethodCallHandler();

          print("DTMSENABLED ::: ${dtmsEnabled}");
          meetingProvider.phoneNumber = phoneNumber;
          meetingProvider.dtmsSettings = dtmsSettings;
          meetingProvider.dtmsEnabled = dtmsEnabled;
          meetingProvider.playAudio = isAudioEnabled;
          meetingProvider.audioSource = audioFile;
          bool isMeetingJoined = await joinMeetingProvider.joinMeeting(
              meetingProvider, methodChannelProvider);
          if (isMeetingJoined) {
            fcRouter.push(const MeetingViewRoute());
          }
          joinMeetingProvider.joinButtonClicked = false;
          meetingProvider.isLoading = false;
        }else{
          meetingProvider.stopMeeting();
          fcRouter.pop();
        }
      },
      child: meetingProvider.isLoading == true ? const LoadingScreen() : Container(
        padding: EdgeInsets.symmetric(
            horizontal: 0.02 * width, vertical: 0.03 * height),
        height: isVertical ? 0.3 * height : 0.22 * height,
        width: 0.24 * width,
        decoration: BoxDecoration(
          color: isVertical
              ? color ?? Color(0XFF5155C3)
              : color ?? Color(0XFFAC2734),
          borderRadius: BorderRadius.circular(0.02 * height),
          boxShadow: [
            BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 5,
                spreadRadius: 5,
                color: Colors.black.withOpacity(0.07)),
            BoxShadow(
                offset: Offset(0, 6),
                blurRadius: 4,
                spreadRadius: 0,
                color: Colors.white.withOpacity(0.07)),
          ],
        ),
        child: isVertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image != ""
                      ? FutureBuilder<String>(
                          future: getImageUrl(image),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                // Handle the error state
                                return SizedBox(
                                  // height: size.height * 0.04,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Icon(Icons.broken_image, size: 50 * FCStyle.fem, color: ColorPallet.kPrimaryTextColor,),
                                      Text(snapshot.error.toString()),
                                    ],
                                  ),
                                );
                              }
                            }

                            return CachedNetworkImage(
                              imageUrl: snapshot.data ?? "",
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.center,
                              // color: Colors.redAccent,
                              // progressIndicatorBuilder: (context, url, progress) {
                              //   return CupertinoActivityIndicator();
                              // },
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.0652,
                              errorWidget: (ctx, url, err) {
                                return Image.asset(
                                  "assets/icons/Phone.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width *
                                      0.0652,
                                );
                              },
                              placeholder: (context, url) => Container(
                                  decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/icons/Phone.png"),
                                ),
                              )),
                              // fit: BoxFit.cover,
                            );
                          })
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.0946,
                          width: MediaQuery.of(context).size.width * 0.0590,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color ?? Color(0XFF4448B1),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              icon,
                              height:
                                  MediaQuery.of(context).size.height * 0.04456,
                              width: MediaQuery.of(context).size.width * 0.0339,
                            ),
                          ),
                        ),
                  Expanded(
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          color: textColor ?? Colors.white,
                          fontSize: height / 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image != ""
                      ? FutureBuilder<String>(
                          future: getImageUrl(image),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                // Handle the error state
                                return SizedBox(
                                  // height: size.height * 0.04,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Icon(Icons.broken_image, size: 50 * FCStyle.fem, color: ColorPallet.kPrimaryTextColor,),
                                      Text(snapshot.error.toString()),
                                    ],
                                  ),
                                );
                              }
                            }

                            return CachedNetworkImage(
                              imageUrl: snapshot.data ?? "",
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.center,
                              // color: Colors.redAccent,
                              // progressIndicatorBuilder: (context, url, progress) {
                              //   return CupertinoActivityIndicator();
                              // },
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.0652,
                              errorWidget: (ctx, url, err) {
                                return Image.asset(
                                  "assets/icons/Phone.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width *
                                      0.0652,
                                );
                              },
                              placeholder: (context, url) => Container(
                                  decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/icons/Phone.png"),
                                ),
                              )),
                              // fit: BoxFit.cover,
                            );
                          })
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.0946,
                          width: MediaQuery.of(context).size.width * 0.0590,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color ?? Color(0XFF9A212D),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              icon,
                              height:
                                  MediaQuery.of(context).size.height * 0.04456,
                              width: MediaQuery.of(context).size.width * 0.0339,
                            ),
                          ),
                        ),
                  Expanded(
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          color: textColor ?? Colors.white,
                          fontSize: height / 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
