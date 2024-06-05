// import 'dart:io';
//
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../../../feature/health_and_wellness/my_medication/entity/medication.dart';
//
// class DatabaseHelperForMedication {
//   static late Database _database;
//
//   static Database get instance => _database;
//
//   static Future<Database> initDb(String? userId) async {
//     Directory databasesDir = await getApplicationSupportDirectory();
//     String dbPath = join(databasesDir.path, '${userId}_medication.db');
//
//     var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
//     if (database.isOpen) {
//       _database = database;
//     }
//
//     return database;
//   }
//
//   static _onCreate(Database db, int newVersion) async {
//     await createDatabase(db);
//     await _createDeleteMedicationTable(db);
//     // await _createSendMedicationDetailTable(db);
//   }
//
//   // static _createSendMedicationDetailTable(Database db) async {
//   //   await db
//   //       .execute(
//   //           """CREATE TABLE sendMedication(medicationName TEXT, medicationID TEXT)""")
//   //       .then((value) => print("creating table message"))
//   //       .catchError((e) => print("error creating table: $e"));
//   // }
//
//   Future<void> storeMedicationDetailDeleteData(String medicationId) async {
//     await _database.delete("medications",
//         where: 'medicationId = ?', whereArgs: [medicationId]);
//   }
//
//   // Future<void> sendMedicationInsertData(
//   //     String medicationName, String medicationId) async {
//   //   await _database.insert(
//   //     'medication',
//   //     {
//   //       'medicationName': medicationName,
//   //       'medicationId': medicationId,
//   //     },
//   //     conflictAlgorithm: ConflictAlgorithm.replace,
//   //   );
//   // }
//
//   Future<void> deleteMedicationInsertData(
//       String medicationId, String? userId) async {
//     await _database.insert(
//         'deleteMedication',
//         {
//           'medicationId': medicationId,
//           'userId': userId,
//         },
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   Future<void> deleteMedicationDeleteData(String medicationId) async {
//     await _database.delete('deleteMedication',
//         where: 'medicationId = ?', whereArgs: [medicationId]);
//   }
//
//   static _createDeleteMedicationTable(Database db) async {
//     await db
//         .execute(
//         """CREATE TABLE deleteMedication(medicationId TEXT PRIMARY KEY, userId Text)""")
//         .then((value) => print("Creating Table Messages"))
//         .catchError((e) => print("error creating table: $e"));
//   }
//
//   static createDatabase(Database db) async {
//     await db
//         .execute(
//       "CREATE TABLE medications(date TEXT, imgUrl TEXT, medicationId TEXT PRIMARY KEY, medicationName TEXT, nextDosage TEXT, previousDosage TEXT)",
//     )
//         .then((_) => print('creating table medication'))
//         .catchError((e) => print('error creating medication table: $e'));
//   }
//
//   Future<void> insertMedication(Medication medication) async {
//     await _database.insert(
//       'medications',
//       medication.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<List<Map<String, dynamic>>> readDataFromTableDeleteMedication() async {
//     List<Map<String, dynamic>> result =
//     await _database.rawQuery('SELECT * FROM deleteMedication');
//     return result;
//   }
//
//   // Future<List<Map<String, dynamic>>> readDataFromTableSendMedication() async {
//   //   List<Map<String, dynamic>> result =
//   //   await _database.rawQuery("SELECT * FROM sendMedication   ");
//   //   return result;
//   // }
//
//   Future<List<Map<String, dynamic>>> readDataFromTableMedications() async {
//     List<Map<String, dynamic>> result =
//     await _database.rawQuery("SELECT * FROM medications");
//     return result;
//   }
//
//   Future<List<Map<String, dynamic>>>
//   readDataStoreMedicationNameWithMedicationId(String medicationId) async {
//     List<Map<String, dynamic>> result = await _database.rawQuery(
//         "SELECT medicationName FROM medications where medicationId=$medicationId");
//     return result;
//   }
//
//   Future<List<Map<String, dynamic>>> getMedications() async {
//     final List<Map<String, dynamic>> result =
//     await _database.query('medications');
//     return result;
//   }
// }
