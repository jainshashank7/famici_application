import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/utils/config/color_pallet.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial()) {
    _listenToSystemThemeChange();
  }

  void _listenToSystemThemeChange() {
    SchedulerBinding.instance!.window.onPlatformBrightnessChanged = () {
      ColorPallet.setThemeMode(
        SchedulerBinding.instance!.window.platformBrightness,
      );
      emit(
        state.copyWith(
          mode: SchedulerBinding.instance!.window.platformBrightness,
        ),
      );
    };
  }

  void toggleDarkMode() {
    Brightness current = state.mode;

    if (current == Brightness.dark) {
      ColorPallet.setThemeMode(Brightness.light);
      emit(state.copyWith(mode: Brightness.light));
    } else if (current == Brightness.light) {
      ColorPallet.setThemeMode(Brightness.dark);
      emit(state.copyWith(mode: Brightness.dark));
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    ThemeState _savedState = ThemeState(
      mode: getBrightnessFromString(json['theme']),
    );
    ColorPallet.setThemeMode(_savedState.mode);
    return _savedState;
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'theme': state.mode.toString()};
  }

  Brightness getBrightnessFromString(String stringMode) {
    if (Brightness.light.toString() == stringMode) {
      return Brightness.light;
    } else if (Brightness.dark.toString() == stringMode) {
      return Brightness.dark;
    } else {
      return SchedulerBinding.instance!.window.platformBrightness;
    }
  }
}
