import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/feature/kiosk_generic/widgets/kiosk_scaffold.dart';
import 'package:famici/feature/kiosk_generic/widgets/pdf_viewer_screen.dart';
import 'package:famici/utils/barrel.dart';

// import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// import 'package:url_launcher_windows/url_launcher_windows.dart';
import '../../../core/enitity/user.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import 'custom_in_app_webview.dart';
import 'kiosk_back_button.dart';

class DashboardGridViewItem extends StatefulWidget {
  DashboardGridViewItem(
      {super.key,
      required this.title,
      required this.link,
      required this.itemType,
      required this.color,
      this.documentId,
      required this.textColor,
      this.isSensitive = false,
      required this.sensitiveScreenTimeOut,
      required this.sensitiveAlertTimeOut,
      });

  final String title;
  final String link;
  final String itemType;
  final Color color;
  final String? documentId;
  final Color textColor;
  final bool isSensitive;
  final int sensitiveScreenTimeOut;
  final int sensitiveAlertTimeOut;

  @override
  State<DashboardGridViewItem> createState() => _DashboardGridViewItemState();
}

class _DashboardGridViewItemState extends State<DashboardGridViewItem> {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final pdfUrl = 'https://css4.pub/2017/newsletter/drylab.pdf';
  final AuthRepository _authRepository = AuthRepository();

  final _textController = TextEditingController();

