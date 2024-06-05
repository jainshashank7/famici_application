part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInAuthEvent extends AuthEvent {
  final String username;
  final String password;

  const SignInAuthEvent({
    required this.username,
    required this.password,
  });
  @override
  List<Object?> get props => [];
}

class AutoSignInAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class StartedCompleteSignInAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticatedEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ConfirmUserSignInAuthEvent extends AuthEvent {
  final String inviteCode;
  final String email;
  const ConfirmUserSignInAuthEvent({
    required this.inviteCode,
    required this.email
  });
  @override
  List<Object?> get props => [];
}

class SuccessfullyAuthenticatedAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SignOutAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ResetConfirmUserFailedAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class CheckUserStatus extends AuthEvent {
  @override
  List<Object?> get props => [];
}
