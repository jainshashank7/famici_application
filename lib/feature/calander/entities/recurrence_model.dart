import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';

enum ClientReminderType { REMINDER, EVENT }

class RecurrenceModel {
  DateTime dtstart;
  int interval;
  int? count;
  bool isAfter;
  DateTime? until;
  String freq = 'WEEKLY';
  List<int> byweekday;

  RecurrenceModel({
    DateTime? dtstart,
    int? interval,
    this.count,
    bool? isAfter,
    this.until,
    freq = 'WEEKLY',
    List<int>? byweekday,
  })  : byweekday = byweekday ?? [1],
        dtstart = dtstart ?? DateTime.now(),
        isAfter = isAfter ?? false,
        interval = interval ?? 1;

  String toString() {
    return 'RecurrenceModel {'
        ' dtstart: $dtstart,'
        ' interval: $interval,'
        ' count: $count,'
        ' isAfter: $isAfter,'
        ' until: $until,'
        ' freq: $freq,'
        ' byweekday: $byweekday'
        ' }';
  }
}

class Reminders extends Equatable {
  Reminders({
    String? reminder_id,
    this.title = '',
    DateTime? startTime,
    DateTime? endTime,
    DateTime? date,
    this.isAllDay = false,
    this.item_type = ClientReminderType.EVENT,
    this.notes = '',
    this.creator_type = "CLIENT",
    this.recurrenceRule = null,
  })  : reminder_id = reminder_id ?? '',
        date = date ?? DateTime.now(),
        startTime = startTime ?? DateTime.now(),
        endTime = endTime ?? DateTime.now();

  String reminder_id;
  String title;
  DateTime startTime, date;
  DateTime endTime;
  bool isAllDay;
  String notes;
  String creator_type;
  ClientReminderType item_type;
  dynamic recurrenceRule;

  @override
  String toString() {
    return 'Reminders {'
        ' reminder_id: $reminder_id,'
        ' title: $title,'
        ' startTime: $startTime,'
        ' date: $date,'
        ' endTime: $endTime,'
        ' isAllDay: $isAllDay,'
        ' notes: $notes,'
        ' creator_type: $creator_type,'
        ' item_type: $item_type,'
        ' recurrenceRule: $recurrenceRule'
        ' }';
  }

  static List<Reminders> fromJsonList(dynamic jsonList) {
    if (jsonList == null) {
      return [];
    }
    return jsonList
        .map<Appointment>((data) => Appointment.fromJson(data))
        .toList();
  }

  factory Reminders.fromJson(jsonData) {
    return Reminders(
      date: DateFormat("MM-dd-yyyy").parse(DateFormat("HH:mm")
          .format(DateTime.parse(jsonData['start_time']).toLocal())),
      reminder_id: jsonData['reminder_id'],
      title: jsonData['title'],
      startTime: DateFormat("yyyy-MM-dd hh:mm:ss").parse(DateFormat("HH:mm")
          .format(DateTime.parse(jsonData['start_time']).toLocal())),
      endTime: DateFormat("yyyy-MM-dd hh:mm:ss").parse(DateFormat("HH:mm")
          .format(DateTime.parse(jsonData['end_time']).toLocal())),
      isAllDay: jsonData['all_day'] == 'false' ? false : true,
      item_type: jsonData['item_type'] == ClientReminderType.EVENT
          ? ClientReminderType.EVENT
          : ClientReminderType.REMINDER,
      notes: jsonData['note'],
      creator_type: "CLIENT",
      recurrenceRule: null,
    );
  }

  @override
  List<Object?> get props => [
        reminder_id,
        title,
        startTime,
        endTime,
        isAllDay,
        notes,
        creator_type,
        item_type,
        recurrenceRule,
      ];
}
