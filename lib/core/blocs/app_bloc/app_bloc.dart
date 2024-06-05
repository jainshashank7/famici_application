import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:famici/core/blocs/battery_cubit/battery_cubit.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/enitity/user_device.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/care_team/profile_photo_bloc/profile_photo_bloc.dart';
import 'package:famici/feature/chat/blocs/chat_profile_bloc/chat_profile_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/maintenance/bloc/maintenance_bloc.dart';

import '../../../feature/care_team/blocs/care_team_bloc.dart';
import '../../../feature/care_team/company_logo_bloc/company_logo_bloc.dart';
import '../../../feature/chat/blocs/call_history_bloc/history_bloc.dart';
import '../../../feature/chat/blocs/chat_bloc/chat_bloc.dart';
import '../../../feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import '../../../feature/member_profile/blocs/member_profile_bloc.dart';
import '../../../feature/notification/helper/appointment_company_settings_fetcher.dart';
import '../../../feature/notification/helper/user_notify_helper.dart';
import '../../../feature/video_call/blocs/user_db_bloc/user_db_bloc.dart';
import '../../../feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import '../../../repositories/barrel.dart';
import '../../../utils/barrel.dart';
import '../../enitity/barrel.dart';
import '../../router/router_delegate.dart';
import '../theme_builder_bloc/theme_builder_bloc.dart';

