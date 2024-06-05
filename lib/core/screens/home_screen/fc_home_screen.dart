import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'package:famici/core/screens/home_screen/widgets/appointments_template2.dart';
import 'package:famici/core/screens/home_screen/widgets/bottom_status_bar.dart';
import 'package:famici/core/screens/home_screen/widgets/calling_screen.dart';
import 'package:famici/core/screens/home_screen/widgets/container_widgets.dart';
import 'package:famici/core/screens/home_screen/widgets/custom_container.dart';
import 'package:famici/core/screens/home_screen/widgets/medication_template2.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/education/education_bloc/education_bloc.dart';
import 'package:famici/feature/member_profile/blocs/member_profile_bloc.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';
import 'package:famici/utils/barrel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import '../../../feature/care_team/blocs/care_team_bloc.dart';
import '../../../feature/care_team/profile_photo_bloc/profile_photo_bloc.dart';
import '../../../feature/kiosk_generic/screen/kiosk_sub_dashboard.dart';
import '../../../feature/kiosk_generic/widgets/custom_in_app_webview.dart';
import '../../../feature/kiosk_generic/widgets/kiosk_scaffold.dart';
import '../../../feature/kiosk_generic/widgets/pdf_viewer_screen.dart';
import '../../../feature/maintenance/bloc/maintenance_bloc.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/helpers/events_track.dart';
import '../../blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import '../../blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import '../../blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import '../../enitity/user.dart';
import '../../offline/local_database/user_photos_db.dart';
import '../../router/router_delegate.dart';
import 'home_screen.dart';

class FCHomeScreen extends StatefulWidget {
  const FCHomeScreen({Key? key}) : super(key: key);

  @override
  _FCHomeScreenState createState() => _FCHomeScreenState();
}

class _FCHomeScreenState extends State<FCHomeScreen> {

  Map<String, GSIOrLI> items = {
    'Care Team2': GSIOrLI(
        title: "Care Team",
        image: "assets/icons/care_team_icon.svg",
        route: const CareTeamRoute(),
        color: Colors.white,
        textColor: Colors.black,
        innerColor: ""),
    // 'kiosk ': GSIOrLI(
    //     title: "Superior Kiosk",
    //     image: "assets/icons/widget_app_icon_black.png",
    //     route: "kiosk",
    //     color: Colors.white,
    //     textColor: Colors.black,
    //     innerColor: ""),
    'Games2': GSIOrLI(
        title: "Games",
        image: "assets/icons/games_icon.svg",
        color: Color(0xff4CBC9A),
        textColor: Colors.black,
        route: const GamesSelectionRoute(),
        innerColor: ""),
    'Web Links2': GSIOrLI(
        title: 'Web Links',
        image: 'assets/icons/web_links.svg',
        color: const Color(0xff5155C3),
        textColor: const Color(0xffF9FAFD),
        innerColor: const Color(0xff3A3EA7),
        route: const InternetRoute()),
    'Content & Education2': GSIOrLI(
      title: 'Content & Education',
      image: 'assets/icons/content_and_education.svg',
      color: Color(0xffFFFFFF),
      textColor: Color(0xff271E4A),
      innerColor: Color(0xffAC2734),
      route: const HealthyHabitsRoute(),
    ),
    'Let\'s Connect2': GSIOrLI(
      title: 'Let\'s Connect',
      image: 'assets/icons/lets_connect.svg',
      color: Color(0xffFFFFFF),
      textColor: Color(0xff271E4A),
      innerColor: Color(0xff4CBC9A),
      route: const MultipleChatUserRoute(),
    ),
  };

