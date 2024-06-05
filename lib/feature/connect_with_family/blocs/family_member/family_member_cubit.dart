import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/enitity/invite_status.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/chat/repository/local_user_service/local_user_service.dart';
import 'package:famici/feature/connect_with_family/views/error_popup_message.dart';
import 'package:famici/repositories/user_repository.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../shared/fc_back_button.dart';

part 'family_member_state.dart';

class FamilyMemberCubit extends HydratedCubit<FamilyMemberState> {
  FamilyMemberCubit({
    required User me,
  })  : _me = me,
        super(FamilyMemberState.initial());

  final UserRepository _userRepository = UserRepository();
  final User? _me;
  final LocalUserService _localUserService = LocalUserService();

  Future<void> fetchExistingFamilyMembers() async {
    try {
      emit(state.copyWith(status: FamilyBlocStatus.loading));
      if (state.existingMembers.isNotEmpty) {
        emit(state.copyWith(status: FamilyBlocStatus.success));
      }
      List<User> _listOfContacts = await _userRepository.fetchContacts(familyId: _me?.familyId ?? '',);
      // _localUserService.addBulkUsers(_listOfContacts).then((value) {
      //   DebugLogger.debug("Updated");
      // });
      emit(
        state.copyWith(
          existingMembers: _listOfContacts,
          status: FamilyBlocStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  Future<void> resetFamilyMembers() async {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    List<User> searchResult = state.existingMembers;
    try {
      emit(state.copyWith(
        memberSearchResult: searchResult,
        status: FamilyBlocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  void searchFamilyMembers({String term = ''}) {
    emit(state.copyWith(status: FamilyBlocStatus.loading));

    try {
      if (term.isNotEmpty) {
        List<User> currentResult = List.from(state.existingMembers);
        List<User> searchResult = currentResult.where(
          (user) {
            return user.givenName != null &&
                    user.givenName!
                        .toLowerCase()
                        .contains(term.toLowerCase()) ||
                user.familyName != null &&
                    user.familyName!.toLowerCase().contains(term.toLowerCase());
          },
        ).toList();

        emit(state.copyWith(
          memberSearchResult: searchResult,
          status: FamilyBlocStatus.success,
        ));
      } else {
        emit(state.copyWith(
          memberSearchResult: state.existingMembers,
          status: FamilyBlocStatus.success,
        ));
      }
    } catch (err) {
      emit(state.copyWith(
        status: FamilyBlocStatus.failure,
      ));
    }
  }

  void syncCreatedContact({required User user}) {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    List<User> searchResult = state.existingMembers..add(user);
    try {
      emit(state.copyWith(
        memberSearchResult: searchResult,
        status: FamilyBlocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  void selectMemberToRequestMedia({required User user}) {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    List<User> _users = state.existingMembers;
    List<User> _userWithSelection = _users.map((userDetails) {
      if (userDetails.id != null && userDetails.id == user.id) {
        return userDetails.copyWith(isSelected: !userDetails.isSelected);
      }
      return userDetails;
    }).toList();
    try {
      emit(state.copyWith(
        existingMembers: _userWithSelection,
        status: FamilyBlocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  void selectMemberToShareMedia({required User user}) {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    List<User> _users = state.existingMembers;
    List<User> _userWithSelection = _users.map((userDetails) {
      if (userDetails.id != null && userDetails.id == user.id) {
        return userDetails.copyWith(isSelected: !userDetails.isSelected);
      }
      return userDetails;
    }).toList();
    try {
      emit(state.copyWith(
        existingMembers: _userWithSelection,
        status: FamilyBlocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  void resetSelectMemberToRequestMedia() {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    List<User> _users = state.existingMembers;
    List<User> _userWithSelection = _users.map((userDetails) {
      return userDetails.copyWith(isSelected: false);
    }).toList();
    try {
      emit(state.copyWith(
        existingMembers: _userWithSelection,
        status: FamilyBlocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  void resetSelectMemberToShareMedia() {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    List<User> _users = state.existingMembers;
    List<User> _userWithSelection = _users.map((userDetails) {
      return userDetails.copyWith(isSelected: false);
    }).toList();
    try {
      emit(state.copyWith(
        existingMembers: _userWithSelection,
        status: FamilyBlocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  void syncViewingUser(User? user) async {
    try {
      emit(state.copyWith(
        status: FamilyBlocStatus.loading,
        inviteSubmitStatus: Status.initial,
      ));
      User _user = user!;

      String formatted = FlutterLibphonenumber().formatNumberSync(
        user.phone ?? '',
        phoneNumberFormat: PhoneNumberFormat.international,
      );

      emit(state.copyWith(
        userViewing: _user.copyWith(
          isEditing: true,
          phone: formatted,
        ),
        status: FamilyBlocStatus.success,
        remainingTime: '',
      ));
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<void> stopRemainingTimeCount() async {
    emit(state.copyWith(remainingTime: ''));
  }

  Future<void> resetUserViewing() async {
    emit(state.copyWith(
      userViewing: User(),
      status: FamilyBlocStatus.initial,
    ));

    return;
  }

  void deleteSelectedContact() async {
    emit(state.copyWith(status: FamilyBlocStatus.loading));
    try {
      User _user = state.userViewing;
      bool isDeleted = await _userRepository.deleteContact(
        familyId: _user.familyId!,
        contactId: _user.id!,
      );
      if (isDeleted) {
        await fetchExistingFamilyMembers();
        await resetUserViewing();
        emit(state.copyWith(
          status: FamilyBlocStatus.deleted,
        ));
      } else {
        throw Exception('Unable to delete.');
      }
    } on GraphQLResponseError catch (err) {
      fcRouter.pushWidget(ErrorMessagePopup(message: err.message));
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    } catch (e) {
      emit(state.copyWith(status: FamilyBlocStatus.failure));
    }
  }

  Future<void> sendInvite() async {
    try {
      emit(state.copyWith(inviteSubmitStatus: Status.loading));
      User _user = state.userViewing;
      List<User> _users = List.from(state.existingMembers);
      InviteStatus _status = await _userRepository.sendContactInvite(
        familyId: _me!.familyId,
        contactId: _user.id,
      );

      _user = _user.copyWith(
        isInvitationAccepted: _status.isActive,
        invitationSentAt: DateTime.fromMillisecondsSinceEpoch(
          _status.createdAt,
        ),
      );

      int idx = _users.indexWhere((e) => e.id == _user.id);
      if (idx > -1) {
        _users[idx] = _user;

        emit(state.copyWith(
          existingMembers: _users,
          userViewing: _user,
          inviteSubmitStatus: Status.success,
        ));
      }
    } catch (err) {
      emit(state.copyWith(inviteSubmitStatus: Status.failure));
    }
  }

  @override
  FamilyMemberState? fromJson(Map<String, dynamic> json) {
    return FamilyMemberState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(FamilyMemberState state) {
    Map<String, dynamic> json = state.toJson();
    return json;
  }
}
