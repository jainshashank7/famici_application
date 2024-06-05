import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import 'package:famici/core/blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../feature/kiosk_generic/screen/kiosk_sub_dashboard.dart';
import '../../../../feature/kiosk_generic/widgets/custom_in_app_webview.dart';
import '../../../../feature/kiosk_generic/widgets/kiosk_scaffold.dart';
import '../../../../feature/kiosk_generic/widgets/pdf_viewer_screen.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/constants/enums.dart';
import '../../home_screen/home_screen.dart';
import '../../loading_screen/loading_screen.dart';
import 'entity/main_module_item.dart';

// import 'kiosk_back_button.dart';
import 'entity/see_all_screen.dart';
import 'kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';

class KioskDashboardScreen extends StatefulWidget {
  KioskDashboardScreen({Key? key, required this.dashboardUsed})
      : super(key: key);

  final int dashboardUsed;

  @override
  State<KioskDashboardScreen> createState() => _KioskDashboardScreenState();
}

class _KioskDashboardScreenState extends State<KioskDashboardScreen> {
  @override
  void initState() {
    context.read<KioskDashboardBloc>().add(FetchMainModuleDetailsEvent(
        hasUpdate: false, dashboardUsed: widget.dashboardUsed));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // TODO: implement initState
    super.initState();
  }

