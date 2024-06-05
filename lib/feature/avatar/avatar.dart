import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../core/router/router_delegate.dart';
import '../../utils/constants/assets_paths.dart';

class AvatarWebView extends StatefulWidget {
  const AvatarWebView({Key? key}) : super(key: key);

  @override
  State<AvatarWebView> createState() => _AvatarWebViewState();
}

class _AvatarWebViewState extends State<AvatarWebView> {
  late final WebViewPlusController? _webViewController;
  late final Widget _webview;
  double height = 200;
  var _isListening = false;
  String _text = 'Hi';
  SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _webview = Stack(
      children: [
        SizedBox(
          height: height,
          width: 450,
          child: IgnorePointer(
            ignoring: true,
            child: WebViewPlus(
              backgroundColor: Colors.transparent,
              serverPort: 5353,
              javascriptChannels: {
                JavascriptChannel(
                    name: 'Height',
                    onMessageReceived:
                        (JavascriptMessage message) {
                      setState(() {
                        height = double.parse(message.message);
                      });
                    }),
                JavascriptChannel(
                    name: 'Id',
                    onMessageReceived: (JavascriptMessage message) {
                      List<String> ids = message.message.split("+");
                      String id = ids[0].trim();
                      switch (id) {
                        case "medication":
                          fcRouter.navigate(MyMedicineRoute());
                          break;
                        case "mp":
                          fcRouter.navigate(MemberHomeRoute());
                          break;
                        case "vitals":
                          fcRouter.navigate(VitalsAndWellnessRoute());
                          break;
                        default:
                          break;
                      }
                    }),
                JavascriptChannel(
                    name: 'Close',
                    onMessageReceived:
                        (JavascriptMessage message) {
                      if (message.message == 'close') {
                        setState(() {
                          // _isWebView = !_isWebView;
                        });
                      }
                    }),
                JavascriptChannel(
                    name: 'Mic',
                    onMessageReceived:
                        (JavascriptMessage message) {})
              },
              initialUrl: Avatar.avatar,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onPageFinished: (url) {
                // setState(() {
                //   var m = 'listenData("${_text}")'.toString();
                //   _webViewController?.webViewController
                //       .evaluateJavascript(m);
                // });
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
        Positioned(
            right: 150,
            bottom: -28,
            child: Visibility(
              visible: true,
              child: AvatarGlow(
                  endRadius: 75.0,
                  animate: _isListening,
                  duration: const Duration(milliseconds: 2000),
                  glowColor: Colors.blueGrey,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  repeat: true,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (detail) async {
                        if (!_isListening) {
                          var available = await speech.initialize();
                          if (available) {
                            setState(() {
                              _isListening = true;
                              speech.listen(
                                onDevice: false,
                                onResult: (result) {
                                  setState(() {
                                    _text = result.recognizedWords;
                                  });
                                },
                              );
                            });
                          }
                        }
                      },
                      onTapUp: (detail) async {
                        setState(() {
                          _isListening = false;
                        });

                        speech.stop();
                        var m = 'listenData("${_text}")';
                        _webViewController?.webViewController
                            .runJavascript(m);
                        // _webViewController?.webViewController
                        //     .runJavascript(m);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 35,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 40,
                          color: Colors.white,
                        ),
                      ))),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _webview;
  }
}
