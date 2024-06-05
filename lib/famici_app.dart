import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/blocs/app_bloc/app_bloc.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/blocs/battery_cubit/battery_cubit.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'package:famici/core/blocs/time_ago_bloc/count_down_bloc.dart';
import 'package:famici/core/blocs/video_player/video_player_bloc.dart';
import 'package:famici/core/blocs/weather_bloc/weather_bloc.dart';
import 'package:famici/feature/app_info/app_info_bloc/app_info_cubit.dart';
import 'package:famici/feature/calander/blocs/appointment/appointment_bloc.dart';
import 'package:famici/feature/chat/blocs/chat_cloud_sync/chat_cloud_sync_bloc.dart';
import 'package:famici/feature/chat/blocs/chat_profile_bloc/chat_profile_bloc.dart';
import 'package:famici/feature/chat/blocs/sigle_user_chat/single_user_chat_bloc.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/blocs/healthy_habits_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/member_profile/blocs/member_profile_bloc.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/feature/rss_feed/blocs/rss_feed_bloc.dart';
import 'package:famici/feature/vitals/blocs/vital_history_bloc/vital_history_bloc.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/utils/barrel.dart';

import 'core/blocs/theme_bloc/theme_cubit.dart';
import 'core/enitity/user.dart';
import 'core/screens/screen_distributor.dart';
import 'core/screens/template/kiosk/kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';
import 'feature/aws_chime/method_channel_coordinator.dart';
import 'feature/aws_chime/view_models/join_meeting_view_model.dart';
import 'feature/aws_chime/view_models/meeting_view_model.dart';
import 'feature/calander/blocs/calendar/calendar_bloc.dart';
import 'feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import 'feature/care_team/blocs/care_team_bloc.dart';
import 'feature/care_team/company_logo_bloc/company_logo_bloc.dart';
import 'feature/care_team/profile_photo_bloc/profile_photo_bloc.dart';
import 'feature/chat/blocs/call_history_bloc/history_bloc.dart';
import 'feature/chat/blocs/chat_bloc/chat_bloc.dart';
import 'feature/education/education_bloc/education_bloc.dart';
import 'feature/maintenance/bloc/maintenance_bloc.dart';
import 'feature/member_portal/blocs/meeting_bloc.dart';
import 'feature/mood_tracker/bloc/mood_tracker_bloc.dart';
import 'feature/my_apps/blocs/my_apps_cubit.dart';
import 'feature/video_call/blocs/user_db_bloc/user_db_bloc.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class FamiciApp extends StatelessWidget {
  const FamiciApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      lazy: false,
      create: (context) => User(),
      child: BlocProvider.value(
        value: connectivityBloc,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CountDownBloc>(
              lazy: false,
              create: (BuildContext context) => CountDownBloc(),
            ),
            BlocProvider<ThemeCubit>(
              create: (BuildContext context) => ThemeCubit(),
            ),

            BlocProvider<EducationBloc>(
              lazy: true,
              create: (BuildContext context) => EducationBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<ThemeBuilderBloc>(
              lazy: false,
              create: (BuildContext context) => ThemeBuilderBloc(
                me: Provider.of<User>(context, listen: false),
                educationBloc: BlocProvider.of<EducationBloc>(context),
              ),
            ),
            // BlocProvider<DashboardBloc>(
            //   create: (BuildContext context) =>
            //       DashboardBloc(me: Provider.of<User>(context, listen: false)),
            // ),

            BlocProvider<KioskDashboardBloc>(
              create: (BuildContext context) => KioskDashboardBloc(
                  me: Provider.of<User>(context, listen: false)),
            ),
            BlocProvider<NotificationBloc>(
              lazy: false,
              create: (BuildContext context) => NotificationBloc(
                me: Provider.of<User>(context, listen: false),
                themeBuilderBloc: BlocProvider.of<ThemeBuilderBloc>(context),
              ),
            ),
            BlocProvider<MaintenanceBloc>(
              create: (BuildContext context) => MaintenanceBloc(),
            ),
            BlocProvider<UserDbBloc>(
              lazy: false,
              create: (BuildContext context) => UserDbBloc(
                me: Provider.of<User>(context, listen: false),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
              ),
            ),
            BlocProvider<VitalHistoryBloc>(
              lazy: false,
              create: (BuildContext context) => VitalHistoryBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<VitalsAndWellnessBloc>(
              lazy: false,
              create: (BuildContext context) => VitalsAndWellnessBloc(
                vitalHistoryBloc: BlocProvider.of<VitalHistoryBloc>(context),
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<VitalSyncBloc>(
              lazy: false,
              create: (BuildContext context) => VitalSyncBloc(
                vitalsAndWellnessBloc:
                    BlocProvider.of<VitalsAndWellnessBloc>(context),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<WeatherBloc>(
              lazy: false,
              create: (BuildContext context) => WeatherBloc(),
            ),
            BlocProvider<BatteryCubit>(
              lazy: false,
              create: (BuildContext context) => BatteryCubit(),
            ),
            // BlocProvider<AvatarCubit>(
            //   lazy: false,
            //   create: (BuildContext context) => AvatarCubit(),
            // ),

            BlocProvider<MemoriesBloc>(
              lazy: false,
              create: (BuildContext context) => MemoriesBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<AlbumBloc>(
              lazy: false,
              create: (BuildContext context) => AlbumBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<VideoPlayerBloc>(
              lazy: false,
              create: (BuildContext context) => VideoPlayerBloc(),
            ),
            BlocProvider<HealthyHabitsBloc>(
              lazy: false,
              create: (BuildContext context) => HealthyHabitsBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<RssFeedBloc>(
              lazy: false,
              create: (BuildContext context) => RssFeedBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<MedicationBloc>(
              lazy: false,
              create: (BuildContext context) => MedicationBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),

            BlocProvider<MyAppsCubit>(
              lazy: false,
              create: (context) => MyAppsCubit(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<AppInfoCubit>(
              lazy: false,
              create: (context) => AppInfoCubit(),
            ),
            BlocProvider<ChatCloudSyncBloc>(
              lazy: false,
              create: (context) => ChatCloudSyncBloc(
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
              ),
            ),
            BlocProvider<SingleUserChatBloc>(
              lazy: false,
              create: (context) => SingleUserChatBloc(
                me: Provider.of<User>(context, listen: false),
                chatCloudSyncBloc: BlocProvider.of<ChatCloudSyncBloc>(context),
              ),
            ),
            BlocProvider<ChatBloc>(
              lazy: false,
              create: (context) => ChatBloc(
                me: Provider.of<User>(context, listen: false),
                singleUserChatBloc:
                    BlocProvider.of<SingleUserChatBloc>(context),
                chatCloudSyncBloc: BlocProvider.of<ChatCloudSyncBloc>(context),
                notificationBloc: BlocProvider.of<NotificationBloc>(context),
                userDbBloc: BlocProvider.of<UserDbBloc>(context),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
              ),
            ),

            BlocProvider<CalendarBloc>(
              lazy: false,
              create: (context) => CalendarBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<MeetingBloc>(
              lazy: false,
              create: (context) => MeetingBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<MemberProfileBloc>(
              lazy: false,
              create: (context) => MemberProfileBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<ManageRemindersBloc>(
              lazy: false,
              create: (context) => ManageRemindersBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<ManageHistoryBloc>(
              lazy: false,
              create: (context) => ManageHistoryBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<AppointmentBloc>(
              lazy: false,
              create: (context) => AppointmentBloc(
                me: Provider.of<User>(context, listen: false),
                calendarBloc: BlocProvider.of<CalendarBloc>(context),
              ),
            ),
            BlocProvider<CareTeamBloc>(
              lazy: false,
              create: (BuildContext context) => CareTeamBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<CompanyLogoBloc>(
              lazy: false,
              create: (BuildContext context) => CompanyLogoBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<ProfilePhotoBloc>(
              lazy: false,
              create: (BuildContext context) => ProfilePhotoBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<MoodTrackerBloc>(
              lazy: false,
              create: (BuildContext context) => MoodTrackerBloc(
                me: Provider.of<User>(context, listen: false),
              ),
            ),
            BlocProvider<ChatProfilesBloc>(
              lazy: false,
              create: (context) => ChatProfilesBloc(
                me: Provider.of<User>(context, listen: false),
                careTeamBloc: BlocProvider.of<CareTeamBloc>(context),
              ),
            ),
            BlocProvider<AppBloc>(
              lazy: false,
              create: (context) => AppBloc(
                manageHistoryBloc: BlocProvider.of<ManageHistoryBloc>(context),
                me: Provider.of<User>(context, listen: false),
                userDbBloc: BlocProvider.of<UserDbBloc>(context),
                themeBuilderBloc: BlocProvider.of<ThemeBuilderBloc>(context),
                vitalSyncBloc: BlocProvider.of<VitalSyncBloc>(context),
                chatBloc: BlocProvider.of<ChatBloc>(context),
                vitalsAndWellnessBloc:
                    BlocProvider.of<VitalsAndWellnessBloc>(context),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
                batteryCubit: BlocProvider.of<BatteryCubit>(context),
                calendarBloc: BlocProvider.of<CalendarBloc>(context),
                maintenanceBloc: BlocProvider.of<MaintenanceBloc>(context),
                medicationBloc: BlocProvider.of<MedicationBloc>(context),
                careTeamBloc: BlocProvider.of<CareTeamBloc>(context),
                memberProfileBloc: BlocProvider.of<MemberProfileBloc>(context),
                chatProfileBloc: BlocProvider.of<ChatProfilesBloc>(context),
                companyLogoBloc: BlocProvider.of<CompanyLogoBloc>(context),
                profilePhotoBloc: BlocProvider.of<ProfilePhotoBloc>(context),
              ),
            ),
            BlocProvider<SensitiveTimerBloc>(
              lazy: false,
              create: (context) => SensitiveTimerBloc(),
            ),
            BlocProvider(
              lazy: false,
              create: (BuildContext context) => AuthBloc(
                me: Provider.of<User>(context, listen: false),
                appBloc: BlocProvider.of<AppBloc>(context),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
                themeBuilderBloc: BlocProvider.of<ThemeBuilderBloc>(context),
              ),
            ),
            ChangeNotifierProvider(create: (_) => MethodChannelCoordinator()),
            ChangeNotifierProvider(create: (_) => JoinMeetingViewModel()),
            ChangeNotifierProvider(
                create: (context) => MeetingViewModel(context)),
          ],
          child: ScreenUtilInit(
            designSize: Size(1920, 1080),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return _famiciAppBlocInjector();
            },
            child: _famiciAppBlocInjector(),
          ),
        ),
      ),
    );
  }
}

class _famiciAppBlocInjector extends StatefulWidget {
  const _famiciAppBlocInjector({
    Key? key,
  }) : super(key: key);

  @override
  State<_famiciAppBlocInjector> createState() => _famiciAppBlocInjectorState();
}

class _famiciAppBlocInjectorState extends State<_famiciAppBlocInjector> {
  @override
  void initState() {
    super.initState();
    initializeCrashlytics();
  }

  Future<void> initializeCrashlytics() async {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppNotification(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: FCStyle.getTheme(context, state.mode),
            darkTheme: FCStyle.getTheme(context, state.mode),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: state.mode == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: ScreenDistributor(),
          );
        }),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
