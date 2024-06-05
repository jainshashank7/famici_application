import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/utils/config/api_config.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../repositories/auth_repository.dart';
import '../../loading_screen/loading_screen.dart';

class CustomWebViewScreen extends StatefulWidget {
  final String url;
  final String phoneNumber;
  final String dtmsSettings;
  final String dtmsEnabled;

  // final String title;
  const CustomWebViewScreen({super.key, required this.url,required this.phoneNumber,
    required this.dtmsSettings,
    required this.dtmsEnabled,});

  @override
  _CustomWebViewScreenState createState() => new _CustomWebViewScreenState();
}

class _CustomWebViewScreenState extends State<CustomWebViewScreen> {
  final AuthRepository _authRepository = AuthRepository();
  String accessToken = "";

  final GlobalKey webViewKey = GlobalKey();

  WebViewPlusController? _controller;

  VideoPlayerController videoPlayerController =
      VideoPlayerController.networkUrl(Uri.parse(""));
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          javaScriptEnabled: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  String currentUrl = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool isLinkLoading = true;

  Map<String, String> oldParam = {};

  // Timer? _timer;

  Future<void> askPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var microPhoneStatus = await Permission.microphone.status;

    if (cameraStatus.isDenied || microPhoneStatus.isDenied) {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();
    }
  }

  @override
  void initState() {
    askPermissions();

    super.initState();

    getAccessToken();
    currentUrl = widget.url;

    oldParam = Uri.parse(currentUrl).queryParameters;

    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(currentUrl));
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    // _timer?.cancel();
    webViewController?.clearCache();
    webViewController?.clearFocus();
    webViewKey.currentState?.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("$currentUrl  $accessToken");

    log("DTMS SETTINGS :::: ${widget.dtmsSettings}");
    var dtms = jsonEncode(widget.dtmsSettings);
    print("IS DTMS ENABLED :::: ${widget.dtmsEnabled}");
    Map<String, String> queryParams = {
      ...oldParam,
      oldParam["token"] ?? 'token': accessToken,
      'env': ApiConfig.callEnv,
      'phoneNumber':widget.phoneNumber,
      'dtmsSettingsEnabled':widget.dtmsEnabled,
      'dtms': Uri.encodeComponent(dtms)
    };

    currentUrl =
        Uri.parse(currentUrl).replace(queryParameters: queryParams).toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  accessToken != ""
                      ? InAppWebView(
                          key: webViewKey,
                          initialUrlRequest:
                              URLRequest(url: Uri.parse(currentUrl)),
                          initialOptions: options,
                          pullToRefreshController: pullToRefreshController,
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                            print("Webview Created");
                          },
                          onLoadStart: (controller, url) {
                            setState(() {
                              // this.url = url.toString();
                              urlController.text = widget.url;
                            });
                          },
                          androidOnPermissionRequest:
                              (controller, origin, resources) async {
                            return PermissionRequestResponse(
                                resources: resources,
                                action: PermissionRequestResponseAction.GRANT);
                          },
                          shouldOverrideUrlLoading:
                              (controller, navigationAction) async {
                            print("Inside Should OverrideUrlLoading");
                            DebugLogger.info(navigationAction.request.url);

                            var uri = navigationAction.request.url!;
                            if (![
                              "http",
                              "https",
                              "file",
                              "chrome",
                              "data",
                              "javascript",
                              "about"
                            ].contains(uri.scheme)) {
                              if (await canLaunchUrlString(currentUrl)) {
                                // Launch the App
                                await launchUrlString(
                                  currentUrl,
                                );
                                // and cancel the request
                                return NavigationActionPolicy.CANCEL;
                              }
                            }
                            return NavigationActionPolicy.ALLOW;
                          },
                          onLoadStop: (controller, url) async {
                            pullToRefreshController.endRefreshing();
                            setState(() {
                              // this.url = url.toString();
                              urlController.text = currentUrl;
                              isLinkLoading = false;
                            });
                          },
                          onLoadError: (controller, url, code, message) {
                            print("ERRRRROOOOOORRRRRR");
                            DebugLogger.error(code);
                            DebugLogger.error(message);
                            pullToRefreshController.endRefreshing();
                          },
                          onProgressChanged: (controller, progress) {
                            if (progress == 100) {
                              pullToRefreshController.endRefreshing();
                            }
                            setState(() {
                              this.progress = progress / 100;
                              urlController.text = currentUrl;
                            });
                          },
                          onUpdateVisitedHistory:
                              (controller, url, androidIsReload) {
                            setState(() {

                             if(url.toString().contains("call-ended")){
                               fcRouter.pop();
                             }
                              urlController.text = currentUrl;
                            });
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            print("Console Message ::: ${consoleMessage}");
                          },
                          onScrollChanged: (controller, _, __) {},
                        )
                      : const LoadingScreen(),
                  progress < 1.0 ? const LoadingScreen() : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAccessToken() async {
    String? res = await _authRepository.generateAccessToken();
    setState(() {
      accessToken = res ?? "";
    });

    webViewController?.reload();
  }
}
