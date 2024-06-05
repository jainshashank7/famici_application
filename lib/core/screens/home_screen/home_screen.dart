import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/core/screens/home_screen/widgets/message_button.dart';
import 'package:famici/core/screens/home_screen/widgets/user_profile.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/care_team/company_logo_bloc/company_logo_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/member_profile/blocs/member_profile_bloc.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';
import 'package:famici/utils/barrel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import '../../../feature/care_team/blocs/care_team_bloc.dart';
import '../../../feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import '../../../feature/kiosk_generic/widgets/custom_in_app_webview.dart';
import '../../../feature/kiosk_generic/widgets/kiosk_scaffold.dart';
import '../../../feature/kiosk_generic/widgets/pdf_viewer_screen.dart';
import '../../../feature/maintenance/bloc/maintenance_bloc.dart';
import '../../../repositories/auth_repository.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/helpers/widget_key.dart';
import '../../enitity/user.dart';
import '../../offline/local_database/user_photos_db.dart';
import '../../router/router_delegate.dart';
import '../template/kiosk/kiosk_screen.dart';
import 'widgets/barrel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewPlusController? _webViewController;
  bool _isWebView = true;
  var _isListening = false;
  String _text = 'Hi';
  String _finalText = '';
  SpeechToText speech = SpeechToText();

  double height = 150;
  double webViewWidth = 125;
  double micHeight = -30;
  var micRight = 90;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    initializeDatabases();
    context.read<CareTeamBloc>().add(const GetCareTeamMembers());
    context.read<MaintenanceBloc>().add(CheckUpdates());
    super.initState();
  }

  final ScrollController scroll = ScrollController();
  GlobalKey<_BottomWidgetsState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            previous.user.email != current.user.email,
        builder: (context, state) {
          return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
            builder: (context, stateM) {
              // print("this is current screen id ${stateM.templateId}");
              if (stateM.templateId == 2) {
                fcRouter.replaceAll([FCHomeRoute()]);
              } else if (stateM.templateId == 3) {
                fcRouter.replaceAll([CustomerSupportHomeRoute()]);
              }
              return BlocBuilder<MemberProfileBloc, MemberProfileState>(
                  builder: (context, appState) {
                if (appState.coreApps.careAssistant == false) {
                  webViewWidth = 15;
                } else if (webViewWidth == 15) {
                  webViewWidth = 100;
                }
                return BlocListener<ManageRemindersBloc, ManageRemindersState>(
                    listener: (context, state) {
                      if (state.additionStatus == EventStatus.success) {
                        FCAlert.showSuccess(
                            '${state.isEvent! ? 'Event ' : 'Reminder '}Successfully created');
                        context.read<CalendarBloc>().add(
                            FetchCalendarDetailsEvent(
                                context.read<CalendarBloc>().state.startDate,
                                context.read<CalendarBloc>().state.endDate));
                        state.additionStatus = EventStatus.initial;
                      }
                      if (state.editionStatus == EventStatus.success) {
                        FCAlert.showSuccess(
                            '${state.isEvent! ? 'Event ' : 'Reminder '}Successfully edited');
                        context.read<CalendarBloc>().add(
                            FetchCalendarDetailsEvent(
                                context.read<CalendarBloc>().state.startDate,
                                context.read<CalendarBloc>().state.endDate));
                        context
                            .read<CalendarBloc>()
                            .add(FetchThisWeekAppointmentsCalendarEvent());
                        state.editionStatus = EventStatus.initial;
                      }
                      if (state.deletionStatus == EventStatus.success) {
                        FCAlert.showSuccess(
                            '${state.isEvent! ? 'Event ' : 'Reminder '}Successfully deleted');
                        context.read<CalendarBloc>().add(
                            FetchCalendarDetailsEvent(
                                context.read<CalendarBloc>().state.startDate,
                                context.read<CalendarBloc>().state.endDate));
                        state.deletionStatus = EventStatus.initial;
                      }
                      if (state.additionStatus == EventStatus.failure) {
                        FCAlert.showError(
                            (state.isEvent! ? 'Event ' : 'Reminder ') +
                                'Addition falied');
                        state.additionStatus = EventStatus.initial;
                      }
                      if (state.deletionStatus == EventStatus.failure) {
                        FCAlert.showError(
                            (state.isEvent! ? 'Event ' : 'Reminder ') +
                                'Deletion falied');
                        state.deletionStatus = EventStatus.initial;
                      }
                      if (state.editionStatus == EventStatus.failure) {
                        FCAlert.showError(
                            '${state.isEvent! ? 'Event ' : 'Reminder '}Edition failed');
                        state.editionStatus = EventStatus.initial;
                      }
                    },
                    child: BlocListener<CalendarBloc, CalendarState>(
                        listener: (context, state) {
                          if (state.additionStatus == EventStatus.success) {
                            FCAlert.showSuccess(
                                'Calendar Link Successfully created');

                            state.additionStatus = EventStatus.initial;
                          }
                          if (state.editionStatus == EventStatus.success) {
                            FCAlert.showSuccess('Calendar Successfully edited');

                            state.editionStatus = EventStatus.initial;
                          }
                          if (state.deletionStatus == EventStatus.success) {
                            FCAlert.showSuccess(
                                'Calendar Successfully deleted');

                            state.deletionStatus = EventStatus.initial;
                          }
                          if (state.additionStatus == EventStatus.failure) {
                            FCAlert.showError('Calendar Addition falied');
                            state.additionStatus = EventStatus.initial;
                          }
                          if (state.deletionStatus == EventStatus.failure) {
                            FCAlert.showError('Calendar Deletion falied');
                            state.deletionStatus = EventStatus.initial;
                          }
                          if (state.editionStatus == EventStatus.failure) {
                            FCAlert.showError('Calendar Edition falied');
                            state.editionStatus = EventStatus.initial;
                          }
                        },
                        child: FamiciScaffold(
                          backgroundImage: stateM.themeData.background,
                          title: const GreetingWithTime(),
                          topRight: const LogoutButton(),
                          trailing: const MessageButton(),
                          leading:
                              BlocBuilder<CompanyLogoBloc, CompanyLogoState>(
                                  builder: (context, photoState) {
                            // log("this is is logo :: ${stateM.themeData.logo}");
                            // log("this is is logo 2:: ${photoState.companyUrl}");
                            return Container(
                              // color: Colors.grey,
                              height: 250 * FCStyle.fem,
                              width: 500 * FCStyle.fem,
                              alignment: Alignment.centerLeft,
                              child: photoState.companyUrl != ""
                                  ? CachedNetworkImage(
                                      height: 250 * FCStyle.fem,
                                      // width: 500 * FCStyle.fem,
                                      fit: BoxFit.fill,
                                      imageUrl: photoState.companyUrl ?? "",
                                      placeholder: (context, url) => SizedBox(
                                        height: 70 * FCStyle.fem,
                                        child: Shimmer.fromColors(
                                            baseColor: ColorPallet.kWhite,
                                            highlightColor:
                                                ColorPallet.kPrimaryGrey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.photo,
                                                  size: 50 * FCStyle.fem,
                                                ),
                                              ],
                                            )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        DashboardIcons.mobexNewLogoVertical,
                                        fit: BoxFit.contain,
                                      ),
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration:
                                          const Duration(milliseconds: 100),
                                    )
                                  : Image.asset(
                                      DashboardIcons.mobexNewLogoVertical,
                                      fit: BoxFit.contain,
                                    ),
                            );
                          }),
                          bottomNavbar: const FCBottomStatusBar(),
                          child: Stack(
                            children: [
                              Positioned(
                                  left: 17 * FCStyle.fem,
                                  top: 0,
                                  child: const UserProfile()),
                              Positioned(
                                  right: 23 * FCStyle.fem,
                                  top: 0,
                                  child: ((stateM.dashboardBuilder.li
                                                  .items['LI 4'] !=
                                              null)) &&
                                          (stateM.dashboardBuilder.li
                                                  .items['LI 4']!.name! ==
                                              'Care Team')
                                      ? SizedBox(
                                          height: _isWebView
                                              ? 494 * FCStyle.fem
                                              : 474 * FCStyle.fem,
                                          child:
                                              CareTeam(isWebView: _isWebView))
                                      : const SizedBox()),
                              Positioned(
                                  left: 628 * FCStyle.fem,
                                  top: 0,
                                  child: ((stateM.dashboardBuilder.li
                                                  .items['LI 3'] !=
                                              null)) &&
                                          (stateM.dashboardBuilder.li
                                                  .items['LI 3']!.name! ==
                                              'Scheduling')
                                      ? const AppointmentsWidget()
                                      : const SizedBox()),
                              Positioned(
                                top: 150 * FCStyle.fem,
                                left: 5 * FCStyle.fem,
                                child: ((stateM.dashboardBuilder.li
                                                .items['LI 5'] !=
                                            null)) &&
                                        (stateM.dashboardBuilder.li
                                                .items['LI 5']!.name! ==
                                            'Vitals')
                                    ? BlocBuilder<VitalsAndWellnessBloc,
                                        VitalsAndWellnessState>(
                                        builder: (context, state) {
                                          return GestureDetector(
                                            onTap: () {
                                              fcRouter.navigate(
                                                  const VitalsAndWellnessRoute());
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: VitalsSlider(
                                                key: FCElementID
                                                    .homeScreenVitalsSlider,
                                                vitals: state.vitalList,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : (((stateM.dashboardBuilder.li
                                                    .items['LI 5'] !=
                                                null)) &&
                                            (stateM.dashboardBuilder.li
                                                    .items['LI 5']!.name! ==
                                                'Medication')
                                        ? BlocBuilder<MedicationBloc,
                                            MedicationState>(
                                            buildWhen: (prev, cur) =>
                                                cur.status ==
                                                    MedicationStatus.success &&
                                                prev.status != cur.status,
                                            builder: (context, state) {
                                              return GestureDetector(
                                                onTap: () {
                                                  fcRouter.navigate(
                                                      const MyMedicineRoute());
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: MedicationSlider(
                                                    meds: state.medicationList,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : const SizedBox()),
                              ),
                              Positioned(
                                top: 150 * FCStyle.fem,
                                left: 299 * FCStyle.fem,
                                child: ((stateM.dashboardBuilder.li
                                                .items['LI 6'] !=
                                            null)) &&
                                        (stateM.dashboardBuilder.li
                                                .items['LI 6']!.name! ==
                                            'Medication')
                                    ? BlocBuilder<MedicationBloc,
                                        MedicationState>(
                                        buildWhen: (prev, cur) =>
                                            cur.status ==
                                                MedicationStatus.success &&
                                            prev.status != cur.status,
                                        builder: (context, state) {
                                          return GestureDetector(
                                            onTap: () {
                                              fcRouter.navigate(
                                                  const MyMedicineRoute());
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 17.0),
                                              child: MedicationSlider(
                                                meds: state.medicationList,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : (((stateM.dashboardBuilder.li
                                                    .items['LI 6'] !=
                                                null)) &&
                                            (stateM.dashboardBuilder.li
                                                    .items['LI 6']!.name! ==
                                                'Vitals')
                                        ? BlocBuilder<VitalsAndWellnessBloc,
                                            VitalsAndWellnessState>(
                                            builder: (context, state) {
                                              return GestureDetector(
                                                onTap: () {
                                                  fcRouter.navigate(
                                                      const VitalsAndWellnessRoute());
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 17.0),
                                                  child: VitalsSlider(
                                                    key: FCElementID
                                                        .homeScreenVitalsSlider,
                                                    vitals: state.vitalList,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : const SizedBox()),
                              ),
                              // Positioned(
                              //   top: 315 * FCStyle.fem,
                              //   left: 610 * FCStyle.fem,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(left: 12.0),
                              //     child: ReminderSlider(
                              //       reminders: const [
                              //         "Lexapro Oral will run out in 5 days",
                              //         "Documents needing signature",
                              //         "New documents uploaded "
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Positioned(
                                  left: 18 * FCStyle.fem,
                                  bottom: 10,
                                  width: MediaQuery.of(context).size.width -
                                      webViewWidth,
                                  height: 120,
                                  child: BottomWidgets(
                                    clientId:
                                        state.user.customAttribute2.userId,
                                    companyId:
                                        state.user.customAttribute2.companyId,
                                    key: globalKey,
                                    scroll: scroll,
                                    isAvatar: appState.coreApps.careAssistant,
                                  )),
                              Positioned(
                                right: 20,
                                bottom: 10,
                                child: Visibility(
                                  visible: _isWebView &&
                                      appState.coreApps.careAssistant,
                                  child: Material(
                                    shape: const CircleBorder(
                                        side: BorderSide.none),
                                    elevation: 15,
                                    child: CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            webViewWidth = 309;
                                            _isWebView = !_isWebView;
                                            height = 150;
                                            micHeight = -30;
                                            micRight = 90;
                                            globalKey.currentState?.scrollAct();
                                          });
                                        },
                                        icon:
                                            // Lottie.asset(
                                            //   'assets/icons/lottie/message.json',width: 46,
                                            // fit: BoxFit.cover)

                                            SvgPicture.asset(
                                          DashboardIcons.avatarMessage,
                                          color: ColorPallet.kTertiary,
                                          width: 46,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: Visibility(
                                    visible: !_isWebView &&
                                        appState.coreApps.careAssistant,
                                    child: SizedBox(
                                      height: height,
                                      width: webViewWidth,
                                      child: IgnorePointer(
                                        ignoring: _isWebView,
                                        child: WebViewPlus(
                                          debuggingEnabled: true,
                                          backgroundColor:
                                              Color.fromARGB(0, 226, 58, 58),
                                          serverPort: 5353,
                                          allowsInlineMediaPlayback: true,
                                          initialMediaPlaybackPolicy:
                                              AutoMediaPlaybackPolicy
                                                  .always_allow,
                                          javascriptChannels: {
                                            JavascriptChannel(
                                                name: 'Height',
                                                onMessageReceived:
                                                    (JavascriptMessage
                                                        message) {
                                                  setState(() {
                                                    height = double.parse(
                                                        message.message);
                                                    if (height == 300) {
                                                      micHeight = 25;
                                                      micRight = 104;
                                                      height = 180;
                                                      webViewWidth = 309;
                                                    } else if (height == 700) {
                                                      micHeight = 280;
                                                      webViewWidth = 309;

                                                      micRight = 107;
                                                    } else if (height == 200) {
                                                      height = 150;
                                                      micHeight = -35;
                                                      micRight = 90;
                                                      webViewWidth = 309;
                                                    } else if (height == 500) {
                                                      height = 290;
                                                      micHeight = 23;
                                                      micRight = 104;
                                                      webViewWidth = 309;
                                                    }
                                                  });
                                                }),
                                            JavascriptChannel(
                                                name: 'Id',
                                                onMessageReceived:
                                                    (JavascriptMessage
                                                        message) {
                                                  List<String> ids = message
                                                      .message
                                                      .split("+");
                                                  String id = ids[0].trim();
                                                  switch (id) {
                                                    case "medication":
                                                      fcRouter.navigate(
                                                          MyMedicineRoute());
                                                      break;
                                                    case "mp":
                                                      fcRouter.navigate(
                                                          MemberHomeRoute());
                                                      break;
                                                    case "vitals":
                                                      fcRouter.navigate(
                                                          VitalsAndWellnessRoute());
                                                      break;
                                                    default:
                                                      DebugLogger.warning(
                                                          "not implemented");
                                                      break;
                                                  }
                                                }),
                                            JavascriptChannel(
                                                name: 'Close',
                                                onMessageReceived:
                                                    (JavascriptMessage
                                                        message) {
                                                  if (message.message ==
                                                      'close') {
                                                    setState(() {
                                                      _isWebView = !_isWebView;
                                                      webViewWidth = 100;
                                                      globalKey.currentState
                                                          ?.scrollBack();
                                                    });
                                                  }
                                                }),
                                            JavascriptChannel(
                                                name: 'Mic',
                                                onMessageReceived:
                                                    (JavascriptMessage
                                                        message) {})
                                          },
                                          initialUrl: Avatar.avatar,
                                          onWebViewCreated: (controller) {
                                            _webViewController = controller;
                                          },
                                          onPageFinished: (url) {
                                            var primary = ColorPallet
                                                .kPrimary.value
                                                .toRadixString(16);
                                            var secondary = ColorPallet.kPrimary
                                                .withOpacity(0.2)
                                                .value
                                                .toRadixString(16);
                                            var tertiary = ColorPallet
                                                .kTertiary.value
                                                .toRadixString(16);
                                            var m =
                                                'setDynamicColor("#${primary.substring(2, primary.length)}","#${secondary.substring(2, secondary.length)}20","#${tertiary.substring(2, tertiary.length)}")';
                                            // var m =
                                            //     'setDynamicColor("#${tertiary.substring(2, tertiary.length)}","#${secondary.substring(2, secondary.length)}20","#${primary.substring(2, primary.length)}")';
                                            _webViewController!
                                                .webViewController
                                                .runJavascript(m);
                                          },
                                          javascriptMode:
                                              JavascriptMode.unrestricted,
                                        ),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  right: micRight.toDouble(),
                                  bottom: micHeight,
                                  child: Visibility(
                                    visible: !_isWebView,
                                    child: AvatarGlow(
                                        endRadius: 75.0,
                                        animate: _isListening,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        glowColor: Colors.blueGrey,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 100),
                                        repeat: true,
                                        child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: toggleRecording,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 23,
                                              child: _isListening
                                                  ? Icon(Icons.mic_none,
                                                      size: 30,
                                                      color:
                                                          ColorPallet.kTertiary)
                                                  : SvgPicture.asset(
                                                      DashboardIcons.avatarMic,
                                                      width: 25,
                                                    ),
                                            ))),
                                  )),
                            ],
                          ),
                        )));
              });
            },
          );
        });
  }

  Future toggleRecording() => Speech.toggleRecording(
      onResult: (String text) => setState(() {
            height = 150;
            webViewWidth = 309;
            micHeight = -30;
            micRight = 90;
            _text = text;
          }),
      onListening: (bool isListening) {
        setState(() {
          this._isListening = isListening;
        });
        if (!isListening) {
          _finalText = _text;
          Future.delayed(const Duration(milliseconds: 1000), () {
            var m = 'listenData("${_finalText}")';

            _webViewController?.webViewController.runJavascript(m);
          });
        }
      });

  initializeDatabases() async {
    final AuthRepository authRepository = AuthRepository();
    User current = await authRepository.currentUser();

    final prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('${current.id}_appointments') ?? "";

    context.read<NotificationBloc>().add(OnSetNotificationsEvent(response));

    // await DatabaseHelperForMedication.initDb(current.id);
    await DatabaseHelperForMemories.initDb(current.id);
  }
}

class Speech {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording(
      {required Function(String text) onResult,
      bool isInAppListening = false,
      required ValueChanged<bool> onListening}) async {
    final isAvailable = await _speech.initialize(
        onStatus: (status) => onListening(_speech.isListening),
        onError: (error) => DebugLogger.error('Error $error'));

    if (_speech.isListening || isInAppListening) {
      _speech.stop();
      return true;
    }

    if (isAvailable) {
      _speech.listen(onResult: (value) {
        onResult(value.recognizedWords);
      });
    }

    return isAvailable;
  }
}

class BottomWidgets extends StatefulWidget {
  const BottomWidgets(
      {Key? key,
      required this.scroll,
      required this.isAvatar,
      required this.clientId,
      required this.companyId})
      : super(key: key);
  final ScrollController scroll;
  final bool isAvatar;
  final String clientId;
  final String companyId;

  @override
  State<BottomWidgets> createState() => _BottomWidgetsState();
}

class _BottomWidgetsState extends State<BottomWidgets> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
        builder: (context, memberState) {
      return ListView.builder(
          controller: widget.scroll,
          scrollDirection: Axis.horizontal,
          reverse: false,
          itemCount: memberState.dashboardBuilder.gsi.items.keys.length,
          itemBuilder: (BuildContext context, int index) {
            String key =
                memberState.dashboardBuilder.gsi.items.keys.elementAt(index);

            // print("btm widgte ${memberState.dashboardBuilder.gsi.items[key]}");
            if (memberState.dashboardBuilder.gsi.items[key] == null) {
              return SizedBox.shrink();
            } else {
              return BottomWidgetItem(
                clientId: widget.clientId,
                companyId: widget.companyId,
                app: memberState.dashboardBuilder.gsi.items[key]!,
                isAvatar: widget.isAvatar,
              );
            }
          });
    });
  }

  scrollAct() {
    widget.scroll.animateTo(widget.scroll.position.pixels,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  scrollBack() {
    widget.scroll.animateTo(widget.scroll.position.pixels,
        duration: Duration(microseconds: 500), curve: Curves.linear);
  }
}

class BottomWidgetItem extends StatelessWidget {
  BottomWidgetItem(
      {Key? key,
      required this.app,
      required this.isAvatar,
      required this.clientId,
      required this.companyId})
      : super(key: key);

  final DashboardItem app;
  final String companyId;
  final String clientId;
  final bool isAvatar;

  final AuthRepository _authRepository = AuthRepository();

  Future<String> getImageUrl(String fileId) async {
    String? accessToken = await _authRepository.generateAccessToken();
    var headers;
    if (accessToken != null) {
      headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };
    } else {
      headers = {};
    }
    print("this is 3rdparty data file id " + fileId);
    var imageBody = json.encode({
      "fileIds": [fileId]
    });
    if (accessToken != null) {
      try {
        var responseImages = await http.post(
            Uri.parse(
                '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
            body: imageBody,
            headers: headers);

        var reponseImageData = json.decode(responseImages.body);
        if (responseImages.statusCode == 200 ||
            responseImages.statusCode == 201) {
          print("this is 3rdparty data one " +
              reponseImageData["data"][0]["image"]);
          return reponseImageData["data"][0]["image"];
        } else {
          print("this is 3rdparty data no data  two ");
          return "";
        }
      } catch (e) {
        print("this is 3rdparty data no data error " + e.toString());
        DebugLogger.error(e);
        return "";
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    String image = "";
    dynamic route;
    // log("3pd in gsi ${app.type} appName ${app.name} ${app.toString()}");
    if (app.type == "core") {
      switch (app.name) {
        case 'Entertainment':
          name = 'Entertainment';
          image = DashboardIcons.Entertainment;
          route = const GamesSelectionRoute();
          break;
        case 'Content & Education':
          name = 'Content & Education';
          image = DashboardIcons.ContentAndEductation;
          route = const HealthyHabitsRoute();
          break;
        case "Let's Connect":
          name = 'Let\'s Connect';
          image = DashboardIcons.letConnect;
          route = const MultipleChatUserRoute();
          break;
        case 'Web Links':
          name = 'Web Links';
          image = DashboardIcons.webLinks;
          route = const InternetRoute();
          break;
        case 'RSS FEED':
          name = 'RSS Feed';
          image = DashboardIcons.webLinks;
          route = const RssFeedRoute();
          break;
        case 'Photos':
          name = 'Photos';
          image = DashboardIcons.photos;
          route = const FamilyMemoriesRoute();
          break;
        case 'Vitals':
          name = 'remove';
          break;
        case 'Scheduling':
          name = 'remove';
          break;
        case 'Care Assistant':
          name = 'remove';
          break;
        case 'Medication':
          name = 'remove';
          break;
        case 'Care Team':
          name = 'remove';
          break;
        default:
          name = "AlreadyAdded ${app.name}";
      }
    } else if (app.name == "Dashboard") {
      name = app.link ?? "Dashboard";
      image = app.fileId ?? "";
      route = "kiosk";
    } else if (app.type == "Mood Tracker") {
      name = "Mood Tracker";
      route = MoodTrackerRoute(title: "Mood Tracker");
      image = DashboardIcons.moodTracker;
    } else if (app.type == "Education") {
      name = "Education";
      route = EducationRoute(title: "Education");
      image = DashboardIcons.education;
    }
    else {
      // print("hey this is total " + app.toString());
      // var im = "";
      // getImageUrl(app.fileId!).then((value) {
      //   print(value + "this is data nnnn");
      //   im = value;
      // });
      // // if (im == "") {
      //   image = app.image!;
      //   print("this is 3rdparty data taking from image data " +
      //       app.type.toString() +
      //       " " +
      //       image!);
      // } else {
      image = app.image!;
      print("this is 3rdparty data brining from the device" +
          app.type.toString() +
          " " +
          image);
      // }
      name = app.name;
    }

    return name != "remove"
        ? BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
            builder: (sensContext, sensState) {
            return GestureDetector(
              onTap: () async {


                 if (app.type == "core" || name == "Mood Tracker" || name == "Education") {
                  if (route != null) {
                    fcRouter.navigate(route);
                  }
                } else if (app.type == "pdf") {
                  String? fileLink;
                  if (app.documentId != null && app.documentId != "") {
                    fileLink = await getDocumentUrl(app.documentId!);
                    print("this is file link $fileLink");
                  }
                  if (app.isSensitive) {
                    debugPrint(
                        "App Type : ${app.type} || Starting the sensitive timer");
                    sensState.st = St.reset;
                    context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(
                        context: context,
                        sensitiveScreenTimeOut:
                            app.sensitiveScreenTimeOut ?? 30,
                        sensitiveAlertTimeOut:
                            app.sensitiveAlertTimeOut ?? 15));
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PdfViewerScreen(
                            pdfUrl: fileLink ?? app.link!,
                            pdfTitle: app.name,
                            isSensitive: app.isSensitive,
                            sensitiveScreenTimeOut:
                                app.sensitiveScreenTimeOut ?? 30,
                            sensitiveAlertTimeOut:
                                app.sensitiveAlertTimeOut ?? 15);
                      },
                    ),
                  );
                }
                // else if (app.type == "module") {
                //   print("clicked on it module");
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => KioskSubDashboard(
                //               title: app.name,
                //               id: int.parse(app.id),
                //               color: app.color != null
                //                   ? app.color!
                //                   : ColorPallet.kPrimary,
                //               textColor: app.textColor != null
                //                   ? app.textColor!
                //                   : ColorPallet.kPrimaryColor,
                //             )),
                //   );
                // }
                else if (app.type == "video" || app.type == "link") {
                  String? fileLink;
                  if (app.documentId != null) {
                    fileLink = await getDocumentUrl(app.documentId!);
                    print("this is file link $fileLink");
                  }
                  if (app.isSensitive) {
                    debugPrint(
                        "App Type : ${app.type} || Starting the sensitive timer");
                    sensState.st = St.reset;
                    context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(
                        context: context,
                        sensitiveScreenTimeOut:
                            app.sensitiveScreenTimeOut ?? 30,
                        sensitiveAlertTimeOut:
                            app.sensitiveAlertTimeOut ?? 15));
                  }
                  Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return KioskScaffold(
                          onDashboard: true,
                          body: CustomInAppWebView(
                              url: fileLink ?? app.link!,
                              isSensitive: app.isSensitive,
                              sensitiveScreenTimeOut:
                                  app.sensitiveScreenTimeOut ?? 30,
                              sensitiveAlertTimeOut:
                                  app.sensitiveAlertTimeOut ?? 15),
                          title: app.name,
                          isSensitive: app.isSensitive,
                          sensitiveScreenTimeOut:
                              app.sensitiveScreenTimeOut ?? 30,
                          sensitiveAlertTimeOut:
                              app.sensitiveAlertTimeOut ?? 15);
                    },
                  ));
                } else if (app.name == "Dashboard") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KioskDashboardScreen(
                        dashboardUsed: int.parse(app.id),
                      ),
                    ),
                  );
                } else {
                  try {
                    await LaunchApp.openApp(androidPackageName: app.androidId);
                  } catch (err) {
                    try {
                      await launchUrl(Uri.parse(
                          'https://play.google.com/store/apps/details?id=${app.androidId}'));
                    } catch (err) {
                      DebugLogger.error(err);
                    }
                  }
                }
              },
              child: ConstrainedBox(
                constraints: isAvatar
                    ? BoxConstraints(
                        minWidth: 257 * FCStyle.fem,
                        maxWidth: 300 * FCStyle.fem)
                    : BoxConstraints(
                        minWidth: 282 * FCStyle.fem,
                        maxWidth: 300 * FCStyle.fem),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10 * FCStyle.fem),
                  decoration: BoxDecoration(
                      color:
                          app.color != null ? app.color : ColorPallet.kPrimary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      app.type == "core" ||
                          ( name == "Mood Tracker" || name == "Education")
                          ? name == "RSS Feed"
                              ? Icon(
                                  Icons.rss_feed,
                                  size: 60 * FCStyle.fem,
                                  color: ColorPallet.kPrimaryText,
                                )
                              : SvgPicture.asset(
                                  image,
                                  width: 50 * FCStyle.fem,
                                  height: 50 * FCStyle.fem,
                                  // color: ColorPallet.kPrimaryText,
                                )
                          : app.textColor != null
                              ? FutureBuilder<String>(
                                  future: getImageUrl(app.fileId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // Handle the error state
                                        return SizedBox(
                                          height: 50 * FCStyle.fem,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.photo,
                                                size: 50 * FCStyle.fem,
                                                color: app.textColor,
                                              ),
                                              // Icon(Icons.broken_image, size: 50 * FCStyle.fem, color: ColorPallet.kPrimaryTextColor,),
                                              // Text(snapshot.error.toString()),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                    final imageUrl = snapshot.data;
                                    return CachedNetworkImage(
                                      height: 50 * FCStyle.fem,
                                      fit: BoxFit.fitHeight,
                                      imageUrl: imageUrl ?? "",
                                      color: app.textColor,
                                      placeholder: (context, url) => SizedBox(
                                        height: 50 * FCStyle.fem,
                                        child: Shimmer.fromColors(
                                            baseColor: ColorPallet.kWhite,
                                            highlightColor:
                                                ColorPallet.kPrimaryGrey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.photo,
                                                  size: 50 * FCStyle.fem,
                                                ),
                                              ],
                                            )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        height: 50 * FCStyle.fem,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // Icon(
                                            //   Icons.broken_image,
                                            //   size: 50 * FCStyle.fem,
                                            //   color: ColorPallet.kPrimaryTextColor,
                                            // ),
                                            Icon(
                                              Icons.photo,
                                              size: 50 * FCStyle.fem,
                                              color: app.textColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration:
                                          const Duration(milliseconds: 100),
                                    );
                                  })
                              : FutureBuilder<String>(
                                  future: getImageUrl(app.fileId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // Handle the error state
                                        return SizedBox(
                                          height: 50 * FCStyle.fem,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              // Icon(Icons.broken_image, size: 50 * FCStyle.fem, color: ColorPallet.kPrimaryTextColor,),
                                              Icon(Icons.photo,
                                                  size: 50 * FCStyle.fem,
                                                  color:
                                                      ColorPallet.kPrimaryText),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                    final imageUrl = snapshot.data;
                                    return CachedNetworkImage(
                                      height: 50 * FCStyle.fem,
                                      fit: BoxFit.fitHeight,
                                      imageUrl: imageUrl ?? "",
                                      placeholder: (context, url) => SizedBox(
                                        height: 50 * FCStyle.fem,
                                        child: Shimmer.fromColors(
                                            baseColor: ColorPallet.kWhite,
                                            highlightColor:
                                                ColorPallet.kPrimaryGrey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.photo,
                                                  size: 50 * FCStyle.fem,
                                                ),
                                              ],
                                            )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        height: 50 * FCStyle.fem,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // Icon(
                                            //   Icons.broken_image,
                                            //   size: 50 * FCStyle.fem,
                                            //   color: ColorPallet.kPrimaryTextColor,
                                            // ),
                                            Icon(Icons.photo,
                                                size: 50 * FCStyle.fem,
                                                color:
                                                    ColorPallet.kPrimaryText),
                                          ],
                                        ),
                                      ),
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration:
                                          const Duration(milliseconds: 100),
                                    );
                                  }),
                      const SizedBox(height: 15),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: app.textColor != null
                                ? app.textColor
                                : ColorPallet.kPrimaryText,
                            fontFamily: 'roboto',
                            fontSize: 22 * FCStyle.ffem,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
        : const SizedBox();
  }
}

final AuthRepository _authRepository = AuthRepository();

Future<String?> getDocumentUrl(String docId) async {
  print("this is file link doc id $docId");
  ;
  String? accessToken = await _authRepository.generateAccessToken();
  User me = await _authRepository.currentUser();
  String clientId = me.customAttribute2.userId;
  String companyId = me.customAttribute2.companyId;
  try {
    if (accessToken != null) {
      String getDocumentUrl =
          '${ApiConfig.baseUrl}/integrations/file-manager/document/$docId';
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };
      var response =
          await http.get(Uri.parse(getDocumentUrl), headers: headers);
      print('Document Data ${response.body}');
      var data = jsonDecode(response.body);
      print(data['info'].toString());
      var fileId = data['info']['file_id'];
      print("TYPE ::: ${fileId.runtimeType}");
      var fileBody = json.encode({
        "fileIds": [fileId]
      });
      try {
        var fileResponse = await http.post(
            Uri.parse(
                '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
            body: fileBody,
            headers: headers);
        var responseData = json.decode(fileResponse.body);
        print(responseData);
        if (fileResponse.statusCode == 200 || fileResponse.statusCode == 201) {
          return responseData["data"][0]["image"];
        } else {
          print("THIS IS INSIDE GET DOCUMENT URL ELSE ");
          // DebugLogger.debug("${fileResponse.statusCode}   ${fileResponse.body}");
          return null;
        }
      } catch (e) {
        DebugLogger.error("ERROR IN GET DOCUMENT URL 1 $e");
        return null;
      }
    }
  } catch (err) {
    DebugLogger.error("ERROR IN GET DOCUMENT URL 2 $err");
  }
  return null;
}
