import 'dart:async';
import 'dart:convert';

import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/feature/notification/helper/activity_reminder_notification_helper.dart';
import 'package:famici/feature/notification/helper/appointment_notification_helper.dart';
import 'package:famici/feature/notification/helper/dashboard_builder_notification_helper.dart';
import 'package:famici/feature/notification/helper/medication_notify_helper.dart';
import 'package:famici/feature/notification/helper/memories_notification_helper.dart';
import 'package:famici/feature/notification/helper/remote_message_archive.dart';
import 'package:famici/feature/notification/repositories/notification_repository.dart';
import 'package:famici/utils/barrel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../../core/enitity/user.dart';
import '../../../../core/local_database/local_db.dart';
import '../../../chat/entities/message.dart';
import '../../entities/notification.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc
    extends HydratedBloc<NotificationEvent, NotificationState> {
  NotificationBloc({required User me,required ThemeBuilderBloc themeBuilderBloc})
      : _me = me,
  _themeBuilderBloc = themeBuilderBloc,
        super(NotificationState.initial()) {
    on<IncrementGlobalBy>(_onIncrementGlobalBy);
    on<DecrementGlobalBy>(_onDecrementGlobalBy);
    on<ClearAllNotification>(_onClearAllNotification);
    on<MessageReceivedNotificationEvent>(
      _onMessageReceivedNotificationEvent,
    );
    on<MessageRemovedNotificationEvent>(
      _onMessageRemovedNotificationEvent,
    );
    on<_HandleCallReceiptNotificationEvent>(
      _onHandleCallReceiptNotificationEvent,
    );
    on<AllMessageRemovedNotificationEvent>(
      _onAllMessageRemovedNotificationEvent,
    );
    on<SyncMemoryNotificationEvent>(
      _onSyncMemoryNotificationEvent,
    );
    on<SyncMedicationNotificationEvent>(
      _onSyncMedicationNotificationEvent,
    );
    on<DismissMemoryNotificationEvent>(
      _onDismissMemoryNotificationEvent,
    );
    on<DismissAllMemoryNotificationEvent>(
      _onDismissAllMemoryNotificationEvent,
    );
    on<SyncAppointmentNotificationEvent>(
      _onSyncAppointmentNotificationEvent,
    );

    on<SyncInitialNotificationEvent>(
      _onSyncInitialNotificationEvent,
    );

    on<DismissAllEventsNotificationEvent>(
      _onDismissAllEventsNotificationEvent,
    );

    on<DismissAllMedicationNotificationEvent>(
      _onDismissAllMedicationNotificationEvent,
    );
    on<SyncScheduledAppointmentNotificationEvent>(
      _onSyncScheduledAppointmentNotificationEvent,
    );

    on<SyncScheduledMedicationNotificationEvent>(
      _onSyncScheduledMedicationNotificationEvent,
    );

    on<SyncActivityReminderNotificationEvent>(
      _onSyncActivityReminderNotificationEvent,
    );

    on<SyncDashboardBuilderNotificationEvent>(
      _onSyncDashboardBuilderNotificationEvent,
    );

    on<OnSetNotificationsEvent>(
      _onSetNotificationsEvent,
    );

    _memoryNotify = _notification.memories.listen((event) {
      add(SyncMemoryNotificationEvent(event));
    });
    _medicationNotify = _notification.medication.listen((event) {
      add(SyncMedicationNotificationEvent(event));
    });
    _eventNotify = _notification.appointments.listen((event) {
      add(SyncAppointmentNotificationEvent(event));
    });
    _reminderNotify = _notification.reminders.listen((event) {
      add(SyncActivityReminderNotificationEvent(event));
    });
    _dashboardBuilderNotify = _notification.dashboardBuilder.listen((event) {
      add(SyncDashboardBuilderNotificationEvent(event));
    });
  }

  final NotificationRepository _notification = NotificationRepository();
  final User _me;
  final Database _localDb = LocalDatabaseFactory.instance;
  final ThemeBuilderBloc _themeBuilderBloc;

  StreamSubscription? _memoryNotify;
  StreamSubscription? _medicationNotify;
  StreamSubscription? _eventNotify;
  StreamSubscription? _reminderNotify;
  StreamSubscription? _dashboardBuilderNotify;

  Future<void> _onIncrementGlobalBy(
    IncrementGlobalBy event,
    emit,
  ) async {
    int _count = 0;

    // _count += state.multipleMessageCount.length;
    for(var i in state.multipleMessageCount.values){
      _count += i;
    }

    // _count += state.medications.length;
    //
    // _count += state.appointments.length;
    //
    // _count += state.memories.length;

    emit(state.copyWith(globalCount: _count));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${_me.id}_appointments', jsonEncode(state.toJson()));
  }

  Future<void> _onDecrementGlobalBy(
    DecrementGlobalBy event,
    emit,
  ) async {
    int _count = 0;

    _count += state.multipleMessageCount.length;

    // _count += state.medications.length;
    //
    // _count += state.appointments.length;
    //
    // _count += state.memories.length;

    emit(state.copyWith(globalCount: _count));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${_me.id}_appointments', jsonEncode(state.toJson()));
  }

  Future<void> _onClearAllNotification(
    ClearAllNotification event,
    emit,
  ) async {
    emit(NotificationState.initial());
  }

  Future<void> _onMessageReceivedNotificationEvent(
    MessageReceivedNotificationEvent event,
    emit,
  ) async {
    Message _received = event.message;
    int singleMessageCount = state.multipleMessageCount[_received.sentBy] ?? 0;
    Map<String, List<Message>> _messages = Map<String, List<Message>>.from(
      state.messages,
    );
    if (_received.type == MessageType.callReceipt) {
      add(_HandleCallReceiptNotificationEvent(_received));
    } else {
      if (_messages[_received.sentBy] != null) {
        _messages[_received.sentBy]?.add(_received);
      } else {
        _messages[_received.sentBy] = [_received];
      }

      try {
        Map<String, int> count = Map.from(state.multipleMessageCount);

        // if (!count.containsKey(_received.sentBy)) {
        //   count[_received.sentBy] = 0;
        // }

        count[_received.sentBy] = (count[_received.sentBy] ?? 0) + 1;

        emit(state.copyWith(messages: _messages, multipleMessageCount: count));

        add(IncrementGlobalBy());
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  Future<void> _onSyncMedicationNotificationEvent(
    SyncMedicationNotificationEvent event,
    emit,
  ) async {
    if (event.notification.senderContactId != _me.id) {
      Map<String, Notification> _medications = Map.from(state.medications);
      _medications[event.notification.notificationId] = event.notification;
      emit(state.copyWith(medications: _medications));

      print("timetimetime");
      DebugLogger.info(event.notification.toJson());

      MedicationNotificationHelper.notify(event.notification);
      if (event.notification.type == NotificationType.medicationRemove) {
        MedicationNotificationHelper.removeScheduled(event.notification);
      } else {
        MedicationNotificationHelper.schedule(event.notification);
      }
      Future.delayed(Duration(seconds: 10), () {
        MedicationNotificationHelper.dismissById(
            event.notification.notificationId);
      });
    } else {
      if (event.notification.type == NotificationType.medicationRemove) {
        MedicationNotificationHelper.removeScheduled(event.notification);
      } else {
        MedicationNotificationHelper.schedule(event.notification);
      }
    }
    add(IncrementGlobalBy());
  }

  Future<void> _onSyncAppointmentNotificationEvent(
    SyncAppointmentNotificationEvent event,
    emit,
  ) async {
    if (event.notification.senderContactId != _me.id) {
      Map<String, Notification> _appointments = Map.from(state.appointments);

      _appointments[event.notification.notificationId] = event.notification;
      emit(state.copyWith(appointments: _appointments));

      if (!event.notification.body.isSilent) {
        AppointmentsNotificationHelper.notify(event.notification);
      }

      if (event.notification.type == NotificationType.eventRemove) {
        AppointmentsNotificationHelper.removeScheduled(event.notification);
      } else {
        AppointmentsNotificationHelper.schedule(event.notification);
      }
      Future.delayed(Duration(seconds: 10), () {
        AppointmentsNotificationHelper.dismissById(
            event.notification.notificationId);
      });
    } else {
      if (event.notification.type == NotificationType.eventRemove) {
        AppointmentsNotificationHelper.removeScheduled(event.notification);
      } else {
        AppointmentsNotificationHelper.schedule(event.notification);
      }
    }
    add(IncrementGlobalBy());
  }

  Future<void> _onSyncActivityReminderNotificationEvent(
      SyncActivityReminderNotificationEvent event, emit) async {
    if (event.notification.senderContactId != _me.id) {
      Map<String, Notification> activityReminders =
          Map.from(state.activityReminders);
      activityReminders[event.notification.notificationId] = event.notification;
      emit(state.copyWith(activityReminders: activityReminders));
      if (!event.notification.body.isSilent) {
        ActivityReminderNotificationHelper.notify(event.notification);
      }
    }
    add(IncrementGlobalBy());
  }

  Future<void> _onSyncDashboardBuilderNotificationEvent(
      SyncDashboardBuilderNotificationEvent event, emit) async {
    if (event.notification.senderContactId != _me.id) {
      Map<String, Notification> dashboardBuilderNotifications =
          Map.from(state.dashboardBuilder);
      dashboardBuilderNotifications[event.notification.notificationId] =
          event.notification;
      emit(state.copyWith(dashboardBuilder: dashboardBuilderNotifications));
      if (!event.notification.body.isSilent) {
        DashboardBuilderNotificationHelper.notify(event.notification);
        _themeBuilderBloc.add(FetchDetailsEvent(hasUpdate: true));
      }
    }
    add(IncrementGlobalBy());
  }

  Future<void> _onSyncScheduledMedicationNotificationEvent(
    SyncScheduledMedicationNotificationEvent event,
    emit,
  ) async {
    Map<String, Notification> _medications = Map.from(state.medications);

    _medications[event.notification.notificationId] = event.notification;
    emit(state.copyWith(medications: _medications));

    add(IncrementGlobalBy());
  }

  Future<void> _onSyncScheduledAppointmentNotificationEvent(
    SyncScheduledAppointmentNotificationEvent event,
    emit,
  ) async {
    Map<String, Notification> _appointments = Map.from(state.appointments);

    _appointments[event.notification.notificationId] = event.notification;

    emit(state.copyWith(appointments: _appointments));

    add(IncrementGlobalBy());
  }

  Future<void> _onSyncMemoryNotificationEvent(
    SyncMemoryNotificationEvent event,
    emit,
  ) async {
    if (event.notification.senderContactId != _me.id) {
      Map<String, Notification> _memories = Map.from(state.memories);

      _memories[event.notification.notificationId] = event.notification;
      MemoriesNotificationHelper.notify(event.notification);
      emit(state.copyWith(memories: _memories));
      add(IncrementGlobalBy());
    }
  }

  Future<void> _onHandleCallReceiptNotificationEvent(
    _HandleCallReceiptNotificationEvent event,
    emit,
  ) async {
    Message _received = event.message;
    int messageCount = state.messageCount;
    Map<String, List<Message>> _messages = Map<String, List<Message>>.from(
      state.messages,
    );

    bool shouldUpdate = _received.isMissedReceipt;
    if (_messages[_received.sentBy] != null) {
      int idx = _messages[_received.sentBy]!.indexWhere(
        (e) => e.tempId == _received.tempId,
      );
      if (idx > -1) {
        _messages[_received.sentBy]![idx] = _received;
        shouldUpdate = false;
      } else {
        _messages[_received.sentBy]?.add(_received);
      }
    } else {
      _messages[_received.sentBy] = [_received];
    }
    if (shouldUpdate && _received.sentBy != _me.id) {
      emit(state.copyWith(messages: _messages, messageCount: messageCount + 1));
      add(IncrementGlobalBy());
    }
  }

  Future<void> _onMessageRemovedNotificationEvent(
    MessageRemovedNotificationEvent event,
    emit,
  ) async {
    Message _received = event.message;
    int messageCount = 0;
    Map<String, List<Message>> _messages = Map<String, List<Message>>.from(
      state.messages,
    );

    if (_messages[_received.sentBy] != null) {
      _messages[_received.sentBy]?.removeWhere(
        (e) => e.messageId == _received.messageId,
      );
      _messages.forEach((key, value) {
        messageCount += value.length;
      });
      emit(state.copyWith(messages: _messages, messageCount: messageCount));
      add(DecrementGlobalBy());
    }
  }

  Future<void> _onAllMessageRemovedNotificationEvent(
    AllMessageRemovedNotificationEvent event,
    emit,
  ) async {
    List<Map<String, dynamic>> response = await _localDb.rawQuery(
        'select sentBy from messages where conversationId = \'${event.contactId}\' limit 1;');

    String senderId = response[0]['sentBy'];

    Map<String, int> count = state.multipleMessageCount;

    if (count.containsKey(senderId)) {
      count.remove(senderId);
    }
    //family connect method
    // String _contactId = event.contactId;
    // int messageCount = 0;
    // Map<String, List<Message>> _messages = Map<String, List<Message>>.from(
    //   state.messages,
    // );
    //
    // if (_messages[_contactId] != null) {
    //   int _count = _messages[_contactId]?.length ?? 0;
    //   _messages.remove(_contactId);
    //   _messages.forEach((key, value) {
    //     messageCount += value.length;
    //   });
    //   emit(state.copyWith(messages: _messages, messageCount: messageCount));
    //   add(DecrementGlobalBy(value: _count));
    // }
    //String _contactId = event.contactId;
    // int messageCount = 0;
    Map<String, List<Message>> _messages = Map<String, List<Message>>.from(
      state.messages,
    );
    // int _count = _messages.length;
    emit(state.copyWith(messages: _messages, multipleMessageCount: count));

    add(const DecrementGlobalBy(value: 1));
  }

  Future<void> _onDismissMemoryNotificationEvent(
    DismissMemoryNotificationEvent event,
    emit,
  ) async {
    String _notificationId = event.notificationId;

    Map<String, Notification> _memories = Map.from(
      state.memories,
    );
    if (_memories[_notificationId] != null) {
      _memories.remove(_notificationId);
      emit(state.copyWith(memories: _memories));
      add(DecrementGlobalBy());
    }
    MemoriesNotificationHelper.dismissById(_notificationId);
  }

  Future<void> _onDismissAllMemoryNotificationEvent(
    DismissAllMemoryNotificationEvent event,
    emit,
  ) async {
    Map<String, Notification> _memories = Map.from(
      state.memories,
    );
    emit(state.copyWith(memories: {}));
    add(DecrementGlobalBy(value: _memories.length));
    MemoriesNotificationHelper.dismissAll();
  }

  Future<void> _onDismissAllEventsNotificationEvent(
    DismissAllEventsNotificationEvent event,
    emit,
  ) async {
    Map<String, Notification> _appointments = Map.from(
      state.appointments,
    );
    emit(state.copyWith(appointments: {}));
    add(DecrementGlobalBy(value: _appointments.length));
  }

  Future<void> _onDismissAllMedicationNotificationEvent(
    DismissAllMedicationNotificationEvent event,
    emit,
  ) async {
    Map<String, Notification> medications = Map.from(
      state.medications,
    );
    emit(state.copyWith(medications: {}));
    add(DecrementGlobalBy(value: medications.length));
  }

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    return NotificationState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    return state.toJson();
  }

  Future<void> _onSyncInitialNotificationEvent(
    SyncInitialNotificationEvent event,
    emit,
  ) async {
    Map<String, dynamic> messagesMap = await RemoteMessageArchive().findAll();

    List<RemoteMessage> _messages =
        messagesMap.values.map((e) => RemoteMessage.fromMap(e)).toList();

    for (var element in _messages) {
      NotificationRepository().handleReceived(element);
      RemoteMessageArchive().delete(element.messageId!);
    }
  }

  @override
  Future<void> close() {
    _memoryNotify?.cancel();
    _medicationNotify?.cancel();
    _eventNotify?.cancel();
    _reminderNotify?.cancel();
    _dashboardBuilderNotify?.cancel();
    return super.close();
  }

  Future<void> _onSetNotificationsEvent(
      OnSetNotificationsEvent event, Emitter<NotificationState> emit) async {
    try {
      String data = event.notificationData;
      NotificationState notificationData = data != ""
          ? NotificationState.fromJson(jsonDecode(data))
          : const NotificationState(
              globalCount: 0,
              messages: {},
              messageCount: 0,
              memories: {},
              medications: {},
              appointments: {},
              multipleMessageCount: {},
              activityReminders: {},
              dashboardBuilder: {},
            );

      emit(state.copyWith(
        globalCount: notificationData.globalCount,
        messageCount: notificationData.messageCount,
        messages: notificationData.messages,
        medications: notificationData.medications,
        appointments: notificationData.appointments,
        multipleMessageCount: notificationData.multipleMessageCount,
        memories: notificationData.memories,
      ));
    } catch (err) {
      DebugLogger.error(err);
    }
  }
}
