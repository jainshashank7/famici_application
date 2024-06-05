import 'dart:convert';

class CallNotification {
  CallNotification({
    this.caller = '',
    this.audioOnly = false,
    this.callerPhotoUrl = '',
    this.id = '',
    this.type = 'none',
    this.status = '',
    this.callerName = 'Unknown',
    this.isGroup = false,
    DateTime? createdAt,
    List<String>? participants,
  })  : createdAt = createdAt ?? DateTime.now(),
        participants = participants ?? const [];

  final String caller;
  final bool audioOnly;
  final String callerPhotoUrl;
  final String id;
  final String type;
  final String status;
  final String callerName;
  final DateTime createdAt;
  final bool isGroup;
  final List<String> participants;

  CallNotification copyWith({
    String? caller,
    bool? audioOnly,
    String? callerPhotoUrl,
    String? id,
    String? type,
    String? status,
    String? callerName,
    bool? isGroup,
    List<String>? participants,
  }) =>
      CallNotification(
        caller: caller ?? this.caller,
        audioOnly: audioOnly ?? this.audioOnly,
        callerPhotoUrl: callerPhotoUrl ?? this.callerPhotoUrl,
        id: id ?? this.id,
        type: type ?? this.type,
        status: status ?? this.status,
        callerName: callerName ?? this.callerName,
        isGroup: isGroup ?? this.isGroup,
        participants: participants ?? this.participants,
      );

  factory CallNotification.fromRawJson(String str) {
    if (str.isEmpty) {
      return CallNotification();
    }
    return CallNotification.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory CallNotification.fromJson(dynamic json) {
    if (json == null) {
      return CallNotification();
    }
    return CallNotification(
        caller: json["caller"] ?? '',
        audioOnly: json["audioOnly"] == "true",
        callerPhotoUrl: json["callerPhotoUrl"],
        id: json["id"] ?? '',
        type: json["type"] ?? '',
        status: json["status"],
        callerName: json["callerName"] ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(
          json['createdAt'],
        )),
        isGroup: json["isGroup"] == "true",
        participants: (json['participants'] ?? '').toString().split(','));
  }
  Map<String, String> toJson() => {
        "caller": caller,
        "audioOnly": "$audioOnly",
        "callerPhotoUrl": callerPhotoUrl,
        "id": id,
        "type": type,
        "status": status,
        "callerName": callerName,
        "createdAt": createdAt.millisecondsSinceEpoch.toString(),
        "isGroup": '$isGroup',
        "participants": participants.join(',')
      };

  bool get isMissed {
    bool _canShow = status != CallStatus.inProgress;

    _canShow = _canShow && status != CallStatus.completed;
    _canShow = _canShow && status != CallStatus.ringing;
    _canShow = _canShow && status != CallStatus.noAnswerFromParticipant;
    _canShow = _canShow && status == CallStatus.canceled ||
        status == CallStatus.noAnswer;

    return _canShow;
  }

  bool get isNoAnswer {
    return status == CallStatus.noAnswer;
  }

  bool get isDeclined {
    return status == CallStatus.busy;
  }

  bool get isCompleted {
    return status == CallStatus.completed;
  }

  bool get isCancelled {
    return status == CallStatus.canceled;
  }

  bool get isRinging => status == CallStatus.ringing;
}

class CallStatus {
  static bool inProgress = false;

  static bool completed = false;

  static bool ringing = false;

  static bool noAnswerFromParticipant = false;

  static bool canceled = false;

  static bool noAnswer = false;

  static bool busy = false;
}
