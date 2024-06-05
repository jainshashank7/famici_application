import 'dart:async';

import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/shared/fc_back_button.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/famici.theme.dart';
import 'kiosk_back_button.dart';

class KioskScaffold extends StatefulWidget {
  KioskScaffold(
      {super.key,
      required this.body,
      required this.title,
      required this.onDashboard,
      this.isSensitive = false,
      required this.sensitiveScreenTimeOut,
      required this.sensitiveAlertTimeOut
      });

  final String title;
  final Widget body;
  bool onDashboard = false;
  bool isSensitive;
  int sensitiveScreenTimeOut;
  int sensitiveAlertTimeOut;

  @override
  State<KioskScaffold> createState() => _KioskScaffoldState();
}

class _KioskScaffoldState extends State<KioskScaffold> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose(){
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
      builder: (context, sensState) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Container(
              margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                  0 * FCStyle.fem, 0 * FCStyle.fem, 0 * FCStyle.fem),
              padding: EdgeInsets.fromLTRB(
                  40 * FCStyle.fem,
                  18 * FCStyle.fem,
                  33.26 * FCStyle.fem,
                  18 * FCStyle.fem),
              width: double.infinity,
              height: 96 * FCStyle.fem,
              decoration: BoxDecoration(
                color: const Color(0xe5ffffff),
                borderRadius: BorderRadius.circular(10 * FCStyle.fem),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LeadingWidget(child: FCBackButton(onPressed: (){
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft,
                      ]);
                      sensState.st = St.stop;
                      context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                      Timer(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    })
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 25.0),
                    width: 800,
                    child: TitleWidget(child: Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize:
                          MediaQuery.of(context).orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height / 44
                              : MediaQuery.of(context).size.width / 44,
                          fontWeight: FontWeight.w600
                      ),
                    )),
                  ),
                ],
              ),
            ),
            elevation: 10,
            toolbarHeight:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.06
                          : MediaQuery.of(context).size.width * 0.05,
                      backgroundColor: Colors.white.withOpacity(0.85),
            //Color(0xff7E869D),
          ),
          body: widget.body,
        );
      }
    );
  }
}
