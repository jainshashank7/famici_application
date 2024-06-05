part of 'manage_appointment_bloc.dart';

class ManageAppointmentState {
  ManageAppointmentState({
    required this.currentStep,
    required this.appointmentType,
    required this.appointmentName,
    required this.appointmentNameError,
    required this.appointmentTimeError,
    required this.summary,
    required this.appointmentDate,
    required this.appointmentStartTime,
    required this.appointmentEndTime,
    required this.recurrence,
    required this.allDay,
    required this.guestEmail,
    required this.guests,
    required this.location,
    required this.notes,
    required this.description,
    required this.status,
    required this.submissionStatus,
    required this.appointmentId,
  });

  int currentStep;
  AppointmentType appointmentType;
  String appointmentName;
  bool appointmentNameError;
  bool appointmentTimeError;
  List<Map<String, String>> summary;
  DateTime appointmentDate;
  DateTime appointmentStartTime;
  DateTime appointmentEndTime;
  RecurrenceType recurrence;
  bool allDay;
  String guestEmail;
  final List<User> guests;
  Address location;
  String notes;
  String description;
  Status status;
  Status submissionStatus;
  String appointmentId;

  static ManageAppointmentState _editAppointment(Appointment appointment) {
    List<User> _guests =
        appointment.guestsMetaData.map((e) => User.fromJsonContact(e)).toList();
    return ManageAppointmentState(
      currentStep: 0,
      appointmentId: appointment.appointmentId,
      appointmentType: appointment.appointmentType,
      appointmentName: appointment.appointmentName,
      appointmentNameError: false,
      appointmentTimeError: false,
      summary: appointment.summary,
      appointmentDate: appointment.appointmentDate,
      appointmentStartTime: appointment.startTime,
      appointmentEndTime: appointment.endTime,
      recurrence: appointment.recurrenceType,
      allDay: appointment.isAllDay,
      guestEmail: _guests.map((e) => e.email).toList().join(','),
      guests: _guests,
      location: appointment.location,
      notes: appointment.notes,
      description: appointment.taskDescription,
      status: Status.initial,
      submissionStatus: Status.initial,
    );
  }

  factory ManageAppointmentState.initial({required Appointment appointment}) {
    if (appointment.appointmentId.isNotEmpty) {
      return _editAppointment(appointment);
    }
    return ManageAppointmentState(
      currentStep: 0,
      appointmentId: '',
      appointmentType: AppointmentType.individual,
      appointmentName: "",
      appointmentNameError: false,
      appointmentTimeError: false,
      summary: [],
      appointmentDate: DateTime.now(),
      appointmentStartTime: DateTime.now(),
      appointmentEndTime: DateTime.now().add(Duration(hours: 1)),
      recurrence: RecurrenceType.doesNotRepeat,
      allDay: false,
      guestEmail: "",
      guests: [],
      location: Address(),
      notes: "",
      description: "",
      status: Status.initial,
      submissionStatus: Status.initial,
    );
  }

  ManageAppointmentState copyWith({
    int? currentStep,
    AppointmentType? appointmentType,
    String? appointmentName,
    bool? appointmentNameError,
    bool? appointmentTimeError,
    List<Map<String, String>>? summary,
    DateTime? appointmentDate,
    DateTime? appointmentStartTime,
    DateTime? appointmentEndTime,
    RecurrenceType? recurrence,
    bool? allDay,
    String? guestEmail,
    List<User>? guests,
    Address? location,
    String? notes,
    String? description,
    Status? status,
    Status? submissionStatus,
    String? appointmentId,
  }) {
    return ManageAppointmentState(
      currentStep: currentStep ?? this.currentStep,
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentName: appointmentName ?? this.appointmentName,
      appointmentNameError: appointmentNameError ?? this.appointmentNameError,
      appointmentTimeError: appointmentTimeError ?? this.appointmentTimeError,
      summary: summary ?? this.summary,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentStartTime: appointmentStartTime ?? this.appointmentStartTime,
      appointmentEndTime: appointmentEndTime ?? this.appointmentEndTime,
      recurrence: recurrence ?? this.recurrence,
      allDay: allDay ?? this.allDay,
      guestEmail: guestEmail ?? this.guestEmail,
      guests: guests ?? this.guests,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      description: description ?? this.description,
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }

  bool get isEditing => appointmentId.isNotEmpty;
  bool get isLoading => Status.loading == status;

  bool get isSubmitted => submissionStatus == Status.loading;
  bool get isSubmissionFailed => submissionStatus == Status.failure;
  bool get isSubmissionSuccess => submissionStatus == Status.success;

  bool get isFirstStep => currentStep == 0;

  // bool get isEvent => appointmentType == AppointmentType.event;
  // bool get isReminder => appointmentType == AppointmentType.reminder;
  // bool get isTask => appointmentType == AppointmentType.task;
  bool get isEvent => appointmentType == AppointmentType.individual;
  bool get isReminder => appointmentType == AppointmentType.individual;
  bool get isTask => appointmentType == AppointmentType.individual;
}
