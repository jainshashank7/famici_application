import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/care_team/blocs/care_team_bloc.dart';
import 'package:famici/repositories/user_status_repository/user_status_repository.dart';

import '../../../../repositories/user_repository.dart';
import '../../../chat/repository/local_user_service/local_user_service.dart';
import '../../../notification/entities/notification.dart';

part 'user_db_event.dart';

part 'user_db_state.dart';

class UserDbBloc extends HydratedBloc<UserDbEvent, UserDbState> {
  UserDbBloc({required User me, required ConnectivityBloc connectivityBloc})
      : _me = me,
        _connectivityBloc = connectivityBloc,
        super(UserDbState.initial()) {
    on<SyncUsersUserDbEvent>(_onSyncUsersDbEvent);
    on<ListenToStatusUpdateUserDbEvent>(_onListenToStatusUpdateUserDbEvent);
    on<UserStatusUpdatedUserDbEvent>(_onUserStatusUpdatedUserDbEvent);
    on<UpdateMyHeartBeatUserDbEvent>(_onUpdateMyHeartBeatUserDbEvent);
    on<IamOnlineUserDbEvent>(_onIamOnlineUserDbEvent);
    on<IamOfflineUserDbEvent>(_onIamOfflineUserDbEvent);

    _connectivityBloc.stream.listen((event) async {
      await Future.delayed(Duration(seconds: 0));
      add(SyncUsersUserDbEvent());
    });
  }

  final UserRepository _userRepo = UserRepository();
  final LocalUserService _localUserService = LocalUserService();
  final User _me;
  final UserStatusRepo _userStatusRepo = UserStatusRepo();
  // final CareTeamBloc _careTeamBloc = CareTeamBloc();

  StreamSubscription? _userStatusSubscription;

  final ConnectivityBloc _connectivityBloc;

  Timer? _heartBeat;

  void _onSyncUsersDbEvent(SyncUsersUserDbEvent event, emit) async {
    try {
      if (!_connectivityBloc.state.hasInternet) {
        _heartBeat?.cancel();
        _heartBeat = null;
        return;
      }

      Map<String, User> ccUsers = {};
      Map<String, User> fcUsers = {};

      List<User> contacts = await _userRepo.fetchContacts(
        familyId: _me.familyId!,
      );
      ccUsers.addAll({for (var e in contacts) e.ccId: e});
      fcUsers.addAll({for (var e in contacts) e.id!: e});

      // print('%%%%%%%%%%%%%%%%%%%%');
      // contacts.forEach((element) {
      //   print(element.toCurrentAuthUserJson());
      // });

      _localUserService.addBulkUsers(contacts).then((value) {
        DebugLogger.info("contacts updated on local db");
      });
      emit(state.copyWith(fcUsers: fcUsers, ccUsers: ccUsers));
      if (!event.omitListeners) {
        add(ListenToStatusUpdateUserDbEvent());
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _onListenToStatusUpdateUserDbEvent(
    ListenToStatusUpdateUserDbEvent event,
    emit,
  ) async {
    try {
      if (_me.id == null || _me.id!.isEmpty) {
        return;
      }
      if (!_connectivityBloc.state.hasInternet) {
        _userStatusSubscription?.cancel();
        _userStatusSubscription = null;
        return;
      }
      _userStatusSubscription?.cancel();
      _userStatusSubscription = null;

      _userStatusSubscription ??=
          _userStatusRepo.subscribe(familyId: _me.familyId).listen((heartBeat) {
        add(UserStatusUpdatedUserDbEvent(heartBeat));
      }, onError: (err) {
        _userStatusSubscription?.cancel();
        _userStatusSubscription = null;
        add(IamOfflineUserDbEvent());
      });
      add(IamOnlineUserDbEvent());
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _onUserStatusUpdatedUserDbEvent(
    UserStatusUpdatedUserDbEvent event,
    emit,
  ) async {
    try {
      HeartBeat pulse = event.heartBeat;
      Map<String, User> ccUsers = Map.from(state.ccUsers);
      Map<String, User> fcUsers = Map.from(state.fcUsers);

      User? user = fcUsers[pulse.contactId];

      if (user != null) {
        fcUsers[pulse.contactId] = user.copyWith(
          activeStatus: pulse.activeStatus,
        );
        ccUsers[user.ccId] = user.copyWith(
          activeStatus: pulse.activeStatus,
        );
        emit(state.copyWith(ccUsers: ccUsers, fcUsers: fcUsers));
      } else if (pulse.contactId.isNotEmpty && pulse.contactId != _me.id) {
        add(SyncUsersUserDbEvent(omitListeners: true));
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _onUpdateMyHeartBeatUserDbEvent(
    UpdateMyHeartBeatUserDbEvent event,
    emit,
  ) async {
    try {
      if (!_connectivityBloc.state.hasInternet || _me.id == null) {
        return;
      }
      await _userStatusRepo.heartBeat(familyId: _me.familyId);
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _onIamOnlineUserDbEvent(
    IamOnlineUserDbEvent event,
    emit,
  ) async {
    // try {
    //   if (!_connectivityBloc.state.hasInternet || _me.id == null) {
    //     _heartBeat?.cancel();
    //     _heartBeat = null;
    //     return;
    //   }
    //   if (_me.familyId != null) {
    //     await _userStatusRepo.connect(familyId: _me.familyId);
    //     // _heartBeat = Timer.periodic(const Duration(seconds: 10), (timer) {
    //     add(UpdateMyHeartBeatUserDbEvent());
    //     // });
    //   }
    // } catch (err) {
    //   DebugLogger.error(err);
    // }
  }

  void _onIamOfflineUserDbEvent(
    IamOfflineUserDbEvent event,
    emit,
  ) async {
    // try {
    //   _heartBeat?.cancel();
    //   _heartBeat = null;
    //
    //   if (!_connectivityBloc.state.hasInternet) {
    //     return;
    //   }
    //   if (_me.familyId != null) {
    //     await _userStatusRepo.disconnect(familyId: _me.familyId);
    //   }
    // } catch (err) {
    //   DebugLogger.error(err);
    // }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return UserDbState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _userStatusSubscription?.cancel();
    _userStatusRepo.dispose();
    _heartBeat?.cancel();
    return super.close();
  }
}
