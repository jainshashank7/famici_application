part of 'manual_reading_bloc.dart';

class ManualReadingState {
  ManualReadingState({
    required this.readings,
    required this.vital,
    required this.isValid,
    required this.status,
    required this.validTime,
    required this.invalidTimeIndex,
  });

  final List<NewManualReading> readings;
  final Vital vital;
  final bool isValid;
  final Status status;
  final bool validTime;
  final int invalidTimeIndex;

  factory ManualReadingState.initial({required Vital vital}) {
    return ManualReadingState(
      vital: vital,
      readings: [
        NewManualReading(readAt: DateTime.now().millisecondsSinceEpoch)
      ],
      isValid: false,
      status: Status.initial,
      validTime: false,
      invalidTimeIndex: -1,
    );
  }

  ManualReadingState copyWith({
    List<NewManualReading>? readings,
    Vital? vital,
    bool? isValid,
    Status? status,
    bool? validTime,
    int? invalidTimeIndex,
  }) {
    return ManualReadingState(
      vital: vital ?? this.vital,
      readings: readings ?? this.readings,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      validTime: validTime ?? this.validTime,
      invalidTimeIndex: invalidTimeIndex ?? this.invalidTimeIndex,
    );
  }
}
