import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:famici/feature/google_maps/entities/address.dart';
import 'package:famici/utils/barrel.dart';

import '../../../utils/strings/appointment_strings.dart';

class Appointment extends Equatable {
  Appointment(
      {DateTime? appointmentDate,
      this.appointmentId = '',
      this.appointmentName = '',
      this.appointmentType = AppointmentType.unknown,
      List<String>? guests,
      this.isAllDay = false,
      Address? location,
      this.notes = '',
      RecurrenceType? recurrenceType,
      DateTime? startTime,
      DateTime? endTime,
      this.taskDescription = '',
      String? familyId,
      List<Map<String, dynamic>>? guestsMetaData,
      Color? color,
      int? active,
      String? appt_status,
      int? company_id,
      String? group_uuid,
      int? isRequired,
      int? office_id,
      String? place_of_service_code,
      String? recurrence_id,
      String? recurrence_rule,
      int? recurring_appt,
      int? recurring_locked,
      int? room,
      int? telehealth,
      String? user_color,
      List<Counselor>? counselor})
      : familyId = familyId ?? '',
        appointmentDate = appointmentDate ?? DateTime.now(),
        startTime = startTime ?? DateTime.now(),
        endTime = endTime ?? DateTime.now(),
        guests = guests ?? [],
        guestsMetaData = guestsMetaData ?? [],
        location = location ?? Address(),
        recurrenceType = recurrenceType ?? RecurrenceType.doesNotRepeat,
        color = color ?? Color((Random().nextDouble() * 0xFFFFFF).toInt()),
        active = active ?? 0,
        status = appt_status ?? '',
        companyId = company_id ?? 0,
        groupUuid = group_uuid ?? '',
        isRequired = isRequired ?? 0,
        officeId = office_id ?? 0,
        placeOfServiceCode = place_of_service_code ?? '',
        recurrenceId = recurrence_id ?? '',
        recurrenceRule = recurrence_rule ?? '',
        recurringAppointment = recurring_appt ?? 0,
        recurringLocked = recurring_locked ?? 0,
        room = room ?? 0,
        telehealth = telehealth ?? 0,
        userColor = user_color ?? '',
        counselors = counselor ?? [];

  final DateTime appointmentDate;
  final String appointmentId;
  final String appointmentName;
  final AppointmentType appointmentType;
  final List<String> guests;
  final bool isAllDay;
  final Address location;
  final String notes;
  final RecurrenceType recurrenceType;
  final DateTime startTime;
  final DateTime endTime;
  final String taskDescription;
  final List<Map<String, dynamic>> guestsMetaData;
  final Color color;
  final String familyId;

  //new attributes after appointment change as for the mobex portal
  final int active;
  final String status;
  final int companyId;
  final String groupUuid;
  final int isRequired;
  final int officeId;
  final String placeOfServiceCode;
  final String recurrenceId;
  final String recurrenceRule;
  final int recurringAppointment;
  final int recurringLocked;
  final int room;
  final int telehealth;
  final String userColor;
  final List<Counselor> counselors;

  static List<Appointment> fromJsonList(dynamic jsonList) {
    if (jsonList == null) {
      return [];
    }
    return jsonList
        .map<Appointment>((data) => Appointment.fromJson(data))
        .toList();
  }

  factory Appointment.fromJson(jsonData) {
    final List<Map<String, dynamic>> guestsMetaData =
        jsonData['guestsMetaData'] != null
            ? (jsonData['guestsMetaData'] as List)
                .map((guest) => guest as Map<String, dynamic>)
                .toList()
            : [];

    DateTime appt_cnv_date = jsonData['dayt_appt_start'] != null
        ? DateTime.parse(DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(jsonData['dayt_appt_start']).toLocal()))
        : DateTime.now();

    // DateTime testTime = jsonData['dayt_appt_start'] != null
    //     ? DateFormat("yyyy-MM-dd")
    //     .parse(jsonData['dayt_appt_start'])
    //     .toLocal()
    //     : DateTime.now();
    //
    // print("$appt_cnv_date    $testTime");