import 'package:permission_handler/permission_handler.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required ManageHistoryBloc manageHistoryBloc,
    required User me,
    required VitalSyncBloc vitalSyncBloc,
    required ChatBloc chatBloc,
    required VitalsAndWellnessBloc vitalsAndWellnessBloc,
    required UserDbBloc userDbBloc,
    required BatteryCubit batteryCubit,
    required ConnectivityBloc connectivityBloc,
    required CalendarBloc calendarBloc,
    required MaintenanceBloc maintenanceBloc,
    required MedicationBloc medicationBloc,
    required CareTeamBloc careTeamBloc,
    required MemberProfileBloc memberProfileBloc,
    required ChatProfilesBloc chatProfileBloc,
    required CompanyLogoBloc companyLogoBloc,
    required ProfilePhotoBloc profilePhotoBloc,
    required ThemeBuilderBloc themeBuilderBloc,
  })  : _me = me,
        _manageHistoryBloc = manageHistoryBloc,
        _vitalSyncBloc = vitalSyncBloc,
        _vitalsAndWellnessBloc = vitalsAndWellnessBloc,
        _chatBloc = chatBloc,
        _userDbBloc = userDbBloc,
        _batteryCubit = batteryCubit,
        _connectivityBloc = connectivityBloc,
        _calendarBloc = calendarBloc,
        _maintenanceBloc = maintenanceBloc,
        _medicationBloc = medicationBloc,
        _careTeamBloc = careTeamBloc,
        _memberProfileBloc = memberProfileBloc,
        _chatProfileBloc = chatProfileBloc,
        _companyLogoBloc = companyLogoBloc,
        _profilePhotoBloc = profilePhotoBloc,
        _themeBuilderBloc = themeBuilderBloc,
        super(AppState.initial()) {
    // on<AppEvent>((event, emit) {});
    on<ClockTimerStart>(_mapClockTimeStartEventToState);
    on<ClockTimeUpdated>(_mapClockTimeUpdatedEventToState);
    on<AppInitializedEvent>(_onAppInitializedEventToState);
    on<AppInitializedOfflineEvent>(_onAppInitializedOfflineEventToState);
    on<EnableLock>(_mapEnableLockEventToState);
    on<DisableLock>(_mapDisableLockEventToState);
    on<SyncDeviceInfoEvent>(_mapSyncDeviceInfoEvent);
    on<StartedSyncingDeviceInfoEvent>(_mapStartedSyncingDeviceInfoEvent);
    on<ListenToContactChangesEvent>(_mapListenToContactChangesEvent);

    add(ClockTimerStart());
    _maintenanceBloc.add(MaintenanceInitializedMaintenanceEvent());
  }

  final User _me;

  final UserRepository _userRepository = UserRepository();
  final ConfigService _configService = ConfigService();
  DataFetcher companySettingsFetcher = DataFetcher();

  final VitalSyncBloc _vitalSyncBloc;
  final VitalsAndWellnessBloc _vitalsAndWellnessBloc;
  final ChatBloc _chatBloc;
  final UserDbBloc _userDbBloc;
  final ConnectivityBloc _connectivityBloc;
  final BatteryCubit _batteryCubit;
  final CalendarBloc _calendarBloc;
  final MaintenanceBloc _maintenanceBloc;
  final MedicationBloc _medicationBloc;
  final ManageHistoryBloc _manageHistoryBloc;
  final CareTeamBloc _careTeamBloc;
  final MemberProfileBloc _memberProfileBloc;
  final ChatProfilesBloc _chatProfileBloc;
  final CompanyLogoBloc _companyLogoBloc;
  final ProfilePhotoBloc _profilePhotoBloc;
  final ThemeBuilderBloc _themeBuilderBloc;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final DeviceRepository _deviceRepository = DeviceRepository();

  StreamSubscription? usersChanged;

  StreamSubscription? _timeSubscription;

  StreamSubscription? _batterySubscription;
  StreamSubscription? _connectivitySubscription;

  forceGrandNotificationPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    if (await Permission.notification.status == PermissionStatus.denied) {
      forceGrandNotificationPermission();
    }
  }

  void _onAppInitializedEventToState(AppInitializedEvent event, emit) async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    forceGrandNotificationPermission();

    String? locale =
        fcRouter.navigatorKey.currentState?.context.locale.toString();

    int zone = DateTime.now().timeZoneOffset.inMinutes;

    await _configService.saveLocaleAndTimeZone(
      timezone: zone.toString(),
      locale: locale,
    );

    try {
      FirebaseMessaging.instance.getToken().then((dToken) async {
        print("Device Token ::: ${dToken}");
        await _configService.saveDeviceToken(
          deviceToken: dToken,
        );
      });
    } catch (err) {
      DebugLogger.error(err);
    }

    _connectivityBloc.add(CheckInternetConnectivity());

    _themeBuilderBloc.add(FetchDetailsEvent(hasUpdate: false));
    _calendarBloc.add(LoadAllICals());
    _vitalsAndWellnessBloc.add(FetchVitals());
    _vitalsAndWellnessBloc.add(FetchWellness());
    _chatBloc.add(SyncArchivedMessages());
    _chatBloc.add(SubscribedToMessagesChatEvent());
    _userDbBloc.add(SyncUsersUserDbEvent());
    _calendarBloc.add(FetchMonthAppointments());
    _calendarBloc.add(FetchThisWeekAppointmentsCalendarEvent());
    _medicationBloc.add(FetchMedications());
    _careTeamBloc.add(GetCareTeamMembers());
    _manageHistoryBloc.add(FetchCallHistoryData());
    // _memberProfileBloc.add(FetchMemberProfileDetailsEvent());
    // fcRouter.replaceAll([HomeRoute()]);
    add(ListenToContactChangesEvent());
    Future.delayed(Duration(seconds: 2), () {
      _vitalSyncBloc.add(SyncMyDevices());
    });

    emit(state.copyWith(initialized: true));

    add(SyncDeviceInfoEvent());
    add(StartedSyncingDeviceInfoEvent());
    _userDbBloc.add(ListenToStatusUpdateUserDbEvent());
    _userDbBloc.add(IamOnlineUserDbEvent());

    _chatProfileBloc.add(FetchingChatProfiles());
    _companyLogoBloc.add(FetchCompanyLogoEvent());
    _profilePhotoBloc.add(FetchProfilePhotoEvent());

    // try {
    //   companySettingsFetcher.start();
    // } catch(err){
    //   DebugLogger.error("error in starting the cron job");
    // }
  }

  Future<void> _onAppInitializedOfflineEventToState(
    AppInitializedOfflineEvent event,
    emit,
  ) async {
    _vitalsAndWellnessBloc.add(FetchVitals());
    _vitalsAndWellnessBloc.add(FetchWellness());
    _chatBloc.add(SyncArchivedMessages());
    _chatBloc.add(SubscribedToMessagesChatEvent());
    _userDbBloc.add(SyncUsersUserDbEvent());
    _calendarBloc.add(FetchMonthAppointments());
    _calendarBloc.add(FetchThisWeekAppointmentsCalendarEvent());
    _medicationBloc.add(FetchMedications());
    _careTeamBloc.add(GetCareTeamMembers());
    // _memberProfileBloc.add(FetchMemberProfileDetailsEvent());
    // fcRouter.replaceAll([HomeRoute()]);

    Future.delayed(Duration(seconds: 2), () {
      _vitalSyncBloc.add(SyncMyDevices());
    });

    emit(state.copyWith(initialized: true));
  }

  Future<void> _mapClockTimeStartEventToState(
      ClockTimerStart event, emit) async {
    _timeSubscription ??= Stream.periodic(Duration(seconds: 1)).listen((event) {
      add(ClockTimeUpdated());
    });
  }

  Future<void> _mapClockTimeUpdatedEventToState(
      ClockTimeUpdated event, emit) async {
    try {
      DateTime dateTime = DateTime.now();
      final time = DateFormat('h:mm a')
          .format(dateTime)
          .replaceAll('am', 'AM')
          .replaceAll('pm', 'PM');
      final date = DateFormat(dateFormat).format(dateTime);
      emit(state.copyWith(time: time, date: date));
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<void> _mapEnableLockEventToState(EnableLock event, emit) async {
    emit(state.copyWith(locked: true));
  }

  Future<void> _mapDisableLockEventToState(DisableLock event, emit) async {
    emit(state.copyWith(locked: false));
  }

  Future<void> _mapStartedSyncingDeviceInfoEvent(
    StartedSyncingDeviceInfoEvent event,
    emit,
  ) async {
    _batterySubscription = _batteryCubit.stream.listen((event) {
      add(SyncDeviceInfoEvent());
    });
    _connectivitySubscription = _connectivityBloc.stream.listen((event) {
      add(SyncDeviceInfoEvent());
    });
  }

  Future<void> _mapListenToContactChangesEvent(
    ListenToContactChangesEvent event,
    emit,
  ) async {
    //this will trigger when every notification coming from firebase
    usersChanged ??= FirebaseMessaging.onMessage.listen((event) {
      if (isUserOperation(event.data['type'])) {
        _userDbBloc.add(SyncUsersUserDbEvent(omitListeners: true));
      }
    });
  }

  Future<void> _mapSyncDeviceInfoEvent(SyncDeviceInfoEvent event, emit) async {
    if (!_connectivityBloc.state.hasInternet) {
      return;
    }
    var _saved = await _secureStorage.read(key: "fc_device_info");
    UserDevice _userDevice = UserDevice.fromRawJson(_saved);

    if (_userDevice.userDeviceId.isEmpty) {
      AndroidDeviceInfo _device = await DeviceInfoPlugin().androidInfo;

      UserDevice _created = await _deviceRepository.createUserDevice(
        _userDevice.copyWith(
          deviceName: _device.device,
          metadata: jsonEncode(_device.toMap()),
        ),
      );

      _secureStorage.write(key: 'fc_device_info', value: _created.toRawJson());
      _userDevice = _created;
    }
    _deviceRepository.updateDeviceStatus(
      _userDevice.userDeviceId,
      DeviceStatus(
        battery: _batteryCubit.state.percentage,
        wifi: _connectivityBloc.state.isWifiOn ? "Connected" : "NotConnected",
        bluetooth: _connectivityBloc.state.isBluetoothOn
            ? "Connected"
            : "NotConnected",
      ),
    );
  }

  @override
  Future<void> close() {
    _timeSubscription?.cancel();
    _batterySubscription?.cancel();
    _connectivitySubscription?.cancel();
    _timeSubscription = null;
    _batterySubscription = null;
    _connectivitySubscription = null;
    return super.close();
  }
}
