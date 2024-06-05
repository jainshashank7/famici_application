part of 'user_db_bloc.dart';

abstract class UserDbEvent extends Equatable {}

class SyncUsersUserDbEvent extends UserDbEvent {
  final bool omitListeners;

  SyncUsersUserDbEvent({this.omitListeners = false});
  @override
  List<Object?> get props => [];
}

class UserStatusUpdatedUserDbEvent extends UserDbEvent {
  final HeartBeat heartBeat;

  UserStatusUpdatedUserDbEvent(this.heartBeat);
  @override
  List<Object?> get props => [];
}

class ListenToStatusUpdateUserDbEvent extends UserDbEvent {
  @override
  List<Object?> get props => [];
}

class UpdateMyHeartBeatUserDbEvent extends UserDbEvent {
  @override
  List<Object?> get props => [];
}

class IamOnlineUserDbEvent extends UserDbEvent {
  @override
  List<Object?> get props => [];
}

class IamOfflineUserDbEvent extends UserDbEvent {
  @override
  List<Object?> get props => [];
}
