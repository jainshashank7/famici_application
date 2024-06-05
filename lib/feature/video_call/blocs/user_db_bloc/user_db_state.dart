part of 'user_db_bloc.dart';

class UserDbState extends Equatable {
  const UserDbState({
    required this.ccUsers,
    required this.fcUsers,
  });

  final Map<String, User> ccUsers;
  final Map<String, User> fcUsers;

  factory UserDbState.initial() {
    return const UserDbState(ccUsers: {}, fcUsers: {});
  }

  UserDbState copyWith({
    Map<String, User>? fcUsers,
    Map<String, User>? ccUsers,
  }) {
    return UserDbState(
      ccUsers: ccUsers ?? this.ccUsers,
      fcUsers: fcUsers ?? this.fcUsers,
    );
  }

  @override
  List<Object?> get props => [ccUsers, fcUsers];

  Map<String, dynamic> toJson() {
    return {
      "ccUsers": ccUsers.map((key, value) => MapEntry(key, value.hydrate())),
      "fcUsers": fcUsers.map((key, value) => MapEntry(key, value.hydrate())),
    };
  }

  factory UserDbState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserDbState.initial();
    }

    Map<String, User> fcUsers =
        Map.from(json['fcUsers'] ?? {}).map<String, User>(
      (key, value) => MapEntry(key, User.fromJsonContact(value)),
    );
    Map<String, User> ccUsers =
        Map.from(json['ccUsers'] ?? {}).map<String, User>(
      (key, value) => MapEntry(key, User.fromJsonContact(value)),
    );

    return UserDbState(ccUsers: ccUsers, fcUsers: fcUsers);
  }
}
