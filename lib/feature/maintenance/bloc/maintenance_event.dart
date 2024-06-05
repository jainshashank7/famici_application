part of 'maintenance_bloc.dart';

abstract class MaintenanceEvent extends Equatable {
  const MaintenanceEvent();
}

class MaintenanceInitializedMaintenanceEvent extends MaintenanceEvent {
  @override
  List<Object?> get props => [];
}

class CheckUpdates extends MaintenanceEvent {
  @override
  List<Object?> get props => [];
}

class ConfigChangedMaintenanceEvent extends MaintenanceEvent {
  final MaintenanceConfig config;

  const ConfigChangedMaintenanceEvent({required this.config});

  @override
  List<Object?> get props => [config];
}

class ContactConfigChangedMaintenanceEvent extends MaintenanceEvent {
  final ContactConfig contact;

  const ContactConfigChangedMaintenanceEvent({required this.contact});

  @override
  List<Object?> get props => [contact];
}

class GoToUpdateFromStoreMaintenanceEvent extends MaintenanceEvent {
  @override
  List<Object?> get props => [];
}
