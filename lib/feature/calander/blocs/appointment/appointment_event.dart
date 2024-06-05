part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
}

class SyncAppointmentEvent extends AppointmentEvent {
  const SyncAppointmentEvent(this.appointment);

  final Appointment appointment;

  @override
  List<Object?> get props => [appointment];
}

class AddAppointmentData extends AppointmentEvent{
  const AddAppointmentData({required this.items});
  final List<ContainerItem> items;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class IncreaseIndex extends AppointmentEvent{
  const IncreaseIndex({required this.index});
  final int index;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ResetIndex extends AppointmentEvent{
  const ResetIndex();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DeleteAppointment extends AppointmentEvent {
  final String appointmentId;
  const DeleteAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}
