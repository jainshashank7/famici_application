import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/calander/entities/recurrence_model.dart'
    as clientEventType;
import 'package:famici/feature/notification/helper/activity_reminder_notification_helper.dart';
import 'package:famici/repositories/calendar_repository.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/logger/logger.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:timezone/timezone.dart';

import '../../../../core/offline/local_database/notifiction_db.dart';
import '../../../../core/offline/local_database/users_db.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../utils/config/api_config.dart';
import '../../../notification/helper/appointment_notification_helper.dart';
import '../../entities/appointment_fetcher.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required User me,
  })  : _me = me,
        super(CalendarState.initial()) {
    on<FetchCalendarDetailsEvent>(_onFetchCalendarDetailsEvent);

    on<CurrentCalendarViewChanged>(_onCurrentCalendarViewChanged);
    on<PageControllerChanged>(_onPageControllerChanged);
    on<CurrentDateChanged>(_onCurrentDateChanged);
    on<ResetCalendarEvent>(_onResetCalendarEvent);
    on<RefreshCalendarDetailsEvent>(_onRefreshCalendarDetailsEvent);
    on<FetchThisWeekAppointmentsCalendarEvent>(
      _onFetchThisWeekAppointmentsCalendarEvent,
    );
    on<saveICal>(_saveIcal);
    on<updateICal>(_updateICal);
    on<deleteICal>(_deleteICal);
    on<FetchMonthAppointments>(
      _onMonthAppointments,
    );
    on<RefreshICals>(_onRefreshingICals);

    on<SelectedAppointmentDetails>(
      _onSelectedAppointmentDetails,
    );
    on<LoadAllICals>(_onFetchAllICal);

    _calenderNotify = FirebaseMessaging.onMessage.listen((event) {
      Logger.info("Events DATA :: ${event.data}");
      if (isAppointments(event.data['type'])) {
        add(FetchThisWeekAppointmentsCalendarEvent(showLoader: false));
        add(FetchMonthAppointments());
        add(RefreshCalendarDetailsEvent());
      } else if (isActivityReminder(event.data['type'])) {
        add(FetchThisWeekAppointmentsCalendarEvent(showLoader: false));
        add(FetchMonthAppointments());
        add(RefreshCalendarDetailsEvent());
      }
    });
    //  var  _manageReminder = ManageRemindersBloc(me: me).stream.listen((event) {
    //     if(state.isMonthly == true){
    //     }
    //   });
  }

  final CalendarRepository _calendarRepository = CalendarRepository();
  final User _me;
  final AppointmentFetcher _appointmentFetcher = AppointmentFetcher();
  final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
  final DatabaseHelperForNotifications dbNotifications =
      DatabaseHelperForNotifications();

  StreamSubscription? _calenderNotify;
  final AuthRepository _authRepository = AuthRepository();
  DateTime _current = DateTime.now();

  Future<void> _saveIcal(
    saveICal event,
    Emitter<CalendarState> emit,
  ) async {
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }
    // ICalURL test = ICalURL(
    //     name: 'Google Calendar',
    //     color: Color.fromARGB(255, 155, 34, 115),
    //     id: 'id 1',
    //     url:
    //         "https://calendar.google.com/calendar/ical/ishanirwani%40gmail.com/public/basic.ics");
    // emit(state.copyWith(loading: true));
    if (await _isConnectedToInternet()) {
      var results = await _calendarRepository.saveICal(
          familyId: _me.familyId!,
          contactId: _me.customAttribute2.companyId,
          // ical: event.ical
          ical: event.ical);
      if (results == true) {
        add(RefreshICals());
        emit(state.copyWith(additionStatus: EventStatus.success));
      } else {
        emit(state.copyWith(additionStatus: EventStatus.failure));
      }
    }
  }

  bool isDateWithoutTime(DateTime dateTime) {
    var m = dateTime.hour == 0 &&
        dateTime.minute == 0 &&
        dateTime.second == 0 &&
        dateTime.millisecond == 0 &&
        dateTime.microsecond == 0;
    return m;
  }

  Future<void> _onFetchAllICal(
    LoadAllICals event,
    Emitter<CalendarState> emit,
  ) async {
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }
    EventController _eventController = state.eventController;
    List<CalendarEventData> listOfEventsFinal = [];
    List<ICalURL> links = [];

    if (await _isConnectedToInternet()) {
      links = await _calendarRepository.fetchICalList(
        familyId: _me.familyId!,
        contactId: _me.customAttribute2.companyId,
      );
      emit(state.copyWith(icalLinks: links));
      for (int j = 0; j < links.length; j++) {
        try {
          var icalRes = await http.get(Uri.parse(links[j].url));
          final icsObj = ICalendar.fromString(icalRes.body);
          final icalJson = icsObj.toJson();
          final icalEvents = icalJson['data'];

          for (int i = 0; i < icalEvents.length; i++) {
            if (icalEvents[i]['type'] == "VEVENT") {
              final summary =
                  icalEvents[i]['summary'] ?? " Calendar Event " + i.toString();
              final id = icalEvents[i]['uid'] + 'M' ?? 'mm' + i.toString();
              final start = icalEvents[i]['dtstart']['dt'] ?? "";
              final end = icalEvents[i]['dtend']['dt'] ?? '';
              final description = icalEvents[i]['description'] ?? "";
              var timeZone = icalEvents[i]['dtstart']['tzid'] ?? "";

              var m;
              if (timeZone != "") {
                final parsedStartDate = isDateWithoutTime(DateTime.parse(start))
                    ? DateTime.parse(start)
                        .copyWith(hour: 8, minute: 0, second: 0)
                    : DateTime.parse(start);
                final parsedEndDate = isDateWithoutTime(DateTime.parse(end))
                    ? DateTime.parse(end)
                        .copyWith(hour: 8, minute: 0, second: 0)
                    : DateTime.parse(end);

                var parsedStartDateTime;
                var parsedEndDateTime;
                try {
                  if (timeZone == 'India Standard Time') {
                    timeZone = "Asia/Kolkata";
                  } else if (timeZone == "Pacific Standard Time") {
                    timeZone = "America/Los_Angeles";
                  } else if (timeZone == "Mountain Standard Time") {
                    timeZone = "Canada/Mountain";
                  } else if (timeZone == 'Central Standard Time') {
                    timeZone = "Canada/Central";
                  } else if (timeZone == 'Eastern Standard Time') {
                    timeZone = "America/Cayman";
                  } else if (timeZone == 'Atlantic Standard Time') {
                    timeZone = "America/Anguilla";
                  } else if (timeZone == "UTC-11" ||
                      timeZone == "West Samoa Time" ||
                      timeZone == "Niue Time" ||
                      timeZone == "Samoa Standard Time") {
                    timeZone = "Pacific/Apia";
                  }
                  final timeZonet = getLocation(timeZone);
                  if (timeZonet != null) {
                    parsedStartDateTime =
                        TZDateTime.from(parsedStartDate, timeZonet);

                    // Convert to the local time zone
                    parsedEndDateTime =
                        TZDateTime.from(parsedEndDate, timeZonet);
                  } else {
                    // Convert to the local time zone
                    parsedStartDateTime = parsedStartDate;

                    // Convert to the local time zone
                    parsedEndDateTime = parsedEndDate;
                  }
                } catch (e) {
                  // Convert to the local time zone
                  parsedStartDateTime = parsedStartDate;

                  // Convert to the local time zone
                  parsedEndDateTime = parsedEndDate;
                }

                m = CalendarEventData(
                    id: summary + i.toString(),
                    title: summary,
                    idTitle: links[j].name,
                    date: parsedStartDateTime,
                    startTime: parsedStartDateTime,
                    endDate:
                        end == "" ? parsedStartDateTime : parsedEndDateTime,
                    endTime:
                        end == "" ? parsedStartDateTime : parsedEndDateTime,
                    description: description,
                    color: links[j].color,
                    event: 'icalEvent');
              } else {
                m = CalendarEventData(
                    id: summary + i.toString(),
                    title: summary,
                    idTitle: links[j].name,
                    date: isDateWithoutTime(DateTime.parse(start).toLocal())
                        ? DateTime.parse(start)
                            .toLocal()
                            .copyWith(hour: 8, minute: 0, second: 0)
                        : DateTime.parse(start).toLocal(),
                    startTime:
                        isDateWithoutTime(DateTime.parse(start).toLocal())
                            ? DateTime.parse(start)
                                .toLocal()
                                .copyWith(hour: 8, minute: 0, second: 0)
                            : DateTime.parse(start).toLocal(),
                    endDate: end == ""
                        ? isDateWithoutTime(DateTime.parse(start).toLocal())
                            ? DateTime.parse(start)
                                .toLocal()
                                .copyWith(hour: 8, minute: 0, second: 0)
                            : DateTime.parse(start).toLocal()
                        : isDateWithoutTime(DateTime.parse(end).toLocal())
                            ? DateTime.parse(end)
                                .toLocal()
                                .copyWith(hour: 8, minute: 0, second: 0)
                            : DateTime.parse(end).toLocal(),
                    endTime: end == ""
                        ? isDateWithoutTime(DateTime.parse(start).toLocal())
                            ? DateTime.parse(start)
                                .toLocal()
                                .copyWith(hour: 8, minute: 0, second: 0)
                            : DateTime.parse(start).toLocal()
                        : isDateWithoutTime(DateTime.parse(end).toLocal())
                            ? DateTime.parse(end)
                                .toLocal()
                                .copyWith(hour: 8, minute: 0, second: 0)
                            : DateTime.parse(end).toLocal(),
                    description: description,
                    color: links[j].color,
                    event: 'icalEvent');
              }
              listOfEventsFinal.add(m);
              _eventController.add(m);

              if (DateTime.parse(start).isAfter(DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day - 1)) &&
                  DateTime.parse(start).isBefore(DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day + 10))) {
                AppointmentsNotificationHelper.createEventNotification(
                    Reminders(
                        reminderId:
                            int.parse('11' + i.toString() + j.toString()),
                        title: m.title,
                        startTime: m.startTime!,
                        endTime: m.endTime!,
                        allDay: false,
                        note: m.description,
                        recurrenceRule: "",
                        recurrenceId: "",
                        creatorType: "client",
                        itemType: ClientReminderType.ICAL));
              }
            }
          }
        } catch (e) {
          continue;
        }
      }
    }

    emit(state.copyWith(
      icalEvents: listOfEventsFinal,
      eventController: _eventController,
    ));
  }

  Future<void> _updateICal(
      updateICal event, Emitter<CalendarState> emit) async {
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }
    // ICalURL test = ICalURL(
    //     name: 'Google Calendar',
    //     color: Color.fromARGB(255, 155, 34, 115),
    //     id: 'id 1',
    //     url:
    //         "https://calendar.google.com/calendar/ical/ishanirwani%40gmail.com/public/basic.ics");
    // emit(state.copyWith(loading: true));
    if (await _isConnectedToInternet()) {
      var results = await _calendarRepository.updateICal(
          familyId: _me.familyId!,
          contactId: _me.customAttribute2.companyId,
          // ical: event.ical
          ical: event.ical);
      if (results == true) {
        add(RefreshICals());
        emit(state.copyWith(editionStatus: EventStatus.success));
      } else {
        emit(state.copyWith(editionStatus: EventStatus.failure));
      }
    }
  }

  Future<void> _deleteICal(
      deleteICal event, Emitter<CalendarState> emit) async {
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }
    // ICalURL test = ICalURL(
    //     name: 'Google Calendar',
    //     color: Color.fromARGB(255, 155, 34, 115),
    //     id: 'id 1',
    //     url:
    //         "https://calendar.google.com/calendar/ical/ishanirwani%40gmail.com/public/basic.ics");
    // emit(state.copyWith(loading: true));
    if (await _isConnectedToInternet()) {
      var results = await _calendarRepository.deleteICal(
          familyId: _me.familyId!,
          contactId: _me.customAttribute2.companyId,
          // ical: event.ical
          icalID: event.icalID);
      if (results == true) {
        add(RefreshICals());
        emit(state.copyWith(deletionStatus: EventStatus.success));
      } else {
        emit(state.copyWith(deletionStatus: EventStatus.failure));
      }
    }
  }

  Future<void> _onRefreshingICals(
    RefreshICals event,
    Emitter<CalendarState> emit,
  ) async {
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey(AppointmentChannel.reminder);
    emit(state.copyWith(icalEvents: [], loading: true));
    add(FetchCalendarDetailsEvent(state.startDate, state.endDate));
    // add(LoadAllICals());
  }

  Future<void> _onFetchCalendarDetailsEvent(
    FetchCalendarDetailsEvent event,
    Emitter<CalendarState> emit,
  ) async {
    DebugLogger.debug(
        "_onFetchCalendarDetailsEvent::inner  ${event.startDate}  ${event.endDate}");

    //https://raw.githubusercontent.com/OpenAOSP/calendar/ics-import/tests/res/ics/vtodo.ics
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }

    emit(state.copyWith(loading: true));

    List<Appointment> results = [];
    List<Reminders> reminders = [];
    List<ActivityReminder> activityReminderList = [];
    if (await _isConnectedToInternet()) {
      results = await _calendarRepository.fetchAppointments(
        familyId: _me.familyId,
        clientId: _me.customAttribute2.userId,
        companyId: _me.customAttribute2.companyId,
        userId: _me.id,
        startDate: DateFormat("yyyy-MM-dd").format(event.startDate),
        endDate: DateFormat("yyyy-MM-dd").format(event.endDate),
      );

      AwesomeNotifications _notification = AwesomeNotifications();

      for (Appointment appointment in results) {
        Reminders _newReminder = Reminders(
            reminderId: int.parse(appointment.appointmentId),
            title: appointment.appointmentName,
            startTime: appointment.appointmentDate.copyWith(
                hour: appointment.startTime.hour,
                minute: appointment.startTime.minute),
            endTime: appointment.appointmentDate.copyWith(
                hour: appointment.endTime.hour,
                minute: appointment.endTime.minute),
            allDay: false,
            recurrenceId: appointment.recurrenceId,
            creatorType: "",
            itemType: ClientReminderType.EVENT,
            note: appointment.notes,
            recurrenceRule: "");
        await AppointmentsNotificationHelper.createEventNotification(
            _newReminder);
        // DebugLogger.debug("get Appointment date info ${appointment.startTime}");
        // _notification.createNotification(
        //     content: NotificationContent(
        //       id: DateTime.now().second,
        //       channelKey: AppointmentChannel.reminder,
        //       groupKey: appointment.appointmentId,
        //       title: appointment.appointmentName,
        //       body: appointment.notes,
        //       category: NotificationCategory.Alarm,
        //       wakeUpScreen: true,
        //       autoDismissible: false,
        //       criticalAlert: true,
        //       locked: true,
        //       backgroundColor: ColorPallet.kCardBackground,
        //       payload: {"data": jsonEncode(appointment.toCreateInput())},
        //       summary: "reminder/event_local",
        //     ),
        //     schedule: NotificationCalendar(
        //       hour: appointment.startTime.hour,
        //       minute: appointment.startTime.minute,
        //       day: appointment.appointmentDate.day,
        //       month: appointment.appointmentDate.month,
        //       year: appointment.appointmentDate.year,
        //       timeZone:  await FlutterNativeTimezone.getLocalTimezone(),
        //       repeats: false,
        //     )
        // );
        // await dbNotifications.updateOrInsertEvents(
        //     appointment.appointmentId.toString(),
        //     jsonEncode(appointment.appointmentDate),
        //     Reminders(reminderId: int.parse(appointment.appointmentId), title: title, startTime: startTime, endTime: endTime, allDay: allDay, recurrenceId: recurrenceId, creatorType: creatorType, itemType: itemType));
      }

      // await dbNotifications.updateOrInsertEvents(
      //     reminder.reminderId.toString(),
      //     jsonEncode(reminderData),
      //     reminder);

      // _appointmentFetcher.addAppointments(results);
      String? accessToken = await _authRepository.generateAccessToken();
      String clientId = _me.customAttribute2.userId;
      String startDate = convertTimestampToISO8601(event.startDate.toString());
      String endDate = convertTimestampToISO8601(event.endDate.toString());

      DebugLogger.debug("integrations/client-reminders  $startDate   $endDate");

      if (accessToken != null) {
        String createReminder =
            '${ApiConfig.baseUrl}/integrations/client-reminders/get-reminders-for-client?s=$startDate&e=$endDate';

        String getActivityReminder =
            '${ApiConfig.baseUrl}/integrations/activity-reminders';

        var headers = {
          "x-api-key": ApiKey.webManagementConsoleApi,
          "Authorization": accessToken,
          "x-client-id": clientId,
          "x-company-id": _me.customAttribute2.companyId,
        };

        var reminderResponse =
            await http.get(Uri.parse(createReminder), headers: headers);

        var activityReminderResponse =
            await http.get(Uri.parse(getActivityReminder), headers: headers);

        if (reminderResponse.statusCode == 200) {
          final responseData = jsonDecode(reminderResponse.body);
          final reminderList = responseData['reminders'];

          for (var reminderData in reminderList) {
            DebugLogger.debug("");
            final reminder = Reminders.fromJson(reminderData);
            // DebugLogger.info("reminder info ${reminderData}");
            reminders.add(reminder);
            if ((reminder.startTime.toLocal()).isAfter(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day - 1)) &&
                (reminder.startTime.toLocal()).isBefore(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day + 10))) {
              await AppointmentsNotificationHelper.createEventNotification(
                  Reminders(reminderId: reminder.reminderId, title: reminder.title, startTime: reminder.startTime, endTime: reminder.endTime, allDay: reminder.allDay, recurrenceId: reminder.recurrenceId, recurrenceRule: reminder.recurrenceRule, creatorType: reminder.creatorType, itemType: reminder.itemType));
            }else{
              DebugLogger.error("not fit for app notfication "+ reminder.title + " " +(reminder.startTime.toLocal()).toString() + " the end time is " + (reminder.endTime.toLocal()).toString());
            }
          }

          final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
          dbFactory.insertOrUpdateReminder(
              clientId ?? "DummyId", reminderResponse.body);

          emit(state.copyWith(rem: reminders));
        } else {
          DebugLogger.error("Reminder request failed");
        }
        if (activityReminderResponse.statusCode == 200) {
          final responseData = jsonDecode(activityReminderResponse.body);
          final activityReminders = responseData['reminders'];
          for (var reminderData in activityReminders) {
            final activityReminder = ActivityReminder.fromJson(reminderData);
            activityReminderList.add(activityReminder);
            await dbNotifications.updateOrInsertActivityReminder(
                activityReminder.id.toString(),
                jsonEncode(reminderData),
                activityReminder);
          }
          emit(state.copyWith(activityReminder: activityReminderList));
        } else {
          DebugLogger.error("Activity Reminder request failed");
        }
      }
    } else {
      List<Map<String, dynamic>> data = await dbFactory
          .getAppointmentByUserId(_me.customAttribute2.userId ?? "InvalidUser");
      List<Map<String, dynamic>> reminderData = await dbFactory
          .getReminderByUserId(_me.customAttribute2.userId ?? "InvalidUser");

      String response = data[0]['appointment'];
      final reminderResponse = reminderData[0]['reminder'];

      if (response != null) {
        final jsonString = json.decode(response)["getCalendarDetails"];
        results = Appointment.fromJsonList(jsonString);
      }
      if (reminderResponse != null) {
        var resData = jsonDecode(reminderResponse);
        final reminderList = resData['reminders'];
        for (var reminderData in reminderList) {
          final reminder = Reminders.fromJson(reminderData);
          reminders.add(reminder);
        }

        emit(state.copyWith(rem: reminders));
      }
    }

    results.sort((a, b) {
      return a.appointmentDate
          .add(Duration(hours: a.startTime.hour, minutes: a.startTime.minute))
          .compareTo(b.appointmentDate.add(
              Duration(hours: b.startTime.hour, minutes: b.startTime.minute)));
    });

    EventController _eventController = EventController();
    List<CalendarEventData> _events = _eventController.events;

    // for (CalendarEventData item in _events) {
    //   _eventController.remove(item);
    // }

    _eventController.addAll(results
        .map((e) => CalendarEventData(
            id: e.appointmentId,
            title: e.appointmentName,
            date: e.appointmentDate,
            startTime: e.startTime,
            endDate: e.appointmentDate,
            endTime: e.endTime,
            description: e.notes,
            color: e.color,
            event: 'providerEvent'))
        .toList());
    _eventController.addAll(reminders
        .map((e) => CalendarEventData(
            id: e.reminderId.toString(),
            title: e.title,
            date: e.startTime,
            startTime: e.startTime,
            endDate: e.endTime,
            endTime: e.endTime,
            description: e.note ?? '',
            color: e.itemType.name.toString() ==
                    clientEventType.ClientReminderType.EVENT.name.toString()
                ? ColorPallet.kPrimary
                : ColorPallet.kTertiary,
            titleStyle: TextStyle(
              color: e.itemType.name.toString() ==
                      clientEventType.ClientReminderType.EVENT.name.toString()
                  ? ColorPallet.kPrimaryText
                  : ColorPallet.kTertiaryText,
            ),
            event: 'tabletEvent'))
        .toList());
    // add(LoadAllICals());

    if (!state.icalEvents.isEmpty) {
      _eventController.addAll(state.icalEvents);
    } else {
      add(LoadAllICals());
    }

    // final flutterEvents = icalEvents.map((iCalEvent) {
    //   print(' im inside cal ' + iCalEvent);
    // m++;
    // final summary = icalEvents['summary'] ?? "";
    // final start = iCalEvent['dtstart'] ?? "";
    // final end = iCalEvent['dtend'] ?? '';
    // final description = iCalEvent['description'] ?? "";
    // _eventController.addAll(icalEvents
    //     .map((e) => CalendarEventData(
    //         id: 'mm' + m.toString(),
    //         title: iCalEvent['summary'] ?? "",
    //         date: DateFormat('yyyyMMddTHHmmss').parse(start),
    //         startTime: DateFormat('yyyyMMddTHHmmss').parse(start),
    //         endDate: DateFormat('yyyyMMddTHHmmss').parse(end),
    //         endTime: DateFormat('yyyyMMddTHHmmss').parse(end),
    //         description: description,
    //         color: Colors.pink,
    //         event: 'authEvent'))
    //     .toList());
    //   print(iCalEvent);
    // });

    _eventController.addAll(activityReminderList
        .map((e) => CalendarEventData(
            id: e.id.toString(),
            title: e.title,
            date: e.reminderDateTime,
            startTime: e.reminderDateTime,
            endTime: e.reminderDateTime,
            color: ColorPallet.kRed,
            event: 'providerReminder'))
        .toList());
    emit(state.copyWith(
        loading: false,
        appointments: results,
        startDate: event.startDate,
        endDate: event.endDate,
        eventController: _eventController,
        rem: reminders,
        activityReminder: activityReminderList));
  }

  Future<void> _onResetCalendarEvent(
    ResetCalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarState.initial());
    add(RefreshCalendarDetailsEvent());
  }

  Future<void> _onCurrentDateChanged(
    CurrentDateChanged event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(currentDate: event.date));
    add(RefreshCalendarDetailsEvent());
  }

  String convertTimestampToISO8601(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateTime.toUtc());
    return formattedDateTime;
  }

  Future<void> _onPageControllerChanged(
    PageControllerChanged event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(pageController: event.controller));
  }

  Future<void> _onFetchThisWeekAppointmentsCalendarEvent(
    FetchThisWeekAppointmentsCalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(isLoadingThisWeekAppointments: true));
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;
    String startDate;
    String endDate;
    List<Reminders> reminders = [];
    // startDate = convertTimestampToISO8601(
    //     DateFormat(apiDateFormat).format(_current).toString());
    // endDate =
    //     convertTimestampToISO8601(DateFormat(apiDateFormat).format(_current.add(
    //   Duration(days: 7),
    // )));
    startDate = convertTimestampToISO8601(
        DateFormat(apiDateFormat).format(_current).toString());
    endDate =
        convertTimestampToISO8601(DateFormat(apiDateFormat).format(_current.add(
      Duration(days: 7),
    )));
    print("hey start date " + startDate + " hey end date " + endDate);
    try {
      add(FetchMonthAppointments());
      if (event.showLoader) {
        emit(state.copyWith(isLoadingThisWeekAppointments: true));
      }
      final AuthRepository _authRepository = AuthRepository();
      DateTime _current = DateTime.now();

      List<Appointment> results = [];
      List<ActivityReminder> activityReminders = [];

      if (await _isConnectedToInternet()) {
        results = await _calendarRepository.fetchAppointments(
          familyId: _me.familyId,
          clientId: _me.customAttribute2.userId,
          companyId: _me.customAttribute2.companyId,
          startDate: DateFormat(apiDateFormat).format(_current),
          endDate: DateFormat(apiDateFormat).format(_current.add(
            Duration(days: 7),
          )),
        );
        if (accessToken != null) {
          String createReminder =
              '${ApiConfig.baseUrl}/integrations/client-reminders/get-reminders-for-client?s=$startDate&e=$endDate';
          String getActivityReminder =
              '${ApiConfig.baseUrl}/integrations/activity-reminders';
          var headers = {
            "x-api-key": ApiKey.webManagementConsoleApi,
            "Authorization": accessToken,
            "x-client-id": clientId,
            "x-company-id": companyId,
          };

          var reminderResponse =
              await http.get(Uri.parse(createReminder), headers: headers);

          var activityReminderResponse =
              await http.get(Uri.parse(getActivityReminder), headers: headers);

          if (reminderResponse.statusCode == 200) {
            final responseData = jsonDecode(reminderResponse.body);
            final reminderList = responseData['reminders'];

            for (var reminderData in reminderList) {
              final reminder = Reminders.fromJson(reminderData);
              reminders.add(reminder);
              // await dbNotifications.updateOrInsertEvents(
              //     reminder.reminderId.toString(),
              //     jsonEncode(reminderData),
              //     reminder);
              // await AppointmentsNotificationHelper.createEventNotification(
              //     reminder);
            }

            final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
            dbFactory.insertOrUpdateReminder(
                clientId ?? "DummyId", reminderResponse.body);

            emit(state.copyWith(rem: reminders));
          } else {
            DebugLogger.error("Reminder request failed");
          }
          // List<dynamic> ress = [
          //   {
          //     "id": 1,
          //     "company_id": 1,
          //     "client_id": 1,
          //     "title": "Meeting with Client",
          //     "reminder_date": "2023-09-10T00:00:00.000Z",
          //     "reminder_time": "15:30",
          //     "recurrence_id": "573e2956-de65-4441-997c-86f38bee8fc3",
          //     "active": 1,
          //     "deleted": 0,
          //     "created_at": "2023-09-08T09:45:00.000Z",
          //     "updated_at": "2023-09-08T09:45:00.000Z"
          //   },
          //   {
          //     "id": 2,
          //     "company_id": 1,
          //     "client_id": 2,
          //     "title": "Call with Team",
          //     "reminder_date": "2023-09-12T00:00:00.000Z",
          //     "reminder_time": "10:00",
          //     "recurrence_id": "673e2956-de65-4441-997c-86f38bee8fc4",
          //     "active": 1,
          //     "deleted": 0,
          //     "created_at": "2023-09-10T14:30:00.000Z",
          //     "updated_at": "2023-09-10T14:30:00.000Z"
          //   },
          //   {
          //     "id": 3,
          //     "company_id": 2,
          //     "client_id": 3,
          //     "title": "Project Review",
          //     "reminder_date": "2023-09-14T00:00:00.000Z",
          //     "reminder_time": "09:15",
          //     "recurrence_id": "773e2956-de65-4441-997c-86f38bee8fc5",
          //     "active": 1,
          //     "deleted": 0,
          //     "created_at": "2023-09-12T11:20:00.000Z",
          //     "updated_at": "2023-09-12T11:20:00.000Z"
          //   },
          //   {
          //     "id": 4,
          //     "company_id": 2,
          //     "client_id": 1,
          //     "title": "Presentation Prep",
          //     "reminder_date": "2023-09-16T00:00:00.000Z",
          //     "reminder_time": "14:45",
          //     "recurrence_id": "873e2956-de65-4441-997c-86f38bee8fc6",
          //     "active": 1,
          //     "deleted": 0,
          //     "created_at": "2023-09-14T16:55:00.000Z",
          //     "updated_at": "2023-09-14T16:55:00.000Z"
          //   },
          //   {
          //     "id": 5,
          //     "company_id": 3,
          //     "client_id": 2,
          //     "title": "Team Building Event",
          //     "reminder_date": "2023-09-20T00:00:00.000Z",
          //     "reminder_time": "17:00",
          //     "recurrence_id": "973e2956-de65-4441-997c-86f38bee8fc7",
          //     "active": 1,
          //     "deleted": 0,
          //     "created_at": "2023-09-18T10:10:00.000Z",
          //     "updated_at": "2023-09-18T10:10:00.000Z"
          //   }
          // ];
          //
          // print("Testtt :: ${ress}");
          // print("Activity Reminder List ::: ${activityReminders}");
          // if (ress.isNotEmpty) {
          //   // final responseData = jsonDecode(activityReminderResponse.body);
          //   // final activityReminderList = responseData['reminders'];
          //   for (var reminderData in ress) {
          //     final activityReminder = ActivityReminder.fromJson(reminderData);
          //     activityReminders.add(activityReminder);
          //     await dbNotifications.updateOrInsertActivityReminder(
          //         activityReminder.id.toString(),
          //         jsonEncode(reminderData),
          //         activityReminder);
          //   }
          //   // emit(state.copyWith(activityReminder: activityReminderList));
          // } else {
          //   DebugLogger.error("Activity Reminder request failed");
          // }
          if (activityReminderResponse.statusCode == 200) {
            final responseData = jsonDecode(activityReminderResponse.body);
            final activityReminderList = responseData['reminders'];
            DebugLogger.debug(
                "activityReminderList::responseData  ${responseData['reminders']}");
            for (var reminderData in activityReminderList) {
              final activityReminder = ActivityReminder.fromJson(reminderData);
              activityReminders.add(activityReminder);
              await dbNotifications.updateOrInsertActivityReminder(
                  activityReminder.id.toString(),
                  jsonEncode(reminderData),
                  activityReminder);
            }
            emit(state.copyWith(activityReminder: activityReminders));
          } else {
            DebugLogger.error("Activity Reminder request failed");
          }
        }
      } else {
        List<Map<String, dynamic>> data =
            await dbFactory.getAppointmentByUserId(_me.customAttribute2.userId);
        await dbFactory.getAppointmentByUserId(
            _me.customAttribute2.userId ?? "InvalidUser");
        List<Map<String, dynamic>> reminderData = await dbFactory
            .getReminderByUserId(_me.customAttribute2.userId ?? "InvalidUser");

        String response = data[0]['appointment'];
        final reminderResponse = reminderData[0]['reminder'];

        if (response != null) {
          final jsonString = json.decode(response)["getCalendarDetails"];
          results = Appointment.fromJsonList(jsonString);
        }
        if (reminderResponse != null) {
          var resData = jsonDecode(reminderResponse);
          final reminderList = resData['reminders'];
          for (var reminderData in reminderList) {
            final reminder = Reminders.fromJson(reminderData);
            reminders.add(reminder);
          }
          emit(state.copyWith(rem: reminders));
        }
      }
      results = results.where((app) {
        final appDateTime = DateTime(
            app.appointmentDate.year,
            app.appointmentDate.month,
            app.appointmentDate.day,
            app.endTime.hour,
            app.endTime.minute);

        return appDateTime.isAfter(DateTime.now());
      }).toList();
      reminders = reminders.where((app) {
        final appDateTime = app.endTime;

        return appDateTime.isAfter(DateTime.now());
      }).toList();
      activityReminders = activityReminders.where((app) {
        final appDateTime = app.reminderDateTime;

        return appDateTime.isAfter(DateTime.now()) &&
            appDateTime.isBefore(DateTime.now().add(Duration(days: 7)));
      }).toList();
      results.sort((a, b) {
        return a.appointmentDate
            .add(Duration(hours: a.startTime.hour, minutes: a.startTime.minute))
            .compareTo(b.appointmentDate.add(Duration(
                hours: b.startTime.hour, minutes: b.startTime.minute)));
      });
      emit(state.copyWith(
        remindersThisWeek: reminders,
        activityReminderThisWeek: activityReminders,
        isLoadingThisWeekAppointments: event.showLoader ? false : true,
      ));
      emit(state.copyWith(
        appointmentsThisWeek: results,
        isLoadingThisWeekAppointments: false,
      ));
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<void> _onMonthAppointments(
    FetchMonthAppointments event,
    Emitter<CalendarState> emit,
  ) async {
    bool hasIds = _me.customAttribute2.companyId.isNotEmpty;
    hasIds = hasIds && _me.customAttribute2.userId.isNotEmpty;
    hasIds = hasIds && _me.familyId != null;
    if (!hasIds) {
      return;
    }

    try {
      DateTime _current = DateTime.now();

      List<Appointment> results = [];

      if (await _isConnectedToInternet()) {
        results = await _calendarRepository.fetchAppointments(
          familyId: _me.familyId,
          clientId: _me.customAttribute2.userId,
          companyId: _me.customAttribute2.companyId,
          startDate: DateFormat(apiDateFormat).format(_current.subtract(
            Duration(days: 15),
          )),
          endDate: DateFormat(apiDateFormat).format(_current.add(
            Duration(days: 15),
          )),
        );
      } else {
        // List<Map<String, dynamic>> data =
        // await dbFactory.getAppointmentByUserId(_me.customAttribute2.userId);
        //
        // String response = data[0]['appointment'];
        //
        // if (response != null) {
        //   final jsonString = json.decode(response)["getCalendarDetails"];
        //   results = Appointment.fromJsonList(jsonString);
        // }
      }

      results.sort((a, b) {
        return a.appointmentDate
            .add(Duration(hours: a.startTime.hour, minutes: a.startTime.minute))
            .compareTo(b.appointmentDate.add(Duration(
                hours: b.startTime.hour, minutes: b.startTime.minute)));
      });

      emit(state.copyWith(appointmentsMonth: results));
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  Future<void> _onCurrentCalendarViewChanged(
    CurrentCalendarViewChanged event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(currentView: event.view));
    add(RefreshCalendarDetailsEvent());
  }

  Future<void> _onRefreshCalendarDetailsEvent(
    RefreshCalendarDetailsEvent event,
    Emitter<CalendarState> emit,
  ) async {
    DateTime _selectedDate = state.currentDate;
    DateTime _startDate = state.startDate;
    DateTime _endDate = state.endDate;
    CalendarView _view = state.currentView;

    if (_view == CalendarView.day) {
      _startDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day - 1,
      );
      _endDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day + 1,
      );
    } else if (_view == CalendarView.week) {
      _startDate = _selectedDate.subtract(Duration(
        days: _selectedDate.weekday + 1,
      ));
      _endDate = _selectedDate.add(Duration(
        days: DateTime.daysPerWeek + 1 - _selectedDate.weekday,
      ));
    } else if (_view == CalendarView.month) {
      _startDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        1,
      );
      _endDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
        1,
      );
    } else if (_view == CalendarView.year) {
      _startDate = DateTime(
        _selectedDate.year,
        1,
        1,
      );
      _endDate = DateTime(
        _selectedDate.year + 1,
        1,
        1,
      );
    }
    DebugLogger.debug("FetchCalendarDetailsEvent $_startDate    $_endDate");
    add(FetchCalendarDetailsEvent(_startDate, _endDate));
    add(FetchThisWeekAppointmentsCalendarEvent());
  }

  @override
  Future<void> close() {
    _calenderNotify?.cancel();
    return super.close();
  }

  FutureOr<void> _onSelectedAppointmentDetails(
      SelectedAppointmentDetails event, Emitter<CalendarState> emit) {
    emit(state.copyWith(selectedAppointment: event.appointment));
  }
}

class ICalURL {
  String name;
  Color color;
  String url;
  String id;

  ICalURL({
    required this.name,
    required this.color,
    required this.id,
    required this.url,
  });

  factory ICalURL.fromJson(Map<String, dynamic> json) {
    return ICalURL(
        name: json['name'],
        id: json['calendarId'],
        color: Color(int.parse(json['color'])),
        url: json['link']);
  }

  static List<ICalURL> fromJsonList(dynamic jsonList) {
    if (jsonList == null) {
      return [];
    }
    return jsonList.map<ICalURL>((data) => ICalURL.fromJson(data)).toList();
  }
}

// class FlutterEvent {
// }
// class FlutterEvent {
// final String summary;
// final DateTime start;
// final DateTime end;

// FlutterEvent({
// required this.summary,
// required this.start,
// required this.end,
//   id: e.appointmentId,
//             title: e.appointmentName,
//             date: e.appointmentDate,
//             startTime: e.startTime,
//             endDate: e.appointmentDate,
//             endTime: e.endTime,
//             description: e.notes,
//             color: e.color,
//             event: 'providerEvent'
// });
// }
