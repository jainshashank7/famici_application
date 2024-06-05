import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:famici/feature/notification/entities/dosage_item.dart';
import 'package:famici/feature/notification/entities/notification.dart';

import '../../../../../repositories/medication_repository.dart';

part 'medication_notify_state.dart';

class MedicationNotifyCubit extends Cubit<MedicationNotifyState> {
  MedicationNotifyCubit() : super(MedicationNotifyState.initial());

  final MedicationRepository _medicationRepository = MedicationRepository();

  void syncNotifiedMedication(Notification notification) {
    DosageItem _dosage = notification.body.dosageList.firstWhere(
      (item) => item.id == notification.groupKey,
    );

    emit(state.copyWith(notification: notification, dosage: _dosage));
  }

  void submitTaken() {
    _updateTakenStatus(true);
  }

  void submitMissed() {
    _updateTakenStatus(false);
  }

  void updateTakenStatusLocal(String familyId, String medicationId,
       String dosageId, bool taken) {
    _updateTakenStatusLocal(
        familyId, medicationId, dosageId, taken);
  }

  void _updateTakenStatus(bool taken) async {
    try {
      bool intakeHistoryUpdated = await _medicationRepository.setIntakeHistory(
        familyId: state.notification.familyId,
        medicationId: state.notification.body.medicationId,
        dosageTakenDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        dosageId: state.dosage.id,
        hasTaken: taken,
      );
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _updateTakenStatusLocal(String familyId, String medicationId,
   String dosageId, bool taken) async {
    try {

      bool intakeHistoryUpdated = await _medicationRepository.setIntakeHistory(
        familyId: familyId,
        medicationId: medicationId,
        dosageTakenDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        dosageId: dosageId,
        hasTaken: taken,
      );
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
