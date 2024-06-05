import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:famici/core/enitity/user.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/repositories/appointments_repository.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/router/router_delegate.dart';
import '../../../../core/screens/home_screen/widgets/appointments_template2.dart';
import '../../widgets/error_message_popup.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc({
    required User me,
    required CalendarBloc calendarBloc,
  })  : _me = me,
        _calendarBloc = calendarBloc,
        super(AppointmentState.initial()) {
    on<SyncAppointmentEvent>(_onSyncAppointmentEvent);
    on<DeleteAppointment>(_onDeleteAppointment);
    on<IncreaseIndex>(_increaseIndex);
    on<AddAppointmentData>(_addAppointmentData);
  }

  final User _me;
  final CalendarBloc _calendarBloc;
  final AppointmentRepository _appointmentRepo = AppointmentRepository();
  void _increaseIndex(IncreaseIndex event, emit){
    int currentIndex = state.currentIndex + 1;

    emit(state.copyWith(currentIndex: currentIndex >= state.items.length ? 0 : currentIndex));
  }
  void _addAppointmentData(AddAppointmentData event,emit){
    emit(state.copyWith(items: event.items));
  }

  void _onSyncAppointmentEvent(SyncAppointmentEvent event, emit) async {
    if (_me.familyId == null || _me.familyId!.isEmpty) {
      return;
    }
    emit(state.copyWith(status: Status.loading));

    Appointment _appointment = await _appointmentRepo.fetchAppointment(
      familyId: _me.familyId,
      appointmentId: event.appointment.toString(),
    );

    emit(
        state.copyWith(appointment: event.appointment, status: Status.success));
  }

  Future<void> _onDeleteAppointment(
    DeleteAppointment event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      await _appointmentRepo.deleteAppointment(
        familyId: _me.familyId,
        appointmentId: event.appointmentId,
      );

      fcRouter.pop();

      emit(state.copyWith(
        status: Status.success,
      ));

      _calendarBloc.add(RefreshCalendarDetailsEvent());
    } on GraphQLResponseError catch (err) {
      fcRouter.pushWidget(ErrorMessagePopup(message: err.message));
      emit(state.copyWith(status: Status.failure));
    } catch (err) {
      emit(state.copyWith(
        status: Status.failure,
      ));
      fcRouter.pushWidget(ErrorMessagePopup(
        message: "Something went wrong. \nPlease try again.",
      ));
    }
  }
}
