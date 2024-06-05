import 'dart:async';

import 'package:battery_plus/battery_plus.dart' as mobile;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  BatteryCubit() : super(BatteryState.initial()) {
    initializeBatteryListner();
  }
  final battery = mobile.Battery();
  StreamSubscription? _batterySubscription;

  void initializeBatteryListner() async {
    int level = await battery.batteryLevel;
    emit(state.copyWith(percentage: level));
    _batterySubscription ??=
        battery.onBatteryStateChanged.listen(updateBatteryStatus);
  }

  void updateBatteryStatus(mobile.BatteryState status) async {
    int level = await battery.batteryLevel;
    emit(state.copyWith(percentage: level));
  }

  @override
  Future<void> close() {
    _batterySubscription?.cancel();
    return super.close();
  }
}
