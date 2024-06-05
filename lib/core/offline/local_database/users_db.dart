import 'dart:convert';
import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/conversations.dart';

class DatabaseHelperForUsers {
  static late Database _database;

  static Database get instance => _database;

  static Future<Database> initDb() async {
    Directory databasesDir = await getApplicationSupportDirectory();
    String dbPath = join(databasesDir.path, 'user_detail.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    if (database.isOpen) {
      _database = database;
    }

    return database;
  }

  static _onCreate(Database db, int newVersion) async {
    await createDatabase(db);
    await createTableUser(db);
    await createConversationsTable(db);
    await createAppointmentsTable(db);
    await createRemindersTable(db);
    await createMemberProfileTable(db);
    await createCareTeamTable(db);
  }

  static createDatabase(Database db) async {
    await db
        .execute(
          "CREATE TABLE credentials(username TEXT PRIMARY KEY, password TEXT, name TEXT, pin TEXT)",
        )
        .then((_) => DebugLogger.info('creating table users'))
        .catchError((e) => DebugLogger.error('error creating users table: $e'));
  }

  static createTableUser(Database db) async {
    await db
        .execute(
          "CREATE TABLE userdata(username TEXT, user TEXT, userId TEXT)",
        )
        .then((_) => DebugLogger.info('creating table users'))
        .catchError((e) => DebugLogger.error('error creating users table: $e'));
  }