    return Appointment(
        appointmentDate: appt_cnv_date,
        appointmentId: jsonData['appt_id'].toString(),
        appointmentName: jsonData['appointment'],
        appointmentType:
            (jsonData['appt_type'] ?? "").toString().toAppointmentType(),
        guests: (json.decode(jsonData['user_ids'] ?? "[]") as List)
            .map((guest) => guest.toString())
            .toList(),
        isAllDay: jsonData['isAllDay'] ?? false,
        location: jsonData['location'] is String
            ? Address.fromRawJson(jsonData['location'])
            : Address(),
        notes: jsonData['appt_notes'] ?? '',
        recurrenceType:
            (jsonData['reccuranceType'] ?? '').toString().toRecurrenceType(),
        startTime: DateFormat("HH:mm").parse(DateFormat("HH:mm")
            .format(DateTime.parse(jsonData['dayt_appt_start']).toLocal())),
        endTime: DateFormat("HH:mm").parse(DateFormat("HH:mm")
            .format(DateTime.parse(jsonData['dayt_appt_end']).toLocal())),
        taskDescription: jsonData['taskDescription'] ?? '',
        guestsMetaData: guestsMetaData,
        color: getColor(
          (jsonData['appt_type'] ?? "").toString().toAppointmentType(),
        ),
        active: jsonData['active'] ?? 0,
        appt_status: jsonData['appt_status'] ?? '',
        company_id: jsonData['company_id'] ?? 0,
        group_uuid: jsonData['group_uuid'] ?? '',
        isRequired: jsonData['isRequired'] ?? '',
        office_id: jsonData['office_id'] ?? 0,
        place_of_service_code: jsonData['place_of_service_code'] ?? '',
        recurrence_id: jsonData['recurrence_id'] ?? '',
        recurrence_rule: jsonData['recurrence_rule'] ?? '',
        recurring_appt: jsonData['recurring_appt'] ?? 0,
        recurring_locked: jsonData['recurring_locked'] ?? 0,
        room: jsonData['room'] ?? 0,
        telehealth: jsonData['telehealth'] ?? 0,
        user_color: jsonData['user_color'] ?? '',
        counselor: Counselor.fromJsonList(jsonData['counselors'] ?? []));
  }

  @override
  List<Object?> get props => [
        appointmentDate,
        appointmentId,
        appointmentName,
        appointmentType,
        guests,
        isAllDay,
        location,
        notes,
        recurrenceType,
        startTime,
        endTime,
        taskDescription,
        familyId,
        active,
        status,
        companyId,
        groupUuid,
        isRequired,
        officeId,
        placeOfServiceCode,
        recurrenceId,
        recurrenceRule,
        recurringAppointment,
        recurringLocked,
        room,
        telehealth,
        userColor,
        counselors,
      ];

  bool get hasLocation => location.formattedAddress != 'None';

  String get fullLocation => location.formattedAddress;

  String get guestsNames => guestsMetaData.map((e) => e['givenName']).join(',');

  String get viewNote => notes.isNotEmpty ? notes : 'None';

  // bool get isEvent => appointmentType == AppointmentType.event;
  // bool get isReminder => appointmentType == AppointmentType.reminder;
  // bool get isTask => appointmentType == AppointmentType.task;
  bool get isEvent => appointmentType == AppointmentType.individual;

  bool get isReminder => appointmentType == AppointmentType.individual;

  bool get isTask => appointmentType == AppointmentType.individual;

  List<Map<String, String>> get summary {
    List<Map<String, String>> _summary = [];

    String date = DateFormat('E, MMM dd').format(appointmentDate);
    String _startTime = DateFormat('hh:mm').format(startTime);
    String _endTime = DateFormat('hh:mm a').format(endTime);

    _summary.addAll([
      {
        "${appointmentType.name.capitalize()} ${AppointmentStrings.name.tr()}":
            appointmentName,
      },
      {
        "${appointmentType.name.capitalize()} ${AppointmentStrings.dateAndTime.tr()}":
            "$date, $_startTime - $_endTime",
      },
      {
        AppointmentStrings.recurrence.tr():
            "${recurrenceType.name.toCamelCase()}${isAllDay ? ", ${AppointmentStrings.allDay.tr()}" : ""}"
      },
      // if (isEvent) {AppointmentStrings.guests.tr(): guestsNames},
      // if (isEvent)
      //   {
      //     AppointmentStrings.location.tr():
      //         hasLocation ? location.formattedAddress : "None"
      //   },
      {AppointmentStrings.notes.tr(): notes}
    ]);

    return _summary;
  }

  Map<String, dynamic> toCreateInput() {
    return {
      "familyId": familyId,
      "appointment": {
        "appointmentDate": DateFormat("yyyy-MM-dd").format(appointmentDate),
        "appointmentName": appointmentName,
        "appointmentType": appointmentType.name.capitalize(),
        "endTime": DateFormat("HH:mm").format(endTime),
        "guests": guests,
        "isAllDay": isAllDay,
        "location": location.toRawJson(),
        "note": notes,
        "startTime": DateFormat("HH:mm").format(startTime),
        "taskDescription": taskDescription,
        "reccuranceType": recurrenceType.name.capitalize(),
      }
    };
  }

  Map<String, dynamic> toUpdateInput() {
    return {
      "familyId": familyId,
      "appointmentId": appointmentId,
      "appointment": {
        "appointmentDate": DateFormat("yyyy-MM-dd").format(appointmentDate),
        "appointmentName": appointmentName,
        "appointmentType": appointmentType.name.capitalize(),
        "endTime": DateFormat("HH:mm").format(endTime),
        "guests": guests,
        "isAllDay": isAllDay,
        "location": location.toRawJson(),
        "note": notes,
        "startTime": DateFormat("HH:mm").format(startTime),
        "taskDescription": taskDescription,
        "reccuranceType": recurrenceType.name.capitalize(),
      }
    };
  }
}

