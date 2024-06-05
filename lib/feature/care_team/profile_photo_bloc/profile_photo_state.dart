part of 'profile_photo_bloc.dart';

class ProfilePhotoState extends Equatable {
  const ProfilePhotoState({required this.status, required this.profilePhotoUrl});

  final String profilePhotoUrl;
  final bool status;

  factory ProfilePhotoState.initial() {
    return const ProfilePhotoState(status: false, profilePhotoUrl: "");
  }

  ProfilePhotoState copyWith({String? profilePhotoUrl, bool? status}) {
    return ProfilePhotoState(
        status: status ?? this.status,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl
    );
  }

  @override
  List<Object> get props => [
    status,
    profilePhotoUrl,
  ];
}