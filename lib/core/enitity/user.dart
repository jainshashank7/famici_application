import 'dart:convert';

import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/enitity/invite_status.dart';
import 'package:famici/utils/barrel.dart';

class User {
  User({
    this.id,
    this.givenName,
    this.familyName,
    this.profileUrl,
    this.email,
    this.phone,
    this.isSelected = false,
    this.familyId,
    this.contactType,
    this.role = '',
    this.families,
    this.name,
    this.contactTypeDescription,
    this.allowToSeeVitals = false,
    this.allowToSeeReminders = false,
    this.allowToSeeMedication = false,
    this.isEmergencyContact = false,
    this.isEditing = false,
    this.note,
    this.invitationSentAt,
    this.isInvitationAccepted = false,
    this.ccId = '',
    InviteStatus? invite,
    Picture? picture,
    String? activeStatus,
    CustomAttribute2? customAttribute2,
  })  : invite = invite ?? InviteStatus(),
        picture = picture ?? Picture(),
        activeStatus = activeStatus ?? 'Offline',
        customAttribute2 = customAttribute2 ?? CustomAttribute2();

  String? id;
  String? givenName;
  String? familyName;
  String? profileUrl;
  String? phone;
  String? email;
  String? username;
  ContactType? contactType;

  String? familyId;
  bool isSelected;
  String? families;
  String role;
  String? name;
  String? note;

  String? contactTypeDescription;
  bool allowToSeeMedication;
  bool allowToSeeReminders;
  bool allowToSeeVitals;
  bool isEmergencyContact;

  bool isEditing;
  bool isInvitationAccepted;
  DateTime? invitationSentAt;
  String ccId;
  InviteStatus invite;
  Picture picture;

  String activeStatus;
  CustomAttribute2 customAttribute2;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "profileUrl": profileUrl,
      "phone": phone,
      "email": email,
      "familyId": familyId,
      "name": name,
      "givenName": givenName,
      "familyName": familyName,
      "ccId": customAttribute2.userId,
    };
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      givenName: json['givenName'],
      familyName: json['familyName'],
      profileUrl: json['profileUrl'],
      phone: json['phone'],
      email: json['email'],
      familyId: json['familyId'],
      ccId: json['ccId'],
    );
  }

  Map<String, dynamic> toCurrentAuthUserJson() {
    return <String, dynamic>{
      "custom:contactid": id,
      "custom:families": families,
      "custom:role": role,
      "custom:familyid": familyId,
      "email": email,
      "name": name,
      "phone": phone,
      "given_name": givenName,
      "family_name": familyName,
      "profileUrl": profileUrl,
      "custom:customstringattr2": customAttribute2.toRawJson()
    };
  }

  factory User.fromCurrentAuthUserJson(json) {
    String name = json['name'] ?? '';
    String firstname = json['given_name'] ?? '';
    String lastname = json['family_name'] ?? '';
    CustomAttribute2 customAttribute2 = CustomAttribute2.fromRawJson(
      json['custom:customstringattr2'],
    );
    return User(
      id: json["custom:contactid"] ?? json["sub"] ?? '',
      givenName: json["given_name"] ?? '',
      familyName: json["family_name"] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      families: json["custom:families"] ?? '',
      role: json["custom:role"] ?? '',
      familyId: json["custom:familyid"] ?? '',
      name: name,
      customAttribute2: customAttribute2,
    );
  }

  Map<String, dynamic> toJsonContact() {
    Map<String, dynamic> json = <String, dynamic>{
      "givenName": '$givenName',
      "familyName": '$familyName',
      "email": email,
      "phone":
          phone != null ? phone?.replaceAll(' ', '').replaceAll('-', '') : '',
      "isFamilyOrFriend": contactType == ContactType.familyOrFriend,
      "viewMedication": allowToSeeMedication,
      "viewVitals": allowToSeeVitals,
      "viewReminders": allowToSeeReminders,
      "relationship": contactTypeDescription,
      "isEmergencyContact": isEmergencyContact,
    };
    if (note != null && note!.isNotEmpty) {
      json['note'] = note;
    }

    return json;
  }

  Map<String, dynamic> hydrate() {
    return <String, dynamic>{
      "contactId": id,
      "givenName": '$givenName',
      "familyName": '$familyName',
      "email": email,
      "phone":
          phone != null ? phone?.replaceAll(' ', '').replaceAll('-', '') : '',
      "isFamilyOrFriend": contactType == ContactType.familyOrFriend,
      "viewMedication": allowToSeeMedication,
      "viewVitals": allowToSeeVitals,
      "viewReminders": allowToSeeReminders,
      "isEmergencyContact": isEmergencyContact,
      "relationship": contactTypeDescription,
      "note": note != null && note!.isNotEmpty ? note : '',
      "picture": picture.toJson(),
      "role": role,
      "invite": invite.toJson(),
      "config": {
        "champConnectId": ccId,
      },
    };
  }

  factory User.fromJsonContact(json) {
    String firstname = json['givenName'] ?? '';
    String lastname = json['familyName'] ?? '';
    String name = '$firstname $lastname';
    Picture _profile = Picture.fromJson(json['picture']);
    InviteStatus _invite = InviteStatus.fromJson(json['invite']);
    return User(
      id: json['contactId'],
      givenName: firstname,
      familyName: lastname,
      name: name,
      phone: json['phone'],
      email: json['email'],
      profileUrl: _profile.url,
      contactType: isNull(json['isFamilyOrFriend'])
          ? ContactType.familyOrFriend
          : json['isFamilyOrFriend']
              ? ContactType.familyOrFriend
              : ContactType.other,
      allowToSeeMedication: json['viewMedication'] ?? false,
      allowToSeeReminders: json['viewVitals'] ?? false,
      allowToSeeVitals: json['viewVitals'] ?? false,
      contactTypeDescription: json['relationship'],
      isEmergencyContact: json['isEmergencyContact'] ?? false,
      familyId: json['familyId'],
      ccId: json['config']?['champConnectId'] ?? '',
      isInvitationAccepted: _invite.isActive,
      note: json['note'],
      invitationSentAt: DateTime.fromMillisecondsSinceEpoch(_invite.createdAt),
      invite: _invite,
      picture: _profile,
      activeStatus: json['presenceStatus'] ?? json['activeStatus'] ?? 'Offline',
      role: json['role'] ?? '',
    );
  }

  void copyFrom(User user) {
    id = user.id;
    givenName = user.givenName;
    familyName = user.familyName;
    profileUrl = user.profileUrl;
    phone = user.phone;
    email = user.email;
    isSelected = user.isSelected;
    familyId = user.familyId;
    families = user.families;
    familyName = user.familyName;
    role = user.role;
    name = user.name;
    givenName = user.givenName;
    contactType = user.contactType;
    contactTypeDescription = user.contactTypeDescription;
    allowToSeeReminders = user.allowToSeeReminders;
    allowToSeeMedication = user.allowToSeeMedication;
    allowToSeeVitals = user.allowToSeeVitals;
    isEmergencyContact = user.isEmergencyContact;
    note = user.note;
    isEditing = user.isEditing;
    invitationSentAt = user.invitationSentAt;
    isInvitationAccepted = user.isInvitationAccepted;
    ccId = user.ccId;
    activeStatus = user.activeStatus;
    customAttribute2 = user.customAttribute2;
  }

  User copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? profileUrl,
    String? phone,
    String? email,
    bool? isSelected,
    String? familyId,
    String? families,
    String? role,
    ContactType? contactType,
    String? name,
    String? givenName,
    String? familyName,
    String? contactTypeDescription,
    bool? allowToSeeMedication,
    bool? allowToSeeReminders,
    bool? allowToSeeVitals,
    bool? isFamilyOrFriend,
    bool? isEmergencyContact,
    String? note,
    bool? isEditing,
    bool? isInvitationAccepted,
    DateTime? invitationSentAt,
    String? ccId,
    InviteStatus? invite,
    Picture? picture,
    String? activeStatus,
    CustomAttribute2? customAttribute2,
  }) {
    return User(
      id: id ?? this.id,
      givenName: firstname ?? this.givenName,
      familyName: lastname ?? this.familyName,
      profileUrl: profileUrl ?? this.profileUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isSelected: isSelected ?? this.isSelected,
      familyId: familyId ?? this.familyId,
      families: families ?? this.families,
      role: role ?? this.role,
      name: name ?? this.name,
      contactType: contactType ?? this.contactType,
      contactTypeDescription:
          contactTypeDescription ?? this.contactTypeDescription,
      allowToSeeReminders: allowToSeeReminders ?? this.allowToSeeReminders,
      allowToSeeMedication: allowToSeeMedication ?? this.allowToSeeMedication,
      allowToSeeVitals: allowToSeeVitals ?? this.allowToSeeVitals,
      isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
      note: note ?? this.note,
      isEditing: isEditing ?? this.isEditing,
      invitationSentAt: DateTime.now(),
      isInvitationAccepted: isInvitationAccepted ?? this.isInvitationAccepted,
      ccId: ccId ?? this.ccId,
      invite: invite ?? this.invite,
      picture: picture ?? this.picture,
      activeStatus: activeStatus ?? this.activeStatus,
      customAttribute2: customAttribute2 ?? this.customAttribute2,
    );
  }

  bool get isEmailPrimary =>
      phone == null ||
      phone != null && phone!.isEmpty ||
      contactType != ContactType.familyOrFriend;

  bool get isOnline => activeStatus == "Online";

  bool get isCareGiver => role.toLowerCase() == 'connection';
}

