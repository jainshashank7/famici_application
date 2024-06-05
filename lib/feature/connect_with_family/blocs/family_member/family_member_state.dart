part of 'family_member_cubit.dart';

enum FamilyBlocStatus { initial, loading, success, failure, deleted }

class FamilyMemberState {
  const FamilyMemberState({
    required this.existingMembers,
    required this.memberSearchResult,
    required this.status,
    required this.userViewing,
    required this.remainingTime,
    required this.existingMembersMap,
    required this.inviteSubmitStatus,
  });
  final List<User> existingMembers;
  final Map<String, User> existingMembersMap;
  final List<User> memberSearchResult;
  final FamilyBlocStatus status;
  final User userViewing;
  final String remainingTime;
  final Status inviteSubmitStatus;

  factory FamilyMemberState.initial() {
    return FamilyMemberState(
      existingMembers: [],
      memberSearchResult: [],
      status: FamilyBlocStatus.initial,
      userViewing: User(),
      remainingTime: '',
      existingMembersMap: {},
      inviteSubmitStatus: Status.initial,
    );
  }

  FamilyMemberState copyWith({
    List<User>? existingMembers,
    List<User>? memberSearchResult,
    FamilyBlocStatus? status,
    User? userViewing,
    String? remainingTime,
    Map<String, User>? existingMembersMap,
    Status? inviteSubmitStatus,
  }) {
    return FamilyMemberState(
      existingMembers: existingMembers ?? this.existingMembers,
      memberSearchResult: memberSearchResult ?? this.memberSearchResult,
      status: status ?? this.status,
      userViewing: userViewing ?? this.userViewing,
      remainingTime: remainingTime ?? this.remainingTime,
      existingMembersMap: existingMembersMap ?? this.existingMembersMap,
      inviteSubmitStatus: inviteSubmitStatus ?? this.inviteSubmitStatus,
    );
  }

  @override
  String toString() {
    return '''  FamilyMemberState : { existingMembers : ${existingMembers.length} , memberSearchResult  : ${memberSearchResult.length} ,  status : ${status.toString()} }  ''';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "existingMembers": existingMembers.map((e) => e.hydrate()).toList(),
      "existingMembersMap": existingMembersMap.map(
        (key, value) => MapEntry(key, value.toJsonContact()),
      ),
      "memberSearchResult": [],
      "status": EnumToString.convertToString(status)
    };
  }

  factory FamilyMemberState.fromJson(json) {
    List<dynamic> listOfExistingDynamics = json['existingMembers'];
    Map<String, dynamic> listOfExistingMap = json['existingMembersMap'];
    List<User> existingUsers =
        listOfExistingDynamics.map((e) => User.fromJsonContact(e)).toList();
    Map<String, User> existingUsersMap = Map<String, User>.from(
        listOfExistingMap
            .map((key, value) => MapEntry(key, User.fromJsonContact(value))));
    return FamilyMemberState(
      existingMembers: existingUsers,
      memberSearchResult: existingUsers,
      status: EnumToString.fromString(
            FamilyBlocStatus.values,
            json['status'],
          ) ??
          FamilyBlocStatus.initial,
      userViewing: User(),
      remainingTime: '',
      existingMembersMap: existingUsersMap,
      inviteSubmitStatus: Status.initial,
    );
  }

  bool get isLoading => status == FamilyBlocStatus.loading;
}
