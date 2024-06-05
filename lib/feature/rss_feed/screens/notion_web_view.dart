import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../core/screens/loading_screen/loading_screen.dart';

class NotionWebView extends StatefulWidget {
  const NotionWebView({
    Key? key,
    required String url,
  })  : _url = url,
        super(key: key);

  final String _url;

  @override
  State<NotionWebView> createState() => _NotionWebViewState();
}

class _NotionWebViewState extends State<NotionWebView> {
  final Completer<WebViewPlusController> _controller =
      Completer<WebViewPlusController>();

  WebViewPlusController? _plusController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller.future.asStream().listen((event) {
      _plusController = event;
      _plusController?.loadUrl(widget._url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) async {
            _controller.complete(controller);
          },
          navigationDelegate: (navigation) async {
            return NavigationDecision.prevent;
          },
          onPageStarted: (ops) async {},
          onPageFinished: (opf) async {
            setState(() {
              isLoading = false;
            });
          },
          onProgress: (data) async {
            if (data > 70) {
              _plusController?.webViewController
                  .runJavascript(
                    '''document.getElementsByClassName("notion-topbar-mobile")[0].remove();''',
                  )
                  .then(
                    (value) => debugPrint(
                      'Page finished running Javascript',
                    ),
                  )
                  .catchError(
                    (onError) => debugPrint('$onError'),
                  );
            }
          },
          onWebResourceError: (err) async {},
        ),
        isLoading ? LoadingScreen() : SizedBox.shrink()
      ],
    );
  }
}
