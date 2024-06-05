import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:famici/core/enitity/user.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication_intake_history.dart';
import 'package:famici/repositories/medication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/offline/local_database/notifiction_db.dart';
import '../../../../utils/logger/logger.dart';
import '../../../notification/helper/medication_notify_helper.dart';
import '../add_medication/entity/medication_type.dart';
import '../entity/selected_medication_details.dart';

part 'medication_event.dart';

part 'medication_state.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  MedicationBloc({
    required User me,
  })  : _me = me,
        super(MedicationState.initial()) {
    on<FetchMedications>(_onFetchMedications);
    on<SelectMedication>(_onSelectMedication);
    on<FetchIntakeHistory>(_onFetchIntakeHistory);
    on<ChangeDateOfIntakeHistory>(_onChangeDateOfIntakeHistory);
    on<FetchMedicationDetails>(_onFetchMedicationDetails);
    on<SetIntakeHistory>(_onSetIntakeHistory);
    // on<DeleteMedications>(_onDeleteMedications);
    on<SetSelectedMedicationReminder>(_onSetSelectedMedicationReminder);
    on<SetMedication>(_onSetMedication);
    on<DeleteMedications>(_onDeleteMedications);
    on<UpdateMedication>(_onUpdateMedication);

    // on<FetchMedicationTypes>(_onFetchMedicationTypes);

    // on<MedicationTypeSelected>(_onMedicationTypeSelected);

    _medicationNotify =  FirebaseMessaging.onMessage.listen((event) {
      Logger.info("Events DATA :: ${event.data}");
      if (isMedication(event.data['type'])) {
        add(const FetchMedications());
      }
    });
  }

  final User? _me;
  final MedicationRepository _medicationRepository = MedicationRepository();
  StreamSubscription? _medicationNotify;

  final DatabaseHelperForNotifications notificationDb =
      DatabaseHelperForNotifications();
  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  // void _onMedicationTypeSelected(
  //   MedicationTypeSelected event,
  //   Emitter<AddMedicationState> emit,
  // ) {
  //   emit(state.copyWith(
  //     medicationType: event.medicationType,
  //   ));
  //   if (state.dosageList.isNotEmpty) {
  //     List<Dosage> dosageList = state.dosageList.map((e) {
  //       return e.copyWith(
  //           quantity:
  //               HowMuchDosageInput.dirty(value: state.quantity.toString()),
  //           hasQuantity: state.selectedMedicationType.hasQuantity);
  //     }).toList();
  //     emit(state.copyWith(dosageList: dosageList));
  //   }
  // }

  Future<bool> _onSetMedication(
    SetMedication event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MedicationStatus.loading));
    var setMedicationSuccess = await _medicationRepository.setMedication(
        familyId: _me?.familyId ?? "",
        issuedTo: _me?.name ?? "client",
        dosageList: event.med.dosageList!,
        medicationName: event.med.medicationName!,
        endDate: event.med.endDate!,
        startDate: event.med.startDate!,
        additionalDetails: "",
        isRemind: event.med.isRemind!,
        contactId: _me?.id ?? "",
        createdByUserType: "client",
        SIG: event.med.dosageList![0].detail,
        medicationType: event.med.medicationType!,
        prescriberName: event.med.prescriberName!,
        medicationReminderTime: event.med.medicationReminderTime ?? null,
        medicationTypeId: event.med.medicationTypeId.toString());
    print('this is vv' + setMedicationSuccess.toString());
    if (setMedicationSuccess != null) {
      event.med.medicationId = setMedicationSuccess;

      if (event.med.isRemind == true &&
          event.med.medicationReminderTime != '' &&
          event.medReminderTime != null &&
          DateUtils.isSameDay(DateTime.now(), event.medReminderTime)) {
        state.selectedMedication.medicationId = setMedicationSuccess;
        add(FetchMedicationDetails());
        await Future.delayed(const Duration(seconds: 2));
        print('this is the end');
        MedicationNotificationHelper.createLocalNotification(
            state.selectedMedicationDetails, event.medReminderTime!);

        notificationDb.updateOrInsertReminder(
            setMedicationSuccess.toString(), event.medReminderTime.toString());
      }

      // add(FetchMedications());
      emit(state.copyWith(addStatus: MedicationStatus.success));
      print('this is med id' + setMedicationSuccess);

      return true;
    } else {
      emit(state.copyWith(
          status: MedicationStatus.failure,
          addStatus: MedicationStatus.failure));
      return false;
    }
  }

  void _onDeleteMedications(DeleteMedications event, Emitter emit) async {
    try {
      emit(state.copyWith(deleteStatus: MedicationStatus.initial));

      bool deleteSuccess = await _medicationRepository.deleteMedication(
          _me?.familyId ?? "", event.medicationId ?? "", _me?.id ?? "");
      if (deleteSuccess) {
        // add(FetchMedications());
        emit(state.copyWith(
            status: MedicationStatus.success,
            deleteStatus: MedicationStatus.success));
        await AwesomeNotifications()
            .cancelSchedulesByGroupKey(event.medicationId.toString());
      } else {
        emit(state.copyWith(
            status: MedicationStatus.failure,
            deleteStatus: MedicationStatus.failure));
      }
    } catch (er) {
      // DebugLogger.error(er.toString());
    }
  }

  Future<void> _onUpdateMedication(
    UpdateMedication event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(editStatus: MedicationStatus.loading));
      var updateMedicationSuccess =
          await _medicationRepository.updateMedication(
              medicationId: event.medicationId,
              familyId: _me?.familyId ?? "",
              issuedTo: _me?.name ?? "client",
              dosageList: event.med.dosageList!,
              medicationName: event.med.medicationName!,
              endDate: event.med.endDate!,
              startDate: event.med.startDate!,
              additionalDetails: '',
              isRemind: event.med.isRemind!,
              contactId: _me?.id ?? "",
              createdByUserType: "client",
              SIG: event.med.dosageList![0].detail,
              medicationType: event.med.medicationType!,
              prescriberName: event.med.prescriberName!,
              medicationReminderTime: event.med.medicationReminderTime ?? null,
              medicationTypeId: event.med.medicationTypeId.toString());
      if (updateMedicationSuccess != null) {
        event.med.medicationId = updateMedicationSuccess;
        print('this is the event.medReminderTime ' +
            event.medReminderTime.toString() +
            '  ' +
            DateUtils.isSameDay(DateTime.now(), event.medReminderTime)
                .toString());
        state.selectedMedication.medicationId = updateMedicationSuccess;
        add(FetchMedicationDetails());
        await Future.delayed(const Duration(seconds: 2));
        if (event.med.isRemind == true &&
            event.medReminderTime != null &&
            DateUtils.isSameDay(DateTime.now(), event.medReminderTime) &&
            event.med.medicationReminderTime != '') {
          print('this is the end');
          MedicationNotificationHelper.createLocalNotification(
              state.selectedMedicationDetails, event.medReminderTime!);

          notificationDb.updateOrInsertReminder(
              updateMedicationSuccess.toString(),
              event.medReminderTime.toString());
        }

        // add(FetchMedications());
        emit(
          state.copyWith(
              status: MedicationStatus.success,
              editStatus: MedicationStatus.success),
        );
      } else {
        throw Exception("unable to save");
      }
    } catch (err) {
      emit(state.copyWith(
          status: MedicationStatus.failure,
          editStatus: MedicationStatus.failure));
    }
  }

  Future<void> _onFetchMedications(
    FetchMedications event,
    Emitter emit,
  ) async {
    // if (state.medicationList.isEmpty) {
    emit(state.copyWith(status: MedicationStatus.loading));

    //online
    if (await _isConnectedToInternet()) {
      List<Medication>? _medications;
      for (var count = 0; count <= 6; count++) {
        if (_me?.familyId != null) {
          _medications = await _medicationRepository.fetchMedications(
            familyId: _me?.familyId ?? "",
            contactId: _me?.id ?? "",
            date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          );
          break;
        } else {
          await Future.delayed(const Duration(seconds: 10));
        }
      }

      emit(state.copyWith(
        medicationList: _medications ??
            (state.medicationList.length > 1 ? _medications : []),
        status: MedicationStatus.success,
      ));
    } else {
      // offline

      final prefs = await SharedPreferences.getInstance();
      final response = prefs.getString('${_me?.id}_medication');

      List<Medication>? _medications = (json
              .decode(response!)['getMedicationList']['medicationList'] as List)
          .map((n) => (Medication.fromJson(n)))
          .toList();

      emit(state.copyWith(
        medicationList: _medications,
        status: MedicationStatus.success,
      ));
    }
    // }
  }

  Future<void> _onFetchMedicationDetails(
    FetchMedicationDetails event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MedicationStatus.loading));
    SelectedMedicationDetails? _medicationDetails =
        await _medicationRepository.fetchMedicationDetails(
      familyId: _me?.familyId ?? "",
      medicationId: state.selectedMedication.medicationId ?? "",
      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
    );
    emit(state.copyWith(
        selectedMedicationDetails: _medicationDetails,
        status: MedicationStatus.success));
  }

  Future<void> _onSelectMedication(
    SelectMedication event,
    Emitter emit,
  ) async {
    emit(state.copyWith(selectedMedication: event.medication));
  }

  Future<void> _onFetchIntakeHistory(
    FetchIntakeHistory event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MedicationStatus.loading));
    List<MedicationIntakeHistory>? _intakeHistory;
    var result = await _medicationRepository.fetchIntakeHistory(
        familyId: _me?.familyId ?? "",
        contactId: _me?.id ?? "",
        medicationId: state.selectedMedication.medicationId ?? "",
        month: event.month,
        year: event.year);
    _intakeHistory = result[0];

    emit(state.copyWith(
        selectedIntakeHistoryList: _intakeHistory,
        status: MedicationStatus.success,
        selectedMedicationMissedDoses: result[1],
        selectedMedicationRemainingCount: result[2]));
  }

  Future<void> _onChangeDateOfIntakeHistory(
    ChangeDateOfIntakeHistory event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MedicationStatus.intakeHistoryLoading));
    List<MedicationIntakeHistory>? _intakeHistory;
    var result = await _medicationRepository.fetchIntakeHistory(
        familyId: _me?.familyId ?? "",
        contactId: _me?.id ?? "",
        medicationId: state.selectedMedication.medicationId ?? "",
        month: event.month,
        year: event.year);

    _intakeHistory = result[0];

    emit(state.copyWith(
        selectedIntakeHistoryList: _intakeHistory,
        status: MedicationStatus.success,
        selectedMedicationMissedDoses: result[1],
        selectedMedicationRemainingCount: result[2]));
  }

  Future<void> _onSetIntakeHistory(
    SetIntakeHistory event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MedicationStatus.loading));
    bool intakeHistoryUpdated = await _medicationRepository.setIntakeHistory(
      familyId: _me?.familyId ?? "",
      medicationId: event.medicationId,
      dosageTakenDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      dosageId: event.dosageId,
      hasTaken: event.hasTaken,
    );

    add(FetchMedications());
    if (intakeHistoryUpdated) {
      emit(state.copyWith(status: MedicationStatus.success));
    } else {
      emit(state.copyWith(status: MedicationStatus.failure));
    }
  }

  // void _onDeleteMedications(DeleteMedications event, Emitter emit) async {
  //   try {
  //     emit(state.copyWith(
  //         status: MedicationStatus.loading,
  //         deleteStatus: MedicationDeleteStatus.initial));

  //     bool deleteSuccess = await _medicationRepository.deleteMedication(
  //         _me?.familyId ?? "",
  //         state.selectedMedicationDetails.medicationId ?? "",
  //         _me?.id ?? "");
  //     if (deleteSuccess) {
  //       emit(state.copyWith(
  //           status: MedicationStatus.success,
  //           deleteStatus: MedicationDeleteStatus.success));
  //       add(const FetchMedications());
  //     } else {
  //       emit(state.copyWith(
  //           status: MedicationStatus.failure,
  //           deleteStatus: MedicationDeleteStatus.failure));
  //     }
  //   } catch (er) {
  //     DebugLogger.error(er.toString());
  //   }
  // }

  FutureOr<void> _onSetSelectedMedicationReminder(
      SetSelectedMedicationReminder event, Emitter<MedicationState> emit) {
    emit(state.copyWith(selectedReminderTime: event.reminderTime));
  }
}
