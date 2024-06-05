import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:famici/core/offline/local_database/users_db.dart';

import '../../../core/enitity/user.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';

part 'member_profile_event.dart';

part 'member_profile_state.dart';

class MemberProfileBloc extends Bloc<MemberProfileEvent, MemberProfileState> {
  MemberProfileBloc({
    required User me,
  })  : _me = me,
        super(MemberProfileState.initial()) {
    on<FetchMemberProfileDetailsEvent>(_onFetchMemberProfileDetailsEvent);
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();

  FutureOr<void> _onFetchMemberProfileDetailsEvent(
      FetchMemberProfileDetailsEvent event,
      Emitter<MemberProfileState> emit) async {
    String? email = _me.email;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    // print("%%%%%%%");
    // print(email);
    // print(accessToken);
    // print(clientId);
    // print(companyId);

    if (await _isConnectedToInternet() && accessToken != null) {
      // if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/member-profile/details/$email';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(memberProfile), headers: headers);

      MemberProfileState current =
          MemberProfileState.fromJson(jsonDecode(response.body));

      print("rsp bode");
      print(response.body);

      CoreApps core = CoreApps(
          vitals: false,
          medications: false,
          appointments: false,
          careTeam: false,
          careAssistant: false);

      for (var app in current.functionList) {
        switch (app.name) {
          case "Vitals":
            core.vitals = true;
            break;
          case "Medication":
            core.medications = true;
            break;
          case "Care Team":
            core.careTeam = true;
            break;
          case "Care Assistant":
            core.careAssistant = true;
            break;
          case "Scheduling":
            core.appointments = true;
            break;
        }
      }

      final DatabaseHelperForUsers db = DatabaseHelperForUsers();
      db.insertOrUpdateMemberProfile(clientId ?? "DummyId", response.body);
      emit(state.copyWith(
          id: current.id,
          memberProfileId: current.memberProfileId,
          profileName: current.profileName,
          ageGroup: current.ageGroup,
          active: current.active,
          functionList: current.functionList,
          coreApps: core));
    } else {
      final DatabaseHelperForUsers db = DatabaseHelperForUsers();
      List<Map<String, dynamic>> response =
          await db.getMemberProfileByUserId(clientId ?? "InvalidUser");
      MemberProfileState current =
          MemberProfileState.fromJson(jsonDecode(response[0]['memberprofile']));

      CoreApps core = CoreApps(
          vitals: false,
          medications: false,
          appointments: false,
          careTeam: false,
          careAssistant: false);

      for (var app in current.functionList) {
        switch (app.name) {
          case "Vitals":
            core.vitals = true;
            break;
          case "Medication":
            core.medications = true;
            break;
          case "Care Team":
            core.careTeam = true;
            break;
          case "Care Assistant":
            core.careAssistant = true;
            break;
          case "Scheduling":
            core.appointments = true;
            break;
        }
      }

      emit(state.copyWith(
          id: current.id,
          memberProfileId: current.memberProfileId,
          profileName: current.profileName,
          ageGroup: current.ageGroup,
          active: current.active,
          functionList: current.functionList,
          coreApps: core));
    }
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }
}