  Widget _widget(Color color, BuildContext context, MainModuleItem index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Offset? clickDetails;
    return StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            0.015625 * MediaQuery.of(context).size.width,
            0,
            0.015625 * MediaQuery.of(context).size.width,
            0.02910 * MediaQuery.of(context).size.height),
        child: BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
          builder: (context, state) {
            return index.title == 'empty-we-made-it'
                ? SizedBox()
                : BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
                  builder: (sensContext, sensState) {
                    return GestureDetector(
                        onTapDown: (details) {
                          clickDetails = details.globalPosition;
                        },
                        onTap: () async {
                          switch (index.type) {
                            case "RSS":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RSSSeeAllScreen(),
                                ),
                              );
                              break;
                            case "weblink":
                              if(index.isSensitive) {
                                sensState.st = St.reset;
                                context.read<SensitiveTimerBloc>().add(
                                    SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30, sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15));
                              }
                              Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) {
                                  return KioskScaffold(
                                      onDashboard: true,
                                      body: CustomInAppWebView(
                                        url: index.url,
                                        isSensitive: index.isSensitive,
                                        sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30,
                                          sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15
                                      ),
                                      // InAppWebView(
                                      //   initialUrlRequest: URLRequest(
                                      //     url: Uri.parse(widget.link),
                                      //   ),
                                      // ),
                                      title: index.title,
                                      sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30,
                                      sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15
                                  );
                                },
                              ));
                              break;
                            case "pdf":
                              if(index.isSensitive) {
                                sensState.st = St.reset;
                                context.read<SensitiveTimerBloc>().add(
                                    SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30, sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15));
                              }
                              String? fileLink = index.url;
                              if(index.documentId != "null" && index.documentId != null && index.documentId != ""){
                                fileLink = await getDocumentUrl(
                                    index.documentId!);
                                print("this is file $fileLink");
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PdfViewerScreen(
                                      pdfUrl: fileLink ?? "",
                                      pdfTitle: index.title,
                                      isSensitive: index.isSensitive,
                                      sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30,
                                      sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 30,
                                    );
                                  },
                                ),
                              );
                              break;
                            case "video":
                              if(index.isSensitive) {
                                sensState.st = St.reset;
                                context.read<SensitiveTimerBloc>().add(
                                    SensitiveTimerEvent(context: context, sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30, sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15));
                              }
                              String? fileLink = index.url;
                              if(index.documentId != "null" && index.documentId != null && index.documentId != ""){
                                 fileLink = await getDocumentUrl(
                                    index.documentId!);
                              }
                              Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) {
                                  return KioskScaffold(
                                      onDashboard: true,
                                      body: CustomInAppWebView(
                                        url: fileLink ?? "" ,
                                        isSensitive: index.isSensitive,
                                        sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30,
                                        sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15
                                      ),
                                      // InAppWebView(
                                      //   initialUrlRequest: URLRequest(
                                      //     url: Uri.parse(widget.link),
                                      //   ),
                                      // ),
                                      title: index.title,
                                    sensitiveScreenTimeOut: index.sensitiveScreenTimeOut ?? 30,
                                    sensitiveAlertTimeOut: index.sensitiveAlertTimeOut ?? 15
                                  );
                                },
                              ));
                              break;
                            case "module":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KioskSubDashboard(
                                          title: index.title,
                                          id: index.id,
                                          color: index.color != null
                                              ? index.color!
                                              : ColorPallet.kPrimary,
                                          textColor: index.textColor != null
                                              ? index.textColor!
                                              : ColorPallet.kPrimaryColor,
                                        )),
                              );
                              break;
                            case "3rdParty":
                              try {
                                await LaunchApp.openApp(
                                    androidPackageName: index.androidId);
                              } catch (err) {
                                try {
                                  await launchUrl(Uri.parse(
                                      'https://play.google.com/store/apps/details?id=${index.androidId}'));
                                } catch (err) {
                                  DebugLogger.error(err);
                                }
                              }

                              break;
                            default:
                              print("Not implemented");
                              break;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.15),
                            //     offset: const Offset(0, 4),
                            //     blurRadius: 15,
                            //     spreadRadius: 5,
                            //   ),
                            // ],
                            color: color.withOpacity(0.85),
                            borderRadius: width >= 1200
                                ? BorderRadius.circular(60)
                                : width >= 600
                                    ? BorderRadius.circular(30)
                                    : BorderRadius.circular(20),
                          ),
                          child: LayoutBuilder(
                            builder:
                                (BuildContext context, BoxConstraints constraints) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        0,
                                        // 0.3306 * constraints.maxWidth,
                                        0.05 * constraints.maxHeight,
                                        0,
                                        // 0.3306 * constraints.maxWidth,
                                        0.025 * constraints.maxHeight,
                                      ),
                                      child: index.type == "RSS"
                                          ? Icon(
                                              Icons.rss_feed,
                                              size: width < 900
                                                  ? 0.53 * constraints.maxHeight
                                                  : 0.6 * constraints.maxHeight,
                                              color: state.secondaryColor,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: index.imageUrl ?? "",
                                              fit: BoxFit.contain,
                                              height: width < 900
                                                  ? 0.53 * constraints.maxHeight
                                                  : 0.6 * constraints.maxHeight,
                                              width: 0.6 * constraints.maxWidth,
                                              placeholder: (context, url) =>
                                                  SizedBox(
                                                height: height * 0.04,
                                                child: Shimmer.fromColors(
                                                    baseColor: ColorPallet.kWhite,
                                                    highlightColor:
                                                        ColorPallet.kPrimaryGrey,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.photo,
                                                          size: height * 0.04,
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.photo,
                                                      color: state.secondaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              fadeInCurve: Curves.easeIn,
                                              fadeInDuration:
                                                  const Duration(milliseconds: 100),
                                            )),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.1 * constraints.maxWidth,
                                          0.02 * constraints.maxHeight,
                                          0.1 * constraints.maxWidth,
                                          0.05 * constraints.maxHeight),
                                      child: Text(
                                        index.title,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: index.textColor,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize:
                                              MediaQuery.of(context).orientation ==
                                                      Orientation.landscape
                                                  ? width / 68
                                                  : height / 68,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                  }
                );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
        builder: (context, themeState) {
      return FamiciScaffold(
        backgroundImage: themeState.background,

        title: Padding(
          padding: EdgeInsets.only(
              bottom: 0.003 * MediaQuery.of(context).size.width),
          child: Padding(
            padding: EdgeInsets.only(),
            child: Container(
              child: CachedNetworkImage(
                imageUrl: themeState.logo,
                fit: BoxFit.fill,
                placeholder: (context, url) => SizedBox(
                  height: height * 0.04,
                  child: Shimmer.fromColors(
                      baseColor: ColorPallet.kWhite,
                      highlightColor: ColorPallet.kPrimaryGrey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo,
                            size: height * 0.04,
                          ),
                        ],
                      )),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                    children: <Widget>[
                      Icon(
                        Icons.photo,
                        color: ColorPallet.kPrimaryTextColor,
                      ),
                    ],
                  ),
                ),
                fadeInCurve: Curves.easeIn,
                fadeInDuration: const Duration(milliseconds: 100),
              ),
            ),
          ),
        ),

        //Color(0xff7E869D),

        child: BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
            buildWhen: (cur, prev) {
          print("hey status " + cur.status.name);
          if (cur.mainModuleItems != prev.mainModuleItems ||
              cur.status != prev.status) {
            return true;
          } else
            return false;
        }, builder: (contextM, stateForDashboard) {

          List<Widget> m = stateForDashboard.mainModuleItems.map((value) {
            // log("stateForDashboard.mainModuleItems.map ${value.title} || ${value.documentId}");
            return _widget(value.color, context, value);
          }).toList();
          if (stateForDashboard.feeds.length > 0) {
            m.insert(
                0,
                _widget(
                    themeState.primaryColor,
                    context,
                    MainModuleItem(
                        id: 0,
                        title: "RSS",
                        image: "image",
                        url: "url",
                        imageUrl: "imageUrl",
                        type: "RSS",
                        color: themeState.primaryColor,
                        position: 0,
                        textColor: themeState.secondaryColor,
                        androidId: "",
                        iosId: "",
                        windowsId: "",
                        isSensitive: false,
                        showQR: false)));
          }
          return Container(
            // padding: EdgeInsets.only(top:0.01 * height),
            width: double.infinity,
            height: height * 0.90,
            child: stateForDashboard.status == Status.loading
                ? LoadingScreen()
                //
                : ListView(
                    shrinkWrap: true,
                    children: [
                      StaggeredGrid.count(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 4
                              : width <= 600
                                  ? 3
                                  : width <= 900
                                      ? 3
                                      : 3,
                          children: m),
                    ],
                  ),
          );
        }),
      );
    });
  }
}
