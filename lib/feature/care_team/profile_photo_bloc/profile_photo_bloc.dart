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

part 'profile_photo_event.dart';

part 'profile_photo_state.dart';

class ProfilePhotoBloc extends Bloc<ProfilePhotoEvent, ProfilePhotoState> {
  ProfilePhotoBloc({
    required User me,
  })  : _me = me,
        super(ProfilePhotoState.initial()) {
    on<FetchProfilePhotoEvent>(_onProfilePhotoEvent);
    add(FetchProfilePhotoEvent());
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();

  Future<FutureOr<void>> _onProfilePhotoEvent(
      event, Emitter<ProfilePhotoState> emit) async {
    String? email = _me.email;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      String memberProfile =
          '${ApiConfig.baseUrl}/integrations/clients/client-profile-photo';

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

          String url = data['profilePhotoUrl'];

          emit(state.copyWith(status: true, profilePhotoUrl: url));
        } catch (err) {
          DebugLogger.error(err);
        }
      }
    }
  }
}
