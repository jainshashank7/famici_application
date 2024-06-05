part of 'manage_reminders_bloc.dart';

enum EventStatus { initial, loading, success, failure }

class ManageRemindersState extends Equatable {
  ManageRemindersState(
      {required this.reminders,
      this.isEvent,
      required this.additionStatus,
      required this.deletionStatus,
      required this.editionStatus});

  final List<Reminders> reminders;
  EventStatus additionStatus;
  EventStatus deletionStatus;
  EventStatus editionStatus;
  bool? isEvent;
  factory ManageRemindersState.initial() {
    return ManageRemindersState(
        reminders: [],
        additionStatus: EventStatus.initial,
        deletionStatus: EventStatus.initial,
        editionStatus: EventStatus.initial,
        isEvent: true);
  }

  ManageRemindersState copyWith(
      {List<Reminders>? reminders,
      bool? isEvent,
      EventStatus? deletionStatus,
      EventStatus? additionStatus,
      EventStatus? editionStatus}) {
    return ManageRemindersState(
        isEvent: isEvent ?? this.isEvent,
        reminders: reminders ?? this.reminders,
        deletionStatus: deletionStatus ?? this.deletionStatus,
        additionStatus: additionStatus ?? this.additionStatus,
        editionStatus: editionStatus ?? this.editionStatus);
  }

  @override
  List<Object?> get props =>
      [reminders, deletionStatus, editionStatus, additionStatus, isEvent];
}

enum ClientReminderType { REMINDER, EVENT, ICAL }

// class RecurrenceModel {
//    final int interval;
//   final String freq;
//   final int count;
//   final List<String> byday;
//   final bool isAfter;
//   final DateTime? until;

//   RecurrenceModel({
//     DateTime? dtstart,
//     int? interval,
//     this.count,
//     bool? isAfter,
//     this.until,
//     freq = 'WEEKLY',
//     List<int>? byweekday,
//   })  : byweekday = byweekday ?? [1],
//         dtstart = dtstart ?? DateTime.now(),
//         isAfter = isAfter ?? false,
//         interval = interval ?? 1;

//   String toString() {
//     return 'RecurrenceModel {'
//         ' dtstart: $dtstart,'
//         ' interval: $interval,'
//         ' count: $count,'
//         ' isAfter: $isAfter,'
//         ' until: $until,'
//         ' freq: $freq,'
//         ' byweekday: $byweekday'
//         ' }';
//   }
// }

// class Reminders extends Equatable {
//   Reminders({
//     String? reminder_id,
//     this.title = '',
//     DateTime? startTime,
//     DateTime? endTime,
//     DateTime? date,
//     this.isAllDay = false,
//     this.item_type = ClientReminderType.EVENT,
//     this.notes = '',
//     this.creator_type = "CLIENT",
//     this.recurrenceRule = null,
//   })  : reminder_id = reminder_id ?? '',
//         date = date ?? DateTime.now(),
//         startTime = startTime ?? DateTime.now(),
//         endTime = endTime ?? DateTime.now();

//   String reminder_id;
//   String title;
//   DateTime startTime, date;
//   DateTime endTime;
//   bool isAllDay;
//   String notes;
//   String creator_type;
//   ClientReminderType item_type;
//   dynamic recurrenceRule;

//   @override
//   String toString() {
//     return 'Reminders {'
//         ' reminder_id: $reminder_id,'
//         ' title: $title,'
//         ' startTime: $startTime,'
//         ' date: $date,'
//         ' endTime: $endTime,'
//         ' isAllDay: $isAllDay,'
//         ' notes: $notes,'
//         ' creator_type: $creator_type,'
//         ' item_type: $item_type,'
//         ' recurrenceRule: $recurrenceRule'
//         ' }';
//   }

//   static List<Reminders> fromJsonList(dynamic jsonList) {
//     if (jsonList == null) {
//       return [];
//     }
//     return jsonList.map<Reminders>((data) => Reminders.fromJson(data)).toList();
//   }

