

import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';
import 'package:famici/feature/member_portal/blocs/meeting_bloc.dart';

import 'MeetingSessionData.dart';

class MeetingSessionCreator
{

  MeetingSessionData meetingSessionData = MeetingSessionData();


  Future<String?> create()
  async {

    MeetingState currentMeeting = meetingSessionData.getSessionData();

    await Future.delayed(Duration(seconds: 10));

    return Chime.createMeetingSession(
        meetingId: currentMeeting.meeting.meetingId,
        externalMeetingId: currentMeeting.meeting.externalMeetingId,
        mediaRegion: currentMeeting.meeting.mediaRegion,
        mediaPlacementAudioHostUrl: currentMeeting.meeting.mediaPlacement.audioHostUrl,
        mediaPlacementAudioFallbackUrl: currentMeeting.meeting.mediaPlacement.audioFallbackUrl,
        mediaPlacementSignalingUrl: currentMeeting.meeting.mediaPlacement.signalingUrl,
        mediaPlacementTurnControlUrl: currentMeeting.meeting.mediaPlacement.turnControlUrl,
        attendeeId: currentMeeting.attendee.attendeeId,
        externalUserId: currentMeeting.attendee.externalUserId,
        joinToken: currentMeeting.attendee.joinToken,
    );
  }




}
