part of 'medication_bloc.dart';

abstract class MedicationEvent extends Equatable {
  const MedicationEvent();

  @override
  List<Object> get props => [];
}

class FetchMedications extends MedicationEvent {
  const FetchMedications();
}

class FetchMedicationDetails extends MedicationEvent {
  const FetchMedicationDetails();
}

class SetIntakeHistory extends MedicationEvent {
  final String dosageTakenDate;
  final String dosageId;
  final bool hasTaken;
  final String medicationId;

  const SetIntakeHistory(
      this.dosageTakenDate, this.dosageId, this.hasTaken, this.medicationId);
}

class SelectMedication extends MedicationEvent {
  final Medication medication;

  const SelectMedication(this.medication);
}

class SetSelectedMedicationReminder extends MedicationEvent {
  final String reminderTime;

  const SetSelectedMedicationReminder(this.reminderTime);
}

class FetchIntakeHistory extends MedicationEvent {
  final String month;
  final String year;

  const FetchIntakeHistory(this.month, this.year);
}

class ChangeDateOfIntakeHistory extends MedicationEvent {
  final String month;
  final String year;

  const ChangeDateOfIntakeHistory(this.month, this.year);
}

class SetMedication extends MedicationEvent {
  final SelectedMedicationDetails med;
  final DateTime? medReminderTime;
  SetMedication({required this.med, this.medReminderTime});
}

class DeleteMedications extends MedicationEvent {
  final String medicationId;
  const DeleteMedications({required this.medicationId});
}

class UpdateMedication extends MedicationEvent {
  final SelectedMedicationDetails med;
  final String medicationId;
  final DateTime? medReminderTime;
  UpdateMedication(
      {required this.med, required this.medicationId, this.medReminderTime});
}
