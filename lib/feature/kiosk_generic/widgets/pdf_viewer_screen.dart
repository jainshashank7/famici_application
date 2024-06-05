import 'dart:async';

import 'package:debug_logger/debug_logger.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import '../../../core/screens/loading_screen/loading_screen.dart';
import 'package:famici/shared/fc_back_button.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/famici.theme.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl; // The URL of the PDF to load
  final String pdfTitle;
  final bool isSensitive;
  final int sensitiveScreenTimeOut;
  final int sensitiveAlertTimeOut;

  PdfViewerScreen({super.key, required this.pdfUrl, required this.pdfTitle, required this.isSensitive, required this.sensitiveScreenTimeOut, required this.sensitiveAlertTimeOut});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? pdfDocument;
  bool isPdfLoading = true;

  Timer? _resetSensitiveTimer;

  @override
  void initState() {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    loadPdf(widget.pdfUrl);
  }

  @override
  void dispose(){
    _resetSensitiveTimer?.cancel();
    super.dispose();
  }

  Future<void> loadPdf(String pdfUrl) async {
    print("heyaaa " + pdfUrl);
    pdfDocument = await PDFDocument.fromURL(widget.pdfUrl + "#view=FitB");
    setState(() {
      isPdfLoading = false;
    });
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
              child: Row(
                // alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LeadingWidget(child: FCBackButton(onPressed: (){
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft,
                      ]);
                      sensState.st = St.stop;
                      context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: 0, sensitiveAlertTimeOut: 0));
                      Timer(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    })
                    ),
                  ),
                  // const SizedBox(width: 20,),
                  Container(
                    width: 800,
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TitleWidget(child: Text(
                      widget.pdfTitle,
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
          body: isPdfLoading
              ? LoadingScreen() // Loading screen
              : WillPopScope(
                  onWillPop: () async{
                    sensState.st = St.stop;
                    context.read<SensitiveTimerBloc>().add(
                        SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: 0, sensitiveAlertTimeOut: 0)
                    );
                    return true;
                  },
                  child: Listener(
                    onPointerDown: (_){
                      if(widget.isSensitive){
                        DebugLogger.debug("onPointerDown:: PDF");
                        _resetSensitiveTimer?.cancel();
                        _resetSensitiveTimer = Timer.periodic(const Duration(seconds: 2), (_) {
                          sensState.st = St.reset;
                          context
                              .read<SensitiveTimerBloc>()
                              .add(SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                          print("SensitiveTimerEvent:: Reset");
                        });
                      }
                    },
                    onPointerUp: (_){
                      if(widget.isSensitive) {
                        DebugLogger.debug("onPointerUp:: PDF");
                        _resetSensitiveTimer?.cancel();
                        sensState.st = St.reset;
                        context.read<SensitiveTimerBloc>().add(
                            SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut)
                        );
                      }
                    },
                    onPointerMove: (_){
                      if(widget.isSensitive) {
                        DebugLogger.debug("onPointerMove:: PDF");
                        _resetSensitiveTimer?.cancel();
                        sensState.st = St.reset;
                        context.read<SensitiveTimerBloc>().add(
                            SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut)
                        );
                      }
                    },
                    onPointerPanZoomUpdate: (_){
                      if(widget.isSensitive) {
                        DebugLogger.debug("onPointerPanZoomUpdate:: PDF");
                        _resetSensitiveTimer?.cancel();
                        sensState.st = St.reset;
                        context.read<SensitiveTimerBloc>().add(
                            SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut)
                        );
                      }
                    },
                    child: PDFViewer(
                        document: pdfDocument!,
                        scrollDirection: Axis.vertical,
                        lazyLoad: true,
                        enableSwipeNavigation: true
                    ),
                  ),
                )
        );
      }
    );
  }
}
