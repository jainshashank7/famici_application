part of 'profile_photo_bloc.dart';

@immutable
abstract class ProfilePhotoEvent {}


class FetchProfilePhotoEvent extends ProfilePhotoEvent {
  FetchProfilePhotoEvent();
}