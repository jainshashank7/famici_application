part of 'member_profile_bloc.dart';

class MemberProfileState {
  MemberProfileState({
    required this.id,
    required this.memberProfileId,
    required this.profileName,
    required this.ageGroup,
    required this.active,
    required this.functionList,
    required this.coreApps,
  });

  final int id;
  final int memberProfileId;
  final String profileName;
  final String ageGroup;
  final bool active;
  final List<FunctionList> functionList;
  final CoreApps coreApps;

  factory MemberProfileState.initial() {
    return MemberProfileState(
        id: 0,
        memberProfileId: 0,
        profileName: '',
        ageGroup: '',
        active: false,
        functionList: [],
        coreApps: CoreApps(
            vitals: false,
            medications: false,
            appointments: false,
            careTeam: false,
            careAssistant: false));
  }

  factory MemberProfileState.fromJson(Map<String, dynamic> json) {
    List<FunctionList> functionList = (json['data']['functionList'] as List)
        .map((functionJson) => FunctionList.fromJson(functionJson))
        .toList();

    return MemberProfileState(
      id: json['data']['id'],
      memberProfileId: json['data']['memberProfileId'],
      profileName: json['data']['profileName'],
      ageGroup: json['data']['ageGroup'],
      active: json['data']['active'] == 1,
      functionList: functionList,
      coreApps: CoreApps(
          vitals: false,
          medications: false,
          appointments: false,
          careTeam: false,
          careAssistant: false),
    );
  }

  MemberProfileState copyWith({
    int? id,
    int? memberProfileId,
    String? profileName,
    String? ageGroup,
    bool? active,
    List<FunctionList>? functionList,
    CoreApps? coreApps,
  }) {
    return MemberProfileState(
        id: id ?? this.id,
        memberProfileId: memberProfileId ?? this.memberProfileId,
        profileName: profileName ?? this.profileName,
        ageGroup: ageGroup ?? this.ageGroup,
        active: active ?? this.active,
        functionList: functionList ?? this.functionList,
        coreApps: coreApps ?? this.coreApps);
  }
}

class FunctionList {
  final int id;
  final String name;
  final String androidId;
  final String iosId;
  final String image;
  final String type;
  final bool defaultSelected;
  final bool active;
  final bool deleted;

  FunctionList({
    required this.id,
    required this.name,
    required this.androidId,
    required this.iosId,
    required this.image,
    required this.type,
    required this.defaultSelected,
    required this.active,
    required this.deleted,
  });

  factory FunctionList.fromJson(Map<String, dynamic> json) {
    return FunctionList(
      id: json['function_id'],
      name: json['function_name'],
      androidId: json['android_id'],
      iosId: json['ios_id'],
      image: json['image'],
      type: json['function_type'],
      defaultSelected: json['by_default_selected'] == 1,
      active: json['active'] == 1,
      deleted: json['deleted'] == 1,
    );
  }
}

class CoreApps {
  late bool vitals;
  late bool medications;
  late bool appointments;
  late bool careTeam;
  late bool careAssistant;

  CoreApps({
    required this.vitals,
    required this.medications,
    required this.appointments,
    required this.careTeam,
    required this.careAssistant,
  });
}
