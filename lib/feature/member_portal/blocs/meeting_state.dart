part of 'meeting_bloc.dart';

class MeetingState extends Equatable {
  const MeetingState(
      {required this.groupUuid,
      required this.attendee,
      required this.meeting,
      required this.people,
      required this.isAdmitted,
      this.sessionId,
      this.clientId,
      this.companyId});

  final String groupUuid;
  final Attendee attendee;
  final Meeting meeting;
  final int people;
  final bool isAdmitted;
  final String? sessionId;
  final String? clientId;
  final String? companyId;

  factory MeetingState.initial() {
    return MeetingState(
      sessionId: '',
      groupUuid: '',
      attendee: const Attendee(
          joinToken: '',
          attendeeId: '',
          capabilities: Capabilities(audio: '', video: '', content: ''),
          externalUserId: ''),
      meeting: Meeting(
        meetingId: '',
        tenantIds: [],
        meetingArn: '',
        mediaRegion: '',
        mediaPlacement: const MediaPlacement(
          audioHostUrl: '',
          signalingUrl: '',
          screenDataUrl: '',
          turnControlUrl: '',
          audioFallbackUrl: '',
          screenSharingUrl: '',
          screenViewingUrl: '',
          eventIngestionUrl: '',
        ),
        meetingFeatures: {},
        externalMeetingId: '',
      ),
      people: 0,
      isAdmitted: false,
    );
  }

  MeetingState copyWith(
      {String? groupUuid,
      Attendee? attendee,
      Meeting? meeting,
      int? people,
      bool? isAdmitted,
      String? sessionId,
      String? companyId,
      String? clientId}) {
    return MeetingState(
        groupUuid: groupUuid ?? this.groupUuid,
        attendee: attendee ?? this.attendee,
        meeting: meeting ?? this.meeting,
        people: people ?? this.people,
        isAdmitted: isAdmitted ?? this.isAdmitted,
        sessionId: sessionId ?? this.sessionId,
        companyId : companyId ?? this.companyId,
        clientId : clientId ?? this.clientId);
  }

  factory MeetingState.fromJson(Map<String, dynamic> json) {
    return MeetingState(
        groupUuid: '',
        attendee: Attendee.fromJson(json['Attendee']),
        meeting: Meeting.fromJson(json['Meeting']),
        people: json['People'],
        isAdmitted: false,
        sessionId: '', 
        clientId : '',
        companyId: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'Attendee': attendee.toJson(),
      'Meeting': meeting.toJson(),
      'People': people,
    };
  }

  @override
  List<Object?> get props => [
        attendee,
        meeting,
        people,
      ];
}

class Attendee extends Equatable {
  const Attendee({
    required this.joinToken,
    required this.attendeeId,
    required this.capabilities,
    required this.externalUserId,
  });

  final String joinToken;
  final String attendeeId;
  final Capabilities capabilities;
  final String externalUserId;

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      joinToken: json['JoinToken'],
      attendeeId: json['AttendeeId'],
      capabilities: Capabilities.fromJson(json['Capabilities']),
      externalUserId: json['ExternalUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JoinToken': joinToken,
      'AttendeeId': attendeeId,
      'Capabilities': capabilities.toJson(),
      'ExternalUserId': externalUserId,
    };
  }

  @override
  List<Object?> get props => [
        joinToken,
        attendeeId,
        capabilities,
        externalUserId,
      ];
}

class Capabilities extends Equatable {
  const Capabilities({
    required this.audio,
    required this.video,
    required this.content,
  });

  final String audio;
  final String video;
  final String content;

  factory Capabilities.fromJson(Map<String, dynamic> json) {
    return Capabilities(
      audio: json['Audio'],
      video: json['Video'],
      content: json['Content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Audio': audio,
      'Video': video,
      'Content': content,
    };
  }

  @override
  List<Object?> get props => [
        audio,
        video,
        content,
      ];
}

class Meeting {
  final String meetingId;
  final List<dynamic> tenantIds;
  final String meetingArn;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;
  final Map<String, dynamic> meetingFeatures;
  final String externalMeetingId;

  Meeting({
    required this.meetingId,
    required this.tenantIds,
    required this.meetingArn,
    required this.mediaRegion,
    required this.mediaPlacement,
    required this.meetingFeatures,
    required this.externalMeetingId,
  });

  Meeting.fromJson(Map<String, dynamic> json)
      : meetingId = json['MeetingId'],
        tenantIds = List<dynamic>.from(json['TenantIds']),
        meetingArn = json['MeetingArn'],
        mediaRegion = json['MediaRegion'],
        mediaPlacement = MediaPlacement.fromJson(json['MediaPlacement']),
        meetingFeatures = Map<String, dynamic>.from(json['MeetingFeatures']),
        externalMeetingId = json['ExternalMeetingId'];

  Map<String, dynamic> toJson() => {
        'MeetingId': meetingId,
        'TenantIds': tenantIds,
        'MeetingArn': meetingArn,
        'MediaRegion': mediaRegion,
        'MediaPlacement': mediaPlacement.toJson(),
        'MeetingFeatures': meetingFeatures,
        'ExternalMeetingId': externalMeetingId,
      };
}

class MediaPlacement {
  const MediaPlacement({
    required this.audioHostUrl,
    required this.signalingUrl,
    required this.screenDataUrl,
    required this.turnControlUrl,
    required this.audioFallbackUrl,
    required this.screenSharingUrl,
    required this.screenViewingUrl,
    required this.eventIngestionUrl,
  });

  final String audioHostUrl;
  final String signalingUrl;
  final String screenDataUrl;
  final String turnControlUrl;
  final String audioFallbackUrl;
  final String screenSharingUrl;
  final String screenViewingUrl;
  final String eventIngestionUrl;

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    return MediaPlacement(
      audioHostUrl: json['AudioHostUrl'] as String,
      signalingUrl: json['SignalingUrl'] as String,
      screenDataUrl: json['ScreenDataUrl'] as String,
      turnControlUrl: json['TurnControlUrl'] as String,
      audioFallbackUrl: json['AudioFallbackUrl'] as String,
      screenSharingUrl: json['ScreenSharingUrl'] as String,
      screenViewingUrl: json['ScreenViewingUrl'] as String,
      eventIngestionUrl: json['EventIngestionUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AudioHostUrl': audioHostUrl,
      'SignalingUrl': signalingUrl,
      'ScreenDataUrl': screenDataUrl,
      'TurnControlUrl': turnControlUrl,
      'AudioFallbackUrl': audioFallbackUrl,
      'ScreenSharingUrl': screenSharingUrl,
      'ScreenViewingUrl': screenViewingUrl,
      'EventIngestionUrl': eventIngestionUrl,
    };
  }
}
