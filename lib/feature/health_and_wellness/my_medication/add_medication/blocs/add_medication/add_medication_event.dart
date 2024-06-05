part of 'add_medication_bloc.dart';

abstract class AddMedicationEvent extends Equatable {
  const AddMedicationEvent();

  @override
  List<Object> get props => [];
}

class MedicationNameChanged extends AddMedicationEvent {
  final String medicationName;
  const MedicationNameChanged(this.medicationName);
}

class MedicationTypeSelected extends AddMedicationEvent {
  final MedicationType medicationType;
  const MedicationTypeSelected(this.medicationType);
}

class MedicationNextStep extends AddMedicationEvent {
  const MedicationNextStep();
}

class FetchMedicationTypes extends AddMedicationEvent {
  const FetchMedicationTypes();
}

class MedicationPreviousStep extends AddMedicationEvent {
  const MedicationPreviousStep();
}

class IncrementDosageCount extends AddMedicationEvent {
  const IncrementDosageCount();
}

class DecrementDosageCount extends AddMedicationEvent {
  final int index;
  const DecrementDosageCount(this.index);
}

class IncrementQuantity extends AddMedicationEvent {
  const IncrementQuantity();
}

class DecrementQuantity extends AddMedicationEvent {
  const DecrementQuantity();
}

class HowMuchDosageChanged extends AddMedicationEvent {
  final String howMuch;
  final int index;
  const HowMuchDosageChanged(this.howMuch, this.index);
}

class DosageDetailsSelected extends AddMedicationEvent {
  final String details;
  final int index;
  const DosageDetailsSelected(this.details, this.index);
}

class DosageTimeSelected extends AddMedicationEvent {
  final String time;
  final int index;
  const DosageTimeSelected(this.time, this.index);
}

class OnToggleLoading extends AddMedicationEvent {
  final bool loading;
  const OnToggleLoading(this.loading);
}

class OnDoseDurationSelected extends AddMedicationEvent {
  final DateTime startDate;
  final DateTime endDate;
  const OnDoseDurationSelected(this.startDate, this.endDate);
}

class OnDoseReminderToggle extends AddMedicationEvent {
  final ReminderType reminderType;
  const OnDoseReminderToggle(this.reminderType);
}

class MedicationAdditionalDetailsChanged extends AddMedicationEvent {
  final String additionalDetails;
  const MedicationAdditionalDetailsChanged(this.additionalDetails);
}

class OnFetchMedicationSafetyDisclaimer extends AddMedicationEvent {
  const OnFetchMedicationSafetyDisclaimer();
}

class OnToggleMedicationSafetyDisclaimer extends AddMedicationEvent {
  const OnToggleMedicationSafetyDisclaimer();
}

class GoBackInitialStep extends AddMedicationEvent {
  const GoBackInitialStep();
}

class ToggleEnteredInformationCorrect extends AddMedicationEvent {
  const ToggleEnteredInformationCorrect();
}

// class SetMedication extends AddMedicationEvent {
//   const SetMedication();
// }

class ToggleEditMedication extends AddMedicationEvent {
  final bool isEditing;
  const ToggleEditMedication(this.isEditing);
}

class SetDataForEditMedication extends AddMedicationEvent {
  final MedicationState medicationState;
  const SetDataForEditMedication(this.medicationState);
}

// class UpdateMedication extends AddMedicationEvent {
//   const UpdateMedication();
// }

class CheckMedicationNameAndType extends AddMedicationEvent {
  final int step;
  const CheckMedicationNameAndType(this.step);
}

class CheckFrequencyAndQuantity extends AddMedicationEvent {
  final int step;
  const CheckFrequencyAndQuantity(this.step);
}

class CheckDosageDetails extends AddMedicationEvent {
  final int step;
  const CheckDosageDetails(this.step);
}

class CheckDosageRange extends AddMedicationEvent {
  final int step;
  const CheckDosageRange(this.step);
}

class CheckAdditionalDetails extends AddMedicationEvent {
  final int step;
  const CheckAdditionalDetails(this.step);
}

class CheckEnteredInformationCorrect extends AddMedicationEvent {
  final int step;
  const CheckEnteredInformationCorrect(this.step);
}
