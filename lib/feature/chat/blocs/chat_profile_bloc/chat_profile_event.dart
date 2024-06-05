part of 'chat_profile_bloc.dart';

@immutable
abstract class ChatProfilesEvent extends Equatable {}

class FetchingChatProfiles extends ChatProfilesEvent {
  @override
  List<Object?> get props => [];
}