import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/dosage.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/medication_type.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/safety_disclaimer.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/screens/add_medication_screen.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/utils/how_much_dosage_input.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/utils/medication_additional_details_input.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/utils/medication_name_input.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/repositories/medication_repository.dart';

import '../../../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../../core/enitity/barrel.dart';
import '../../utils/medication_safety_disclaimer_input.dart';

part 'add_medication_event.dart';

part 'add_medication_state.dart';

class AddMedicationBloc extends Bloc<AddMedicationEvent, AddMedicationState> {
  AddMedicationBloc(this.authBloc) : super(AddMedicationState.initial()) {
    on<MedicationNameChanged>(_onMedicationNameChanged);
    on<MedicationTypeSelected>(_onMedicationTypeSelected);
    on<MedicationNextStep>(_onMedicationNextStep);
    on<MedicationPreviousStep>(_onPreviousStep);
    on<IncrementDosageCount>(_onIncrementDosageCount);
    on<DecrementDosageCount>(_onDecrementDosageCount);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<HowMuchDosageChanged>(_onHowMuchDosageChanged);
    on<DosageDetailsSelected>(_onDosageDetailsSelected);
    on<DosageTimeSelected>(_onDosageTimeSelected);
    on<OnToggleLoading>(_onToggleLoading);
    on<OnDoseDurationSelected>(_onDoseDurationSelected);
    on<OnDoseReminderToggle>(_onDoseReminderToggle);
    on<MedicationAdditionalDetailsChanged>(
        _onMedicationAdditionalDetailsChanged);
    on<FetchMedicationTypes>(_onFetchMedicationTypes);
    on<OnFetchMedicationSafetyDisclaimer>(_onFetchMedicationSafetyDisclaimer);
    on<OnToggleMedicationSafetyDisclaimer>(
        _onToggleMedicationsSafetyDisclaimer);
    on<GoBackInitialStep>(_onGoBackInitialStep);
    on<ToggleEnteredInformationCorrect>(_onToggleEnteredInformationCorrect);
    // on<SetMedication>(_onSetMedication);
    on<ToggleEditMedication>(_onToggleEditMedication);
    on<SetDataForEditMedication>(_onFetchDataForEditMedications);
    // on<UpdateMedication>(_onUpdateMedication);
    on<CheckMedicationNameAndType>(_onCheckMedicationNameAndType);
    on<CheckFrequencyAndQuantity>(_onCheckFrequencyAndQuantity);
    on<CheckDosageDetails>(_onCheckDosageDetails);
    on<CheckDosageRange>(_onCheckDosageRange);
    on<CheckAdditionalDetails>(_onCheckAdditionalDetails);
    // on<CheckEnteredInformationCorrect>(_onCheckEnteredInformationCorrect);
  }

  User? _me;
  final AuthBloc authBloc;
  final MedicationRepository _medicationRepository = MedicationRepository();

