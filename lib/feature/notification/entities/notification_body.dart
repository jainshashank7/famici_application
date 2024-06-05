import 'dart:convert';

import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:rrule/rrule.dart';

import 'dosage_item.dart';

class NotificationBody extends Equatable {
  NotificationBody(
      {this.appointmentId = '',
      this.appointmentName = '',
      this.appointmentType = '',
      this.appointmentDate = '',
      this.startTime = '',
      this.endDate = '',
      this.reccuranceType = RecurrenceType.unknown,
      this.isAllDay = false,
      List<dynamic>? guests,
      Map<String, dynamic>? location,
      this.medicationId = '',
      List<DosageItem>? dosageList,
      List<String>? deletedDosages,
      this.senderContactId = '',
      List<String>? mediaIds,
      this.requestingContactId = '',
      this.medicationName = '',
      this.startDate = '',
      this.isRemind = false,
      this.imgUrl = '',
      this.medicationType = '',
      this.id = 0,
      this.companyId = 0,
      this.officeId = 0,
      this.deleted = 0,
      DateTime? daytCreate,
      this.userIdCreate = 0,
      DateTime? daytMod,
      this.userIdMod = 0,
      this.active = 0,
      DateTime? daytApptStart,
      DateTime? daytApptEnd,
      DateTime? reminderTime,
      this.clientId = 0,
      this.videoId,
      this.userIds = '',
      this.groupUuid = '',
      this.roomId,
      this.clientConfirmedDayt,
      this.apptStatus,
      this.clientSigninDayt,
      this.apptMachine,
      this.apptComplete = 0,
      this.recurringAppt = 0,
      this.recurringLocked = 0,
      this.recurrenceId = '',
      RecurrenceRule? recurrenceRule,
      this.appointment = '',
      this.apptType = '',
      this.apptNotes = '',
      this.importedDbApptId,
      this.importedDbFieldName,
      this.telehealth = 0,
      this.reminderId = '',
      this.inviteId = '',
      this.importedDbClientId,
      this.isRequiredSession = 0,
      this.placeOfServiceCode = '',
      List<ScheduleEvent>? schedule,
      int? silent})
      : mediaIds = mediaIds ?? [],
        dosageList = dosageList ?? [],
        guests = guests ?? [],
        location = location ?? {},
        deletedDosages = deletedDosages ?? [],
        daytCreate = daytCreate ?? DateTime.now(),
        daytMod = daytMod ?? DateTime.now(),
        daytApptStart = daytApptStart ?? DateTime.now(),
        daytApptEnd = daytApptEnd ?? DateTime.now(),
        reminderTime = reminderTime ?? DateTime.now(),
        recurrenceRule =
            recurrenceRule ?? RecurrenceRule(frequency: Frequency.daily),
        schedule = schedule ?? [],
        silent = silent ?? 0;

  final String appointmentId;
  final String appointmentName;
  final String appointmentType;
  final String appointmentDate;
  final String startTime;
  final String endDate;
  final RecurrenceType reccuranceType;
  final bool isAllDay;
  final List<dynamic> guests;
  final Map<String, dynamic> location;
  final String medicationId;
  final List<DosageItem> dosageList;
  final String senderContactId;
  final List<String> mediaIds;
  final List<String> deletedDosages;
  final String requestingContactId;
  final String medicationName;
  final String startDate;
  final bool isRemind;
  final String imgUrl;
  final String medicationType;

  final int id;
  final int companyId;
  final int officeId;
  final int deleted;
  final DateTime daytCreate;
  final int userIdCreate;
  final DateTime daytMod;
  final int userIdMod;
  final int active;
  final DateTime daytApptStart;
  final DateTime daytApptEnd;
  final DateTime reminderTime;
  final int clientId;
  final dynamic videoId;
  final String userIds;
  final String groupUuid;
  final dynamic roomId;
  final dynamic clientConfirmedDayt;
  final dynamic apptStatus;
  final dynamic clientSigninDayt;
  final dynamic apptMachine;
  final int apptComplete;
  final int recurringAppt;
  final int recurringLocked;
  final String recurrenceId;
  final RecurrenceRule recurrenceRule;
  final String appointment;
  final String apptType;
  final String apptNotes;
  final dynamic importedDbApptId;
  final dynamic importedDbFieldName;
  final int telehealth;
  final String reminderId;
  final String inviteId;
  final dynamic importedDbClientId;
  final int isRequiredSession;
  final String placeOfServiceCode;
  final List<ScheduleEvent> schedule;
  final int silent;

