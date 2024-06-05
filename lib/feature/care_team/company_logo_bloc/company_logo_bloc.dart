import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/enitity/user.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';

part 'company_logo_event.dart';

part 'company_logo_state.dart';

class CompanyLogoBloc extends Bloc<CompanyLogoEvent, CompanyLogoState> {
  CompanyLogoBloc({
    required User me,
  })  : _me = me,
        super(CompanyLogoState.initial()) {
    on<FetchCompanyLogoEvent>(_onFetchCompanyLogoEvent);
    add(FetchCompanyLogoEvent());
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();

  Future<FutureOr<void>> _onFetchCompanyLogoEvent(
      FetchCompanyLogoEvent event, Emitter<CompanyLogoState> emit) async {
    String? email = _me.email;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/clients/client-company-logo';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(memberProfile), headers: headers);

      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> data = json.decode(response.body);

          String url = data['companyLogo'];

          emit(state.copyWith(status: true, companyUrl: url));
        } catch (err) {
          DebugLogger.error(err);
        }
      }
    }
  }
}