  Future<void> insertUserDetails(
      String username, String password, String? name, String? pin) async {
    var userExits = await getCredentials(username);
    if (userExits == null) {
      await _database.insert(
        'credentials',
        {'username': username, 'password': password, 'name': name, 'pin': pin},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<void> insertPinDetails(String username, String pin) async {
    await _database.update(
      'credentials',
      {'pin': pin},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<void> insertUserDataDetails(String username, String data, String userId) async {
    var userExits = await getCredentialsUsers(username);
    if (userExits.isEmpty) {
      await _database
          .insert(
            'userdata',
            {'username': username, 'user': data, 'userId': userId},
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
          .then((_) => DebugLogger.info('user data inserted '))
          .catchError(
              (e) => DebugLogger.error('error in inserting user data: $e'));
    }
  }

  Future<void> deleteUserDataDetails(String userId) async {
    try {
      await _database.delete(
        'userdata',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      DebugLogger.info('User data with userId: $userId deleted');
    } catch (e) {
      DebugLogger.error('Error deleting user data: $e');
    }
  }

  Future<void> deleteCredsByEmail(String email) async {
    try {
      await _database.delete(
        'credentials',
        where: 'username = ?',
        whereArgs: [email],
      );
      DebugLogger.info('User data with userId: $email deleted');
    } catch (e) {
      DebugLogger.error('Error deleting user data: $e');
    }
  }

  Future<String?> getUsernameByUserId(String userId) async {
    try {
      List<Map<String, dynamic>> results = await _database.query(
        'userdata',
        columns: ['username'],
        where: 'userId = ?',
        whereArgs: [userId],
      );

      if (results.isNotEmpty) {
        return results.first['username'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      DebugLogger.error('Error reading username: $e');
      return null;
    }
  }



  Future<List<Map<String, dynamic>>?> getCredentials(String username) async {
    final List<Map<String, dynamic>> maps = await _database
        .query('credentials', where: 'username = ?', whereArgs: [username]);
    if (maps.isEmpty) {
      return null;
    } else {
      return maps;
    }
  }

  Future<List<Map<String, dynamic>>> getCredentialsUsers(
      String username) async {
    final List<Map<String, dynamic>> maps = await _database
        .query('userdata', where: 'username = ?', whereArgs: [username]);
    return maps;
  }

  Future<List<Map<String, dynamic>>> readDataFromTable() async {
    List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT * FROM credentials');
    return result;
  }

  Future<List<Map<String, dynamic>>> readDataFromUserdata() async {
    List<Map<String, dynamic>> result =
    await _database.rawQuery('SELECT userId FROM userdata');
    return result;
  }

  Future<String?> readPassFromTable(String username) async {
    List<Map> results = await _database.rawQuery(
      'SELECT password FROM credentials WHERE username = ?',
      [username],
    );
    if (results.isNotEmpty) {
      return results[0]['password'];
    } else {
      return null;
    }
  }

  Future<String?> readPinFromTable(String username) async {
    List<Map> results = await _database.rawQuery(
      'SELECT pin FROM credentials WHERE username = ?',
      [username],
    );
    if (results.isNotEmpty) {
      return results[0]['pin'];
    } else {
      return null;
    }
  }

  static createConversationsTable(Database db) async {
    await db
        .execute(
          '''
          CREATE TABLE conversation (
            userId TEXT PRIMARY KEY,
            conversationIds TEXT 
          )
          ''',
        )
        .then((_) => DebugLogger.info('creating table users'))
        .catchError((e) => DebugLogger.error('error creating users table: $e'));
  }

  Future<int> insertConversation(ConversationTable conversation) async {
    final List<String> data =
        await getConversationsByUserId(conversation.userId);
    if (data.isNotEmpty) {
      return await _database.rawUpdate(
        'UPDATE conversation SET conversationIds = ? WHERE userId = ?',
        [jsonEncode(conversation.conversationIds), conversation.userId],
      );
    } else {
      return await _database.insert(
        'conversation',
        {
          'userId': conversation.userId,
          'conversationIds': jsonEncode(conversation.conversationIds)
        },
      );
    }
  }

  Future<List<String>> getConversationsByUserId(String userId) async {
    final List<Map<String, dynamic>> maps = await _database
        .query('conversation', where: 'userId = ?', whereArgs: [userId]);
    var data = maps.isNotEmpty ? jsonDecode(maps[0]['conversationIds']) : [];

    List<String> ids = List<String>.from(data);

    return ids;
  }

  static createAppointmentsTable(Database db) async {
    await db.execute(
      '''
          CREATE TABLE appointments (
            userId TEXT PRIMARY KEY,
            appointment TEXT 
          )
          ''',
    );
  }

  Future<void> insertOrUpdateAppointment(
      String userId, String appointmentData) async {
    final List<Map<String, dynamic>> data =
        await getAppointmentByUserId(userId);
    if (data.isNotEmpty) {
      await _database.rawUpdate(
        'UPDATE appointments SET appointment = ? WHERE userId = ?',
        [appointmentData, userId],
      );
    } else {
      await _database.insert(
        'appointments',
        {'userId': userId, 'appointment': appointmentData},
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAppointmentByUserId(
      String userId) async {
    final List<Map<String, dynamic>> appointments = await _database.query(
      'appointments',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return appointments;
  }

  static createRemindersTable(Database db) async {
    await db
        .execute(
          '''
          CREATE TABLE reminders (
            userId TEXT PRIMARY KEY,
            reminder TEXT 
          )
          ''',
        )
        .then((_) => DebugLogger.info('creating table reminders'))
        .catchError(
            (e) => DebugLogger.error('error creating reminders table: $e'));
  }

  Future<void> insertOrUpdateReminder(
      String userId, String reminderData) async {
    final List<Map<String, dynamic>> data = await getReminderByUserId(userId);
    if (data.isNotEmpty) {
      await _database.rawUpdate(
        'UPDATE reminders SET reminder = ? WHERE userId = ?',
        [reminderData, userId],
      );
    } else {
      await _database.insert(
        'reminders',
        {'userId': userId, 'reminder': reminderData},
      );
    }
  }

  Future<List<Map<String, dynamic>>> getReminderByUserId(String userId) async {
    final List<Map<String, dynamic>> reminders = await _database.query(
      'reminders',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return reminders;
  }

  static createMemberProfileTable(Database db) async {
    await db
        .execute(
          '''
          CREATE TABLE member_profile (
            userId TEXT PRIMARY KEY,
            memberprofile TEXT 
          )
          ''',
        )
        .then((_) => DebugLogger.info('creating table member_profile'))
        .catchError((e) =>
            DebugLogger.error('error creating member_profile table: $e'));
  }

  Future<void> insertOrUpdateMemberProfile(
      String userId, String memberProfile) async {
    final List<Map<String, dynamic>> data =
        await getMemberProfileByUserId(userId);
    if (data.isNotEmpty) {
      await _database
          .rawUpdate(
            'UPDATE member_profile SET memberprofile = ? WHERE userId = ?',
            [memberProfile, userId],
          )
          .then((_) => DebugLogger.info('updating table member_profile'))
          .catchError((e) =>
              DebugLogger.error('error updating member_profile table: $e'));
      ;
    } else {
      await _database
          .insert(
            'member_profile',
            {'userId': userId, 'memberprofile': memberProfile},
          )
          .then(
              (_) => DebugLogger.info('inserting data in table member_profile'))
          .catchError((e) => DebugLogger.error(
              'error inserting data in member_profile table: $e'));
    }
  }

  Future<List<Map<String, dynamic>>> getMemberProfileByUserId(
      String userId) async {
    final List<Map<String, dynamic>> member_profile = await _database.query(
      'member_profile',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return member_profile;
  }

  static createCareTeamTable(Database db) async {
    await db
        .execute(
          '''
          CREATE TABLE care_team (
            userId TEXT PRIMARY KEY,
            careteam TEXT 
          )
          ''',
        )
        .then((_) => DebugLogger.info('creating table care_team'))
        .catchError(
            (e) => DebugLogger.error('error creating care_team table: $e'));
  }

  Future<void> insertOrUpdateCareTeam(String userId, String careteam) async {
    final List<Map<String, dynamic>> data = await getCareTeamByUserId(userId);
    if (data.isNotEmpty) {
      await _database
          .rawUpdate(
            'UPDATE care_team SET careteam = ? WHERE userId = ?',
            [careteam, userId],
          )
          .then((_) => DebugLogger.info('updating table care_team'))
          .catchError(
              (e) => DebugLogger.error('error updating care_team table: $e'));
    } else {
      await _database
          .insert(
            'care_team',
            {'userId': userId, 'careteam': careteam},
          )
          .then((_) => DebugLogger.info('inserting data in table care_team'))
          .catchError((e) =>
              DebugLogger.error('error inserting data in care_team table: $e'));
    }
  }

  Future<List<Map<String, dynamic>>> getCareTeamByUserId(String userId) async {
    final List<Map<String, dynamic>> care_team = await _database.query(
      'care_team',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return care_team;
  }
}
