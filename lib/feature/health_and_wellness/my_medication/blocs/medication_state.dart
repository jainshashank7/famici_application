part of 'medication_bloc.dart';

enum MedicationStatus {
  initial,
  loading,
  failure,
  success,
  intakeHistoryLoading
}

class MedicationState extends Equatable {
  MedicationState(
      {required this.medicationList,
      required this.status,
      required this.selectedMedication,
      required this.selectedIntakeHistoryList,
      required this.selectedMedicationRemainingCount,
      required this.selectedMedicationMissedDoses,
      required this.selectedMedicationDetails,
      required this.selectedReminderTime,
      required this.addStatus,
      required this.editStatus,
      required this.deleteStatus});
  MedicationStatus addStatus;
  MedicationStatus deleteStatus;
  MedicationStatus editStatus;
  final List<Medication> medicationList;
  final MedicationStatus status;
  final Medication selectedMedication;
  final List<MedicationIntakeHistory> selectedIntakeHistoryList;
  final String selectedMedicationRemainingCount;
  final String selectedMedicationMissedDoses;
  final SelectedMedicationDetails selectedMedicationDetails;
  final String selectedReminderTime;
  factory MedicationState.initial() {
    return MedicationState(
        medicationList: [],
        status: MedicationStatus.initial,
        deleteStatus: MedicationStatus.initial,
        editStatus: MedicationStatus.initial,
        addStatus: MedicationStatus.initial,
        selectedMedication: Medication(createdByUserType: 'client'),
        selectedIntakeHistoryList: [],
        selectedMedicationRemainingCount: "0",
        selectedMedicationMissedDoses: "0",
        selectedMedicationDetails: SelectedMedicationDetails(),
        selectedReminderTime: '0');
  }

  MedicationState copyWith({
    List<Medication>? medicationList,
    MedicationStatus? status,
    Medication? selectedMedication,
    List<MedicationIntakeHistory>? selectedIntakeHistoryList,
    String? selectedMedicationRemainingCount,
    String? selectedMedicationMissedDoses,
    SelectedMedicationDetails? selectedMedicationDetails,
    String? selectedReminderTime,
    MedicationStatus? deleteStatus,
    MedicationStatus? editStatus,
    MedicationStatus? addStatus,
    MedicationType? medicationType,
    List<MedicationType>? medicationTypes,
  }) {
    return MedicationState(
        medicationList: medicationList ?? this.medicationList,
        status: status ?? this.status,
        selectedMedication: selectedMedication ?? this.selectedMedication,
        selectedIntakeHistoryList:
            selectedIntakeHistoryList ?? this.selectedIntakeHistoryList,
        selectedMedicationRemainingCount: selectedMedicationRemainingCount ??
            this.selectedMedicationRemainingCount,
        selectedMedicationMissedDoses:
            selectedMedicationMissedDoses ?? this.selectedMedicationMissedDoses,
        selectedMedicationDetails:
            selectedMedicationDetails ?? this.selectedMedicationDetails,
        selectedReminderTime: selectedReminderTime ?? this.selectedReminderTime,
        deleteStatus: deleteStatus ?? this.deleteStatus,
        editStatus: editStatus ?? this.editStatus,
        addStatus: addStatus ?? this.addStatus);
  }

  @override
  List<Object> get props => [
        medicationList,
        status,
        selectedMedication,
        selectedIntakeHistoryList,
        selectedMedicationRemainingCount,
        selectedMedicationMissedDoses,
        selectedMedicationDetails,
        selectedReminderTime,
        addStatus,
        editStatus,
        deleteStatus,
      ];

  @override
  String toString() {
    return '''MedicationState : {
      status      : ${status.toString()}
      medicationList : ${medicationList.length}
      selectedMedicationRemainingCont :$selectedMedicationRemainingCount
      selectedMedicationMissedDoses : $selectedMedicationMissedDoses
      selectedMedicationDetails : $selectedMedicationDetails
      } ''';
  }
}