  void _onMedicationNameChanged(
    MedicationNameChanged event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(
      medicationName: MedicationNameInput.dirty(value: event.medicationName),
    ));
  }

  void _onMedicationTypeSelected(
    MedicationTypeSelected event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(
      medicationType: event.medicationType,
    ));
    if (state.dosageList.isNotEmpty) {
      List<Dosage> dosageList = state.dosageList.map((e) {
        return e.copyWith(
            quantity:
                HowMuchDosageInput.dirty(value: state.quantity.toString()),
            hasQuantity: state.selectedMedicationType.hasQuantity);
      }).toList();
      emit(state.copyWith(dosageList: dosageList));
    }
  }

  Future<void> _onFetchMedicationTypes(
    FetchMedicationTypes event,
    Emitter emit,
  ) async {
    if (state.medicationTypes.isEmpty) {
      // final storage = FlutterSecureStorage();
      // String data = await storage.read(key: 'medication_types')?? "";
      // List<MedicationType>? _medicationTypes =
      //     jsonDecode(data).map((m) => MedicationType.fromJson(m)).toList();
      //
      //   print("%%%%%%%%%%%%%%%%% medication types offline");
      //   print(_medicationTypes);
      List<MedicationType>? _medicationTypes =
          await _medicationRepository.fetchMedicationTypes();

      emit(state.copyWith(
        medicationTypes: _medicationTypes,
      ));
    }
  }

  Future<void> _onMedicationNextStep(
      MedicationNextStep event, Emitter<AddMedicationState> emit) async {
    int step = state.currentStep;
    if (step == 0 && state.safetyDisclaimerAccepted) {
      emit(state.copyWith(currentStep: 1));
    } else if (step == 1) {
      add(CheckMedicationNameAndType(step));
    } else if (step == 2) {
      add(CheckFrequencyAndQuantity(step));
    } else if (step == 3) {
      add(CheckDosageDetails(step));
    }
    // else if (step == 4) {
    //   add(CheckDosageRange(step));
    // }
    else if (step == 4) {
      add(CheckAdditionalDetails(step));
    } else if (step == 5) {
      add(CheckEnteredInformationCorrect(step));
    } else {
      // emit(state.copyWith(currentStep: step + 1));
    }
  }

  Future<void> _onCheckMedicationNameAndType(
    CheckMedicationNameAndType event,
    Emitter emit,
  ) async {
    MedicationNameInput _name = state.medicationName;
    if (_name.pure) {
      add(MedicationNameChanged(_name.value));
    }
    if (_name.valid && state.selectedMedicationType != MedicationType()) {
      emit(state.copyWith(
          currentStep: event.step + (state.isEditing ? 2 : 1),
          showErrors: false));
    } else {
      emit(state.copyWith(showErrors: true));
    }
  }

  Future<void> _onCheckFrequencyAndQuantity(
    CheckFrequencyAndQuantity event,
    Emitter emit,
  ) async {
    if (state.frequency > 0) {
      if (state.selectedMedicationType.hasQuantity!) {
        if (state.quantity > 0) {
          emit(state.copyWith(currentStep: event.step + 1, showErrors: false));
        } else {
          emit(state.copyWith(showErrors: true));
        }
      } else {
        emit(state.copyWith(currentStep: event.step + 1, showErrors: false));
      }
    } else {
      emit(state.copyWith(showErrors: true));
    }
  }

  Future<void> _onCheckDosageDetails(
    CheckDosageDetails event,
    Emitter emit,
  ) async {
    bool hasDosageError = false;
    List<Dosage> dosageList = List.from(state.dosageList);

    for (int i = 0; i < dosageList.length; i++) {
      final dosageItem = dosageList[i];
      HowMuchDosageInput howMuch = dosageItem.quantity;
      if (howMuch.pure) {
        add(HowMuchDosageChanged(howMuch.value, i));
      }

      hasDosageError = dosageItem.quantity.value.isEmpty;
      hasDosageError = hasDosageError || howMuch.invalid;
      hasDosageError = hasDosageError || dosageItem.detail.isEmpty;
      hasDosageError = hasDosageError || dosageItem.time.isEmpty;
    }

    if (!hasDosageError) {
      emit(state.copyWith(currentStep: event.step + 1, showErrors: false));
    } else {
      emit(state.copyWith(showErrors: true));
    }
  }

  Future<void> _onCheckDosageRange(
    CheckDosageRange event,
    Emitter emit,
  ) async {
    if ((state.startDate ==
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day) &&
            state.endDate ==
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)) ||
        (state.startDate == state.endDate)) {
      emit(state.copyWith(showErrors: true));
    } else {
      emit(state.copyWith(currentStep: event.step + 1, showErrors: false));
    }
  }

  Future<void> _onCheckAdditionalDetails(
    CheckAdditionalDetails event,
    Emitter emit,
  ) async {
    ReminderRadioTypeInput _type = state.reminderAllowed;
    MedicationAdditionalDetailsInput _additionalDetails =
        state.medicationAdditionalDetails;
    if (_type.pure || _type.invalid) {
      add(OnDoseReminderToggle(_type.value));
    }
    if (_additionalDetails.pure) {
      add(MedicationAdditionalDetailsChanged(_additionalDetails.value));
    }

    if (_type.valid && _additionalDetails.valid) {
      emit(state.copyWith(currentStep: event.step + 1));
    }
  }

  // Future<void> _onCheckEnteredInformationCorrect(
  //   CheckEnteredInformationCorrect event,
  //   Emitter emit,
  // ) async {
  //   if (state.enteredInformationCorrect) {
  //     emit(state.copyWith(status: MedicationFormStatus.loading));
  //     if (state.isEditing) {
  //       add(UpdateMedication());
  //     } else {
  //       add(SetMedication());
  //     }
  //   } else {
  //     emit(state.copyWith(showErrors: true));
  //   }
  // }

  void _onPreviousStep(
    MedicationPreviousStep event,
    Emitter<AddMedicationState> emit,
  ) {
    int previous =
        state.currentStep - (state.isEditing && state.currentStep == 3 ? 2 : 1);
    emit(state.copyWith(currentStep: previous));
  }

  void _onGoBackInitialStep(
    GoBackInitialStep event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(currentStep: 1));
  }

  void _onIncrementDosageCount(
    IncrementDosageCount event,
    Emitter<AddMedicationState> emit,
  ) {
    if (state.frequency < 6) {
      int frequency = state.frequency + 1;
      List<Dosage> dosageList = state.dosageList;
      dosageList.add(Dosage(
          time: "",
          quantity: HowMuchDosageInput.pure(),
          detail: "",
          hasQuantity: state.selectedMedicationType.hasQuantity ?? true));
      dosageList = dosageList.map((e) {
        return e.copyWith(
            quantity:
                HowMuchDosageInput.dirty(value: state.quantity.toString()),
            hasQuantity: state.selectedMedicationType.hasQuantity);
      }).toList();
      emit(state.copyWith(frequency: frequency, dosageList: dosageList));
    }
  }

  void _onDecrementDosageCount(
    DecrementDosageCount event,
    Emitter<AddMedicationState> emit,
  ) {
    int frequency = state.frequency - 1;
    if (frequency > 0) {
      List<Dosage> dosageList = state.dosageList;
      dosageList.removeAt(event.index);
      emit(state.copyWith(frequency: frequency, dosageList: dosageList));
      if (state.currentStep == 3) {
        emit(state.copyWith(showLoading: true));
      }
    }
  }

  void _onIncrementQuantity(
    IncrementQuantity event,
    Emitter<AddMedicationState> emit,
  ) {
    if (state.quantity < 10) {
      int quantity = state.quantity + 1;
      List<Dosage> dosageList = state.dosageList.map((e) {
        return e.copyWith(
            quantity: HowMuchDosageInput.dirty(value: quantity.toString()));
      }).toList();

      emit(state.copyWith(quantity: quantity, dosageList: dosageList));
    }
  }

  void _onDecrementQuantity(
    DecrementQuantity event,
    Emitter<AddMedicationState> emit,
  ) {
    if (state.quantity > 1) {
      int quantity = state.quantity - 1;
      List<Dosage> dosageList = state.dosageList.map((e) {
        return e.copyWith(
            quantity: HowMuchDosageInput.dirty(value: quantity.toString()));
      }).toList();
      emit(state.copyWith(quantity: quantity, dosageList: dosageList));
    }
  }

  void _onToggleLoading(
    OnToggleLoading event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(showLoading: event.loading));
  }

  void _onToggleEnteredInformationCorrect(
    ToggleEnteredInformationCorrect event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(
        enteredInformationCorrect: !state.enteredInformationCorrect,
        showErrors: false));
  }

  void _onHowMuchDosageChanged(
    HowMuchDosageChanged event,
    Emitter<AddMedicationState> emit,
  ) {
    List<Dosage> dosageList = List.from(state.dosageList);

    dosageList[event.index] = Dosage(
      detail: state.dosageList[event.index].detail,
      quantity: HowMuchDosageInput.dirty(value: event.howMuch),
      time: state.dosageList[event.index].time,
      hasQuantity: state.dosageList[event.index].hasQuantity,
    );

    emit(state.copyWith(
      dosageList: dosageList,
    ));
  }

  void _onDosageDetailsSelected(
    DosageDetailsSelected event,
    Emitter<AddMedicationState> emit,
  ) {
    List<Dosage> dosageList = state.dosageList;
    dosageList[event.index] = Dosage(
        detail: event.details,
        quantity: state.dosageList[event.index].quantity,
        time: state.dosageList[event.index].time,
        hasQuantity: state.dosageList[event.index].hasQuantity);
    emit(state.copyWith(
      dosageList: dosageList,
    ));
  }

  void _onDosageTimeSelected(
    DosageTimeSelected event,
    Emitter<AddMedicationState> emit,
  ) {
    List<Dosage> dosageList = state.dosageList;
    dosageList[event.index] = Dosage(
        detail: state.dosageList[event.index].detail,
        quantity: state.dosageList[event.index].quantity,
        time: event.time,
        hasQuantity: state.dosageList[event.index].hasQuantity);
    emit(state.copyWith(
      dosageList: dosageList,
    ));
    emit(state.copyWith(showLoading: true));
  }

  void _onDoseDurationSelected(
    OnDoseDurationSelected event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(
        startDate: event.startDate, endDate: event.endDate, showErrors: false));
  }

  void _onDoseReminderToggle(
    OnDoseReminderToggle event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(
      reminderAllowed: ReminderRadioTypeInput.dirty(value: event.reminderType),
    ));
  }

  void _onMedicationAdditionalDetailsChanged(
    MedicationAdditionalDetailsChanged event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(
      medicationAdditionalDetails: MedicationAdditionalDetailsInput.dirty(
          value: event.additionalDetails),
    ));
  }

  Future<void> _onFetchMedicationSafetyDisclaimer(
    OnFetchMedicationSafetyDisclaimer event,
    Emitter emit,
  ) async {
    emit(state.copyWith(showLoading: true));
    _me = authBloc.state.user;
    SafetyDisclaimer _disclaimer =
        await _medicationRepository.fetchMedicationSafetyDisclaimer(
      familyId: _me?.familyId ?? "",
    );
    if (_disclaimer.isAccepted) {
      emit(state.copyWith(
        currentStep: state.currentStep + 1,
        showLoading: false,
      ));
    } else {
      emit(state.copyWith(
        safetyDisclaimerAccepted: _disclaimer.isAccepted,
        safetyDisclaimerContent: _disclaimer.content,
        showLoading: false,
      ));
    }
  }

  Future<void> _onToggleMedicationsSafetyDisclaimer(
    OnToggleMedicationSafetyDisclaimer event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
        safetyDisclaimerAccepted: !state.safetyDisclaimerAccepted));
  }

  // Future<bool> _onSetMedication(
  //   SetMedication event,
  //   Emitter emit,
  // ) async {
  //   emit(state.copyWith(status: MedicationFormStatus.loading));
  //   bool setMedicationSuccess = await _medicationRepository.setMedication(
  //       familyId: _me?.familyId ?? "",
  //       dosageList: state.dosageList,
  //       medicationName: state.medicationName.value,
  //       endDate: DateFormat("yyyy-MM-dd").format(state.endDate),
  //       startDate: DateFormat("yyyy-MM-dd").format(state.startDate),
  //       additionalDetails: state.medicationAdditionalDetails.value,
  //       isRemind: state.reminderAllowed.value == ReminderType.allowed,
  //       medicationTypeId:
  //           state.selectedMedicationType.medicationTypeId.toString());
  //   if (setMedicationSuccess) {
  //     emit(state.copyWith(status: MedicationFormStatus.success));
  //     return true;
  //   } else {
  //     emit(state.copyWith(status: MedicationFormStatus.failure));
  //     return false;
  //   }
  // }

  void _onToggleEditMedication(
    ToggleEditMedication event,
    Emitter<AddMedicationState> emit,
  ) {
    emit(state.copyWith(isEditing: event.isEditing));
  }

  Future<void> _onFetchDataForEditMedications(
    SetDataForEditMedication event,
    Emitter<AddMedicationState> emit,
  ) async {
    List<MedicationType>? _medicationTypes =
        await _medicationRepository.fetchMedicationTypes();
    emit(state.copyWith(
      medicationTypes: _medicationTypes,
    ));
    emit(state.copyWith(
      medicationId:
          event.medicationState.selectedMedicationDetails.medicationId,
      medicationName: MedicationNameInput.dirty(
          value:
              event.medicationState.selectedMedicationDetails.medicationName ??
                  ""),
      medicationType:
          state.medicationTypes[state.medicationTypes.indexWhere((element) {
        if (element.medicationTypeId ==
            event.medicationState.selectedMedicationDetails.medicationTypeId) {
          return true;
        }
        return false;
      })],
      frequency:
          event.medicationState.selectedMedicationDetails.dosageList?.length,
      quantity: int.parse(event.medicationState.selectedMedicationDetails
          .dosageList![0].quantity.value),
      dosageList: event.medicationState.selectedMedicationDetails.dosageList,
      startDate: DateTime.parse(
          event.medicationState.selectedMedicationDetails.startDate ?? ""),
      // endDate: DateTime.parse(
      //     event.medicationState.selectedMedicationDetails.endDate ?? ""),
      reminderAllowed: ReminderRadioTypeInput.dirty(
          value: event.medicationState.selectedMedicationDetails.isRemind!
              ? ReminderType.allowed
              : ReminderType.deny),
      medicationAdditionalDetails: MedicationAdditionalDetailsInput.dirty(
          value: event.medicationState.selectedMedicationDetails
                  .additionalDetails ??
              ""),
      safetyDisclaimerAccepted: true,
    ));
  }

  // Future<void> _onUpdateMedication(
  //   UpdateMedication event,
  //   Emitter emit,
  // ) async {
  //   try {
  //     emit(state.copyWith(status: MedicationFormStatus.loading));
  //     bool updateMedicationSuccess =
  //         await _medicationRepository.updateMedication(
  //             medicationId: state.medicationId,
  //             familyId: _me?.familyId ?? "",
  //             dosageList: state.dosageList,
  //             medicationName: state.medicationName.value,
  //             endDate: DateFormat("yyyy-MM-dd").format(
  //               DateTime.now().add(Duration(days: 7200)),
  //             ),
  //             startDate: DateFormat("yyyy-MM-dd").format(state.startDate),
  //             additionalDetails: state.medicationAdditionalDetails.value,
  //             isRemind: state.reminderAllowed.value == ReminderType.allowed
  //                 ? true
  //                 : false,
  //             medicationTypeId:
  //                 state.selectedMedicationType.medicationTypeId.toString());
  //     if (updateMedicationSuccess) {
  //       emit(state.copyWith(status: MedicationFormStatus.success));
  //     } else {
  //       throw Exception("unable to save");
  //     }
  //   } catch (err) {
  //     emit(state.copyWith(status: MedicationFormStatus.failure));
  //   }
  // }
}
