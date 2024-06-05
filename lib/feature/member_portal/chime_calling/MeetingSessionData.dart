import '../blocs/meeting_bloc.dart';

class MeetingSessionData {
  static final MeetingSessionData _singleton = MeetingSessionData._internal();

  factory MeetingSessionData() {
    return _singleton;
  }

  MeetingSessionData._internal();

  String groupUuid = "";
  Attendee attendee = Attendee(
      joinToken: "",
      attendeeId: "",
      capabilities: Capabilities(audio: '', video: '', content: ''),
      externalUserId: "");
  Meeting meeting = Meeting(
      meetingId: "",
      tenantIds: [],
      meetingArn: "",
      mediaRegion: "",
      mediaPlacement: MediaPlacement(
          audioHostUrl: '',
          signalingUrl: '',
          screenDataUrl: '',
          turnControlUrl: '',
          audioFallbackUrl: '',
          screenSharingUrl: '',
          screenViewingUrl: '',
          eventIngestionUrl: ''),
      externalMeetingId: "",
      meetingFeatures: {});
  int people = 0;
  bool isAdmitted = false;

  setSessionData(MeetingState sessionData) {
    groupUuid = sessionData.groupUuid;
    attendee = sessionData.attendee;
    meeting = sessionData.meeting;
    people = sessionData.people;
    isAdmitted = sessionData.isAdmitted;
  }

  MeetingState getSessionData() {
    return MeetingState(
        groupUuid: groupUuid,
        attendee: attendee,
        meeting: meeting,
        people: people,
        isAdmitted: isAdmitted);
  }
}
