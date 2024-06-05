part of 'appointment_bloc.dart';

class AppointmentState extends Equatable {
  const AppointmentState({
    required this.appointment,
    required this.status,
    required this.items,
    required this.currentIndex,
  });

  final Appointment appointment;
  final Status status;

  final List<ContainerItem> items;
  final int currentIndex;

  factory AppointmentState.initial() {
    return AppointmentState(
      appointment: Appointment(),
      status: Status.initial,
      items: [],
      currentIndex: 0,
    );
  }

  AppointmentState copyWith(
      {Appointment? appointment,
      Status? status,
      int? currentIndex,
      List<ContainerItem>? items}) {
    return AppointmentState(
        appointment: appointment ?? this.appointment,
        status: status ?? this.status,
        items: items ?? this.items,
        currentIndex: currentIndex ?? this.currentIndex);
  }

  bool get isLoading => status == Status.loading;

  @override
  List<Object> get props => [
        appointment,
        status,
        currentIndex,
        items,
      ];
}
