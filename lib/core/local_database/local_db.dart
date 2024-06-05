import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseFactory {
  // static bool _isCreated = false;

  static late Database _database;

  static Database get instance => _database;

  static Future<Database> createDatabase() async {
    // if (_isCreated) {
    //   return _database;
    // }
    Directory databasesDir = await getApplicationSupportDirectory();
    String dbPath = join(databasesDir.path, 'conversation_chat.db');

    var database =
        await openDatabase(dbPath, version: 1, onCreate: _populateDb);
    if (database.isOpen) {
      // _isCreated = true;
      _database = database;
    }
    return database;
  }

  static void _populateDb(Database db, int version) async {
    await _createConversationTable(db);
    await _createMessagesTable(db);
    await _createUsersTable(db);
  }

  static _createConversationTable(Database db) async {
    await db
        .execute(
          """CREATE TABLE conversations(
            conversationId TEXT PRIMARY KEY,
            familyId TEXT,
            createdAt INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )""",
        )
        .then((_) => DebugLogger.info('creating table conversations...'))
        .catchError((e) => DebugLogger.error('error creating conversations table: $e'));
  }

  static _createMessagesTable(Database db) async {
    await db
        .execute("""
          CREATE TABLE messages(
            tempId TEXT PRIMARY KEY,
            messageId TEXT ,
            conversationId TEXT,
            sentBy TEXT NOT NULL,
            receivedBy TEXT,
            data TEXT,
            text TEXT,
            type TEXT,
            createdAt INTEGER,
            sentAt INTEGER,
            familyId TEXT,
            receipt TEXT,
            readAt INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )
      """)
        .then((_) => DebugLogger.info('creating table messages'))
        .catchError((e) => DebugLogger.error('error creating messages table: $e'));
  }

  static _createUsersTable(Database db) async {
    await db
        .execute("""
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            name TEXT,
            givenName TEXT,
            familyName TEXT,
            profileUrl TEXT,
            email TEXT,
            phone TEXT,
            ccId TEXT,
            familyId TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )
      """)
        .then((_) => DebugLogger.info('creating table users'))
        .catchError((e) => DebugLogger.error('error creating users table: $e'));
  }

  static _createCallsTable(Database db) async {
    await db
        .execute("""
          CREATE TABLE calls(
            id TEXT PRIMARY KEY,
            status TEXT,
            caller TEXT,
            callerPhotoUrl TEXT,
            audioOnly TEXT,
            createdAt INTEGER,
            phone TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )
      """)
        .then((_) => DebugLogger.info('creating table users'))
        .catchError((e) => DebugLogger.error('error creating users table: $e'));
  }
}

class DBTable {
  static const users = 'users';
  static const conversations = 'conversations';
  static const messages = 'messages';
  static const calls = 'calls';
}