  final List<StreamSubscription> _subscriptions = [];

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  void openApp(String url) async {
    // final url = 'ms-store://'; // URL scheme for the Microsoft Store
    var res = await canLaunchUrl(Uri.parse(url));

    if (res) {
      await launchUrl(Uri.parse(url));
    } else {
      // Handle the case where the Microsoft Store app is not installed
      // or the URL scheme is not recognized.

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Unable to open the App. Would you like to Open Play Store?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await launchUrl(Uri.parse("ms-windows-store://"));
                  },
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(14),
                    child: const Text(
                      "okay",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // await launchUrl(Uri.parse("ms-windows-store://"));
                  },
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(14),
                    child: const Text("Go Back!"),
                  ),
                ),
              ],
            );
          });
    }
  }

  Future<void> _showPdfDialog(BuildContext context, String pdfUrl) async {
    var pdfDocument = await PDFDocument.fromURL(pdfUrl);
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return Scaffold(
          appBar: AppBar(
            // titleSpacing: width * 0.04,
            leading: KioskBackButton(
              onDashboard: false,
            ),
            // leadingWidth: width * 0.04,
            // toolbarOpacity: 0.1,
            title: Padding(
              padding: EdgeInsets.only(
                  bottom: 0.003 * MediaQuery.of(context).size.width),
              child: Text(
                widget.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 44,
                    fontWeight: FontWeight.w600),
              ),
            ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.06,
            backgroundColor: Colors.white.withOpacity(0.85),
            //Color(0xff7E869D),
          ),
          body: Stack(
            children: [
              PDFViewer(
                document: pdfDocument,
                scrollDirection: Axis.vertical,
                lazyLoad: true,
                enableSwipeNavigation: true,
              ),
              // Positioned(
              //   top: MediaQuery.of(context).size.width * 2 / 100,
              //   left: MediaQuery.of(context).size.width * 2 / 100,
              //   child: KioskBackButton(),
              // ),
            ],
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.width < size.height;
    final isSmallScreen = size.shortestSide <= 600;
    final buttonTextFontSize = isSmallScreen ? 12.0 : 16.0;
    final titleFontSize = isSmallScreen ? 16.0 : 20.0;
    final iconSize = isSmallScreen ? 24.0 : 32.0;

    return BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
        builder: (context, sensState) {
      return GestureDetector(
        onTap: () async {
          if (widget.isSensitive) {
            debugPrint("App Type : link || Starting the sensitive timer");
            sensState.st = St.reset;
            context
                .read<SensitiveTimerBloc>()
                .add(SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
          }
          print("Widget Link :: ${widget.link}");
          String? fileLink;
          if (widget.documentId != "null" &&
              widget.documentId != null &&
              widget.documentId != "") {
            fileLink = await getDocumentUrl(widget.documentId!);
            log("this is file link $fileLink");
          }
          if (widget.itemType == "pdf") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PdfViewerScreen(
                      pdfUrl: fileLink ?? widget.link,
                      pdfTitle: widget.title,
                      isSensitive: widget.isSensitive,
                      sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut,
                      sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut
                  );
                },
              ),
            );
          } else if (widget.itemType == "link") {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return KioskScaffold(
                    onDashboard: false,
                    body: CustomInAppWebView(
                      url: fileLink ?? widget.link,
                      isSensitive: widget.isSensitive,
                      sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut,
                      sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut
                    ),
                    // InAppWebView(
                    //   initialUrlRequest: URLRequest(
                    //     url: Uri.parse(widget.link),
                    //   ),
                    // ),
                    title: widget.title,
                    isSensitive: widget.isSensitive,
                    sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut,
                    sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut
                  );
                },
              ),
            );
          } else {
            openApp(widget.link);
          }
        },
        child: Container(
          padding: EdgeInsets.all(isPortrait ? 8 : 16),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0, 4),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
            color: widget.color.withOpacity(0.6),
            // Color.fromRGBO(22, 204, 130, 1),
            borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 30),
          ),
          height: isSmallScreen ? size.height * 0.25 : size.height * 0.3,
          width: isPortrait ? size.width * 0.1 : size.width * 0.15,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Positioned(
                  //   top: constraints.maxHeight * 0.3,
                  //   left: 16,
                  //   right: 16,
                  //   child:
                  Container(
                    child: Center(
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: widget.textColor,
                            fontSize: size.height / 40,
                            // titleFontSize,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  // ),
                  // Positioned(
                  //   top: constraints.maxHeight * 0.6,
                  //   left: 16,
                  //   right: 16,
                  //   child:
                  Container(
                    height: size.width < 400
                        ? constraints.maxHeight * 0.3
                        : constraints.maxHeight * 0.35,
                    width: constraints.maxWidth * 0.35,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.8),
                      // Color(0xff7E869D).withOpacity(0.7),

                      // Color.fromRGBO(0, 0, 0, 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isPortrait
                          ? constraints.maxWidth * 0.06
                          : constraints.maxWidth * 0.06),
                      child: SvgPicture.asset(
                        DashboardIcons.dashboardArrow,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                  // ),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _textController.dispose();
    super.dispose();
  }

  Future<String?> getDocumentUrl(String docId) async {
    print("this is file link doc id $docId");

    String? accessToken = await _authRepository.generateAccessToken();
    User me = await _authRepository.currentUser();
    String clientId = me.customAttribute2.userId;
    String companyId = me.customAttribute2.companyId;
    try {
      if (accessToken != null) {
        String getDocumentUrl =
            '${ApiConfig.baseUrl}/integrations/file-manager/document/$docId';
        var headers = {
          "x-api-key": ApiKey.webManagementConsoleApi,
          "Authorization": accessToken,
          "x-client-id": clientId,
          "x-company-id": companyId,
          "Content-Type": "application/json"
        };
        var response =
            await http.get(Uri.parse(getDocumentUrl), headers: headers);
        print('Document Data ${response.body}');
        print('Document status code ${response.statusCode}');
        var data = jsonDecode(response.body);
        print(data['info'].toString());
        var fileId = data['info']['file_id'];
        print("TYPE ::: ${fileId.runtimeType}");
        var fileBody = json.encode({
          "fileIds": [fileId]
        });
        try {
          var fileResponse = await http.post(
              Uri.parse(
                  '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
              body: fileBody,
              headers: headers);
          var responseData = json.decode(fileResponse.body);
          print(responseData);
          if (fileResponse.statusCode == 200 ||
              fileResponse.statusCode == 201) {
            return responseData["data"][0]["image"];
          } else {
            print("THIS IS INSIDE GET DOCUMENT URL ELSE ");
            // DebugLogger.debug("${fileResponse.statusCode}   ${fileResponse.body}");
            return null;
          }
        } catch (e) {
          DebugLogger.error("ERROR IN GET DOCUMENT URL 1 $e");
          return null;
        }
      }
    } catch (err) {
      DebugLogger.error("ERROR IN GET DOCUMENT URL 2 $err");
    }
    return null;
  }
}