  NotificationBody copyWith(
      {String? appointmentId,
      String? appointmentName,
      String? appointmentType,
      String? appointmentDate,
      String? startTime,
      String? endDate,
      RecurrenceType? reccuranceType,
      bool? isAllDay,
      List<String>? guests,
      Map<String, dynamic>? location,
      String? medicationId,
      List<DosageItem>? dosageList,
      String? senderContactId,
      List<String>? mediaIds,
      List<String>? deletedDosages,
      String? requestingContactId,
      String? medicationName,
      String? medicationType,
      String? startDate,
      bool? isRemind,
      String? imgUrl,

//appointment birch notes
      int? id,
      int? companyId,
      int? officeId,
      int? deleted,
      DateTime? daytCreate,
      int? userIdCreate,
      DateTime? daytMod,
      int? userIdMod,
      int? active,
      DateTime? daytApptStart,
      DateTime? daytApptEnd,
      DateTime? reminderTime,
      int? clientId,
      dynamic videoId,
      String? userIds,
      String? groupUuid,
      dynamic roomId,
      dynamic clientConfirmedDayt,
      dynamic apptStatus,
      dynamic clientSigninDayt,
      dynamic apptMachine,
      int? apptComplete,
      int? recurringAppt,
      int? recurringLocked,
      String? recurrenceId,
      RecurrenceRule? recurrenceRule,
      String? appointment,
      String? apptType,
      String? apptNotes,
      dynamic? importedDbApptId,
      dynamic? importedDbFieldName,
      int? telehealth,
      String? reminderId,
      String? inviteId,
      dynamic importedDbClientId,
      int? isRequiredSession,
      String? placeOfServiceCode,
      List<ScheduleEvent>? schedule,
      int? silent}) {
    return NotificationBody(
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentName: appointmentName ?? this.appointmentName,
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      reccuranceType: reccuranceType ?? this.reccuranceType,
      isAllDay: isAllDay ?? this.isAllDay,
      guests: guests ?? this.guests,
      location: location ?? this.location,
      medicationId: medicationId ?? this.medicationId,
      dosageList: dosageList ?? this.dosageList,
      senderContactId: senderContactId ?? this.senderContactId,
      mediaIds: mediaIds ?? this.mediaIds,
      requestingContactId: requestingContactId ?? this.requestingContactId,
      medicationName: medicationName ?? this.medicationName,
      startDate: startDate ?? this.startDate,
      isRemind: isRemind ?? this.isRemind,
      imgUrl: imgUrl ?? this.imgUrl,
      medicationType: medicationType ?? this.medicationType,
      deletedDosages: deletedDosages ?? this.deletedDosages,
//appointment birch notes
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      officeId: officeId ?? this.officeId,
      deleted: deleted ?? this.deleted,
      daytCreate: daytCreate ?? this.daytCreate,
      userIdCreate: userIdCreate ?? this.userIdCreate,
      daytMod: daytMod ?? this.daytMod,
      userIdMod: userIdMod ?? this.userIdMod,
      active: active ?? this.active,
      daytApptStart: daytApptStart ?? this.daytApptStart,
      daytApptEnd: daytApptEnd ?? this.daytApptEnd,
      reminderTime: reminderTime ?? this.reminderTime,
      clientId: clientId ?? this.clientId,
      videoId: videoId ?? this.videoId,
      userIds: userIds ?? this.userIds,
      groupUuid: groupUuid ?? this.groupUuid,
      roomId: roomId ?? this.roomId,
      clientConfirmedDayt: clientConfirmedDayt ?? this.clientConfirmedDayt,
      apptStatus: apptStatus ?? this.apptStatus,
      clientSigninDayt: clientSigninDayt ?? this.clientSigninDayt,
      apptMachine: apptMachine ?? this.apptMachine,
      apptComplete: apptComplete ?? this.apptComplete,
      recurringAppt: recurringAppt ?? this.recurringAppt,
      recurringLocked: recurringLocked ?? this.recurringLocked,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      appointment: appointment ?? this.appointment,
      apptType: apptType ?? this.apptType,
      apptNotes: apptNotes ?? this.apptNotes,
      importedDbApptId: importedDbApptId ?? this.importedDbApptId,
      importedDbFieldName: importedDbFieldName ?? this.importedDbFieldName,
      telehealth: telehealth ?? this.telehealth,
      reminderId: reminderId ?? this.reminderId,
      inviteId: inviteId ?? this.inviteId,
      importedDbClientId: importedDbClientId ?? this.importedDbClientId,
      isRequiredSession: isRequiredSession ?? this.isRequiredSession,
      placeOfServiceCode: placeOfServiceCode ?? this.placeOfServiceCode,
      schedule: schedule ?? this.schedule,
      silent: silent ?? this.silent,
    );
  }

