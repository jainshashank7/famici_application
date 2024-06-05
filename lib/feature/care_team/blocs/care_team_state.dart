part of 'care_team_bloc.dart';

class CareTeamState extends Equatable {
  const CareTeamState({required this.members});

  final List<CareTeamMember> members;

  factory CareTeamState.initial() {
    return const CareTeamState(members: []);
  }

  CareTeamState copyWith({List<CareTeamMember>? members}) {
    return CareTeamState(members: members ?? []);
  }

  @override
  List<Object> get props => [
        members,
      ];
}

class CareTeamMember {
  const CareTeamMember({
    required this.isPrimary,
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.profileUrl,
    required this.firstName,
    required this.lastName,
  });

  final int? isPrimary;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? email;
  final String? phoneNumber;
  final String? profileUrl;

  factory CareTeamMember.fromJson(Map<String, dynamic> json) {
    return CareTeamMember(
      isPrimary: json['is_primary'],
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: json['role'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone'] as String?,
      profileUrl: json['profilePhoto'] as String?,
    );
  }
}