enum AppointmentType {
  individual,
  group,
  couple,
  family,
  other,
  unknown,
}

extension AppointmentTypeExt on String {
  AppointmentType toAppointmentType() {
    return AppointmentType.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => AppointmentType.unknown,
    );
  }

  String capitalizeAppointmentType() {
    if (isEmpty) {
      return '';
    } else if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
    return toUpperCase();
  }
}

Color getColor(AppointmentType type) {
  if (type == AppointmentType.individual) {
    return ColorPallet.kCyan;
  }
  if (type == AppointmentType.group) {
    return ColorPallet.kDarkRed;
  }
  if (type == AppointmentType.couple) {
    return ColorPallet.kPurple;
  }
  if (type == AppointmentType.family) {
    return ColorPallet.kBrightGreen;
  }
  if (type == AppointmentType.other) {
    return ColorPallet.kBlue;
  }
  return ColorPallet.kFadedYellow;
}

enum RecurrenceType {
  doesNotRepeat,
  daily,
  weekly,
  lastDayOfMonth,
  annually,
  everyWeekDay,
}

extension RecurrenceTypeExt on String {
  RecurrenceType toRecurrenceType() {
    return RecurrenceType.values.firstWhere(
      (value) => toLowerCase() == value.name.toLowerCase(),
      orElse: () => RecurrenceType.doesNotRepeat,
    );
  }

  toCamelCase() {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    String result = replaceAllMapped(
      exp,
      (Match m) => (' ${m.group(0)?.toUpperCase()}'),
    );
    return result.capitalize();
  }
}

class Counselor {
  Counselor({
    this.id = '',
    this.isDisabled = false,
    this.name = '',
  });

  final String id;
  final bool isDisabled;
  final String name;

  Counselor copyWith({
    String? id,
    bool? isDisabled,
    String? name,
  }) =>
      Counselor(
        id: id ?? this.id,
        isDisabled: isDisabled ?? this.isDisabled,
        name: name ?? this.name,
      );

  factory Counselor.fromJson(dynamic json) => Counselor(
        id: json["id"].toString(),
        isDisabled: json["isDisabled"] ?? true,
        name: json["name"],
      );

  static fromJsonList(dynamic jsonList) {
    return jsonList.map<Counselor>((json) => Counselor.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDisabled": isDisabled,
        "name": name,
      };
}
