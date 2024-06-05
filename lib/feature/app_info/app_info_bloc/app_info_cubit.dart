import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:famici/feature/app_info/entity/app_support_info.dart';
import 'package:famici/repositories/barrel.dart';

part 'app_info_state.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  AppInfoCubit() : super(AppInfoState.initial());

  final ConfigService _config = ConfigService();

  void fetchAppInfo() async {
    AppSupportInfo info = await _config.getAppInformation();
    emit(state.copyWith(info: info));
  }
}
