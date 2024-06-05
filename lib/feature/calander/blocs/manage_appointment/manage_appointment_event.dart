part of 'manage_appointment_bloc.dart';

@immutable
abstract class ManageAppointmentEvent {}

class CreateAppointmentNextStep extends ManageAppointmentEvent {
  CreateAppointmentNextStep();
}

class CreateAppointmentPreviousStep extends ManageAppointmentEvent {
  CreateAppointmentPreviousStep();
}

class AppointmentTypeChange extends ManageAppointmentEvent {
  final AppointmentType type;

  AppointmentTypeChange(this.type);
}

class AppointmentNameChange extends ManageAppointmentEvent {
  final String name;
  AppointmentNameChange(this.name);
}

class AppointmentDateChange extends ManageAppointmentEvent {
  final DateTime date;
  AppointmentDateChange(this.date);
}

class AppointmentStartTimeChange extends ManageAppointmentEvent {
  final DateTime date;
  AppointmentStartTimeChange(this.date);
}

class AppointmentEndTimeChange extends ManageAppointmentEvent {
  final DateTime date;
  AppointmentEndTimeChange(this.date);
}

class AppointmentRecurrenceChange extends ManageAppointmentEvent {
  final RecurrenceType recurrence;

  AppointmentRecurrenceChange(this.recurrence);
}

class AppointmentAllDayToggle extends ManageAppointmentEvent {
  AppointmentAllDayToggle();
}

class AppointmentToggleGuest extends ManageAppointmentEvent {
  final User guest;
  AppointmentToggleGuest(this.guest);
}

class AppointmentChangeLocation extends ManageAppointmentEvent {
  final Address location;

  AppointmentChangeLocation(this.location);
}

class AppointmentNotesChange extends ManageAppointmentEvent {
  final String notes;

  AppointmentNotesChange(this.notes);
}

class AppointmentDescriptionChange extends ManageAppointmentEvent {
  final String description;

  AppointmentDescriptionChange(this.description);
}

class GetAppointment extends ManageAppointmentEvent {
  final String appointmentId;
  GetAppointment(this.appointmentId);
}

class ResetAllAppointmentData extends ManageAppointmentEvent {
  ResetAllAppointmentData();
}

class SaveManageAppointmentEvent extends ManageAppointmentEvent {}

class UpdateManageAppointmentEvent extends ManageAppointmentEvent {}

class SubmitNameManageAppointmentEvent extends ManageAppointmentEvent {}

class SubmitDateManageAppointmentEvent extends ManageAppointmentEvent {}

class SubmitTimeManageAppointmentEvent extends ManageAppointmentEvent {}

class SubmitGuestsManageAppointmentEvent extends ManageAppointmentEvent {}

class SubmitRecurrenceManageAppointmentEvent extends ManageAppointmentEvent {}
