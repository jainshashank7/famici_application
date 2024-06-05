import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/core/screens/template/kiosk/kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:pdfx/pdfx.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/enitity/user.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../../../utils/config/color_pallet.dart';
import '../entity/sub_module_link.dart';
import '../widgets/custom_in_app_webview.dart';
import '../widgets/kiosk_scaffold.dart';
import '../widgets/pdf_viewer_screen.dart';
import 'grid_items.dart';
import 'kiosk_sub_dashboard_expanded.dart';

class DashboardListItem extends StatefulWidget {
  const DashboardListItem(
      {super.key,
      required this.title,
      required this.description,
      required this.hasSubModule,
      required this.icon,
      required this.iconColor,
      required this.id,
      required this.index,
      required this.color,
      required this.imageId,
      required this.textColor,
      required this.pageTitle,
      this.documentId,
      this.isSensitive = false,
      required this.sensitiveScreenTimeOut,
      required this.sensitiveAlertTimeOut,
      });

  final String pageTitle;
  final String icon;
  final String title;
  final String imageId;
  final String description;
  final bool hasSubModule;
  final Color iconColor;
  final int id;
  final int index;
  final Color color;
  final Color textColor;
  final bool isSensitive;
  final int sensitiveScreenTimeOut;
  final int sensitiveAlertTimeOut;
  final String? documentId;

  @override
  State<DashboardListItem> createState() => _DashboardListItemState();
}

class _DashboardListItemState extends State<DashboardListItem> {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isExpanded = false;

  final _textController = TextEditingController();

  final List<StreamSubscription> _subscriptions = [];

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  final AuthRepository _authRepository = AuthRepository();

