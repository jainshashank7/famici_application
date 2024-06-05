import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../core/enitity/user.dart';
import '../../../core/offline/local_database/users_db.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';

part 'care_team_event.dart';

part 'care_team_state.dart';

class CareTeamBloc extends Bloc<CareTeamEvent, CareTeamState> {
  CareTeamBloc({
    required User me,
  })  : _me = me,
        super(CareTeamState.initial()) {
    on<GetCareTeamMembers>(_onGetCareTeamMembers);
    add(GetCareTeamMembers());
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();

  Future<FutureOr<void>> _onGetCareTeamMembers(
      GetCareTeamMembers event, Emitter<CareTeamState> emit) async {
    String? email = _me.email;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null && await _isConnectedToInternet()) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/clients/client-care-team';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };
      print("USer Response ::: ${_me.toMap()}");

      var response = await http.get(Uri.parse(memberProfile), headers: headers);


      if(response.statusCode == 200) {
        List<Map<String, dynamic>> careTeamData =
        List<Map<String, dynamic>>.from(json.decode(response.body));

        List<CareTeamMember> members = [];

        for (var data in careTeamData) {

          CareTeamMember tempMember = CareTeamMember.fromJson(data);
          members.add(tempMember);
        }
        final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
        dbFactory.insertOrUpdateCareTeam(clientId, response.body);

        emit(state.copyWith(members: members));
      }

    } else {
      final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
      List<Map<String, dynamic>> response =
          await dbFactory.getCareTeamByUserId(clientId);

      if (response != null) {
        List<Map<String, dynamic>> careTeamData =
            List<Map<String, dynamic>>.from(
                json.decode(response[0]['careteam']));

        List<CareTeamMember> members = [];

        for (var data in careTeamData) {
          CareTeamMember tempMember = CareTeamMember.fromJson(data);
          members.add(tempMember);
        }
        emit(state.copyWith(members: members));
      }
    }
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }
}
