import 'dart:async';
import 'dart:io';

import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

import '../../../core/screens/multiple_user_screen/entity/window_obsever.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';

class CustomInAppWebView extends StatefulWidget {
  final String url;
  final bool isSensitive;
  final int sensitiveScreenTimeOut;
  final int sensitiveAlertTimeOut;

  // final String title;
  const CustomInAppWebView({super.key, required this.url, required this.isSensitive, required this.sensitiveScreenTimeOut, required this.sensitiveAlertTimeOut});

  @override
  _CustomInAppWebViewState createState() => new _CustomInAppWebViewState();
}

class _CustomInAppWebViewState extends State<CustomInAppWebView> {
  final GlobalKey webViewKey = GlobalKey();

  WebViewPlusController? _controller;

  VideoPlayerController videoPlayerController =
      VideoPlayerController.networkUrl(Uri.parse(""));
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: true,
          javaScriptEnabled: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  // String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool isLinkLoading = true;

  Timer? _timer;

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

    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
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
    _timer?.cancel();
    webViewController?.clearCache();
    webViewController?.clearFocus();
    webViewKey.currentState?.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timer?.cancel();
    if (widget.url
        .contains("https://mobex-hh-pm-s3-bucket.s3.us-west-2.amazonaws.com")) {
      videoPlayerController.initialize().then((value) {
        videoPlayerController.play();
      });
    }
    print(widget.url);
    return BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
      builder: (sensContext, sensState) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      KeyboardVisibilityBuilder(
                        builder: (context, child, isKeyboardVisible) {
                          if (isKeyboardVisible) {
                            _timer =
                                Timer.periodic(const Duration(seconds: 3), (timer) {
                              print("resttting");

                              // context.read<DigitalSignageBloc>().add(
                              //     ResetScreenSaverTimer(
                              //         logout: false,
                              //         context: context,
                              //         isSensitive: widget.isSensitive));
                            });
                            return Container();
                          } else {
                            _timer?.cancel();
                            return Container();
                          }
                        },
                        child: GestureDetector(
                            onTap: () {
                              print("In Custom App View Tap");
                              // context.read<DigitalSignageBloc>().add(
                              //     ResetScreenSaverTimer(
                              //         logout: false,
                              //         context: context,
                              //         isSensitive: widget.isSensitive));
                            },
                            child: Container()),
                      ),
                      widget.url.contains("https://mobex-hh-pm-s3-bucket.s3.us-west-2.amazonaws.com")
                        ? VideoPlayer(videoPlayerController)
                        : InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                            initialOptions: options,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (controller) {
                              webViewController = controller;
                              print("Webview Created");

                              controller.addJavaScriptHandler(
                                  handlerName: "onTouchStart",
                                  callback: (args) {
                                    if(widget.isSensitive) {
                                      sensState.st = St.reset;
                                      context.read<SensitiveTimerBloc>().add(
                                          SensitiveTimerEvent(context: context,sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                                    }
                                  }
                              );

                              controller.addJavaScriptHandler(
                                  handlerName: "onTouchMove",
                                  callback: (args) {
                                    if(widget.isSensitive) {
                                      sensState.st = St.reset;
                                      context.read<SensitiveTimerBloc>().add(
                                          SensitiveTimerEvent(context: context,sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                                    }
                                  }
                              );

                              controller.addJavaScriptHandler(
                                  handlerName: "onScroll",
                                  callback: (args) {
                                    if(widget.isSensitive) {
                                      sensState.st = St.reset;
                                      context.read<SensitiveTimerBloc>().add(
                                          SensitiveTimerEvent(context: context,sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                                    }
                                  }
                              );
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
                                if (await canLaunchUrlString(widget.url)) {
                                  // Launch the App
                                  await launchUrlString(
                                    widget.url,
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
                                urlController.text = widget.url;
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
                                if(widget.isSensitive){
                                  sensState.st = St.reset;
                                  context.read<SensitiveTimerBloc>().add(
                                      SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: widget.sensitiveScreenTimeOut, sensitiveAlertTimeOut: widget.sensitiveAlertTimeOut));
                                }
                                pullToRefreshController.endRefreshing();
                                controller.evaluateJavascript(source: '''
                                  document.addEventListener('touchstart', (event) => {
                                    window.flutter_inappwebview.callHandler('onTouchStart');
                                  });
                                  document.addEventListener('touchmove', (event) => {
                                    window.flutter_inappwebview.callHandler('onTouchMove');
                                  });
                                  document.addEventListener('scroll', (event) => {
                                    window.flutter_inappwebview.callHandler('onScroll');
                                  });
                                  // const _video = document.getElementsByTagName("video");
                                  // _video[0].addEventListener('play', (event) => {
                                  //   window.flutter_inappwebview.callHandler('onPlay');
                                  // });
                                  // _video[0].addEventListener('pause', (event) => {
                                  //   window.flutter_inappwebview.callHandler('onPause');
                                  // });
                                ''');
                              }
                              setState(() {
                                this.progress = progress / 100;
                                urlController.text = widget.url;
                              });
                            },
                            onUpdateVisitedHistory: (controller, url, androidIsReload) {
                              setState(() {
                                // this.url = url.toString();
                                urlController.text = widget.url;
                              });
                            },
                            onConsoleMessage: (controller, consoleMessage) {
                              print("Console Message ::: ${consoleMessage}");
                            },
                            onScrollChanged: (controller,_,__){
                            },
                          ),
                      // progress < 1.0 ? LoadingScreen() : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