  // String? imageUrl;

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
        previous.user.email != current.user.email,
        builder: (context, state) {
          return BlocBuilder<ProfilePhotoBloc,
              ProfilePhotoState>(
            builder: (context, profileState) {
              return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
                buildWhen: (previous, current) =>
                previous.dashboardBuilder != current.dashboardBuilder ||
                    previous.status != current.status ||
                    previous.themeData != current.themeData,
                builder: (context, stateM) {
                  if (stateM.templateId == 1) {
                    fcRouter.replaceAll([HomeRoute()]);
                  }
                  else if (stateM.templateId == 3) {
                    fcRouter.replaceAll([CustomerSupportHomeRoute()]);
                  }
                  // if (stateM
                  //     .dashboardBuilder
                  //     .li
                  //     .items['LI 4']
                  //     ?.fileId != "" && stateM
                  //     .dashboardBuilder
                  //     .li
                  //     .items['LI 4']
                  //     ?.fileId != null && imageUrl == null) {
                  // getImage(stateM
                  //     .dashboardBuilder
                  //     .li
                  //     .items['LI 4']
                  //     ?.fileId ?? "");
                  // }

                  // print("this is current screen id ${stateM.templateId}");
                  // print(items[stateM
                  //     .dashboardBuilder
                  //     .gsi
                  //     .items['GSI 1']
                  //     ?.name]
                  //     ?.title);
                  // print(stateM
                  //     .dashboardBuilder
                  //     .gsi
                  //     .items['GSI 1']
                  //     ?.name);
                  // print("sdfkjslf sldkjf lskjf ljkfsdfds");
                  // stateM.dashboardBuilder.gsi.items.forEach((key, value) {
                  //   print(value?.name);
                  // });
                  return BlocBuilder<MemberProfileBloc, MemberProfileState>(
                      builder: (context, appState) {
                        List<Color> valuesDataColors = [
                          Colors.purple,
                          Colors.yellow,
                          Colors.green,
                          Colors.red,
                          Colors.grey,
                          Colors.blue,
                        ];
                        List<Widget> valuesWidget = [];
                        for (int i = 0; i < valuesDataColors.length; i++) {
                          valuesWidget.add(Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: valuesDataColors[i],
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  i.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              )));
                        }
                        return BlocListener<
                            ManageRemindersBloc,
                            ManageRemindersState>(
                            listener: (context, state) {
                              if (state.additionStatus == EventStatus.success) {
                                FCAlert.showSuccess(
                                    '${state.isEvent!
                                        ? 'Event '
                                        : 'Reminder '}Successfully created');
                                context.read<CalendarBloc>().add(
                                    FetchCalendarDetailsEvent(
                                        context
                                            .read<CalendarBloc>()
                                            .state
                                            .startDate,
                                        context
                                            .read<CalendarBloc>()
                                            .state
                                            .endDate));
                                state.additionStatus = EventStatus.initial;
                              }
                              if (state.editionStatus == EventStatus.success) {
                                FCAlert.showSuccess(
                                    '${state.isEvent!
                                        ? 'Event '
                                        : 'Reminder '}Successfully edited');
                                context.read<CalendarBloc>().add(
                                    FetchCalendarDetailsEvent(
                                        context
                                            .read<CalendarBloc>()
                                            .state
                                            .startDate,
                                        context
                                            .read<CalendarBloc>()
                                            .state
                                            .endDate));
                                context
                                    .read<CalendarBloc>()
                                    .add(
                                    FetchThisWeekAppointmentsCalendarEvent());
                                state.editionStatus = EventStatus.initial;
                              }
                              if (state.deletionStatus == EventStatus.success) {
                                FCAlert.showSuccess(
                                    '${state.isEvent!
                                        ? 'Event '
                                        : 'Reminder '}Successfully deleted');
                                context.read<CalendarBloc>().add(
                                    FetchCalendarDetailsEvent(
                                        context
                                            .read<CalendarBloc>()
                                            .state
                                            .startDate,
                                        context
                                            .read<CalendarBloc>()
                                            .state
                                            .endDate));
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
                                    '${state.isEvent!
                                        ? 'Event '
                                        : 'Reminder '}Edition failed');
                                state.editionStatus = EventStatus.initial;
                              }
                            },
                            child: BlocListener<CalendarBloc, CalendarState>(
                                listener: (context, state) {
                                  if (state.additionStatus ==
                                      EventStatus.success) {
                                    FCAlert.showSuccess(
                                        'Calendar Link Successfully created');

                                    state.additionStatus = EventStatus.initial;
                                  }
                                  if (state.editionStatus ==
                                      EventStatus.success) {
                                    FCAlert.showSuccess(
                                        'Calendar Successfully edited');

                                    state.editionStatus = EventStatus.initial;
                                  }
                                  if (state.deletionStatus ==
                                      EventStatus.success) {
                                    FCAlert.showSuccess(
                                        'Calendar Successfully deleted');

                                    state.deletionStatus = EventStatus.initial;
                                  }
                                  if (state.additionStatus ==
                                      EventStatus.failure) {
                                    FCAlert.showError(
                                        'Calendar Addition falied');
                                    state.additionStatus = EventStatus.initial;
                                  }
                                  if (state.deletionStatus ==
                                      EventStatus.failure) {
                                    FCAlert.showError(
                                        'Calendar Deletion falied');
                                    state.deletionStatus = EventStatus.initial;
                                  }
                                  if (state.editionStatus ==
                                      EventStatus.failure) {
                                    FCAlert.showError(
                                        'Calendar Edition falied');
                                    state.editionStatus = EventStatus.initial;
                                  }
                                }, child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, authState) {
                                  print("PROFILE PIC : ${authState.user
                                      .profileUrl}");
                                  return Scaffold(
                                    // BACKGROUND IMAGE
                                    body: Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      decoration: BoxDecoration(
                                        // color: Colors.orange,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/background_gradient.jpg"),
                                            fit: BoxFit.fill),
                                      ),
                                      // MAIN DASHBOARD COLUMN
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Container(
                                            height:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.9,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFFFFFF)
                                                  .withOpacity(
                                                  0.4),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            child: Column(
                                              children: [
                                                // USER PROFILE, NOTIFICATION & LOGOUT BUTTON
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 0.02 *
                                                          MediaQuery
                                                              .of(context)
                                                              .size
                                                              .height,
                                                      left: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.04,
                                                      right: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.03),
                                                  child: Container(
                                                    // color: Colors.redAccent,
                                                    width:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    height: 0.16 *
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .height,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 0.1158 *
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .height,
                                                              width: 0.07222 *
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color(
                                                                        0xff5155C3),
                                                                    width: 3,
                                                                  )),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3,
                                                                  ),
                                                                  image: profileState
                                                                      .profilePhotoUrl !=
                                                                      ""
                                                                      ? DecorationImage(
                                                                      image: NetworkImage(
                                                                          profileState
                                                                              .profilePhotoUrl),
                                                                      fit: BoxFit
                                                                          .fill)
                                                                      : const DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/generic_avatar.png'),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 0.01 *
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width,
                                                            ),
                                                            Container(
                                                              height: 0.15 *
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .height,
                                                              width: 0.4 *
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "Hello, ",
                                                                        style: TextStyle(
                                                                            color: const Color(
                                                                                0xff5155C3),
                                                                            fontSize: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height *
                                                                                0.03899,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                      ),
                                                                      Text(
                                                                          authState
                                                                              .user
                                                                              .name ??
                                                                              "",
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xff4CBC9A),
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.03899,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w700)),
                                                                    ],
                                                                  ),
                                                                  StreamBuilder(
                                                                    stream: Stream
                                                                        .periodic(
                                                                        const Duration(
                                                                            seconds: 1)),
                                                                    builder: (
                                                                        context,
                                                                        snapshot) {
                                                                      return Text(
                                                                          DateFormat
                                                                              .yMMMMEEEEd(
                                                                              'en_US')
                                                                              .add_jm()
                                                                              .format(
                                                                              DateTime
                                                                                  .now())
                                                                              .replaceAll(
                                                                              'am',
                                                                              'AM')
                                                                              .replaceAll(
                                                                              'pm',
                                                                              'PM'),
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.0256,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w500));
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width *
                                                              0.22,
                                                          height: 0.12 *
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .height,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        // Navigator.of(context).push(
                                                                        //   PageRouteBuilder(
                                                                        //     opaque: false, // set to false
                                                                        //     pageBuilder: (_, __, ___) => CallingScreen(),
                                                                        //   ),
                                                                        // );
                                                                      },
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/images/notification_bell.svg",
                                                                        height: 0.07 *
                                                                            MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height,
                                                                        width: 0.1 *
                                                                            MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width,
                                                                        color:
                                                                        Color(
                                                                            0xff271E4A),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "Notifications",
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xff271E4A),
                                                                            fontSize: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height *
                                                                                0.0256,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w600)),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    var properties = TrackEvents()
                                                                        .setProperties(
                                                                        fromDate: '',
                                                                        toDate: '',
                                                                        reading: '',
                                                                        readingDateTime:
                                                                        '',
                                                                        vital: '',
                                                                        appointmentDate:
                                                                        '',
                                                                        appointmentTime:
                                                                        '',
                                                                        appointmentCounselors:
                                                                        '',
                                                                        appointmentType:
                                                                        '',
                                                                        callDuration:
                                                                        '',
                                                                        readingType:
                                                                        '');

                                                                    TrackEvents()
                                                                        .trackEvents(
                                                                        'Logout Clicked',
                                                                        properties);
                                                                    showDialog(
                                                                        context: context,
                                                                        builder:
                                                                            (
                                                                            BuildContext
                                                                            context) {
                                                                          return FCConfirmDialog(
                                                                            height: 400,
                                                                            width: 660,
                                                                            subText:
                                                                            'Hope to see you back soon',
                                                                            submitText:
                                                                            'Confirm',
                                                                            cancelText:
                                                                            'Cancel',
                                                                            icon: "assets/images/logout_button.svg",
                                                                            message:
                                                                            "Are you sure you want to logout?",
                                                                          );
                                                                        })
                                                                        .then((
                                                                        value) {
                                                                      if (value) {
                                                                        var properties = TrackEvents()
                                                                            .setProperties(
                                                                            fromDate: '',
                                                                            toDate: '',
                                                                            reading: '',
                                                                            readingDateTime:
                                                                            '',
                                                                            vital: '',
                                                                            appointmentDate:
                                                                            '',
                                                                            appointmentTime:
                                                                            '',
                                                                            appointmentCounselors:
                                                                            '',
                                                                            appointmentType:
                                                                            '',
                                                                            callDuration:
                                                                            '',
                                                                            readingType:
                                                                            '');

                                                                        TrackEvents()
                                                                            .trackEvents(
                                                                            'User Logged Out',
                                                                            properties);
                                                                        context
                                                                            .read<
                                                                            AuthBloc>()
                                                                            .add(
                                                                            SignOutAuthEvent());
                                                                        fcRouter
                                                                            .removeUntil(
                                                                                (
                                                                                route) =>
                                                                            false);
                                                                        fcRouter
                                                                            .navigate(
                                                                            MultipleUserRoute());
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        "assets/images/logout_button.svg",
                                                                        height: 0.07 *
                                                                            MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height,
                                                                        width: 0.1 *
                                                                            MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width,
                                                                        color: Color(
                                                                            0xff271E4A),
                                                                      ),
                                                                      Text(
                                                                          "Logout",
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xff271E4A),
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.0256,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w600)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // color: Colors.black45,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.03),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      // APPOINTMENTS & KIOSK DASHBOARD
                                                      Container(
                                                        // color: Colors.blue,
                                                        padding: EdgeInsets
                                                            .fromLTRB(0, 0, 0,
                                                            0.06 *
                                                                MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .height),
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            0.22,
                                                        // color: Colors.purpleAccent,
                                                        height: 0.7 *
                                                            MediaQuery
                                                                .of(context)
                                                                .size
                                                                .height,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            stateM
                                                                .dashboardBuilder
                                                                .li
                                                                .items['LI 1']
                                                                ?.name ==
                                                                'Scheduling2'
                                                                ?
                                                            GestureDetector(
                                                                onTap: () {
                                                                  fcRouter
                                                                      .navigate(
                                                                      CalenderRoute());
                                                                },
                                                                child:
                                                                AppointmentsTemplate2())
                                                                : SizedBox(
                                                              height: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .height *
                                                                  0.36,
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width *
                                                                  0.20,),

                                                            // SizedBox(height: MediaQuery
                                                            //     .of(context)
                                                            //     .size
                                                            //     .height *
                                                            //     0.02,),
                                                            if (stateM
                                                                .dashboardBuilder
                                                                .li
                                                                .items['LI 4']
                                                                ?.name ==
                                                                "Dashboard")
                                                              CustomContainer(
                                                                stateM
                                                                    .dashboardBuilder
                                                                    .li
                                                                    .items['LI 4']
                                                                    ?.id,
                                                                route: "kiosk",
                                                                height:
                                                                MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .height *
                                                                    0.24,
                                                                width:
                                                                MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width *
                                                                    0.19,
                                                                title: stateM
                                                                    .dashboardBuilder
                                                                    .li
                                                                    .items['LI 4']
                                                                    ?.link ??
                                                                    "Superior Kiosk",
                                                                iconImage: stateM
                                                                    .dashboardBuilder
                                                                    .li
                                                                    .items['LI 4']
                                                                    ?.fileId ??
                                                                    "assets/icons/widget_app_icon_black.png",
                                                                color: Colors
                                                                    .white,
                                                                textColor: Colors
                                                                    .black,
                                                              ),

                                                            if (stateM
                                                                .dashboardBuilder
                                                                .li
                                                                .items['LI 4']
                                                                ?.name !=
                                                                "Dashboard")
                                                              genericModule(
                                                                  stateM
                                                                      .dashboardBuilder
                                                                      .li
                                                                      .items['LI 4'],
                                                                  context
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                      // CARE TEAM & GAMES
                                                      Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(0,
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width *
                                                                  0.02, 0,
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width *
                                                                  0.035),
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width *
                                                              0.22,
                                                          height: 0.7 *
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .height,
                                                          // color: Colors.yellow,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                if (checkLI(
                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items['LI 2']
                                                                        ?.name))
                                                                  CustomContainer(
                                                                      "",
                                                                      height:
                                                                      MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .height *
                                                                          0.28,
                                                                      width: MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width *
                                                                          0.20,
                                                                      title: items[stateM
                                                                          .dashboardBuilder
                                                                          .li
                                                                          .items['LI 2']
                                                                          ?.name]
                                                                          ?.title ??
                                                                          "Care Team",
                                                                      iconImage: items[stateM
                                                                          .dashboardBuilder
                                                                          .li
                                                                          .items['LI 2']
                                                                          ?.name]
                                                                          ?.image ??
                                                                          "assets/icons/care_team_icon.svg",
                                                                      color: items[stateM
                                                                          .dashboardBuilder
                                                                          .li
                                                                          .items['LI 2']
                                                                          ?.name]
                                                                          ?.color ??
                                                                          Colors
                                                                              .white,
                                                                      textColor: items[stateM
                                                                          .dashboardBuilder
                                                                          .li
                                                                          .items['LI 2']
                                                                          ?.name]
                                                                          ?.textColor ??
                                                                          Colors
                                                                              .black,
                                                                      route: items[stateM
                                                                          .dashboardBuilder
                                                                          .li
                                                                          .items[
                                                                      'LI 2']
                                                                          ?.name]
                                                                          ?.route ??
                                                                          const CareTeamRoute()),
                                                                if (!checkLI(
                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items['LI 2']
                                                                        ?.name))
                                                                  const SizedBox(),
                                                                if (checkLI(
                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items['LI 5']
                                                                        ?.name))
                                                                  CustomContainer(
                                                                    "",
                                                                    height: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        0.28,
                                                                    width: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        0.20,
                                                                    title: items[stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items[
                                                                    'LI 5']
                                                                        ?.name]
                                                                        ?.title ??
                                                                        "Games",
                                                                    iconImage: items[stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items[
                                                                    'LI 5']
                                                                        ?.name]
                                                                        ?.image ??
                                                                        "assets/icons/games_icon.svg",
                                                                    color: items[stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items[
                                                                    'LI 5']
                                                                        ?.name]
                                                                        ?.color ??
                                                                        Color(
                                                                            0xff4CBC9A),
                                                                    textColor: items[stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items[
                                                                    'LI 5']
                                                                        ?.name]
                                                                        ?.textColor ??
                                                                        Colors
                                                                            .black,
                                                                    route: items[stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items[
                                                                    'LI 5']
                                                                        ?.name]
                                                                        ?.route ??
                                                                        const GamesSelectionRoute(),
                                                                  ),
                                                                if (!checkLI(
                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .li
                                                                        .items['LI 5']
                                                                        ?.name))
                                                                  const SizedBox(),
                                                              ])),
                                                      // UPCOMING MEDICATIONS
                                                      stateM
                                                          .dashboardBuilder.li
                                                          .items['LI 3']
                                                          ?.name ==
                                                          'Medication2'
                                                          ? const MedicationTemplate2()
                                                          : SizedBox(
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            0.26,
                                                        height:
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .height *
                                                            0.7,),
                                                      // WEBLINKS, CONTENT & EDU, LET's CONNECT
                                                      Container(
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width *
                                                              0.22,
                                                          height: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .height *
                                                              0.7,
                                                          padding: EdgeInsets
                                                              .fromLTRB(0,
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width *
                                                                  0.02, 0,
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width *
                                                                  0.035),
                                                          // color: Colors.orange,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                if(checkGSI(
                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 1']
                                                                        ?.name))
                                                                  ContainerWidget(
                                                                      title: items[stateM
                                                                          .dashboardBuilder
                                                                          .gsi
                                                                          .items['GSI 1']
                                                                          ?.name]
                                                                          ?.title ??
                                                                          'Web Links',
                                                                      icon:
                                                                      items[stateM
                                                                          .dashboardBuilder
                                                                          .gsi
                                                                          .items['GSI 1']
                                                                          ?.name]
                                                                          ?.image ??
                                                                          'assets/icons/web_links.svg',
                                                                      color:
                                                                      items[stateM
                                                                          .dashboardBuilder
                                                                          .gsi
                                                                          .items['GSI 1']
                                                                          ?.name]
                                                                          ?.color ??
                                                                          Color(
                                                                              0xff5155C3),
                                                                      textColor: items[stateM
                                                                          .dashboardBuilder
                                                                          .gsi
                                                                          .items['GSI 1']
                                                                          ?.name]
                                                                          ?.textColor ??
                                                                          Color(
                                                                              0xffF9FAFD),
                                                                      innerColor: items[stateM
                                                                          .dashboardBuilder
                                                                          .gsi
                                                                          .items['GSI 1']
                                                                          ?.name]
                                                                          ?.innerColor ??
                                                                          Color(
                                                                              0xff3A3EA7),
                                                                      textWidth:
                                                                      MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width *
                                                                          0.09375,
                                                                      route: items[stateM
                                                                          .dashboardBuilder
                                                                          .gsi
                                                                          .items['GSI 1']
                                                                          ?.name]
                                                                          ?.route ??
                                                                          const InternetRoute()),
                                                                if(!checkGSI(

                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 1']
                                                                        ?.name)) SizedBox(
                                                                  height: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.1737,),
                                                                if(checkGSI(

                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name))
                                                                  ContainerWidget(
                                                                    title:
                                                                    items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name]
                                                                        ?.title ??
                                                                        'Content & Education',
                                                                    icon: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name]
                                                                        ?.image ??
                                                                        'assets/icons/content_and_education.svg',
                                                                    color: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name]
                                                                        ?.color ??
                                                                        const Color(
                                                                            0xffFFFFFF),
                                                                    textColor: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name]
                                                                        ?.textColor ??
                                                                        const Color(
                                                                            0xff271E4A),
                                                                    innerColor: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name]
                                                                        ?.innerColor ??
                                                                        const Color(
                                                                            0xffAC2734),
                                                                    textWidth:
                                                                    MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        0.09375,
                                                                    route: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name]
                                                                        ?.route ??
                                                                        const HealthyHabitsRoute(),
                                                                  ),
                                                                if(!checkGSI(

                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 2']
                                                                        ?.name)) SizedBox(
                                                                  height: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.1737,),
                                                                if(checkGSI(

                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name))
                                                                  ContainerWidget(
                                                                    title: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name]
                                                                        ?.title ??
                                                                        'Let\'s Connect',
                                                                    icon: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name]
                                                                        ?.image ??
                                                                        'assets/icons/lets_connect.svg',
                                                                    color: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name]
                                                                        ?.color ??
                                                                        const Color(
                                                                            0xffFFFFFF),
                                                                    textColor: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name]
                                                                        ?.textColor ??
                                                                        const Color(
                                                                            0xff271E4A),
                                                                    innerColor: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name]
                                                                        ?.innerColor ??
                                                                        const Color(
                                                                            0xff4CBC9A),
                                                                    textWidth:
                                                                    MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        0.09375,
                                                                    route: items[stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name]
                                                                        ?.route ??
                                                                        const MultipleChatUserRoute(),
                                                                  ),
                                                                if(!checkGSI(
                                                                    stateM
                                                                        .dashboardBuilder
                                                                        .gsi
                                                                        .items['GSI 3']
                                                                        ?.name)) SizedBox(
                                                                  height: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.1737,),
                                                              ])),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // BOTTOM STATUS BAR
                                          const BottomStatusBar(),
                                        ],
                                      ),
                                    ),
                                  );
                                })));
                      });
                },
              );
            },
          );
        });
  }

  initializeDatabases() async {
    final AuthRepository authRepository = AuthRepository();
    User current = await authRepository.currentUser();

    final prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('${current.id}_appointments') ?? "";

    context.read<NotificationBloc>().add(OnSetNotificationsEvent(response));

    // await DatabaseHelperForMedication.initDb(current.id);
    await DatabaseHelperForMemories.initDb(current.id);
  }

  checkLI(String? name) {
    if (name == "Games2" || name == "Care Team2") {
      return true;
    }
    return false;
  }

  checkGSI(String? name) {
    if (name != null) {
      print("this is the name we are getting$name");
      if (name == "Web Links2" || name == "Let's Connect2" ||
          name == "Content & Education2") {
        return true;
      }
    }
    return false;
  }


