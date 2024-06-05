// ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'manage_appointment_bloc.dart';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rrule/rrule.dart';

import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/calander/widgets/error_message_popup.dart';
import 'package:famici/repositories/appointments_repository.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/appointment_strings.dart';

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
    // DateTime testTime = jsonData['dayt_appt_start'] != null
    //     ? DateFormat("yyyy-MM-dd")
    //     .parse(jsonData['dayt_appt_start'])
    //     .toLocal()
    //     : DateTime.now();
    //
    // print("$appt_cnv_date    $testTime");

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

  // bool get isEvent => appointmentType == AppointmentType.event;
  // bool get isReminder => appointmentType == AppointmentType.reminder;
  // bool get isTask => appointmentType == AppointmentType.task;

  // List<Map<String, String>> get summary {
  //   List<Map<String, String>> _summary = [];

  //   String date = DateFormat('E, MMM dd').format(appointmentDate);
  //   String _startTime = DateFormat('hh:mm').format(startTime);
  //   String _endTime = DateFormat('hh:mm a').format(endTime);

  //   _summary.addAll([
  //     {
  //       "${appointmentType.name.capitalize()} ${AppointmentStrings.name.tr()}":
  //           appointmentName,
  //     },
  //     {
  //       "${appointmentType.name.capitalize()} ${AppointmentStrings.dateAndTime.tr()}":
  //           "$date, $_startTime - $_endTime",
  //     },
  //     {
  //       AppointmentStrings.recurrence.tr():
  //           "${recurrenceType.name.toCamelCase()}${isAllDay ? ", ${AppointmentStrings.allDay.tr()}" : ""}"
  //     },
  //     // if (isEvent) {AppointmentStrings.guests.tr(): guestsNames},
  //     // if (isEvent)
  //     //   {
  //     //     AppointmentStrings.location.tr():
  //     //         hasLocation ? location.formattedAddress : "None"
  //     //   },
  //     {AppointmentStrings.notes.tr(): notes}
  //   ]);

  //   return _summary;
  // }
}

// class ManageReminderState {}
//   ManageReminderState({
//    required  this.title,
//   required this.startTime,
//   required this.endTime,
//   required this.note,
//   required this.all_day,
//   required this.creator_type,
//   required  this.item_type,
//   required this.timezone,
//   required this.utcOffset,
//   required this.recurrenceRule,
//   });
//  String title;
// DateTime startTime ;
// DateTime endTime;
// String? note;
// bool? all_day;
// String creator_type;
// ClientReminderType item_type;
// String timezone;
// int utcOffset;
// dynamic recurrenceRule;
  

//   static ManageReminderState _editReminder(ManageReminderState reminder) {
//     // List<User> _guests =
//     //     appointment.guestsMetaData.map((e) => User.fromJsonContact(e)).toList();
//     return ManageReminderState(
//       title : reminder.title,
//   startTime : reminder.startTime,
//    endTime : reminder.endTime,
//   note : reminder.note,
//    all_day: reminder.all_day,
//  creator_type: reminder.creator_type,
//   item_type: reminder.item_type,
//    timezone : reminder.timezone,
//   utcOffset : reminder.utcOffset,
//  recurrenceRule : reminder.recurrenceRule
//     );
//   }

//   factory ManageReminderState.initial({required ManageReminderState appointment}) {
//     if (appointment.) {
//       return _editReminder(appointment);
//     }
//     return ManageReminderState(
//       currentStep: 0,
//       appointmentId: '',
//       appointmentType: AppointmentType.individual,
//       appointmentName: "",
//       appointmentNameError: false,
//       appointmentTimeError: false,
//       summary: [],
//       appointmentDate: DateTime.now(),
//       appointmentStartTime: DateTime.now(),
//       appointmentEndTime: DateTime.now().add(Duration(hours: 1)),
//       recurrence: RecurrenceType.doesNotRepeat,
//       allDay: false,
//       guestEmail: "",
//       guests: [],
//       location: Address(),
//       notes: "",
//       description: "",
//       status: Status.initial,
//       submissionStatus: Status.initial,
//     );
//   }

//   ManageReminderState copyWith({
//     int? currentStep,
//     AppointmentType? appointmentType,
//     String? appointmentName,
//     bool? appointmentNameError,
//     bool? appointmentTimeError,
//     List<Map<String, String>>? summary,
//     DateTime? appointmentDate,
//     DateTime? appointmentStartTime,
//     DateTime? appointmentEndTime,
//     RecurrenceType? recurrence,
//     bool? allDay,
//     String? guestEmail,
//     List<User>? guests,
//     Address? location,
//     String? notes,
//     String? description,
//     Status? status,
//     Status? submissionStatus,
//     String? appointmentId,
//   }) {
//     return ManageReminderState(
//       currentStep: currentStep ?? this.currentStep,
//       appointmentType: appointmentType ?? this.appointmentType,
//       appointmentName: appointmentName ?? this.appointmentName,
//       appointmentNameError: appointmentNameError ?? this.appointmentNameError,
//       appointmentTimeError: appointmentTimeError ?? this.appointmentTimeError,
//       summary: summary ?? this.summary,
//       appointmentDate: appointmentDate ?? this.appointmentDate,
//       appointmentStartTime: appointmentStartTime ?? this.appointmentStartTime,
//       appointmentEndTime: appointmentEndTime ?? this.appointmentEndTime,
//       recurrence: recurrence ?? this.recurrence,
//       allDay: allDay ?? this.allDay,
//       guestEmail: guestEmail ?? this.guestEmail,
//       guests: guests ?? this.guests,
//       location: location ?? this.location,
//       notes: notes ?? this.notes,
//       description: description ?? this.description,
//       status: status ?? this.status,
//       submissionStatus: submissionStatus ?? this.submissionStatus,
//       appointmentId: appointmentId ?? this.appointmentId,
//     );
//   }

//   bool get isEditing => appointmentId.isNotEmpty;
//   bool get isLoading => Status.loading == status;

//   bool get isSubmitted => submissionStatus == Status.loading;
//   bool get isSubmissionFailed => submissionStatus == Status.failure;
//   bool get isSubmissionSuccess => submissionStatus == Status.success;

//   bool get isFirstStep => currentStep == 0;

//   // bool get isEvent => appointmentType == AppointmentType.event;
//   // bool get isReminder => appointmentType == AppointmentType.reminder;
//   // bool get isTask => appointmentType == AppointmentType.task;
//   bool get isEvent => appointmentType == AppointmentType.individual;
//   bool get isReminder => appointmentType == AppointmentType.individual;
//   bool get isTask => appointmentType == AppointmentType.individual;
// }
