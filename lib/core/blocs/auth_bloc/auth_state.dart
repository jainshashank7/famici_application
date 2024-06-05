part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
  confirmationRequired,
  confirming,
  confirmFailed,
  pinRequired,
  pinUpdate
}

extension AuthStatusExt on String {
  AuthStatus toAuthStatus() {
    return AuthStatus.values.firstWhere(
      (value) => this == value.name,
      orElse: () => AuthStatus.unknown,
    );
  }
}

class AuthState extends Equatable {
  const AuthState({
    required this.user,
    required this.status,
  });
  final AuthStatus status;
  final User user;

  factory AuthState.initial() {
    return AuthState(
      user: User(givenName: "Janice"),
      status: AuthStatus.unknown,
    );
  }

  AuthState copyWith({
    User? user,
    AuthStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  factory AuthState.fromJson(Map<String, dynamic> json) {
    AuthState state = AuthState.initial();

    return state.copyWith(
      status: AuthStatus.loading,
      user: json['user'] != null
          ? User.fromCurrentAuthUserJson(json['user'])
          : User(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user.toCurrentAuthUserJson(),
    };
  }

  @override
  List<Object?> get props => [status, user];

  @override
  String toString() {
    return ''' ''';
  }
}
