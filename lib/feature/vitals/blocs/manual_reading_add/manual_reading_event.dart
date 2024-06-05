part of 'manual_reading_bloc.dart';

@immutable
abstract class ManualReadingEvent {}

class AddMoreReading extends ManualReadingEvent {}

class RemoveNewManualReading extends ManualReadingEvent {
  final int index;

  RemoveNewManualReading(this.index);
}

class ManualReadingInputAdded extends ManualReadingEvent {
  final NewManualReading reading;
  final int index;

  ManualReadingInputAdded(this.reading, this.index);
}

class ManualReadingTimeUpdated extends ManualReadingEvent {
  final DateTime time;
  final int index;

  ManualReadingTimeUpdated(this.time, this.index);
}

class SaveNewManualReadings extends ManualReadingEvent {}

class ValidateNewReading extends ManualReadingEvent {}

class ValidateNewReadingTime extends ManualReadingEvent {}
