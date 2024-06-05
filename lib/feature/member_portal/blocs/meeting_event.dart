part of 'meeting_bloc.dart';

@immutable
abstract class MeetingEvent {}

class FetchMeetingDetailsEvent extends MeetingEvent {
  final String uuid;

  FetchMeetingDetailsEvent(this.uuid);
}
