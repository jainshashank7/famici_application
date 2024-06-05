import 'package:famici/core/enitity/barrel.dart';

abstract class IUserService {
  Future<User> addUser(User user);
  Future<User?> getUser(String id);
  Future<List<User>> addBulkUsers(List<User> users);
  Future<void> delete(String id);
}
