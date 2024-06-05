part of 'medication_notify_cubit.dart';

class MedicationNotifyState extends Equatable {
  const MedicationNotifyState({
    required this.notification,
    required this.dosage,
  });

  final Notification notification;
  final DosageItem dosage;

  factory MedicationNotifyState.initial() {
    return MedicationNotifyState(
      notification: Notification(),
      dosage: DosageItem(),
    );
  }

  MedicationNotifyState copyWith({
    Notification? notification,
    DosageItem? dosage,
  }) {
    return MedicationNotifyState(
      notification: notification ?? this.notification,
      dosage: dosage ?? this.dosage,
    );
  }

  @override
  List<Object?> get props => [notification, dosage];
}