  factory NotificationBody.fromRawJson(String? str) {
    if (str == null) {
      return NotificationBody();
    }
    return NotificationBody.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory NotificationBody.fromJson(Map<String, dynamic>? json) {

    if (json == null) {
      return NotificationBody();
    }


    DateTime? _reminderTime;
    try {
      if (json['medicationReminderTime'] != null && json["effectiveDate"] != null) {
        _reminderTime =
            DateTime.parse("${json["effectiveDate"]} ${json["medicationReminderTime"]}:00");

        // print("Making st date and end dt crt");
        try {
          // print(json["effectiveDate"]);
          // print(json["endDate"]);
          // print(json["utcStartDate"]);
          DateTime currentTime = DateTime.now();
          if (DateTime.parse(json["effectiveDate"]).isBefore(DateTime(
                  currentTime.year, currentTime.month, currentTime.day + 1)) &&
              DateTime.parse(json["endDate"]).isAfter(DateTime(
                  currentTime.year, currentTime.month, currentTime.day - 1))) {
            _reminderTime = DateTime(currentTime.year, currentTime.month,
                currentTime.day, _reminderTime.hour, _reminderTime.minute);

            // print("timebody $_reminderTime");
          }

        } catch (err) {
          DebugLogger.warning(err);
        }
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    List<DosageItem> _dosage =
        List.from(jsonDecode(json["dosageList"] ?? "[]") ?? [])
            .map((e) => DosageItem.fromJson(e))
            .toList();

    List<ScheduleEvent> schedule =
        ScheduleEvent.fromJsonList(json['schedule'] ?? []);
    return NotificationBody(
      appointmentId: json["appointmentId"] ?? '',
      appointmentName: json["appointmentName"] ?? '',
      appointmentType: json["appointmentType"] ?? '',
      appointmentDate: json["appointmentDate"] ?? '',
      startTime: json["effectiveDate"] ?? '',
      endDate: json["endDate"] ?? '',
      reccuranceType: (json["reccuranceType"] ?? '').toString().toRecurrence(),
      isAllDay: json["isAllDay"] ?? false,
      guests: List<dynamic>.from(json["guests"] ?? []),
      location: json["location"] ?? {},
      medicationId: json["medicationId"] ?? '',
      dosageList: _dosage,
      senderContactId: json["senderContactId"] ?? '',
      mediaIds: List<String>.from(json["mediaIds"] ?? []),
      requestingContactId: json["requestingContactId"] ?? '',
      medicationName: json["medicationName"] ?? '',
      startDate: json["startDate"] ?? '',
      isRemind: json["isRemind"] ?? false,
      imgUrl: json["imageUrl"] ?? '',
      medicationType: json['medicationType'] ?? '',
      deletedDosages: json['deletedDosages'] != null
          ? List<String>.from(json['deletedDosages'])
          : [],
//appointment birch notes
      id: json["id"] ?? 0,
      companyId: json["company_id"] ?? 0,
      officeId: json["office_id"] ?? 0,
      deleted: json["deleted"] ?? 0,
      daytCreate: json["dayt_create"] != null
          ? DateTime.parse(json["dayt_create"]).toLocal()
          : DateTime.now(),
      userIdCreate: json["user_id_create"] ?? 0,
      daytMod: json["dayt_mod"] != null
          ? DateTime.parse(json["dayt_mod"]).toLocal()
          : DateTime.now(),
      userIdMod: json["user_id_mod"] ?? 0,
      active: json["active"] ?? 0,
      daytApptStart: json["dayt_appt_start"] != null
          ? DateTime.parse(json["dayt_appt_start"]).toLocal()
          : DateTime.now(),
      daytApptEnd: json["dayt_appt_end"] != null
          ? DateTime.parse(json["dayt_appt_end"]).toLocal()
          : DateTime.now(),
      reminderTime: _reminderTime ?? DateTime.now(),
      clientId: json["client_id"] ?? 0,
      videoId: json["video_id"],
      userIds: json["user_ids"] ?? '',
      groupUuid: json["group_uuid"] ?? '',
      roomId: json["room_id"],
      clientConfirmedDayt: json["client_confirmed_dayt"],
      apptStatus: json["appt_status"],
      clientSigninDayt: json["client_signin_dayt"],
      apptMachine: json["appt_machine"],
      apptComplete: json["appt_complete"] ?? 0,
      recurringAppt: json["recurring_appt"] ?? 0,
      recurringLocked: json["recurring_locked"] ?? 0,
      recurrenceId: json["recurrence_id"] ?? '',
      recurrenceRule: json["recurrence_rule"] != null
          ? RecurrenceRule.fromString('RRULE:' + json["recurrence_rule"])
          : RecurrenceRule(frequency: Frequency.daily),
      appointment: json["appointment"] ?? '',
      apptType: json["appt_type"] ?? '',
      apptNotes: json["appt_notes"] ?? '',
      importedDbApptId: json["imported_db_appt_id"],
      importedDbFieldName: json["imported_db_field_name"],
      telehealth: json["telehealth"] ?? 0,
      reminderId: json["reminder_id"] ?? '',
      inviteId: json["invite_id"] ?? '',
      importedDbClientId: json["imported_db_client_id"],
      isRequiredSession: json["is_required_session"] ?? 0,
      placeOfServiceCode: json["place_of_service_code"] ?? '',
      schedule: schedule,
      silent: json['silent'],
    );
  }

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "appointmentName": appointmentName,
        "appointmentType": appointmentType,
        "appointmentDate": appointmentDate,
        "startTime": startTime,
        "endDate": endDate,
        "reccuranceType": reccuranceType.name.capitalizeRecurrence(),
        "isAllDay": isAllDay,
        "guests": guests,
        "location": location,
        "medicationId": medicationId,
        "dosageList": jsonEncode(dosageList.map((e) => e.toJson()).toList()),
        "senderContactId": senderContactId,
        "mediaIds": mediaIds,
        "requestingContactId": requestingContactId,
        "medicationName": medicationName,
        "isRemind": isRemind,
        "startDate": startDate,
        "imageUrl": imgUrl,
        "medicationType": medicationType,
        "deletedDosages": deletedDosages,

//appointment birch notes
        "id": id,
        "company_id": companyId,
        "office_id": officeId,
        "deleted": deleted,
        "dayt_create": daytCreate.toUtc().toIso8601String(),
        "user_id_create": userIdCreate,
        "dayt_mod": daytMod.toUtc().toIso8601String(),
        "user_id_mod": userIdMod,
        "active": active,
        "dayt_appt_start": daytApptStart.toUtc().toIso8601String(),
        "dayt_appt_end": daytApptEnd.toUtc().toIso8601String(),
        "client_id": clientId,
        "video_id": videoId,
        "user_ids": userIds,
        "group_uuid": groupUuid,
        "room_id": roomId,
        "client_confirmed_dayt": clientConfirmedDayt,
        "appt_status": apptStatus,
        "client_signin_dayt": clientSigninDayt,
        "appt_machine": apptMachine,
        "appt_complete": apptComplete,
        "recurring_appt": recurringAppt,
        "recurring_locked": recurringLocked,
        "recurrence_id": recurrenceId,
        "recurrence_rule": recurrenceRule.toString().replaceAll('RRULE:', ''),
        "appointment": appointment,
        "appt_type": apptType,
        "appt_notes": apptNotes,
        "imported_db_appt_id": importedDbApptId,
        "imported_db_field_name": importedDbFieldName,
        "telehealth": telehealth,
        "reminder_id": reminderId,
        "invite_id": inviteId,
        "imported_db_client_id": importedDbClientId,
        "is_required_session": isRequiredSession,
        "place_of_service_code": placeOfServiceCode,
        "schedule": schedule.map((e) => e.toJson()).toList(),
        "silent": silent
      };

  @override
  List<Object?> get props => [
        appointmentId,
        appointmentName,
        appointmentType,
        appointmentDate,
        startTime,
        endDate,
        reccuranceType,
        isAllDay,
        guests,
        location,
        medicationId,
        dosageList,
        senderContactId,
        mediaIds,
        requestingContactId,
        medicationName,
        isRemind,
        startDate,
        imgUrl,
        medicationType,
        deletedDosages,
        //appointment birch notes
        id,
        companyId,
        officeId,
        deleted,
        daytCreate,
        userIdCreate,
        daytMod,
        userIdMod,
        active,
        daytApptStart,
        daytApptEnd,
        reminderTime,
        clientId,
        videoId,
        userIds,
        groupUuid,
        roomId,
        clientConfirmedDayt,
        apptStatus,
        clientSigninDayt,
        apptMachine,
        apptComplete,
        recurringAppt,
        recurringLocked,
        recurrenceId,
        recurrenceRule,
        appointment,
        apptType,
        apptNotes,
        importedDbApptId,
        importedDbFieldName,
        telehealth,
        reminderId,
        inviteId,
        importedDbClientId,
        isRequiredSession,
        placeOfServiceCode,
      ];

  bool get shouldRepeat => reccuranceType != RecurrenceType.doesNotRepeat;

  bool get isRecurring => recurringAppt == 1;

  bool get isSilent => silent == 1;

  bool get isWeekly => recurrenceRule.frequency == Frequency.weekly;

  bool get isDaily => recurrenceRule.frequency == Frequency.daily;

  bool get isMonthly => recurrenceRule.frequency == Frequency.monthly;

  bool get isWeekDay => reccuranceType == RecurrenceType.everyWeekDay;

  bool get isAnnually => recurrenceRule.frequency == Frequency.yearly;

  bool get isLatWeekOfTheMonth =>
      reccuranceType == RecurrenceType.lastDayOfMonth;

  bool get isEvent => appointmentType == 'Event';

  bool get isReminder => appointmentType == 'Reminder';

  bool get isTask => appointmentType == 'Task';
}

enum RecurrenceType {
  everyWeekDay,
  daily,
  weekly,
  annually,
  lastDayOfMonth,
  unknown,
  doesNotRepeat
}

extension RecurrenceTypeExt on String {
  RecurrenceType toRecurrence() {
    return RecurrenceType.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => RecurrenceType.unknown,
    );
  }

  String capitalizeRecurrence() {
    if (isEmpty) {
      return '';
    } else if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
    return toUpperCase();
  }
}

class ScheduleEvent {
  ScheduleEvent({
    int? id,
    DateTime? startDate,
  })  : id = id ?? 0,
        startDate = startDate ?? DateTime.now();

