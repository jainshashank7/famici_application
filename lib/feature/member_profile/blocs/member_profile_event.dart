part of 'member_profile_bloc.dart';

@immutable
abstract class MemberProfileEvent {}

class FetchMemberProfileDetailsEvent extends MemberProfileEvent {
  FetchMemberProfileDetailsEvent();
}