//     factory Reminders.fromJson(Map<String, dynamic> json) {
//     return Reminders(
//       reminder_id: json['reminder_id'],
//       title: json['title'],
//       startTime: DateTime.parse(json['start_time']),
//       endTime: DateTime.parse(json['end_time']),
//       isAllDay: json['all_day'],
//       recurrenceRule: json['recurrence_rule'] == null
//           ? ''
//           : RecurrenceModel.fromJson(json['recurrence_rule']),
//       recurrenceId: json['recurrence_id'],
//       note: json['note'],
//       creatorType: json['creator_type'],
//       itemType: json['item_type'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'reminder_id': reminderId,
//       'title': title,
//       'start_time': startTime.toIso8601String(),
//       'end_time': endTime.toIso8601String(),
//       'all_day': allDay,
//       'recurrence_rule': recurrenceRule.toJson(),
//       'recurrence_id': recurrenceId,
//       'note': note,
//       'creator_type': creatorType,
//       'item_type': itemType,
//     };
//   }

//   @override
//   List<Object?> get props => [
//         reminder_id,
//         title,
//         startTime,
//         endTime,
//         isAllDay,
//         notes,
//         creator_type,
//         item_type,
//         recurrenceRule,
//       ];
// }

class Reminders extends Equatable {
  int reminderId;
  String title;
  DateTime startTime;
  DateTime endTime;
  bool allDay;
  dynamic? recurrenceRule;
  String recurrenceId;
  String? note;
  String creatorType;
  ClientReminderType itemType;

  Reminders({
    required this.reminderId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.allDay,
    this.recurrenceRule,
    required this.recurrenceId,
    this.note = '',
    required this.creatorType,
    required this.itemType,
  });

  factory Reminders.fromJson(Map<String, dynamic> json) {
    DebugLogger.info("Reminders.fromJson  $json");
    return Reminders(
      reminderId: json['reminder_id'],
      title: json['title'],
      startTime: DateTime.parse(json['start_time']).toLocal(),
      endTime: DateTime.parse(json['end_time']).toLocal(),
      allDay: json['all_day'] == 0 ? false : true,
      recurrenceRule: json['recurrence_rule'] == null
          ? ''
          : RecurrenceRule.fromJson(json['recurrence_rule']),
      recurrenceId: json['recurrence_id'],
      note: json['note'] == 'empty_note_404' ? '' : json['note'],
      creatorType: json['creator_type'],
      itemType: json['item_type'] == ClientReminderType.EVENT.name
          ? ClientReminderType.EVENT
          : ClientReminderType.REMINDER,
    );
  }

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {

    return {
      'reminder_id': reminderId,
      'title': title,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'all_day': allDay == 0 ? false : true,
      'recurrence_rule': recurrenceRule == '' ? null : recurrenceRule.toJson(),
      'recurrence_id': recurrenceId,
      'note': note,
      'creator_type': creatorType,
      'item_type': itemType == ClientReminderType.EVENT.name
          ? ClientReminderType.EVENT.name
          : ClientReminderType.REMINDER.name,
    };
  }

  Reminders copyWith({
    int? reminderId,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    bool? allDay,
    dynamic? recurrenceRule,
    String? recurrenceId,
    String? note,
    String? creatorType,
    ClientReminderType? itemType,
  }) {
    return Reminders(
      reminderId: reminderId ?? this.reminderId,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      allDay: allDay ?? this.allDay,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      note: note ?? this.note,
      creatorType: creatorType ?? this.creatorType,
      itemType: itemType ?? this.itemType,
    );
  }

  @override
  List<dynamic> get props => [
        reminderId,
        title,
        startTime,
        endTime,
        allDay,
        recurrenceRule,
        recurrenceId,
        note,
        creatorType,
        itemType,
      ];
}

class RecurrenceRule {
  int interval;
  String freq = "WEEKLY";
  int count;
  List<int> byday;
  bool isAfter;
  DateTime? until;

  RecurrenceRule(
      {required this.interval,
      required this.count,
      required this.byday,
      required this.isAfter,
      this.until});
  String toString() {
    return 'RecurrenceModel {'
        ' interval: $interval,'
        ' count: $count,'
        ' isAfter: $isAfter,'
        ' until: $until,'
        ' freq: $freq,'
        ' byweekday: $byday'
        ' }';
  }

  RecurrenceRule copyWith({
    int? interval,
    int? count,
    List<int>? byday,
    bool? isAfter,
    DateTime? until,
  }) {
    return RecurrenceRule(
      interval: interval ?? this.interval,
      count: count ?? this.count,
      byday: byday ?? List.from(this.byday),
      isAfter: isAfter ?? this.isAfter,
      until: until ?? this.until,
    );
  }