  final int id;
  final DateTime startDate;

  ScheduleEvent copyWith({
    int? id,
    DateTime? startDate,
  }) =>
      ScheduleEvent(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
      );

  factory ScheduleEvent.fromRawJson(String str) =>
      ScheduleEvent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) => ScheduleEvent(
        id: json["id"],
        startDate: json["start_date"] != null
            ? DateTime.parse(json["start_date"]).toLocal()
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate.toUtc().toIso8601String(),
      };

  static fromJsonList(dynamic jsonList) {
    if (jsonList == null) {
      return [];
    }
    return jsonList
        .map<ScheduleEvent>((e) => ScheduleEvent.fromJson(e))
        .toList() as List<ScheduleEvent>;
  }
}

class GuestUser {
  GuestUser({
    this.id = 0,
    this.name = '',
    this.isDisabled = false,
  });

  final int id;
  final String name;
  final bool isDisabled;

  GuestUser copyWith({
    int? id,
    String? name,
    bool? isDisabled,
  }) =>
      GuestUser(
        id: id ?? this.id,
        name: name ?? this.name,
        isDisabled: isDisabled ?? this.isDisabled,
      );

  factory GuestUser.fromJson(Map<String, dynamic> json) => GuestUser(
        id: json["id"],
        name: json["name"],
        isDisabled: json["\u0024isDisabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "\u0024isDisabled": isDisabled,
      };

  static List<GuestUser> fromJsonList(String str) =>
      List<GuestUser>.from(json.decode(str).map((x) => GuestUser.fromJson(x)));

  static String toJsonList(List<GuestUser> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
