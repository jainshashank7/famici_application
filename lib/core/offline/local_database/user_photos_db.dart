import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../repositories/auth_repository.dart';
import '../../enitity/user.dart';

class DatabaseHelperForMemories {

  static late Database _database;

  static Database get instance => _database;

  static Future<Database> initDb(String? userId) async {


    Directory databasesDir = await getApplicationSupportDirectory();
    String dbPath = join(databasesDir.path, '${userId}_memories.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    if (database.isOpen) {
      _database = database;
    }

    return database;
  }

  static _onCreate(Database db, int newVersion) async {
    await _createStoreDataTable(db);
    await _createDeleteImageTable(db);
    await _createSendImageTable(db);
  }

  Future<void> storeImagePathsDeleteData(String mediaId) async {
    await _database.delete(
      'storeData',
      where: 'mediaId = ?',
      whereArgs: [mediaId],
    );
  }

  Future<void> storeImagePathsDeleteDataByPath(String path) async {
    await _database.delete(
      'storeData',
      where: 'imagePath = ?',
      whereArgs: [path],
    );
  }

  Future<void> sendImageInsertData(String imagePath, String? userId) async {
    await _database.insert(
      'sendImage',
      {
        'imagePath': imagePath,
        'userId': userId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> sendImageDeleteData(String path) async {
    await _database.delete(
      'sendImage',
      where: 'imagePath = ?',
      whereArgs: [path],
    );
  }

  Future<void> storeImagePathsInsertData(String imagePath, String? mediaId,
      String? userId, String? familyId) async {
    await _database.insert(
      'storeData',
      {
        'imagePath': imagePath,
        'mediaId': mediaId,
        'userId': userId,
        'familyId': familyId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteImageInsertData(String mediaId, String? userId) async {
    await _database.insert(
      'deleteImage',
      {
        'mediaId': mediaId,
        'userId': userId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteImageDeleteData(String mediaId) async {
    await _database.delete(
      'deleteImage',
      where: 'mediaId = ? ',
      whereArgs: [mediaId],
    );
  }

  static _createDeleteImageTable(Database db) async {
    await db
        .execute("""
        CREATE TABLE deleteImage(
            mediaId TEXT, 
            userId TEXT
        )""")
        .then((_) => DebugLogger.info('creating table messages'))
        .catchError((e) => DebugLogger.error('error creating messages table: $e'));
  }

  static _createSendImageTable(Database db) async {
    //  sendImage table
    await db
        .execute("""
        CREATE TABLE sendImage(
          imagePath TEXT,  
          userId TEXT)
        """)
        .then((_) => DebugLogger.info('creating table messages'))
        .catchError((e) => DebugLogger.error('error creating messages table: $e'));
  }

  static _createStoreDataTable(Database db) async {
    //  storeData table
    await db
        .execute("""
        CREATE TABLE storeData(
          imagePath TEXT, 
          mediaId TEXT, 
          userId TEXT,
          familyId TEXT
          )
        """)
        .then((_) => DebugLogger.info('creating table messages'))
        .catchError((e) => DebugLogger.error('error creating messages table: $e'));
  }

  Future<List<Map<String, dynamic>>> readDataFromTableSendImage() async {
    List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT * FROM sendImage');
    return result;
  }

  Future<List<Map<String, dynamic>>> readDataFromTableDeleteImage() async {
    List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT * FROM deleteImage');
    return result;
  }

  Future<List<Map<String, dynamic>>> readDataFromTableStoreImage() async {
    List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT * FROM storeData');
    return result;
  }

  Future<List<Map<String, dynamic>>> readDataStoreImageWithMediaId(
      String path) async {
    List<Map<String, dynamic>> result = await _database
        .rawQuery('SELECT mediaId FROM storeData WHERE imagePath = \'$path\'');
    return result;
  }

  Future<bool> checkMediaIdExists(String? mediaId) async {
    var result = await _database.query("storeData", where: "mediaId = ?", whereArgs: [mediaId]);
    return result.isEmpty;
  }

}
