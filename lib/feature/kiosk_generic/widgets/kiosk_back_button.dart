import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart' as st;
import 'package:famici/core/router/router.dart';

class KioskBackButton extends StatelessWidget {
  KioskBackButton({super.key, required this.onDashboard});
  bool onDashboard = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
            state.st = St.stop;
            context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(context: context, sensitiveScreenTimeOut:  0, sensitiveAlertTimeOut:  0));
            // Timer(Duration(seconds: 1), () {
            //   Navigator.pop(context);
            // });
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
                // right: MediaQuery.of(context).size.width * 0.05,
              ),
              // color: Color(0xff7E869D),
              // padding: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_ios,
                size: MediaQuery.of(context).orientation == Orientation.landscape
                    ? MediaQuery.of(context).size.height * 0.06
                    : MediaQuery.of(context).size.width * 0.06,
                color: Colors.black,
              ),
            );
          }),
        );
      }
    );
  }
}
