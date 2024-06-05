import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:famici/core/screens/template/kiosk/kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:pdfx/pdfx.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../feature/kiosk_generic/widgets/custom_in_app_webview.dart';
import '../../../../../feature/kiosk_generic/widgets/kiosk_scaffold.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../utils/config/api_config.dart';
import '../../../../../utils/config/api_key.dart';
import '../../../../../utils/config/color_pallet.dart';


class RSSListItem extends StatefulWidget {
  const RSSListItem(
      {super.key,
        required this.title,
        required this.description,
        required this.icon,
        required this.buttonColor,
        required this.iconColor,
        required this.id,
        required this.index,
        required this.color,
        required this.textColor,
        required this.url,
        this.isSensitive,
        this.sensitiveScreenTimeOut,
        this.sensitiveAlertTimeOut,
      });

  final String icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color buttonColor;
  final int id;
  final int index;
  final Color color;
  final Color textColor;
  final String url;
  final bool? isSensitive;
  final int? sensitiveScreenTimeOut;
  final int? sensitiveAlertTimeOut;

  @override
  State<RSSListItem> createState() => _RSSListItemState();
}

class _RSSListItemState extends State<RSSListItem> {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isExpanded = false;

  // late KeyboardEvent keyboardEvent;


  final _textController = TextEditingController();

  final List<StreamSubscription> _subscriptions = [];

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    try {


      // await _controller.loadUrl("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
      // await _controller.loadUrl("https://css4.pub/2017/newsletter/drylab.pdf");
      // url = await controller.url.toString();
      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code: ${e.code}'),
                  if (e.message == "") Text('Message: ${e.message}'),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      });
    }
  }

  final AuthRepository _authRepository = AuthRepository();

  Future<String> getImageUrl(String fileId) async {
    final prefs = await SharedPreferences.getInstance();
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
    // print("this is Dashboard List data file id " + fileId);
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
        // print("Image Data df ::: ${reponseImageData}");
        if (responseImages.statusCode == 200 ||
            responseImages.statusCode == 201) {
          // print("this is Dashboard List data one " +
          //     reponseImageData["data"][0]["image"]);
          return reponseImageData["data"][0]["image"];
        } else {
          print("this is Dashboard List data no data  two ");
          return "";
        }
      } catch (e) {
        print("this is 3rdparty data no data error " + e.toString());
        DebugLogger.error(e);
        return "";
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Offset? clickDetails;

    return BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (details) {
            clickDetails = details.globalPosition;
          },
          onTap: () async {

            // TrackEvents().trackEvents("RSS Module", {
            //   "action": "Open RSS Feed",
            //   "url": widget.url,
            //   "click_coordinates":
            //   "{${clickDetails?.dx.ceil().toString()}, ${clickDetails?.dy.ceil().toString()}}",
            //   "module_display_name": widget.title
            // });
            Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return KioskScaffold(
                    onDashboard: true,
                    body: CustomInAppWebView(
                      url: widget.url,
                      isSensitive: widget.isSensitive ?? false,
                      sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut ?? 30,
                      sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut ?? 15
                    ),
                    // InAppWebView(
                    //   initialUrlRequest: URLRequest(
                    //     url: Uri.parse(widget.link),
                    //   ),
                    // ),
                    title: widget.title,
                    sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut ?? 30,
                    sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut ?? 15
                );
              },));
          },
          child: Stack(children: [
            Padding(
              padding:
              EdgeInsets.fromLTRB(0.015625 * width, 0, 0.03125 * width, 0),
              child: Container(
                height:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0.23 * height
                    : 0.13 * height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white,
                ),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        constraints.maxWidth * 0.025,
                        constraints.maxHeight * 0.025,
                        0,
                        constraints.maxHeight * 0.025),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:
                          CachedNetworkImage(
                            imageUrl: widget.icon,
                            width: constraints.maxWidth * 0.25,
                            height: constraints.maxHeight * 0.8,
                            fit: BoxFit.fitHeight,
                            placeholder: (context, url) => SizedBox(
                              height: size.height * 0.04,
                              child: Shimmer.fromColors(
                                baseColor: ColorPallet.kWhite,
                                highlightColor: ColorPallet.kPrimaryGrey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: size.height * 0.04,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: constraints.maxWidth * 0.25,
                              height: constraints.maxHeight * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      Icons.photo,
                                    ),
                                  ),
                                  Text(
                                    "No Image",
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black,
                                      fontSize:
                                      MediaQuery.of(context).orientation ==
                                          Orientation.landscape
                                          ? width / 60
                                          : height / 56,
                                      decoration: TextDecoration.none,
                                      fontFamily:
                                      GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: widget.id,
                                  ),
                                ],
                              ),
                            ),
                            //     SizedBox(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: <Widget>[
                            //       Icon(
                            //         Icons.broken_image,
                            //         color: ColorPallet.kPrimaryTextColor,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            fadeInCurve: Curves.easeIn,
                            fadeInDuration: const Duration(milliseconds: 100),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              constraints.maxWidth * 0.03,
                              constraints.maxHeight * 0.07,
                              0,
                              0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: widget.id == 1
                                    ? constraints.maxHeight * 0.25
                                    : constraints.maxHeight * 0.40,
                                width: constraints.maxWidth * 0.55,
                                // color: Colors.orange,
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize:
                                    MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                        ? width / 60
                                        : height / 56,
                                    decoration: TextDecoration.none,
                                    fontFamily:
                                    GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: widget.id,
                                ),
                              ),
                              Container(
                                height: constraints.maxHeight * 0.40,
                                width: constraints.maxWidth * 0.6,
                                // color: Colors.blue,
                                child: Text(
                                  widget.description,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                    MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                        ? width / 60
                                        : height / 70,
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
                      ],
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 0.09 * height
                  : 0.045 * height,
              right: 0.022 * width,
              child: Container(
                height:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0.06 * height
                    : 0.042 * height,
                width: 0.05 * width,
                decoration: BoxDecoration(
                    color: Color(0xff484CBE),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: MediaQuery.of(context).orientation ==
                      Orientation.landscape
                      ? 0.039 * height
                      : 0.03 * height,
                ),
              ),
            ),
          ]),
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
}