  Future<String> getImageUrl(String fileId) async {
    final prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString('sessionId') ?? "";
    String companyId = prefs.getString('companyId') ?? "";
    String clientId = prefs.getString('clientId') ?? "";
    String? accessToken = await _authRepository.generateAccessToken();
    var headers;
    if (accessToken != null) {
      headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };
    } else {
      headers = {};
    }
    print("this is 3rdparty data file id " + fileId);
    var imageBody = json.encode({
      "fileIds": [fileId]
    });
    if (accessToken != null) {
      try {
        var responseImages = await http.post(
            Uri.parse(
                '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
            body: imageBody,
            headers: headers);

        var reponseImageData = json.decode(responseImages.body);
        if (responseImages.statusCode == 200 ||
            responseImages.statusCode == 201) {
          print("this is 3rdparty data one " +
              reponseImageData["data"][0]["image"]);
          return reponseImageData["data"][0]["image"];
        } else {
          print("this is 3rdparty data no data  two ");
          return "";
        }
      } catch (e) {
        print("this is 3rdparty data no data error " + e.toString());
        DebugLogger.error(e);
        return "";
      }
      ;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(' hey a widget data ' + widget.title.toString());
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
          builder: (context, state) {
            List<SubModuleLink> list = state.subModuleLinks[widget.id] ?? [];
            return BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
                builder: (sensContext, sensState) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print(
                          "this is id ${state.subModuleItems[widget.index].documentId}");
                      if (state.subModuleItems[widget.index].allow3rdParty ==
                          true) {
                        if (Platform.isAndroid) {
                          print("hey im prinitng the android id " +
                              state.subModuleItems[widget.index].androidId);
                          try {
                            await LaunchApp.openApp(
                              androidPackageName:
                                  state.subModuleItems[widget.index].androidId,
                            );
                          } catch (err) {
                            try {
                              await launchUrl(Uri.parse(
                                  'https://play.google.com/store/apps/details?id=${state.subModuleItems[widget.index].androidId}'));
                            } catch (err) {
                              DebugLogger.error("heyyy prob " + err.toString());
                            }
                          }
                        } else if (Platform.isIOS) {
                          await LaunchApp.openApp(
                            iosUrlScheme:
                                state.subModuleItems[widget.index].iosId,
                            // openStore: false
                          );
                        } else if (Platform.isWindows) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Alert!",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                      "This App is not available on Windows...."),
                                  actions: <Widget>[
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
                      } else if (state.subModuleItems[widget.index].url == "" &&
                          (state.subModuleItems[widget.index].documentId ==
                                  null ||
                              state.subModuleItems[widget.index].documentId ==
                                  "" ||
                              state.subModuleItems[widget.index].documentId ==
                                  "null")) {
                        // setState(() {
                        //   _isExpanded = !_isExpanded;
                        // });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DashboardExpandedListItem(
                                  imageId: widget.imageId,
                                  pageTitle: widget.pageTitle,
                                  title: widget.title,
                                  description: widget.description,
                                  hasSubModule: widget.hasSubModule,
                                  icon: widget.icon,
                                  documentId: widget.documentId,
                                  iconColor: widget.iconColor,
                                  id: widget.id,
                                  index: widget.index,
                                  color: widget.color,
                                  textColor: widget.textColor);
                            },
                          ),
                        );
                      }
                      else {
                        if (widget.isSensitive) {
                          debugPrint(
                              "App Type : video link or web link} || Starting the sensitive timer");
                          sensState.st = St.reset;
                          context
                              .read<SensitiveTimerBloc>()
                              .add(SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                        }
                        String? fileLink;
                        if (state.subModuleItems[widget.index].documentId !=
                                null &&
                            state.subModuleItems[widget.index].documentId !=
                                "" &&
                            state.subModuleItems[widget.index].documentId !=
                                "null") {
                          fileLink = await getDocumentUrl(
                              state.subModuleItems[widget.index].documentId!);
                          print("this is file link $fileLink");
                        }
                        if (state.subModuleItems[widget.index].moduleType == "pdf") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PdfViewerScreen(
                                    pdfUrl: fileLink ??
                                        state.subModuleItems[widget.index].url,
                                    pdfTitle: state
                                        .subModuleItems[widget.index].title,
                                    isSensitive: state
                                        .subModuleItems[widget.index]
                                        .isSensitive,
                                  sensitiveScreenTimeOut: state
                                      .subModuleItems[widget.index].sensitiveScreenTimeOut ?? 30,
                                  sensitiveAlertTimeOut: state
                                      .subModuleItems[widget.index].sensitiveAlertTimeOut ?? 30,
                                );
                              },
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return KioskScaffold(
                                    onDashboard: false,
                                    body: CustomInAppWebView(
                                      url: fileLink ??
                                          state
                                              .subModuleItems[widget.index].url,
                                          isSensitive: widget.isSensitive,
                                          sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut,
                                          sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut,
                                      ),
                                      // InAppWebView(
                                      //   initialUrlRequest: URLRequest(
                                      //     url: Uri.parse(state
                                      //         .subModuleItems[widget.index].url),
                                      //   ),
                                      // ),
                                      title:
                                          state.subModuleItems[widget.index].title,
                                      isSensitive: widget.isSensitive,
                                      sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut,
                                      sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut,
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? size.height * 0.2
                            : size.height * 0.11,
                        width: double.infinity,
                        margin: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? EdgeInsets.only(left: 20, right: 20, top: 10)
                            : width >= 1200
                                ? EdgeInsets.only(left: 50, right: 50, top: 50)
                                : EdgeInsets.only(
                                    left: width * 0.04,
                                    right: width * 0.04,
                                    top: height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: state.subModuleItems[widget.index].allow3rdParty ==
                                      true &&
                                  Platform.isWindows
                              ? Colors.grey
                              : state.subModuleItems[widget.index].buttonColor,
                          // Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.12,
                              height: size.height * 0.09,
                              // margin: EdgeInsets.fromLTRB(
                              //     size.width * 0.03, 10, 10, 10),
                              child: FutureBuilder<String>(
                                  future: getImageUrl(widget.imageId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // Handle the error state
                                        return SizedBox(
                                          height: size.height * 0.04,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              // Icon(Icons.broken_image, size: 50 * FCStyle.fem, color: ColorPallet.kPrimaryTextColor,),
                                              Text(snapshot.error.toString()),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                    final imageUrl = snapshot.data;
                                    return CachedNetworkImage(
                                      imageUrl: imageUrl ?? "",
                                      placeholder: (context, url) => SizedBox(
                                        height: size.height * 0.04,
                                        child: Shimmer.fromColors(
                                          baseColor: ColorPallet.kWhite,
                                          highlightColor: ColorPallet.kPrimaryGrey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.photo,
                                                size: size.height * 0.04,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.broken_image,
                                              color: ColorPallet.kPrimaryTextColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration:
                                          const Duration(milliseconds: 100),
                                    );
                                  }),
                            ),
                            SizedBox(width: 0),
                            Expanded(
                              child: Container(
                                margin: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? EdgeInsets.only(top: 10, bottom: 5)
                                    : EdgeInsets.zero,
                                padding: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? const EdgeInsets.only(
                                        left: 10, right: 10, top: 10)
                                    : const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(
                                          color: state.subModuleItems[widget.index].textColor,
                                          fontSize:
                                              MediaQuery.of(context).orientation ==
                                                      Orientation.landscape
                                                  ? width / 60
                                                  : height / 56,
                                          decoration: TextDecoration.none,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.description,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              MediaQuery.of(context).orientation ==
                                                      Orientation.landscape
                                                  ? width / 70
                                                  : height / 80,
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          decoration: TextDecoration.none,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: size.width * 0.015),
                              child: Icon(
                                _isExpanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                                size: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? size.width / 20
                                    : width > 1200
                                        ? 120
                                        : 60,
                                color: widget.iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isExpanded)
                      Container(
                        margin: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? EdgeInsets.only(left: 20, right: 20, top: 0)
                            : width >= 1200
                                ? EdgeInsets.only(left: 50, right: 50, top: 0)
                                : EdgeInsets.only(
                                    left: width * 0.04,
                                    right: width * 0.04,
                                    top: 0),
                        // color: Colors.blue,
                        height: width < 400
                            ? height * 0.12 * (list.length / 3).ceil()
                            : width > 900
                                ? size.height * 0.23 * (list.length / 3).ceil()
                                : size.height * 0.13 * (list.length / 3).ceil(),
                        width: double.infinity,
                        child: GridItems(
                          gridViewItemList: list,
                          color: widget.color,
                          textColor: widget.textColor,
                        ),
                      ),
                    // )
                  ],
                );
              }
            );
          },
        );
      },
    );
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
