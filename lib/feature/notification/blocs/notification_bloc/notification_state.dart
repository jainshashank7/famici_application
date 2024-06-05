part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState({
    required this.globalCount,
    required this.messages,
    required this.messageCount,
    required this.memories,
    required this.medications,
    required this.appointments,
    required this.multipleMessageCount,
    required this.activityReminders,
    required this.dashboardBuilder,
  });

  final int globalCount;
  final Map<String, List<Message>> messages;
  final Map<String, Notification> memories;
  final Map<String, Notification> medications;
  final Map<String, Notification> appointments;
  final Map<String, int> multipleMessageCount;
  final Map<String, Notification> activityReminders;
  final Map<String, Notification> dashboardBuilder;

  final int messageCount;

  factory NotificationState.initial() {
    return NotificationState(
        globalCount: 0,
        messages: {},
        messageCount: 0,
        memories: {},
        medications: {},
        appointments: {},
        multipleMessageCount: {},
        activityReminders: {},
        dashboardBuilder: {});
  }

  NotificationState copyWith(
      {int? globalCount,
      Map<String, List<Message>>? messages,
      int? messageCount,
      Map<String, Notification>? memories,
      Map<String, Notification>? medications,
      Map<String, Notification>? appointments,
      Map<String, int>? multipleMessageCount,
      Map<String, Notification>? activityReminders,
      Map<String, Notification>? dashboardBuilder}) {
    return NotificationState(
        globalCount: globalCount ?? this.globalCount,
        messages: messages ?? this.messages,
        messageCount: messageCount ?? this.messageCount,
        memories: memories ?? this.memories,
        medications: medications ?? this.medications,
        appointments: appointments ?? this.appointments,
        multipleMessageCount: multipleMessageCount ?? this.multipleMessageCount,
        activityReminders: activityReminders ?? this.activityReminders,
        dashboardBuilder: dashboardBuilder ?? this.dashboardBuilder);
  }

  factory NotificationState.fromJson(dynamic json) {
    if (json == null) {
      return NotificationState.initial();
    }

    Map<String, dynamic> _savedMessages =
        Map<String, dynamic>.from(json['messages'] ?? {});

    Map<String, dynamic> _savedMemories =
        Map<String, dynamic>.from(json['memories'] ?? {});

    Map<String, dynamic> _savedMedications =
        Map<String, dynamic>.from(json['medications'] ?? {});

    Map<String, dynamic> _savedAppointments =
        Map<String, dynamic>.from(json['appointments'] ?? {});

    Map<String, dynamic> _multipleMessageCount =
        Map<String, dynamic>.from(json['multipleMessageCount'] ?? {});

    Map<String, dynamic> _savedActivityReminders =
        Map<String, dynamic>.from(json['activityReminders'] ?? {});

    Map<String, dynamic> _savedDashboardBuilderNotifications =
        Map<String, dynamic>.from(json['dashboardBuilder'] ?? {});

    Map<String, List<Message>> _messages = Map<String, List<Message>>.from(
      _savedMessages.map(
        (key, value) => MapEntry(
          key,
          List<Message>.from(
            (value as List).map((e) => Message.fromJson(e)).toList(),
          ),
        ),
      ),
    );
    return NotificationState(
      globalCount: json['globalCount'] ?? 0,
      messageCount: json['messageCount'] ?? 0,
      messages: _messages,
      memories: Map<String, Notification>.from(_savedMemories.map(
        (key, value) => MapEntry(key, Notification.fromJson(value)),
      )),
      medications: Map<String, Notification>.from(_savedMedications.map(
        (key, value) => MapEntry(key, Notification.fromJson(value)),
      )),
      appointments: Map<String, Notification>.from(_savedAppointments.map(
        (key, value) => MapEntry(key, Notification.fromJson(value)),
      )),
      multipleMessageCount: Map<String, int>.from(
          _multipleMessageCount.map((key, value) => MapEntry(key, value))),
      activityReminders:
          Map<String, Notification>.from(_savedActivityReminders.map(
        (key, value) => MapEntry(key, Notification.fromJson(value)),
      )),
      dashboardBuilder: Map<String, Notification>.from(
          _savedDashboardBuilderNotifications.map(
        (key, value) => MapEntry(key, Notification.fromJson(value)),
      )),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalCount': globalCount,
      'messageCount': messageCount,
      "messages": messages.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      "memories": memories.map((key, value) => MapEntry(key, value.toJson())),
      "medications": medications.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      "appointments": appointments.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      "multipleMessageCount":
          multipleMessageCount.map((key, value) => MapEntry(key, value)),
      "activityReminders":
          activityReminders.map((key, value) => MapEntry(key, value)),
      "dashboardBuilder":
          dashboardBuilder.map((key, value) => MapEntry(key, value)),
    };
  }

  @override
  List<Object?> get props => [
        globalCount,
        messageCount,
        messages,
        memories,
        medications,
        appointments,
        multipleMessageCount,
        activityReminders,
        dashboardBuilder
      ];

  @override
  String toString() {
    return '''
    globalCount : $globalCount,
    messagesCount : $messageCount,
    memoriesCount : ${memories.length}
    medication : ${medications.length}
    multipleMessageCount : ${multipleMessageCount.length}
    activityReminders : ${activityReminders.length}
    ''';
  }
}
