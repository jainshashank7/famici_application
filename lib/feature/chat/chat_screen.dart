import 'package:auto_orientation/auto_orientation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/home_screen/widgets/bottom_status_bar.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/chat/blocs/call_history_bloc/history_bloc.dart';
import 'package:famici/feature/chat/blocs/sigle_user_chat/single_user_chat_bloc.dart';
import 'package:famici/feature/chat/widgets/chat_history.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/fc_slider_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';

import '../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../shared/fc_bottom_status_bar.dart';
import '../calander/blocs/calendar/calendar_bloc.dart';
import '../calander/entities/appointments_entity.dart';
import '../member_portal/member_home.dart';
import '../video_call/blocs/user_db_bloc/user_db_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    // required this.contact,
    this.shouldOpenSession = false,
  }) : super(key: key);

  // final String contact;
  final bool shouldOpenSession;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late SingleUserChatBloc singleUserChatBloc;

  bool _isMessages = true;

  @override
  void initState() {
    context.read<ManageHistoryBloc>().add(FetchCallHistoryData());
    singleUserChatBloc = context.read<SingleUserChatBloc>();
    context.read<UserDbBloc>().add(IamOnlineUserDbEvent());
    if (widget.shouldOpenSession) {
      // singleUserChatBloc.add(
      //   SyncUserSingleUserChatEvent(widget.contact),
      // );
      // context.read<ChatBloc>().add(ViewUserMessagesChatEvent(
      //     "",// need to add conversation id
      //     screenOpened: widget.shouldOpenSession));
    }
    super.initState();
  }

  @override
  void dispose() {
    singleUserChatBloc.add(CloseSessionSingleUserChatEvent());
    AutoOrientation.landscapeAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
      builder: (context, stateM) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return LayoutBuilder(builder: (context, con) {
              return FamiciScaffold(
                resizeOnKeyboard: true,
                leading: BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
                  builder: (context, state) {
                    if (state.isRecoreded) {
                      return FCBackButton(
                        onPressed: () {
                          context
                              .read<SingleUserChatBloc>()
                              .add(DiscardVoiceRecording());
                        },
                      );
                    } else if (state.isRecording) {
                      return FCBackButton(
                        onPressed: () {
                          context
                              .read<SingleUserChatBloc>()
                              .add(StopVoiceRecording());
                        },
                      );
                    }
                    return FCBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // singleUserChatBloc.add(CloseSessionSingleUserChatEvent());
                      },
                    );
                  },
                ),
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
                        setState(() {
                          _isMessages = false;
                        });
                      },
                      onLeftTap: () {
                        setState(() {
                          _isMessages = true;
                        });
                      },
                    ),
                  ],
                ),
                bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
                child: _isMessages
                    ? BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
                  buildWhen: (previous, current) {
                    return previous.userChatStatus != current.userChatStatus;
                  },
                  builder: (context, sessionState) {
                    if (sessionState.isSessionFailed) {
                      return Center(
                        child: Text(
                          'Unable to initiate a conversation. Please check your network reachability.',
                          style: FCStyle.textStyle,
                        ),
                      );
                    } else if (sessionState.hasSession) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Stack(
                          children: [
                            ChatHistory(),
                            // BlocBuilder<SingleUserChatBloc,
                            //     SingleUserChatState>(
                            //   bloc: context.read<SingleUserChatBloc>(),
                            //   buildWhen: (prv, curr) {
                            //     return prv.recordingStatus !=
                            //         curr.recordingStatus;
                            //   },
                            //   builder:
                            //       (context, SingleUserChatState recordState) {
                            //     if (recordState.isRecording) {
                            //       return Align(
                            //         alignment: Alignment.bottomCenter,
                            //         child: TypingContainer(
                            //           child: TypingVoiceMessage(),
                            //         ),
                            //       );
                            //     } else if (recordState.isRecoreded) {
                            //       return Align(
                            //         alignment: Alignment.bottomCenter,
                            //         child: TypingContainer(
                            //           child: PreviewVoiceMessage(
                            //             url: recordState.recordedFile,
                            //           ),
                            //         ),
                            //       );
                            //     }
                            //     return Align(
                            //       alignment: Alignment.bottomCenter,
                            //       child: TypingContainer(
                            //         child: TypingTextMessage(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            // RecordingButton(
                            //   userChatBloc: context.read<SingleUserChatBloc>(),
                            // )
                          ],
                        ),
                      );
                    }
                    return LoadingScreen();
                  },
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
                                          margin: EdgeInsets.only(
                                              bottom: 1),
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
                                                      color:
                                                      Colors.black,
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
                                                      appointments[
                                                      index]
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
                                      style:
                                      TextStyle(color: Colors.black),
                                    )
                                  ],
                                ))
                                : SizedBox.shrink(),
                          ],
                        ));
                  },
                ),
              );
            });
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
}
