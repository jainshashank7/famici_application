import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import '../../../feature/notification/helper/appointment_notification_helper.dart';

class DatabaseHelperForNotifications {
  static late Database _database;

  static Database get instance => _database;

  static Future<Database> initDb(String? userId) async {
    Directory databasesDir = await getApplicationSupportDirectory();
    String dbPath = join(databasesDir.path, '${userId}_notifications.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    if (database.isOpen) {
      _database = database;
    }

    return database;
  }

  static _onCreate(Database db, int newVersion) async {
    await createTableMedications(db);
    await createTableEvents(db);
  }

  static createTableMedications(Database db) async {
    await db
        .execute(
          "CREATE TABLE notifications(medicationId TEXT, time TEXT)",
        )
        .then((_) => DebugLogger.info('creating table notifications'))
        .catchError(
            (e) => DebugLogger.error('error creating notifications table: $e'));
  }

  Future<void> updateOrInsertReminder(String medicationId, String time) async {
    List<Map<String, dynamic>> reminders = await _database.query(
      'notifications',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );

    if (reminders.isNotEmpty) {
      await _database.update(
        'notifications',
        {'time': time},
        where: 'medicationId = ?',
        whereArgs: [medicationId],
      );
    } else {
      await _database.insert(
        'notifications',
        {'medicationId': medicationId, 'time': time},
      );
    }
  }

  Future<List<Map<String, dynamic>>> getRemindersByMedicationId(
      String medicationId) async {
    List<Map<String, dynamic>> reminders = await _database.query(
      'notifications',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );

    return reminders;
  }

  static createTableEvents(Database db) async {
    await db
        .execute(
          "CREATE TABLE reminders(id TEXT, jsonData TEXT)",
        )
        .then((_) => DebugLogger.info('creating table reminders notifications'))
        .catchError((e) => DebugLogger.error(
            'error creating reminders notifications table: $e'));
  }

  Future<List<Map<String, dynamic>>> getEventsById(String id) async {
    List<Map<String, dynamic>> reminders = await _database.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );

    return reminders;
  }

  Future<void> updateOrInsertEvents(
      String id, String jsonData, Reminders reminder) async {
    List<Map<String, dynamic>> reminders = await _database.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (reminders.isNotEmpty) {
      // AppointmentsNotificationHelper.createEventNotification(reminder);
      // await _database.update(
      //   'reminders',
      //   {'jsonData': jsonData},
      //   where: 'id = ?',
      //   whereArgs: [id],
      // );
    } else {
      AppointmentsNotificationHelper.createEventNotification(reminder);
      print("notification created");
      await _database.insert(
        'reminders',
        {'id': id, 'jsonData': jsonData},
      );
    }
  }


  Future<void> updateOrInsertActivityReminder(
      String id, String jsonData, ActivityReminder reminder) async {
    List<Map<String, dynamic>> reminders = await _database.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );

    DebugLogger.debug("updateOrInsertActivityReminder:: id  ${reminder.id}");
    //TODO
    AppointmentsNotificationHelper.createEventNotification(Reminders(reminderId: reminder.id, title: reminder.title, startTime: reminder.reminderDateTime, endTime: reminder.reminderDateTime, allDay: false, recurrenceId: "", creatorType: "", itemType: ClientReminderType.REMINDER,note: "", recurrenceRule: ""));
    if (reminders.isNotEmpty) {
      // await _database.update(
      //   'reminders',
      //   {'jsonData': jsonData},
      //   where: 'id = ?',
      //   whereArgs: [id],
      // );
    } else {
      // AppointmentsNotificationHelper.createEventNotification(reminder);
      // print("notification created");
      // await _database.insert(
      //   'reminders',
      //   {'id': id, 'jsonData': jsonData},
      // );
    }
  }
}
