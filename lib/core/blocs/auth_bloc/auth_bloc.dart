import 'dart:async';
import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/chat/repository/local_user_service/local_user_service.dart';
import 'package:famici/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../feature/notification/helper/appointment_company_settings_fetcher.dart';
import '../../../feature/video_call/helper/call_manager/call_manager.dart';
import '../../../repositories/user_pin_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../../../utils/helpers/firebase_helper.dart';
import '../../../utils/helpers/notification_helper.dart';
import '../../offline/local_database/notifiction_db.dart';
import '../../offline/local_database/users_db.dart';
import '../app_bloc/app_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc({
    required User me,
    required AppBloc appBloc,
    required ConnectivityBloc connectivityBloc,
    required ThemeBuilderBloc themeBuilderBloc,
  })  : _me = me,
        _appBloc = appBloc,
        _connectivityBloc = connectivityBloc,
        _themeBuilderBloc = themeBuilderBloc,
        super(AuthState.initial()) {
    on<SignInAuthEvent>(_onSignInAuthEvent);
    on<AutoSignInAuthEvent>(_onAutoSignInAuthEvent);
    on<StartedCompleteSignInAuthEvent>(_onStartedCompleteSignInAuthEvent);
    on<AuthenticatedEvent>(_onAuthenticatedEvent);
    on<ConfirmUserSignInAuthEvent>(_onConfirmUserSignInAuthEvent);
    on<SignOutAuthEvent>(_onSignOutAuthEvent);
    on<ResetConfirmUserFailedAuthEvent>(_onResetConfirmUserFailedAuthEvent);
    on<SuccessfullyAuthenticatedAuthEvent>(
      _onSuccessfullyAuthenticatedAuthEvent,
    );
    on<CheckUserStatus>(_onCheckUserStatus);
    add(AutoSignInAuthEvent());
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();
  final PinRepository pins = PinRepository();
  final LocalUserService _localUserService = LocalUserService();
  final FlutterSecureStorage _vault = FlutterSecureStorage();
  final LoggedUser _savedUserId = LoggedUser();
  var userEmail = "";
  DataFetcher companySettingsFetcher = DataFetcher();

  ConnectivityBloc _connectivityBloc;
  ThemeBuilderBloc _themeBuilderBloc;

  final AppBloc _appBloc;

  Future<void> _onSignInAuthEvent(SignInAuthEvent event, emit) async {
    final prefs = await SharedPreferences.getInstance();
    (state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.signIn(
        username: event.username,
        password: event.password,
      );

      DebugLogger.debug("on Sign In Event enter");

      User current = await _authRepository.currentUser();

      // print(current.toCurrentAuthUserJson());
      // print("%%%%%");
      // var res = await _authRepository.generateAccessToken();
      // print(res);

      // await NotificationHelper.closeNotificationChannels();
      NotificationHelper.initializeNotificationsPlugin();
      await FirebaseHelper.initializeFirebasePlugins();

      if (current.id != null) {
        prefs.setBool('authenticate', false);
        _me.copyFrom(current);

        try {
          final DatabaseHelperForUsers userDetails = DatabaseHelperForUsers();

          userDetails.insertUserDetails(
              event.username, event.password, current.name, "");

          String jsonData = jsonEncode(current.toCurrentAuthUserJson());

          // prefs.setString("current_user", jsonData);
          await _vault.write(key: "current_user", value: jsonData);

          userDetails.insertUserDataDetails(
              event.username, jsonData, current.customAttribute2.userId);
        } catch (err) {
          DebugLogger.error(err);
        }

        await _vault.write(key: 'creds_username', value: event.username);
        await _vault.write(key: 'creds_pass_code', value: event.password);

        // emit(state.copyWith(user: _me, status: AuthStatus.authenticated));

        add(SuccessfullyAuthenticatedAuthEvent());
      } else {
        emit(state.copyWith(status: AuthStatus.confirmFailed));
      }
    } on UserNotFoundException {
      emit(state.copyWith(status: AuthStatus.confirmFailed));
    } catch (er) {
      final DatabaseHelperForUsers userDetails = DatabaseHelperForUsers();
      String? dbPass = await userDetails.readPassFromTable(event.username);

      if (dbPass == event.password) {
        List<Map<String, dynamic>> userData =
            await userDetails.getCredentialsUsers(event.username);
        try {
          final userJson = jsonDecode(userData[0]['user']);
          User _current = User.fromCurrentAuthUserJson(userJson);

          if (_current.id?.isNotEmpty ?? false) {
            await _vault.write(key: "current_user", value: userData[0]['user']);

            _me.copyFrom(_current);

            emit(state.copyWith(
              user: _current,
              status: AuthStatus.authenticated,
            ));
            userEmail = event.username;

            prefs.setString("user_name", event.username);
            prefs.setString("user_password", event.password);
            prefs.setBool("authenticate", true);

            add(SuccessfullyAuthenticatedAuthEvent());
          } else {
            emit(state.copyWith(status: AuthStatus.confirmFailed));
          }
        } catch (err) {
          DebugLogger.error(err);
        }
      } else {
        emit(state.copyWith(status: AuthStatus.confirmFailed));
      }
    }
  }

  Future<void> _onAutoSignInAuthEvent(event, emit) async {
    try {
      _connectivityBloc.add(ListenToConnectivityStatus());
      _connectivityBloc.add(CheckInternetConnectivity());
      bool isSignedIn = await _authRepository.isSignedIn();

      String? _user = await _vault.read(key: 'creds_username') ?? '';
      String? _pass = await _vault.read(key: 'creds_pass_code') ?? '';

      if (isSignedIn) {
        add(SuccessfullyAuthenticatedAuthEvent());
      } else if (_user.isNotEmpty && _pass.isNotEmpty) {
        add(SignInAuthEvent(username: _user, password: _pass));
      } else {
        throw Exception("Unable to load user");
      }
    } catch (err) {
      add(StartedCompleteSignInAuthEvent());
    }
  }

  Future<void> _onConfirmUserSignInAuthEvent(
    ConfirmUserSignInAuthEvent event,
    emit,
  ) async {
    try {
      if (state.status == AuthStatus.confirmationRequired ||
          state.status == AuthStatus.unauthenticated) {
        emit(state.copyWith(status: AuthStatus.confirming));
        // JoinFamilyResponse _res = await _authRepository.confirmInviteCode(
        //   inviteCode: event.inviteCode,
        // );
        //
        // if (_res.isAccepted && _res.username == event.email) {
        //   Future.delayed(Duration(seconds: 2), () {
        //     add(SignInAuthEvent(
        //       username: _res.username,
        //       password: _res.inviteCode,
        //     ));
        //   });
        // } else {
        //   emit(state.copyWith(status: AuthStatus.confirmFailed));
        //   throw Exception('Unable to verify user at the moment');
        // }
        add(SignInAuthEvent(
          username: event.email,
          password: event.inviteCode,
        ));
      }
    } catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(status: AuthStatus.confirmFailed));
      throw Exception('Unable to verify user at the moment');
    }
  }

  Future<void> _onStartedCompleteSignInAuthEvent(event, emit) async {
    emit(state.copyWith(status: AuthStatus.confirmationRequired));
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  Future<void> _onSuccessfullyAuthenticatedAuthEvent(event, emit) async {
    if (await _isConnectedToInternet()) {
      try {
        emit(state.copyWith(status: AuthStatus.loading));

        User _current = await _authRepository.currentUser();

        // await pins.createPin(_current.email, "1234");

        await DatabaseHelperForNotifications.initDb(_current.id);

        _me.copyFrom(_current);
        _savedUserId.save(_me.id!);

        await _localUserService.addUser(_me);
        _appBloc.add(AppInitializedEvent());

        // final DatabaseHelperForUsers userDetails = DatabaseHelperForUsers();
        // String? userPin =
        //     await userDetails.readPinFromTable(_me.email ?? "invalid id");

        String? userPin = await pins.getUserPin(_me.email);

        if (userPin != null && userPin != '') {
          try {
            final DatabaseHelperForUsers userDetails = DatabaseHelperForUsers();
            await userDetails.insertPinDetails(
                _current.email ?? "invalidUser", userPin);
          } catch (err) {
            DebugLogger.error(err);
          }
          emit(state.copyWith(user: _me, status: AuthStatus.authenticated));
        } else if (userPin == null) {
          emit(state.copyWith(user: _me, status: AuthStatus.pinUpdate));
        } else {
          emit(state.copyWith(user: _me, status: AuthStatus.pinRequired));
        }

        add(CheckUserStatus());
      } catch (err) {
        DebugLogger.error(err);
        _me.copyFrom(state.user);
        _savedUserId.save(_me.id!);
        _appBloc.add(AppInitializedOfflineEvent());

        emit(state.copyWith(status: AuthStatus.authenticated));
      }
    } else {
      //offline
      try {
        emit(state.copyWith(status: AuthStatus.loading));

        final DatabaseHelperForUsers userDetails = DatabaseHelperForUsers();

        List<Map<String, dynamic>> userData =
            await userDetails.getCredentialsUsers(userEmail);

        final userJson = jsonDecode(userData[0]['user']);
        User _current = User.fromCurrentAuthUserJson(userJson);

        _me.copyFrom(_current);
        _savedUserId.save(_me.id!);

        await _localUserService.addUser(_me);
        _appBloc.add(AppInitializedEvent());
        emit(state.copyWith(status: AuthStatus.authenticated));
      } catch (err) {
        DebugLogger.error(err);
        _me.copyFrom(state.user);
        _savedUserId.save(_me.id!);
        _appBloc.add(AppInitializedOfflineEvent());

        emit(state.copyWith(status: AuthStatus.authenticated));
      }
    }
  }

  Future<void> _onSignOutAuthEvent(SignOutAuthEvent event, emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      FirebaseMessaging.instance.deleteToken();
      AwesomeNotifications().cancelAllSchedules();
      await _authRepository.signeOut();
      _themeBuilderBloc.add(SetDetailsEvent());
      // companySettingsFetcher.stop();
      // emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(status: AuthStatus.authenticated));
    }
  }

  Future<void> _onResetConfirmUserFailedAuthEvent(
    ResetConfirmUserFailedAuthEvent event,
    emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.confirmationRequired));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }

  FutureOr<void> _onAuthenticatedEvent(
      AuthenticatedEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.authenticated));
  }

  FutureOr<void> _onCheckUserStatus(
      CheckUserStatus event, Emitter<AuthState> emit) async {
    // await Future.delayed(Duration(seconds: 10));
    // print("%%%%%% ched2");

    final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
    List<Map<String, dynamic>> userData =
        await dbFactory.readDataFromUserdata();

    List userIds = userData.map((user) => user['userId']).toList();

    String? email = _me.email;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    // print("%%%%%%%");
    // print(email);
    // print(accessToken);
    // print(clientId);
    // print(companyId);

    if (await _isConnectedToInternet() && accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };

      var imageBody = json.encode({"userIds": userIds});

      var response = await http.post(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/clients/getClientStatus'),
          body: imageBody,
          headers: headers);

      userIds.sort();

      if (response.statusCode == 200) {
        List<String> data = json.decode(response.body).cast<String>();
        for (int i = 0; i < data.length; i++) {
          if (data[i] == "Inactive") {
            String? mail = await dbFactory.getUsernameByUserId(userIds[i]);
            if (mail != null) {
              dbFactory.deleteCredsByEmail(mail);
              dbFactory.deleteUserDataDetails(userIds[i]);
            }
          }
        }
      }
    }
  }
}