  static List<int> convertToWeekdayNumbers(List<String> abbreviations) {
    Map<String, int> weekdayMap = {
      'MO': DateTime.monday,
      'TU': DateTime.tuesday,
      'WE': DateTime.wednesday,
      'TH': DateTime.thursday,
      'FR': DateTime.friday,
      'SA': DateTime.saturday,
      'SU': DateTime.sunday,
    };

    return abbreviations.map((abbreviation) {
      return (weekdayMap[abbreviation.toUpperCase()]! - DateTime.sunday + 7) %
          7;
    }).toList();
  }

  factory RecurrenceRule.fromJson(String json) {
    final ruleParams = json.split(';');
    int interval = 1;
    String freq = '';
    int count = 0;
    List<int> byday = [];
    dynamic until = 0;
    for (var param in ruleParams) {
      final keyValue = param.split('=');
      final key = keyValue[0];
      final value = keyValue[1];

      if (key == 'INTERVAL') {
        interval = int.parse(value);
      } else if (key == 'FREQ') {
        freq = value;
      } else if (key == 'COUNT') {
        count = int.parse(value);
      } else if (key == 'UNTIL') {
        until = DateTime.parse(value).toLocal();
      } else if (key == 'BYDAY') {
        var temp = value.split(',');
        byday = convertToWeekdayNumbers(temp);
      }
    }
    if (until == 0) {
      return RecurrenceRule(
        interval: interval,
        count: count,
        byday: byday,
        isAfter: count != null ? true : false,
        // ignore: unnecessary_null_comparison
      );
    } else {
      return RecurrenceRule(
          interval: interval,
          count: count,
          byday: byday,
          isAfter: count != null ? true : false,
          // ignore: unnecessary_null_comparison
          until: until);
    }
  }

  Map<String, dynamic> toJson() {
    if (isAfter == true)
      return {
        'interval': interval,
        'freq': freq,
        'count': count,
        'byday': byday,
      };
    else
      return {
        'interval': interval,
        'freq': freq,
        'count': count,
        'until': until,
      };
  }
}

class ActivityReminder extends Equatable {
  int id;
  int companyId;
  int clientId;
  String title;
  DateTime reminderDateTime;
  // String reminderTime;
  String? recurrenceId;
  bool active;
  bool deleted;
  String createdAt;
  String updatedAt;

  ActivityReminder(
      {required this.id,
      required this.companyId,
      required this.clientId,
      required this.title,
      required this.reminderDateTime,
      // required this.reminderTime,
      required this.recurrenceId,
      required this.active,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt});

  factory ActivityReminder.fromJson(Map<String, dynamic> json) {
    final String dateString = json['reminder_date'];
    final String timeString = json['reminder_time'];

    print("Activity Reminder DATETIME ::: ${DateTime.parse(dateString)}");
    // Parse the date and time strings
    final DateTime date = DateTime.parse(dateString);
    final List<String> timeParts = timeString.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    // Create a DateTime by combining date and time
    final DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
    print("Time :: $combinedDateTime");
    return ActivityReminder(
        id: json['id'],
        companyId: json['company_id'],
        clientId: json['client_id'],
        title: json['title'],
        reminderDateTime:  combinedDateTime,
        // DateTime.parse(json['reminder_date']).toLocal(),
        // reminderTime: json['reminder_time'],
        recurrenceId: json['recurrence_id'] ?? "",
        active: json['active'] == 1 ? true : false,
        deleted: json['deleted'] == 1 ? true : false,
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'client_id': clientId,
      'title': title,
      'reminder_date': reminderDateTime.toIso8601String(),
      // 'reminder_time': reminderTime,
      'recurrence_id': recurrenceId,
      'active': active,
      'deleted': deleted,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  ActivityReminder copyWith({
    int? id,
    int? companyId,
    int? clientId,
    String? title,
    DateTime? reminderDateTime,
    // String? reminderTime,
    String? recurrenceId,
    bool? active,
    bool? deleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return ActivityReminder(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        clientId: clientId ?? this.clientId,
        title: title ?? this.title,
        reminderDateTime: reminderDateTime ?? this.reminderDateTime,
        // reminderTime: reminderTime ?? this.reminderTime,
        recurrenceId: recurrenceId ?? this.recurrenceId,
        active: active ?? this.active,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,companyId,clientId,title,reminderDateTime,recurrenceId,active,deleted,createdAt,updatedAt];
}
