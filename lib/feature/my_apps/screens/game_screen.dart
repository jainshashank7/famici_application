import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/my_apps/blocs/my_apps_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../utils/barrel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.game}) : super(key: key);

  final Game game;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Completer<WebViewPlusController> _controller =
      Completer<WebViewPlusController>();

  @override
  void initState() {
    super.initState();
    context.read<MyAppsCubit>().gameLoading();
    _controller.future.asStream().listen(onWebViewCreated);
  }

  @override
  void dispose() {
    AutoOrientation.landscapeAutoMode();
    Future.delayed(Duration(seconds: 2));
    super.dispose();
  }

  void onWebViewCreated(WebViewPlusController controller) async {
    await Future.delayed(Duration(seconds: 2));
    switch (widget.game) {
      case Game.jigsaw:
        controller.loadUrl(GamePath.jigsaw);
        break;
      case Game.solitaire:
        controller.loadUrl(GamePath.solitaire);
        break;
      case Game.sudoku:
        AutoOrientation.portraitUpMode();
        controller.loadUrl(GamePath.sudoku);
        break;
      case Game.wordSearch:
        AutoOrientation.portraitUpMode();
        controller.loadUrl(GamePath.wordSearch);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewPlus(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) async {
              _controller.complete(controller);
            },
            navigationDelegate: (navigation) async {
              return NavigationDecision.navigate;
            },
            onPageStarted: (ops) async {
              context.read<MyAppsCubit>().gameLoaded();
            },
            onPageFinished: (opf) async {},
            onProgress: (data) async {},
            onWebResourceError: (err) async {},
          ),
          BlocBuilder<MyAppsCubit, MyAppsState>(
            builder: (context, state) {
              if (state.isLoaded) {
                return SizedBox.shrink();
              }
              return LoadingScreen();
            },
          ),
          Positioned(
            top: FCStyle.defaultFontSize,
            right: FCStyle.defaultFontSize,
            child: BlocBuilder<MyAppsCubit, MyAppsState>(
              builder: (context, state) {
                if (state.isLoaded) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorPallet.kBackground,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: CloseIconButton(
                      size: FCStyle.largeFontSize * 2,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
