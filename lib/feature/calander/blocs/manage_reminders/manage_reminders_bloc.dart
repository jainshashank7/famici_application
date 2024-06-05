import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:famici/feature/calander/entities/recurrence_model.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../../../../core/enitity/user.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../utils/config/api_config.dart';
import '../../../../utils/config/api_key.dart';
import '../../../../utils/constants/constants.dart';

part 'manage_reminders_event.dart';

part 'manage_reminders_state.dart';

class ManageRemindersBloc
    extends Bloc<ManageRemindersEvent, ManageRemindersState> {
  ManageRemindersBloc({
    required User me,
  })  : _me = me,
        super(ManageRemindersState.initial()) {
    // on<FetchEventsAndRemindersData>(_onFetchEventsAndRemindersDataForMonth);
    on<SendEventsAndRemindersData>(_onSendEventsAndRemindersData);
    on<DeleteEventsAndRemindersData>(_onDeleteEventsAndRemindersData);
    on<DeleteEventsAndRemindersForByRecurrenceRule>(
        _onDeleteEventsAndRemindersForByRecurrenceRule);
    on<EditEventsAndRemindersWithoutRecurrenceData>(
        _onEditEventsAndRemindersWithoutRecurrenceData);
    on<EditEventsAndRemindersWithRecurrenceData>(
        _onEditEventsAndRemindersWithRecurrenceData);
  }
  String _timezone = 'Unknown';

  final User _me;

  DateTime _current = DateTime.now();
  final AuthRepository _authRepository = AuthRepository();
  String convertTimestampToISO8601ForStartTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);

    // Calculate the offset in hours and minutes
    int offsetHours = dateTime.timeZoneOffset.inHours;
    int offsetMinutes = dateTime.timeZoneOffset.inMinutes.remainder(60);

    // Format the offset with the correct sign and padding
    String offset = (dateTime.timeZoneOffset.isNegative ? '-' : '+') +
        offsetHours.abs().toString().padLeft(2, '0') +
        ':' +
        offsetMinutes.abs().toString().padLeft(2, '0');
    return '$formattedDateTime$offset';
  }

  String convertTimestampToISO8601(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateTime.toUtc());
    return formattedDateTime;
  }

  FutureOr<void> _onEditEventsAndRemindersWithoutRecurrenceData(
      EditEventsAndRemindersWithoutRecurrenceData event,
      Emitter<ManageRemindersState> emit) async {
    emit(state.copyWith(editionStatus: EventStatus.loading));
    bool isSucssess = false;
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {}
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/client-reminders/update';
      final Map<String, dynamic> requestData = event.byRecId
          ? {
              "title": event.title,
              "note": event.notes != '' ? event.notes : 'empty_note_404',
              "allDay": event.isAllDay,
              "startTime": convertTimestampToISO8601ForStartTime(
                  event.startDate.toString()),
              "endTime": convertTimestampToISO8601ForStartTime(
                  event.endDate.toString()),
              "itemType": event.isEvent ? "EVENT" : "REMINDER",
              "updateType": "via_recurrence",
              "recurrenceId": event.recurrenceId,
            }
          : {
              "title": event.title,
              "note": event.notes != '' ? event.notes : 'empty_note_404',
              "allDay": event.isAllDay,
              "startTime": convertTimestampToISO8601ForStartTime(
                  event.startDate.toString()),
              "endTime": convertTimestampToISO8601ForStartTime(
                  event.endDate.toString()),
              "itemType": event.isEvent ? "EVENT" : "REMINDER",
              "updateType": "via_id",
              "reminderIds": [event.reminderId],
              "recurrenceId": event.recurrenceId,
            };

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        'Content-Type': 'application/json',
      };

      var response = await http
          .put(
        Uri.parse(memberProfile),
        headers: headers,
        body: jsonEncode(requestData),
      )
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSucssess = true;
        } else {
          isSucssess = false;
        }
      }).catchError((e) {
        isSucssess = false;
      });

      // print(response.body);
    }
    emit(state.copyWith(
        editionStatus: isSucssess ? EventStatus.success : EventStatus.failure,
        isEvent: event.isEvent));
  }

  FutureOr<void> _onEditEventsAndRemindersWithRecurrenceData(
      EditEventsAndRemindersWithRecurrenceData event,
      Emitter<ManageRemindersState> emit) async {
    emit(state.copyWith(editionStatus: EventStatus.loading));
    bool isSucssess = false;
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {}
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/client-reminders/update-recurrence';

      final Map<String, dynamic> requestData = {
        "title": event.title,
        "startTime":
            convertTimestampToISO8601ForStartTime(event.startDate.toString()),
        "endTime":
            convertTimestampToISO8601ForStartTime(event.endDate.toString()),
        "note": event.notes != '' ? event.notes : 'empty_note_404',
        "creator_type": "CLIENT",
        "all_day": event.isAllDay,
        "item_type": event.isEvent ? "EVENT" : "REMINDER",
        "timezone": _timezone,
        "utcOffset": DateTime.now().timeZoneOffset.inMinutes,
        "recurrenceRule": event.recurrenceModel == null
            ? null
            : (event.recurrenceModel.isAfter
                ? {
                    "interval":
                        (event.recurrenceModel as RecurrenceRule).interval,
                    "freq": (event.recurrenceModel as RecurrenceRule).freq,
                    "count": (event.recurrenceModel as RecurrenceRule).count,
                    "byweekday":
                        (event.recurrenceModel as RecurrenceRule).byday,
                  }
                : {
                    "interval":
                        (event.recurrenceModel as RecurrenceRule).interval,
                    "freq": (event.recurrenceModel as RecurrenceRule).freq,
                    "until": convertTimestampToISO8601(
                        (event.recurrenceModel as RecurrenceRule)
                            .until
                            .toString()),
                    "byweekday":
                        (event.recurrenceModel as RecurrenceRule).byday,
                  }),
        "recurrence_id": event.recurrenceId
      };

      DebugLogger.info(requestData);

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        'Content-Type': 'application/json',
      };

      var response = await http
          .put(
        Uri.parse(memberProfile),
        headers: headers,
        body: jsonEncode(requestData),
      )
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSucssess = true;
        } else {
          isSucssess = false;
        }
      }).catchError((e) {
        isSucssess = false;
      });

      // print(response.body);
    }
    emit(state.copyWith(
        editionStatus: isSucssess ? EventStatus.success : EventStatus.failure,
        isEvent: event.isEvent));
  }

  FutureOr<void> _onSendEventsAndRemindersData(SendEventsAndRemindersData event,
      Emitter<ManageRemindersState> emit) async {
    emit(state.copyWith(additionStatus: EventStatus.loading));
    bool isSucssess = false;
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {}
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/client-reminders/create';

      final Map<String, dynamic> requestData = {
        "title": event.title,
        "startTime":
            convertTimestampToISO8601ForStartTime(event.startDate.toString()),
        "endTime":
            convertTimestampToISO8601ForStartTime(event.endDate.toString()),
        "note": event.notes != '' ? event.notes : 'empty_note_404',
        "creator_type": "CLIENT",
        "all_day": event.isAllDay,
        "item_type": event.isEvent ? "EVENT" : "REMINDER",
        "timezone": _timezone,
        "utcOffset": DateTime.now().timeZoneOffset.inMinutes,
        "recurrenceRule": event.recurrenceModel == null
            ? null
            : (event.recurrenceModel.isAfter
                ? {
                    "interval":
                        (event.recurrenceModel as RecurrenceRule).interval,
                    "freq": (event.recurrenceModel as RecurrenceRule).freq,
                    "count": (event.recurrenceModel as RecurrenceRule).count,
                    "byweekday":
                        (event.recurrenceModel as RecurrenceRule).byday,
                  }
                : {
                    "dtstart":
                        convertTimestampToISO8601(event.startDate.toString()),
                    "interval":
                        (event.recurrenceModel as RecurrenceRule).interval,
                    "freq": (event.recurrenceModel as RecurrenceRule).freq,
                    "until": convertTimestampToISO8601(
                        (event.recurrenceModel as RecurrenceRule)
                            .until
                            .toString()),
                    "byweekday":
                        (event.recurrenceModel as RecurrenceRule).byday,
                  })
      };

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        'Content-Type': 'application/json',
      };

      var response = await http
          .post(
        Uri.parse(memberProfile),
        headers: headers,
        body: jsonEncode(requestData),
      )
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSucssess = true;
        } else {
          isSucssess = false;
        }
      }).catchError((e) {
        isSucssess = false;
      });

      // print(response.body);
    }
    emit(state.copyWith(
        additionStatus: isSucssess ? EventStatus.success : EventStatus.failure,
        isEvent: event.isEvent));
  }

  FutureOr<void> _onDeleteEventsAndRemindersData(
      DeleteEventsAndRemindersData event,
      Emitter<ManageRemindersState> emit) async {
    emit(state.copyWith(deletionStatus: EventStatus.loading));
    bool isSucssess = false;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/client-reminders/delete';

      final Map<String, dynamic> requestData = {
        "delete_type": "via_id",
        "reminder_ids": [event.reminder_id]
      };

      DebugLogger.info(requestData);

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        'Content-Type': 'application/json',
      };

      var response = await http
          .delete(
        Uri.parse(memberProfile),
        headers: headers,
        body: jsonEncode(requestData),
      )
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSucssess = true;
        } else {
          isSucssess = false;
        }
      }).catchError((e) {
        isSucssess = false;
      });

      // print(response.body);
    }
    emit(state.copyWith(
        deletionStatus: isSucssess ? EventStatus.success : EventStatus.failure,
        isEvent: event.isEvent));
  }

  FutureOr<void> _onDeleteEventsAndRemindersForByRecurrenceRule(
      DeleteEventsAndRemindersForByRecurrenceRule event,
      Emitter<ManageRemindersState> emit) async {
    emit(state.copyWith(deletionStatus: EventStatus.loading));
    bool isSucssess = false;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/client-reminders/delete';

      final Map<String, dynamic> requestData = {
        "delete_type": "via_recurrence",
        "recurrence_id": event.recurrence_id
      };

      // DebugLogger.info(requestData);

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        'Content-Type': 'application/json',
      };

      var response = await http
          .delete(
        Uri.parse(memberProfile),
        headers: headers,
        body: jsonEncode(requestData),
      )
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSucssess = true;
        } else {
          isSucssess = false;
        }
      }).catchError((e) {
        isSucssess = false;
      });

      // print(response.body);
    }
    emit(state.copyWith(
        deletionStatus: isSucssess ? EventStatus.success : EventStatus.failure,
        isEvent: event.isEvent));
  }
}
