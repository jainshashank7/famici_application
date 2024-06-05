part of 'add_medication_bloc.dart';

enum MedicationFormStatus { initial, submitting, failure, success, loading }

class AddMedicationState extends Equatable {
  const AddMedicationState({
    required this.medicationId,
    required this.showLoading,
    required this.dosageList,
    required this.currentStep,
    required this.maxStep,
    required this.startStep,
    required this.medicationName,
    required this.selectedMedicationType,
    required this.frequency,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.reminderAllowed,
    required this.medicationAdditionalDetails,
    required this.medicationTypes,
    required this.safetyDisclaimerToggleInput,
    required this.safetyDisclaimerAccepted,
    required this.safetyDisclaimerContent,
    required this.quantity,
    required this.enteredInformationCorrect,
    required this.showErrors,
    required this.isEditing,
    required this.medicationTime,
    required this.reminderTime,
    required this.sig,
    required this.prescriberName,
  });

  final String medicationId;
  final List<Dosage> dosageList;
  final bool showLoading;
  final int currentStep;
  final int maxStep;
  final int startStep;
  final MedicationNameInput medicationName;
  final MedicationType selectedMedicationType;
  final int frequency;
  final int quantity;
  final MedicationFormStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final ReminderRadioTypeInput reminderAllowed;
  final MedicationAdditionalDetailsInput medicationAdditionalDetails;
  final List<MedicationType> medicationTypes;
  final SafetyDisclaimerToggleInput safetyDisclaimerToggleInput;
  final bool safetyDisclaimerAccepted;
  final String safetyDisclaimerContent;
  final bool enteredInformationCorrect;
  final bool showErrors;
  final bool isEditing;
  final DateTime medicationTime;
  final DateTime reminderTime;
  final String sig;
  final String prescriberName;

  factory AddMedicationState.initial() {
    return AddMedicationState(
        medicationId: "",
        dosageList: [
          Dosage(
              time: "",
              quantity: HowMuchDosageInput.pure(),
              detail: "",
              hasQuantity: true)
        ],
        frequency: 1,
        selectedMedicationType: MedicationType(),
        currentStep: 0,
        maxStep: 5,
        startStep: 0,
        medicationName: MedicationNameInput.pure(),
        status: MedicationFormStatus.initial,
        showLoading: false,
        startDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        endDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        reminderAllowed: ReminderRadioTypeInput.dirty(value: ReminderType.deny),
        medicationAdditionalDetails: MedicationAdditionalDetailsInput.pure(),
        medicationTypes: [],
        safetyDisclaimerToggleInput: SafetyDisclaimerToggleInput.pure(),
        safetyDisclaimerAccepted: false,
        safetyDisclaimerContent: "",
        quantity: 1,
        enteredInformationCorrect: false,
        showErrors: false,
        isEditing: false,
        medicationTime: DateTime.now(),
        reminderTime: DateTime.now(),
        sig: "",
        prescriberName: "");
  }

  AddMedicationState copyWith({
    String? medicationId,
    List<Dosage>? dosageList,
    int? currentStep,
    int? maxStep,
    int? startStep,
    MedicationNameInput? medicationName,
    int? frequency,
    int? quantity,
    MedicationType? medicationType,
    MedicationFormStatus? status,
    bool? showLoading,
    DateTime? startDate,
    DateTime? endDate,
    ReminderRadioTypeInput? reminderAllowed,
    MedicationAdditionalDetailsInput? medicationAdditionalDetails,
    List<MedicationType>? medicationTypes,
    SafetyDisclaimerToggleInput? safetyDisclaimerToggleInput,
    bool? safetyDisclaimerAccepted,
    String? safetyDisclaimerContent,
    bool? enteredInformationCorrect,
    bool? showErrors,
    bool? isEditing,
    DateTime? medicationTime,
    DateTime? reminderTime,
    String? sig,
    String? prescriberName,
  }) {
    return AddMedicationState(
      medicationId: medicationId ?? this.medicationId,
      dosageList: dosageList ?? this.dosageList,
      frequency: frequency ?? this.frequency,
      quantity: quantity ?? this.quantity,
      selectedMedicationType: medicationType ?? this.selectedMedicationType,
      currentStep: currentStep ?? this.currentStep,
      maxStep: maxStep ?? this.maxStep,
      startStep: startStep ?? this.startStep,
      medicationName: medicationName ?? this.medicationName,
      status: status ?? this.status,
      showLoading: showLoading ?? this.showLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminderAllowed: reminderAllowed ?? this.reminderAllowed,
      medicationAdditionalDetails:
          medicationAdditionalDetails ?? this.medicationAdditionalDetails,
      medicationTypes: medicationTypes ?? this.medicationTypes,
      safetyDisclaimerToggleInput:
          safetyDisclaimerToggleInput ?? this.safetyDisclaimerToggleInput,
      safetyDisclaimerAccepted:
          safetyDisclaimerAccepted ?? this.safetyDisclaimerAccepted,
      safetyDisclaimerContent:
          safetyDisclaimerContent ?? this.safetyDisclaimerContent,
      enteredInformationCorrect:
          enteredInformationCorrect ?? this.enteredInformationCorrect,
      showErrors: showErrors ?? this.showErrors,
      isEditing: isEditing ?? this.isEditing,
      medicationTime: medicationTime ?? this.medicationTime,
      reminderTime: reminderTime ?? this.reminderTime,
      sig: sig ?? this.sig,
      prescriberName: prescriberName ?? this.prescriberName,
    );
  }

  @override
  List<Object> get props => [
        medicationId,
        dosageList,
        medicationName,
        currentStep,
        maxStep,
        startStep,
        frequency,
        quantity,
        selectedMedicationType,
        status,
        showLoading,
        startDate,
        endDate,
        reminderAllowed,
        medicationAdditionalDetails,
        medicationTypes,
        safetyDisclaimerToggleInput,
        safetyDisclaimerAccepted,
        safetyDisclaimerContent,
        enteredInformationCorrect,
        showErrors,
        isEditing
      ];

  @override
  String toString() {
    return '''AddMedicationState : {
    medicationId :$medicationId 
      currentStep : ${currentStep.toString()}
      medicationName   : ${medicationName.value}
      selectedMedicationType : $selectedMedicationType
      dosageCount: ${frequency.toString()}
      dosage: ${dosageList.toString()}
      status      : ${status.toString()}
      showLoading: ${showLoading.toString()}
      startDate: ${startDate}
      endDate: $endDate
      reminderAllowed: ${reminderAllowed.toString()}
      medicationAdditionalDetails: ${medicationAdditionalDetails.value}
      medicationTypes ${medicationTypes.toString()}
      safetyDisclaimerAccepted $safetyDisclaimerToggleInput
      safetyDisclaimerAccepted $safetyDisclaimerAccepted,
      safetyDisclaimerContent $safetyDisclaimerContent
      quantity $quantity
      frequency : $frequency
      enteredInformationCorrect $enteredInformationCorrect
      isEditing $isEditing
      } ''';
  }

  bool get isLoading => status == MedicationFormStatus.loading;
}
