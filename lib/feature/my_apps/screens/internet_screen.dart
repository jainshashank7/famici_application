import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/my_apps/blocs/my_apps_cubit.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';

class InternetScreen extends StatefulWidget {
  const InternetScreen({Key? key}) : super(key: key);

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  final Completer<WebViewPlusController> _controller =
      Completer<WebViewPlusController>();

  WebViewPlusController? _plusController;
  bool isWebView = true;

  @override
  void initState() {
    context.read<MyAppsCubit>().syncInternetLinks();
    context.read<MyAppsCubit>().loadingInternetPage();
    if (context.read<MyAppsCubit>().state.isFullScreen) {
      context.read<MyAppsCubit>().toggleFullScreen();
    }
    super.initState();

    _controller.future.asStream().listen((event) {
      _plusController = event;
      // Future.delayed(Duration(seconds: 2), () {
      //   _plusController?.loadUrl(googleUrl);
      // });
    });
  }

  @override
  void dispose() {
    AutoOrientation.landscapeAutoMode();

    super.dispose();
  }

  Future<Future<OverlayEntry?>> showUrlLoadingError(dynamic error) async {
    // fcRouter.pop();
    return FCAlert.showError("Unable to load the requested link.",
        duration: Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return FamiciScaffold(
        topRight: LogoutButton(),
        title: Center(
          child: Text(
            'Web Links',
            style: FCStyle.textStyle.copyWith(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 50.sp,
                fontWeight: FontWeight.w700),
          ),
        ),
        bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) => Stack(
            children: [
              LayoutBuilder(builder: (context, cons) {
                return Row(
                  children: [
                    BlocBuilder<MyAppsCubit, MyAppsState>(
                      builder: (context, state) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          width: state.isFullScreen ? 0 : cons.biggest.width,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 0, bottom: 10),
                            // padding: EdgeInsets.only(
                            //     right: 53 * FCStyle.fem,
                            //     left: 0,
                            //     top: 35 * FCStyle.fem,
                            //     bottom: 43 * FCStyle.fem),
                            padding: EdgeInsets.only(
                                top: 30 * FCStyle.fem,
                                left: 30 * FCStyle.fem,
                                right: 30 * FCStyle.fem,
                                bottom: 30 * FCStyle.fem),
                            decoration: BoxDecoration(
                                color: const Color(0xe5ffffff),
                                borderRadius: BorderRadius.circular(10)),

                            child: Scrollbar(
                              trackVisibility: true,
                              radius: Radius.circular(10),
                              thickness: 5,
                              thumbVisibility: true,
                              child: state.links.length > 0
                                  ? ListView.builder(
                                      itemCount: state.links.length,
                                      itemBuilder: (ctx, int index) {
                                        bool isLast =
                                            state.links.length == index + 1;
                                        return InkWell(
                                          onTap: () async {
                                            // if (isWebView) {
                                            //   await _plusController
                                            //       ?.loadUrl(
                                            //         state.links[index].link,
                                            //       )
                                            //       .catchError(showUrlLoadingError);

                                            //   setState(() {
                                            //     isWebView = false;
                                            //   });

                                            //   await Future.delayed(Duration(seconds: 2));
                                            // }

                                            // await _plusController
                                            //     ?.loadUrl(
                                            //       state.links[index].link,
                                            //     )
                                            //     .catchError(showUrlLoadingError);
                                            // await Future.delayed(Duration(seconds: 2));
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Stack(
                                                    children: [
                                                      BlocBuilder<MyAppsCubit,
                                                          MyAppsState>(
                                                        buildWhen: (curr,
                                                                prv) =>
                                                            curr.isFullScreen !=
                                                            prv.isFullScreen,
                                                        builder:
                                                            (context, screen) {
                                                          return AnimatedContainer(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    100),
                                                            width: cons
                                                                .biggest.width,
                                                            child: BlocBuilder<
                                                                ConnectivityBloc,
                                                                ConnectivityState>(
                                                              builder: (context,
                                                                  connection) {
                                                                if (connection
                                                                    .hasInternet) {
                                                                  return WebViewPlus(
                                                                    javascriptMode:
                                                                        JavascriptMode
                                                                            .unrestricted,
                                                                    onWebViewCreated:
                                                                        (controller) async {
                                                                      _controller
                                                                          .complete(
                                                                              controller);
                                                                    },
                                                                    initialUrl: state
                                                                        .links[
                                                                            index]
                                                                        .link,
                                                                    navigationDelegate:
                                                                        (navigation) async {
                                                                      return NavigationDecision
                                                                          .navigate;
                                                                    },
                                                                    onPageStarted:
                                                                        (ops) async {
                                                                      context
                                                                          .read<
                                                                              MyAppsCubit>()
                                                                          .loadedInternetUrl();
                                                                    },
                                                                    onPageFinished:
                                                                        (opf) async {
                                                                      context
                                                                          .read<
                                                                              MyAppsCubit>()
                                                                          .loadedInternetUrl();
                                                                    },
                                                                    onProgress:
                                                                        (data) async {
                                                                      if (data >
                                                                          10) {
                                                                        if (themeState
                                                                            .isDark) {
                                                                          _plusController
                                                                              ?.webViewController
                                                                              .runJavascript(
                                                                                '''document.getElementsByTagName("header")[0].remove();
                                                       document.getElementsByClassName("Fx4vi")[0].click();''',
                                                                              )
                                                                              .then(
                                                                                (value) => debugPrint(
                                                                                  'Page finished running Javascript',
                                                                                ),
                                                                              )
                                                                              .catchError(
                                                                                (onError) => debugPrint('$onError'),
                                                                              );
                                                                        } else {
                                                                          _plusController
                                                                              ?.webViewController
                                                                              .runJavascript(
                                                                                '''document.getElementsByTagName("header")[0].remove();''',
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
                                                                      }
                                                                    },
                                                                    onWebResourceError:
                                                                        showUrlLoadingError,
                                                                  );
                                                                }
                                                                // }
                                                                return Center(
                                                                  child: Text(
                                                                    "Please Check your internet connection.",
                                                                    style: FCStyle
                                                                        .textStyle
                                                                        .copyWith(
                                                                      fontSize:
                                                                          FCStyle
                                                                              .defaultFontSize,
                                                                      color: ColorPallet
                                                                          .kDark,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: BlocBuilder<
                                                            MyAppsCubit,
                                                            MyAppsState>(
                                                          builder: (context,
                                                              appState) {
                                                            return appState
                                                                    .isLoaded
                                                                ? appState.links
                                                                        .isNotEmpty
                                                                    ? SizedBox
                                                                        .shrink()
                                                                    : SizedBox(
                                                                        width: appState.isFullScreen
                                                                            ? cons.biggest.width
                                                                            : 0,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            "No shared links were found",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      )
                                                                : SizedBox(
                                                                    width: appState.isFullScreen
                                                                        ? cons
                                                                            .biggest
                                                                            .width
                                                                        : cons.biggest.width *
                                                                            2 /
                                                                            3,
                                                                    child:
                                                                        LoadingScreen(),
                                                                  );
                                                          },
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: FCStyle
                                                            .mediumFontSize,
                                                        right: FCStyle
                                                            .mediumFontSize,
                                                        child: FCMaterialButton(
                                                          elevation: 8,
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color: ColorPallet
                                                                .kPrimaryTextColor,
                                                            size: FCStyle
                                                                .xLargeFontSize,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6.3),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(0, 5),
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                )
                                              ],
                                              color: Colors.white,
                                              border: Border(
                                                left: BorderSide(
                                                    style: BorderStyle.solid,
                                                    strokeAlign: BorderSide
                                                        .strokeAlignInside,
                                                    color: ColorPallet.kPrimary,
                                                    width: 3),
                                                // bottom: isLast
                                                //     ? BorderSide(
                                                //         color: ColorPallet
                                                //             .kInverseBackground,
                                                //       )
                                                //     : BorderSide.none,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            height:
                                                FCStyle.xLargeFontSize * 2.3,
                                            width: state.isFullScreen
                                                ? 0
                                                : cons.biggest.width,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 23,
                                                  backgroundColor:
                                                      ColorPallet.kPrimary,
                                                  child: SvgPicture.asset(
                                                    VitalIcons.webLinks,
                                                    width: 40,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        state.links[index].link,
                                                        style: FCStyle.textStyle
                                                            .copyWith(
                                                                color:
                                                                    ColorPallet
                                                                        .kDark,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 30 *
                                                                    FCStyle
                                                                        .fem),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                        state.links[index]
                                                            .description,
                                                        style: FCStyle.textStyle
                                                            .copyWith(
                                                          fontSize:
                                                              22 * FCStyle.fem,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255,
                                                              102,
                                                              102,
                                                              102),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              14.5 * FCStyle.fem,
                                              0 * FCStyle.fem,
                                              0 * FCStyle.fem,
                                              15 * FCStyle.fem),
                                          child: Text(
                                            'Web Links list empty, No Web Link added yet.\n',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 40 * FCStyle.ffem,
                                              fontWeight: FontWeight.w500,
                                              height: 1 *
                                                  FCStyle.ffem /
                                                  FCStyle.fem,
                                              color: ColorPallet.kPrimary,
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   margin: EdgeInsets.fromLTRB(
                                        //       0 * FCStyle.fem,
                                        //       0 * FCStyle.fem,
                                        //       850.5 * FCStyle.fem,
                                        //       18 * FCStyle.fem),
                                        //   width: 8 * FCStyle.fem,
                                        //   height: 4 * FCStyle.fem,
                                        //   child: SvgPicture.asset(
                                        //     AssetIconPath.emptyMedicationIcon,
                                        //     width: 8 * FCStyle.fem,
                                        //     height: 4 * FCStyle.fem,
                                        //   ),
                                        // ),
                                        // Opacity(
                                        //   opacity: 1,
                                        //   child: Container(
                                        //     margin: EdgeInsets.fromLTRB(
                                        //         0 * FCStyle.fem,
                                        //         0 * FCStyle.fem,
                                        //         44.5 * FCStyle.fem,
                                        //         0 * FCStyle.fem),
                                        //     width: 370 * FCStyle.fem,
                                        //     height: 312.49 * FCStyle.fem,
                                        //     child: SvgPicture.asset(
                                        //       AssetIconPath.emptyMedicationIcon,
                                        //       width: 370 * FCStyle.fem,
                                        //       height: 312.49 * FCStyle.fem,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
              // BlocBuilder<MyAppsCubit, MyAppsState>(
              //   builder: (context, appState) {
              //     return Visibility(
              //       visible: !appState.isFullScreen,
              //       child: Positioned(
              //         top: FCStyle.largeFontSize,
              //         left: FCStyle.largeFontSize,
              //         child: FCBackButton(
              //           onPressed: () async {
              //             if (_plusController != null) {
              //               String _url = await _plusController
              //                       ?.webViewController
              //                       .currentUrl() ??
              //                   '';
              //               if (_url.isEmpty) {
              //                 fcRouter.pop();
              //                 // } else if (!_url.contains(googleUrl)) {
              //                 //   _plusController?.loadUrl(googleUrl);
              //               } else {
              //                 fcRouter.pop();
              //               }
              //             } else {
              //               fcRouter.pop();
              //             }
              //           },
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ));
  },
);
  }
}
