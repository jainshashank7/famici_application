import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/shared/fc_confirm_dialog.dart';
import 'package:famici/utils/constants/assets_paths.dart';

class SensitiveTimerBloc extends Bloc<SensitiveTimerEvent, SensitiveTimerState>{
  SensitiveTimerBloc(): super(SensitiveTimerState.initial()){
    on<SensitiveTimerEvent>(_changeSensitiveTimer);
  }

  Timer? _sensitiveTimer;

  FutureOr<void> _changeSensitiveTimer(SensitiveTimerEvent event, Emitter<SensitiveTimerState> emit) {
    DebugLogger.debug("Inside changeSensitiveTimer!! :: 141 ${state.st}");
    if(state.st == St.reset){
      DebugLogger.debug("Timer Resetting!! :: 141");
      _sensitiveTimer?.cancel();
      state.st = St.add;
      add(SensitiveTimerEvent(context: event.context, sensitiveScreenTimeOut: event.sensitiveScreenTimeOut, sensitiveAlertTimeOut: event.sensitiveAlertTimeOut));
    }
    else if(state.st == St.add){
      DebugLogger.debug("Main Timer:: ${event.sensitiveScreenTimeOut}    ${event.sensitiveAlertTimeOut}");
      _sensitiveTimer?.cancel();
      _sensitiveTimer = Timer(Duration(seconds: event.sensitiveAlertTimeOut), () {
        DebugLogger.debug("Timer Execution Completed!! :: 141");
        showDialog(
            context: event.context,
            builder: (BuildContext alertContext) {
              Future.delayed(Duration(seconds: event.sensitiveScreenTimeOut - event.sensitiveAlertTimeOut), (){
                Navigator.of(alertContext).pop();
              });
              return FCConfirmDialog(
                height: 400,
                width: 660,
                subText: 'Do you want to stay on this page? ',
                submitText: 'Yes',
                cancelText: 'No',
                icon: AssetIconPath.infoIcon,
                message: "Attention Required",
                countDown: event.sensitiveScreenTimeOut - event.sensitiveAlertTimeOut,
              );
            }).then((value) {
              DebugLogger.debug("value from Sensitive dialog $value");
              if (value == null) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
                ]);
                Navigator.pop(event.context);
                state.st = St.stop;
                add(SensitiveTimerEvent(context: event.context, sensitiveScreenTimeOut: event.sensitiveScreenTimeOut, sensitiveAlertTimeOut: event.sensitiveAlertTimeOut));
              }
              else{
                state.st = St.reset;
                add(SensitiveTimerEvent(context: event.context, sensitiveScreenTimeOut: event.sensitiveScreenTimeOut, sensitiveAlertTimeOut: event.sensitiveAlertTimeOut));
              }
            }
        );
      });
    }
    else if(state.st == St.stop){
      DebugLogger.debug("Timer Stopped!! :: 141");
      _sensitiveTimer?.cancel();
    }
  }
}

