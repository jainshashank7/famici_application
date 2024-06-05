import 'dart:async';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/app_bloc/app_bloc.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/feature/video_call/blocs/user_db_bloc/user_db_bloc.dart';
import 'package:famici/utils/barrel.dart';

import '../../feature/chat/blocs/chat_bloc/chat_bloc.dart';
import '../../feature/maintenance/bloc/maintenance_bloc.dart';
import '../../feature/maintenance/screeen/force_update_screen.dart';
import '../../feature/maintenance/screeen/maintainance_screen.dart';
import '../../feature/video_call/helper/call_manager/call_manager.dart';
import '../blocs/connectivity_bloc/connectivity_bloc.dart';
import 'lock_screen/barrel.dart';

class ScreenDistributor extends StatefulWidget {
  const ScreenDistributor({Key? key}) : super(key: key);

  @override
  State<ScreenDistributor> createState() => _ScreenDistributorState();
}

class _ScreenDistributorState extends State<ScreenDistributor>
    with WidgetsBindingObserver {
  late Timer onlineOfflineRecallTimer;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ColorPallet.kBackground,
        statusBarColor: ColorPallet.kBackground,
      ),
    );
    super.initState();
    context.read<UserDbBloc>().add(IamOnlineUserDbEvent());
    onlineOfflineRecallTimer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) {
      context.read<UserDbBloc>().add(IamOnlineUserDbEvent());
      context.read<ChatBloc>().add(CheckMessageSubscriptionEvent());
    });
    WidgetsBinding.instance.addObserver(this);
    context.read<ConnectivityBloc>().add(CheckInternetConnectivity());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      if (onlineOfflineRecallTimer.isActive) {
        onlineOfflineRecallTimer.cancel();
      }
      onlineOfflineRecallTimer =
          Timer.periodic(const Duration(seconds: 5), (Timer t) {
        context.read<UserDbBloc>().add(IamOnlineUserDbEvent());
        context.read<ChatBloc>().add(CheckMessageSubscriptionEvent());
      });
      context.read<UserDbBloc>().add(IamOnlineUserDbEvent());
      context.read<ChatBloc>().add(CheckMessageSubscriptionEvent());
      context.read<ChatBloc>().add(ChangeBackGroundStateChatEvent(false));
      context.read<ChatBloc>().add(SyncArchivedMessages());
      context.read<ConnectivityBloc>().add(CheckInternetConnectivity());
      context.read<NotificationBloc>().add(SyncInitialNotificationEvent());
      context.read<CalendarBloc>().add(FetchThisWeekAppointmentsCalendarEvent());
      context.read<MedicationBloc>().add(const FetchMedications());
      CallNotify.dismissIncomingCallNotification();
    } else if (state == AppLifecycleState.inactive) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      if (onlineOfflineRecallTimer.isActive ||
          state == AppLifecycleState.paused) {
        onlineOfflineRecallTimer.cancel();
      }
      onlineOfflineRecallTimer =
          Timer.periodic(const Duration(seconds: 5), (Timer t) {
        context.read<UserDbBloc>().add(IamOfflineUserDbEvent());
        context.read<ChatBloc>().add(CheckMessageSubscriptionEvent());
      });
      context.read<UserDbBloc>().add(IamOfflineUserDbEvent());
      context.read<ChatBloc>().add(CheckMessageSubscriptionEvent());
      context.read<ChatBloc>().add(ChangeBackGroundStateChatEvent(true));
    } else if (state == AppLifecycleState.detached) {
      context.read<AppBloc>().add(EnableLock());
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  @override
  void dispose() {
    onlineOfflineRecallTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<ThemeCubit>(),
      builder: (ctx, ThemeState state) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, AuthState authState) {
            print("entered");
            return Theme(
              data: ThemeData(fontFamily: FCStyle.fontFamily),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: ColorPallet.kBackground,
                body: Stack(
                  children: [
                    MaterialApp.router(
                      routerDelegate: fcRouter.delegate(),
                      routeInformationParser: fcRouter.defaultRouteParser(),
                      theme: FCStyle.getTheme(context, state.mode),
                      darkTheme: FCStyle.getTheme(context, state.mode),
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      themeMode: state.mode == Brightness.dark
                          ? ThemeMode.dark
                          : ThemeMode.light,
                      builder: (context, child) {
                        return MediaQuery(
                          child: child!,
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                        );
                      },
                    ),
                    BlocBuilder<AppBloc, AppState>(
                      buildWhen: (prv, curr) => prv.locked != curr.locked,
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                          ) {
                            return FadeScaleTransition(
                              animation: animation,
                              child: child,
                            );
                          },
                          duration: Duration(milliseconds: 300),
                          child:
                              state.locked ? LockScreen() : SizedBox.shrink(),
                        );
                      },
                    ),
                    BlocBuilder<MaintenanceBloc, MaintenanceState>(
                      builder: (context, appConfig) {
                        if (appConfig.config.maintenance) {
                          return const MaintenanceScreen();
                        }
                        if (appConfig.config.forceUpdate) {
                          return const ForceUpdateScreen();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
