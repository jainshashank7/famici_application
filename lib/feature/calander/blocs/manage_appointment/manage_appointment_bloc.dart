import 'package:amplify_api/amplify_api.dart';
import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/calander/widgets/error_message_popup.dart';
import 'package:famici/repositories/appointments_repository.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';

import '../../../google_maps/entities/address.dart';

part 'manage_appointment_event.dart';
part 'manage_appointment_state.dart';

class ManageAppointmentBloc
    extends Bloc<ManageAppointmentEvent, ManageAppointmentState> {
  ManageAppointmentBloc({
    required this.me,
    Appointment? appointment,
    required CalendarBloc calendarBloc,
  })  : _calendarBloc = calendarBloc,
        super(
          ManageAppointmentState.initial(
            appointment: appointment ?? Appointment(),
          ),
        ) {
    on<CreateAppointmentNextStep>(_onNextStep);
    on<CreateAppointmentPreviousStep>(_onPreviousStep);
    on<AppointmentTypeChange>(_appointmentTypeChange);
    on<AppointmentNameChange>(_appointmentNameChange);
    on<AppointmentDateChange>(_appointmentDateChange);
    on<AppointmentStartTimeChange>(_appointmentStartTimeChange);
    on<AppointmentEndTimeChange>(_appointmentEndTimeChange);
    on<AppointmentRecurrenceChange>(_appointmentRecurrenceChange);
    on<AppointmentAllDayToggle>(_appointmentAllDayToggle);
    on<AppointmentToggleGuest>(_appointmentToggleGuest);
    on<AppointmentChangeLocation>(_appointmentChangeLocation);
    on<AppointmentNotesChange>(_appointmentNotesChange);
    on<AppointmentDescriptionChange>(_appointmentDescriptionChange);
    on<SaveManageAppointmentEvent>(_onSaveManageAppointmentEvent);
    on<UpdateManageAppointmentEvent>(_onUpdateManageAppointmentEvent);
    on<ResetAllAppointmentData>(_resetAllAppointmentData);
    on<SubmitNameManageAppointmentEvent>(_onSubmitNameManageAppointmentEvent);
    on<SubmitDateManageAppointmentEvent>(_onSubmitDateManageAppointmentEvent);
    on<SubmitTimeManageAppointmentEvent>(_onSubmitTimeManageAppointmentEvent);
    on<SubmitGuestsManageAppointmentEvent>(
      _onSubmitGuestsManageAppointmentEvent,
    );
    on<SubmitRecurrenceManageAppointmentEvent>(
      _onSubmitRecurrenceManageAppointmentEvent,
    );
  }

  final User me;
  final CalendarBloc _calendarBloc;

  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  void _onSubmitNameManageAppointmentEvent(
    SubmitNameManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    List<Map<String, String>> summary = List.from(state.summary);

    String name = state.appointmentName;
    AppointmentType type = state.appointmentType;
    int currentStep = state.currentStep;

    if (name.isNotEmpty) {
      Map<String, String> _summaryItem = {
        "${type.name.capitalize()} ${AppointmentStrings.name.tr()}": name
      };

      if (summary.asMap().containsKey(0)) {
        summary[0] = _summaryItem;
      } else {
        summary.add(_summaryItem);
      }

      emit(state.copyWith(
        summary: summary,
        currentStep: currentStep + 1,
        appointmentNameError: false,
      ));
    } else {
      emit(state.copyWith(
        appointmentNameError: name.isEmpty,
      ));
    }
  }

  void _onSubmitDateManageAppointmentEvent(
    SubmitDateManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    List<Map<String, String>> summary = List.from(state.summary);

    AppointmentType type = state.appointmentType;
    int currentStep = state.currentStep;

    String date = DateFormat('E, MMM dd').format(state.appointmentDate);

    String startTime = DateFormat('hh:mm a').format(
      state.appointmentStartTime,
    );

    String endTime = DateFormat('hh:mm a').format(state.appointmentEndTime);

    Map<String, String> _summaryItem = {
      "${type.name.capitalize()} ${AppointmentStrings.dateAndTime.tr()}":
          state.allDay ? date : "$date, $startTime - $endTime"
    };

    if (summary.asMap().containsKey(1)) {
      summary[1] = _summaryItem;
    } else {
      summary.add(_summaryItem);
    }

    emit(state.copyWith(
      summary: summary,
      currentStep: currentStep + 1,
      appointmentNameError: false,
    ));
  }

  void _onSubmitTimeManageAppointmentEvent(
    SubmitTimeManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    List<Map<String, String>> summary = List.from(state.summary);

    DateTime _startTime = state.appointmentStartTime;
    DateTime _endTime = state.appointmentEndTime;

    AppointmentType type = state.appointmentType;
    int currentStep = state.currentStep;

    _startTime = DateTime(2022, 1, 1, _startTime.hour, _startTime.minute);
    _endTime = DateTime(2022, 1, 1, _endTime.hour, _endTime.minute);

    if (_startTime.isBefore(_endTime)) {
      String date = DateFormat('E, MMM dd').format(state.appointmentDate);
      String startTime = DateFormat('hh:mm a').format(_startTime);
      String endTime = DateFormat('hh:mm a').format(_endTime);

      Map<String, String> step2Summary = {
        "${state.appointmentType.name.capitalize()} ${AppointmentStrings.dateAndTime.tr()}":
            state.allDay ? date : "$date, $startTime - $endTime"
      };

      if (summary.asMap().containsKey(1)) {
        summary[1] = step2Summary;
      } else {
        summary.add(step2Summary);
      }
      emit(state.copyWith(
        currentStep: currentStep + 1,
        summary: summary,
        appointmentTimeError: false,
      ));
    } else {
      emit(state.copyWith(appointmentTimeError: true));
    }
  }

  void _onSubmitRecurrenceManageAppointmentEvent(
    SubmitRecurrenceManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    List<Map<String, String>> summary = List.from(state.summary);

    DateTime _startTime = state.appointmentStartTime;
    DateTime _endTime = state.appointmentEndTime;
    DateTime _date = state.appointmentDate;

    AppointmentType type = state.appointmentType;
    int currentStep = state.currentStep;

    String date = DateFormat('E, MMM dd').format(_date);
    String startTime = DateFormat('hh:mm a').format(_startTime);
    String endTime = DateFormat('hh:mm a').format(_endTime);

    Map<String, String> step2Summary = {
      "${type.name.capitalize()} ${AppointmentStrings.dateAndTime.tr()}":
          state.allDay ? date : "$date, $startTime - $endTime"
    };

    if (summary.asMap().containsKey(1)) {
      summary[1] = step2Summary;
    } else {
      summary.add(step2Summary);
    }

    Map<String, String> step3Summary = {
      AppointmentStrings.recurrence.tr():
          "${state.recurrence.name.toCamelCase()}${state.allDay ? ", ${AppointmentStrings.allDay.tr()}" : ""}"
    };

    if (summary.asMap().containsKey(2)) {
      summary[2] = step3Summary;
    } else {
      summary.add(step3Summary);
    }

    emit(state.copyWith(
      currentStep: state.isTask ? 6 : currentStep + 1,
      summary: summary,
      appointmentTimeError: false,
    ));
  }

  void _onSubmitGuestsManageAppointmentEvent(
    SubmitGuestsManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    List<Map<String, String>> summary = List.from(state.summary);

    int currentStep = state.currentStep;

    String guests = AppointmentStrings.none.tr();

    for (User user in state.guests) {
      if (guests == AppointmentStrings.none.tr()) {
        guests =
            user.givenName ?? user.familyName ?? AppointmentStrings.none.tr();
      } else {
        guests += ", ${user.givenName ?? user.familyName}";
      }
    }

    Map<String, String> step4Summary = {AppointmentStrings.guests.tr(): guests};

    if (summary.asMap().containsKey(3)) {
      summary[3] = step4Summary;
    } else {
      summary.add(step4Summary);
    }

    emit(state.copyWith(
      currentStep: currentStep + 1,
      summary: summary,
      appointmentTimeError: false,
    ));
  }

  Future<void> _onNextStep(
    CreateAppointmentNextStep event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    bool shouldSubmit = state.isTask && state.currentStep == 6;
    shouldSubmit = shouldSubmit || state.isReminder && state.currentStep == 3;
    shouldSubmit = shouldSubmit || state.isEvent && state.currentStep == 5;

    if (shouldSubmit) {
      emit(state.copyWith(status: Status.loading));
      if (state.isEditing) {
        add(UpdateManageAppointmentEvent());
      } else {
        add(SaveManageAppointmentEvent());
      }
    } else {
      if (state.currentStep == 0) {
        add(SubmitNameManageAppointmentEvent());
      } else if (state.currentStep == 1) {
        add(SubmitDateManageAppointmentEvent());
      } else if (state.currentStep == 2) {
        add(SubmitTimeManageAppointmentEvent());
      } else if (state.currentStep == 3) {
        add(SubmitRecurrenceManageAppointmentEvent());
      } else if (state.currentStep == 4) {
        add(SubmitGuestsManageAppointmentEvent());
      }
    }
  }

  void _onPreviousStep(
    CreateAppointmentPreviousStep event,
    Emitter<ManageAppointmentState> emit,
  ) {
    int previousStep = state.currentStep - 1;

    if (state.isTask && state.currentStep == 6) {
      previousStep = 3;
    }
    emit(state.copyWith(currentStep: state.currentStep > 0 ? previousStep : 0));
  }

  void _appointmentTypeChange(
    AppointmentTypeChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(state.copyWith(appointmentType: event.type));
  }

  void _appointmentNameChange(
    AppointmentNameChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(state.copyWith(
      appointmentName: event.name,
      appointmentNameError: event.name == "",
    ));
  }

  void _appointmentDateChange(
    AppointmentDateChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(state.copyWith(appointmentDate: event.date));
  }

  void _appointmentStartTimeChange(
    AppointmentStartTimeChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(state.copyWith(appointmentStartTime: event.date));
  }

  void _appointmentEndTimeChange(
    AppointmentEndTimeChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(state.copyWith(appointmentEndTime: event.date));
  }

  void _appointmentRecurrenceChange(
    AppointmentRecurrenceChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    List<Map<String, String>> summary = List.from(state.summary);

    Map<String, String> step3Summary = {
      AppointmentStrings.recurrence.tr():
          "${event.recurrence.name.toCamelCase()}${state.allDay ? ", ${AppointmentStrings.allDay.tr()}" : ""}"
    };

    if (summary.asMap().containsKey(2)) {
      summary[2] = step3Summary;
    } else {
      summary.add(step3Summary);
    }

    emit(state.copyWith(
      recurrence: event.recurrence,
      summary: summary,
    ));
  }

  void _appointmentAllDayToggle(
    AppointmentAllDayToggle event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(state.copyWith(allDay: !state.allDay));
  }

  void _appointmentToggleGuest(
    AppointmentToggleGuest event,
    Emitter<ManageAppointmentState> emit,
  ) {
    List<User> guests = state.guests;
    bool remove = false;
    int index = 0;

    for (User user in guests) {
      if (user.id == event.guest.id) {
        remove = true;
        break;
      }
      index++;
    }

    if (remove) {
      guests.removeAt(index);
    } else {
      guests.add(event.guest);
    }

    emit(state.copyWith(guests: guests));
  }

  void _appointmentChangeLocation(
    AppointmentChangeLocation event,
    Emitter<ManageAppointmentState> emit,
  ) {
    List<Map<String, String>> summary = state.summary;
    if (state.currentStep == 5) {
      Map<String, String> step5Summary = {
        AppointmentStrings.location.tr():
            event.location.formattedAddress.isNotEmpty
                ? event.location.formattedAddress
                : AppointmentStrings.none.tr()
      };

      if (summary.asMap().containsKey(4)) {
        summary[4] = step5Summary;
      } else {
        summary.add(step5Summary);
      }
    }

    emit(state.copyWith(location: event.location, summary: summary));
  }

  void _appointmentNotesChange(
    AppointmentNotesChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    List<Map<String, String>> summary = state.summary;

    if (state.currentStep == 5) {
      Map<String, String> step5Summary = {
        AppointmentStrings.notes.tr(): event.notes
      };

      if (summary.asMap().containsKey(5)) {
        summary[5] = step5Summary;
      } else {
        summary.add(step5Summary);
      }
    }

    emit(state.copyWith(notes: event.notes, summary: summary));
  }

  void _appointmentDescriptionChange(
    AppointmentDescriptionChange event,
    Emitter<ManageAppointmentState> emit,
  ) {
    List<Map<String, String>> summary = state.summary;

    if (state.currentStep == 6) {
      Map<String, String> step6Summary = {
        AppointmentStrings.description.tr(): event.description
      };

      if (summary.asMap().containsKey(3)) {
        summary[3] = step6Summary;
      } else {
        summary.add(step6Summary);
      }
    }
    emit(state.copyWith(description: event.description, summary: summary));
  }

  void _resetAllAppointmentData(
    ResetAllAppointmentData event,
    Emitter<ManageAppointmentState> emit,
  ) {
    emit(ManageAppointmentState.initial(appointment: Appointment()));
  }

  void _onSaveManageAppointmentEvent(
    SaveManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    try {
      Appointment _appointment = Appointment(
        appointmentDate: state.appointmentDate,
        appointmentName: state.appointmentName,
        appointmentType: state.appointmentType,
        endTime: state.appointmentEndTime,
        guests: state.guests.map((e) => e.id ?? '').toList(),
        isAllDay: state.allDay,
        location: state.location,
        notes: state.notes,
        startTime: state.appointmentStartTime,
        taskDescription: state.description,
        recurrenceType: state.recurrence,
        familyId: me.familyId,
      );

      await _appointmentRepository.createAppointment(
        appointment: _appointment,
      );
      _calendarBloc.add(RefreshCalendarDetailsEvent());
      emit(state.copyWith(
        submissionStatus: Status.success,
        status: Status.success,
      ));
    } on GraphQLResponseError catch (err) {
      fcRouter.pushWidget(ErrorMessagePopup(message: err.message));
      emit(state.copyWith(
        submissionStatus: Status.failure,
        status: Status.failure,
      ));
    } catch (err) {
      emit(state.copyWith(
        submissionStatus: Status.failure,
        status: Status.failure,
      ));
      fcRouter.pushWidget(ErrorMessagePopup(
        message: "Something went wrong. \nPlease try again.",
      ));
    }
  }

  void _onUpdateManageAppointmentEvent(
    UpdateManageAppointmentEvent event,
    Emitter<ManageAppointmentState> emit,
  ) async {
    try {
      Appointment _appointment = Appointment(
        appointmentDate: state.appointmentDate,
        appointmentName: state.appointmentName,
        appointmentType: state.appointmentType,
        endTime: state.appointmentEndTime,
        guests: state.guests.map((e) => e.id ?? '').toList(),
        isAllDay: state.allDay,
        location: state.location,
        notes: state.notes,
        startTime: state.appointmentStartTime,
        taskDescription: state.description,
        recurrenceType: state.recurrence,
        familyId: me.familyId,
        appointmentId: state.appointmentId,
      );

      await _appointmentRepository.updateAppointment(
        appointment: _appointment,
      );

      _calendarBloc.add(RefreshCalendarDetailsEvent());
      emit(state.copyWith(
        submissionStatus: Status.success,
        status: Status.success,
      ));
    } on GraphQLResponseError catch (err) {
      fcRouter.pushWidget(ErrorMessagePopup(message: err.message));
      emit(state.copyWith(
        submissionStatus: Status.failure,
        status: Status.failure,
      ));
    } catch (err) {
      emit(state.copyWith(
        submissionStatus: Status.failure,
        status: Status.failure,
      ));

      fcRouter.pushWidget(ErrorMessagePopup(
        message: "Something went wrong. \nPlease try again.",
      ));
    }
  }
}
