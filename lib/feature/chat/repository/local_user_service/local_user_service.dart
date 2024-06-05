import 'package:famici/core/enitity/user.dart';
import 'package:famici/core/local_database/local_db.dart';
import 'package:famici/feature/chat/repository/local_user_service/local_user_service_interface.dart';
import 'package:sqflite/sqflite.dart';

class LocalUserService implements IUserService {
  final Database _localDb = LocalDatabaseFactory.instance;
  @override
  Future<List<User>> addBulkUsers(List<User> users) async {
    _localDb.transaction(
      (txn) async {
        Batch _batch = txn.batch();
        for (var user in users) {
          _batch.insert(
            DBTable.users,
            user.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        return _batch.commit(noResult: true);
      },
    );
    return users;
  }

  @override
  Future<User> addUser(User user) async {
    await _localDb.insert(
      DBTable.users,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<User?> getUser(String id) async {
    var _data = await _localDb.query(
      DBTable.users,
      where: 'id =?',
      whereArgs: [id],
    );
    if (_data.isNotEmpty) {
      return User.fromMap(_data.first);
    }
    return null;
  }
}