// Future<void> getImage(String fileId) async {
//   if (fileId != "") {
//     String img = await getImageUrl(fileId);
//     print("$fileId got the image data $img");
//     setState(() {
//       imageUrl = img;
//     });
//   }
// }


}

Widget genericModule(DashboardItem? item, BuildContext context) {
  if (item?.id == null) {
    return const SizedBox();
  }
  print("li4 item :: ${item?.type}");
  print("li4 item :: ${item?.fileId}");
  print("li4 item :: ${item?.name}");
  print("li4 item :: ${item?.textColor}");
  print("li4 item :: ${item?.color}");
  print("li4 item :: ${item?.link}");

  String name = item?.name ?? "Generic";
  String icon = item?.fileId ??
      "assets/icons/widget_app_icon_black.png";
  dynamic route = "generic";

  if (item?.type == "Mood Tracker") {
    name = "Mood Tracker";
    icon = DashboardIcons.moodTracker;
    route = MoodTrackerRoute(title: "Mood Tracker");
  } else if (item?.type == "Education") {
    name = "Education";
    icon = DashboardIcons.education;
    route = EducationRoute(title: "Education");
  }

  print("this is id ${item?.id}");

  return
    CustomContainer(
      item?.id,
      route: route,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.24,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.19,
      title: name,
      iconImage: icon,
      color: item?.color ?? Colors.white,
      textColor: item?.textColor ?? Colors.black,
      item: item,
    );
}

class GSIOrLI {
  final String title;
  final String image;
  final dynamic route;
  final Color color;
  final Color textColor;
  final dynamic innerColor;

  GSIOrLI({
    required this.title,
    required this.image,
    required this.route,
    required this.color,
    required this.textColor,
    required this.innerColor,
  });
}
