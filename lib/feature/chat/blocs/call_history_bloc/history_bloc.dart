import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import '../../../../core/enitity/user.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../utils/config/api_config.dart';
import '../../../../utils/config/api_key.dart';
import '../../../calander/entities/appointments_entity.dart';
part 'history_event.dart';
part 'history_state.dart';

class ManageHistoryBloc extends Bloc<ManageHistoryEvent, ManageHistoryState> {
  final User _me;
  ManageHistoryBloc({
    required User me,
  })  : _me = me,
        super(ManageHistoryState.initial()) {
    on<FetchCallHistoryData>(_fetchCallHistoryData);
  }

  Future<FutureOr<void>> _fetchCallHistoryData(
      FetchCallHistoryData event, Emitter<ManageHistoryState> emit) async {
    final AuthRepository _authRepository = AuthRepository();

    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Accept": "application/json",
        "content-type": "application/json"
      };
      List<CallHistoryElement> results;
      String getCallHistoryLogs =
          '${ApiConfig.baseUrl}/integrations/appt-logs';
      var responseSession =
          await http.get(Uri.parse(getCallHistoryLogs), headers: headers);
      print('heiiie' + responseSession.body.toString());
      if (responseSession != null) {
        final jsonString = json.decode(responseSession.body)["sessionLogs"];
        results = CallHistoryElement.fromJsonList(jsonString);
        emit(state.copyWith(log: results));
      }
    }
  }
}
