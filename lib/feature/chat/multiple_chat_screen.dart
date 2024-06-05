import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/chat/blocs/chat_profile_bloc/chat_profile_bloc.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/widgets/chat_user_icon.dart';
import 'package:famici/feature/member_portal/member_home.dart';
import 'package:famici/shared/barrel.dart';

import '../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../core/router/router_delegate.dart';
import '../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../shared/famici_scaffold.dart';
import '../../utils/config/color_pallet.dart';
import '../../utils/config/famici.theme.dart';
import '../../utils/constants/assets_paths.dart';
import '../../utils/helpers/events_track.dart';
import 'blocs/call_history_bloc/history_bloc.dart';

class MultipleChatUserScreen extends StatefulWidget {
  const MultipleChatUserScreen({Key? key}) : super(key: key);

  @override
  State<MultipleChatUserScreen> createState() => _MultipleChatUserScreenState();
}

class _MultipleChatUserScreenState extends State<MultipleChatUserScreen> {
  late ScrollController _scrollController;

  bool _isMessages = true;
  // bool _isStart = true;

  @override
  void initState() {
    context.read<ManageHistoryBloc>().add(FetchCallHistoryData());
    context.read<ChatProfilesBloc>().add(FetchingChatProfiles());
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatProfilesBloc, ChatProfilesState>(
      builder: (context, chatState) {
        Widget userIconWithName(String conversationId, String providerName,
            String senderId, String profileUrl) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ChatUserIcon(
                    conversationId: conversationId,
                    senderId: senderId,
                    profileUrl: profileUrl,
                    username: providerName,
                  ),
                  SizedBox(height: FCStyle.smallFontSize),
                  Text(
                    providerName,
                    style: TextStyle(
                        fontSize: FCStyle.mediumFontSize,
                        color: ColorPallet.kDark,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }

        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
          trailing: ElevatedButton(
            // borderRadius: BorderRadius.circular(10),
            // color: Colors.white,
            onPressed: () {
              setState(() {
                fcRouter.navigate(MemberHomeRoute());
              });
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
                elevation: MaterialStatePropertyAll(20),
                shadowColor:
                    MaterialStatePropertyAll(Color.fromARGB(87, 41, 72, 152)),
                alignment: Alignment.center,
                backgroundColor: MaterialStatePropertyAll(Colors.white)),
            // defaultSize: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
              child: Text(
                'Upcoming Appointments',
                textAlign: TextAlign.center,
                style: FCStyle.textStyle.copyWith(
                    fontFamily: 'roboto',
                    fontSize: 20 * FCStyle.fem,
                    fontWeight: FontWeight.bold,
                    color: ColorPallet.kTertiary),
              ),
            ),
          ),
          topRight: const LogoutButton(),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FCSliderButton(
                borderRadius: (8 * FCStyle.fem),
                height: (60 * FCStyle.fem),
                width: (450 * FCStyle.fem),
                initialLeftSelected: _isMessages,
                leftChild: const Text("Message"),
                rightChild: const Text("Call History"),
                onRightTap: () {
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
                    TrackEvents()
                        .trackEvents('Appointment Toggle Clicked', properties);
                    _isMessages = false;
                  });
                },
                onLeftTap: () {
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
                    TrackEvents()
                        .trackEvents('Message Toggle Clicked', properties);
                    _isMessages = true;
                  });
                },
              ),
            ],
          ),
          bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
          child: _isMessages
              ? Container(
                  height: FCStyle.screenHeight * 0.9,
                  margin:
                      EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 12),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(229, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  child: chatState.conversations.length <= 0
                      ? Center(
                          child: Text(
                          "No current messages.",
                          style: TextStyle(
                              fontSize: 40 * FCStyle.ffem,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2 * FCStyle.ffem),
                        ))
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            chatState.conversations.length > 4
                                ? GestureDetector(
                                    onTap: () async {
                                      await _scrollController.animateTo(
                                        _scrollController
                                            .position.minScrollExtent,
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      );
                                      // setState(() {
                                      //   _isStart = true;
                                      // });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 270 * FCStyle.fem),
                                          child: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            size: FCStyle.xLargeFontSize,
                                            color: ColorPallet.kDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 30 * FCStyle.fem,
                            ),
                            SizedBox(
                              width: FCStyle.screenWidth * 0.75,
                              height: 270 * FCStyle.fem,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                itemCount: chatState.conversations.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: 52 * FCStyle.fem),
                                    child: userIconWithName(
                                        chatState.conversations[index],
                                        index < chatState.providersNames.length
                                            ? chatState.providersNames[index]
                                            : "",
                                        index < chatState.senderIds.length
                                            ? chatState.senderIds[index]
                                            : "",
                                        index < chatState.providerImage.length
                                            ? chatState.providerImage[index]
                                            : ""),
                                  );
                                },
                              ),
                            ),
                            chatState.conversations.length > 4
                                ? GestureDetector(
                                    onTap: () async {
                                      await _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      );
                                      // setState(() {
                                      //   _isStart = false;
                                      // });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 270 * FCStyle.fem),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: FCStyle.xLargeFontSize,
                                            color: ColorPallet.kDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                )
              : BlocBuilder<ManageHistoryBloc, ManageHistoryState>(
                  builder: (context, state) {
                    List<CallHistoryElement> appointments = state.log;

                    return Container(
                        height: FCStyle.screenHeight * 0.9,
                        margin: const EdgeInsets.only(
                            right: 20, left: 20, top: 0, bottom: 12),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(229, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 50),
                              child: (appointments.isEmpty)
                                  ? Center(
                                      child: Text(
                                        "No prior calls.",
                                        style: TextStyle(
                                            fontSize: 40 * FCStyle.ffem,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 2 * FCStyle.ffem),
                                      ),
                                    )
                                  : RawScrollbar(
                                      trackVisibility: true,
                                      radius: Radius.circular(10),
                                      thumbColor: ColorPallet.kPrimary,
                                      thickness: 5,
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                          itemCount: appointments.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 1),
                                                color: Colors.white,
                                                width: double.infinity,
                                                height: 75,
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 40),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            AssetIconPath
                                                                .telehealthIcon,
                                                            width: 40 *
                                                                FCStyle.fem,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: 14,
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            child: Text(
                                                              appointments[
                                                                      index]
                                                                  .appointmentName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 26 *
                                                                      FCStyle
                                                                          .fem,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 90,
                                                        child: Text(
                                                          formatDuration(
                                                            appointments[index]
                                                                .latestCapturedTime
                                                                .difference(
                                                                    appointments[
                                                                            index]
                                                                        .actualStartTime),
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 20 *
                                                                  FCStyle.fem,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      148,
                                                                      148,
                                                                      148),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        child: Text(
                                                          DateFormat(
                                                                  'MMM d, h:mm a')
                                                              .format(appointments[
                                                                      index]
                                                                  .actualStartTime)
                                                              .replaceAll(
                                                                  'am', 'AM')
                                                              .replaceAll(
                                                                  'pm', 'PM'),
                                                          style: TextStyle(
                                                              fontSize: 20 *
                                                                  FCStyle.fem,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      148,
                                                                      148,
                                                                      148),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 90,
                                                        child: Text(
                                                          appointments[index]
                                                              .apponitmentType
                                                              .name
                                                              .capitalize(),
                                                          style: TextStyle(
                                                              fontSize: 20 *
                                                                  FCStyle.fem,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      148,
                                                                      148,
                                                                      148),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      )
                                                    ]));
                                          }),
                                    ),
                            ),
                            state.log.length != 0
                                ? Positioned(
                                    bottom: 10,
                                    right: 50,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Total Number of Records : ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 101, 101, 101)),
                                        ),
                                        Text(
                                          state.log.length.toString(),
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ))
                                : SizedBox.shrink(),
                          ],
                        ));
                  },
                ),
        );
  },
);
      },
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60);
    final seconds = (duration.inSeconds % 60);

    final formattedHours = hours > 0 ? "${hours}h" : '';
    final formattedMinutes =
        minutes > 0 ? "${NumberFormat("0").format(minutes)}m" : '';
    final formattedSeconds =
        seconds > 0 ? "${NumberFormat("0").format(seconds)}s" : '';

    final formattedTime = "$formattedHours $formattedMinutes $formattedSeconds";
    return formattedTime != '  ' ? formattedTime : "0s";
  }
// Future<bool> _isConnectedToInternet() async {
//   return await ConnectivityWrapper.instance.isConnected;
// }
}
