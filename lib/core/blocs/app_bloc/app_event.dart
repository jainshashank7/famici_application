part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

class ClockTimerStart extends AppEvent {
  @override
  List<Object?> get props => [];
}

class ClockTimeUpdated extends AppEvent {
  @override
  List<Object?> get props => [];
}

class EnableLock extends AppEvent {
  @override
  List<Object?> get props => [];
}

class DisableLock extends AppEvent {
  @override
  List<Object?> get props => [];
}

class AppInitializedEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class AppInitializedOfflineEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class SyncDeviceInfoEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class StartedSyncingDeviceInfoEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class ListenToContactChangesEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}