Future<List<User>> parseContactsFromJsonListString(dynamic responseBody) async {
  final parsed = jsonDecode(responseBody as String);
  List<dynamic> _listParsedData = parsed['getContacts']['items'] ?? [];
  return _listParsedData
      .map<User>((json) => User.fromJsonContact(json))
      .toList();
}

class CustomAttribute2 {
  CustomAttribute2({
    this.userType = '',
    this.userId = '',
    this.companySubDomain = '',
    this.companyName = '',
    this.companyId = '',
  });

  final String userType;
  final String userId;
  final String companySubDomain;
  final String companyName;
  final String companyId;

  CustomAttribute2 copyWith({
    String? userType,
    String? userId,
    String? companySubDomain,
    String? companyName,
    String? companyId,
  }) =>
      CustomAttribute2(
        userType: userType ?? this.userType,
        userId: userId ?? this.userId,
        companySubDomain: companySubDomain ?? this.companySubDomain,
        companyName: companyName ?? this.companyName,
        companyId: companyId ?? this.companyId,
      );

  factory CustomAttribute2.fromJson(Map<String, dynamic> json) =>
      CustomAttribute2(
        userType: json["userType"] ?? '',
        userId: json["userId"] ?? '',
        companySubDomain: json["companySubDomain"] ?? '',
        companyName: json["companyName"] ?? '',
        companyId: json["companyId"] ?? '',
      );

  factory CustomAttribute2.fromRawJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return CustomAttribute2();
    }
    return CustomAttribute2.fromJson(jsonDecode(jsonString));
  }

  Map<String, dynamic> toJson() => {
        "userType": userType,
        "userId": userId,
        "companySubDomain": companySubDomain,
        "companyName": companyName,
        "companyId": companyId,
      };

  String toRawJson() => jsonEncode(toJson());
}
