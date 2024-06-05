import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/router/router.dart';

import '../../../../feature/education/education_bloc/education_bloc.dart';
import '../../../../feature/kiosk_generic/screen/kiosk_sub_dashboard.dart';
import '../../../../feature/kiosk_generic/widgets/custom_in_app_webview.dart';
import '../../../../feature/kiosk_generic/widgets/kiosk_scaffold.dart';
import '../../../../feature/kiosk_generic/widgets/pdf_viewer_screen.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../blocs/sensitive_timer_bloc/sensitive_timer_bloc.dart';
import '../../../blocs/sensitive_timer_bloc/sensitive_timer_event.dart';
import '../../../blocs/sensitive_timer_bloc/sensitive_timer_state.dart';
import '../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../template/kiosk/entity/main_module_item.dart';
import '../../template/kiosk/kiosk_screen.dart';
import '../home_screen.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
    this.id, {
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.iconImage,
    required this.color,
    required this.textColor,
    required this.route,
    this.item,
  });

  final double height;
  final double width;
  final String title;
  final String iconImage;
  final Color color;
  final Color textColor;
  final DashboardItem? item;
  final dynamic route;
  final String? id;

  @override
  Widget build(BuildContext context) {
    if (route == "kiosk") {
      print("image data $iconImage");
    }

    return BlocBuilder<SensitiveTimerBloc, SensitiveTimerState>(
      builder: (sensContext, sensState) {
        return GestureDetector(
          onTap: () async {

            context.read<EducationBloc>().add(OnGetEducationData(dashboardId: '236'));

            DashboardItem app = item ??
                DashboardItem(
                    id: "1", name: "no", height: 1, width: 1, fileId: "fileId");

            print("this is type ${app.type}");

            if (app.type == "pdf") {
              String? fileLink;
              if (app.documentId != null && app.documentId != "") {
                fileLink = await getDocumentUrl(app.documentId!);
                print(" ${app.documentId} this is file link $fileLink");
              }
              if (app.isSensitive) {
                debugPrint(
                    "App Type : ${app.type} || Starting the sensitive timer");
                sensState.st = St.reset;
                context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(
                    context: context,
                    sensitiveScreenTimeOut: app.sensitiveScreenTimeOut ?? 30,
                    sensitiveAlertTimeOut: app.sensitiveAlertTimeOut ?? 15));
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PdfViewerScreen(
                        pdfUrl: fileLink ?? app.link!,
                        pdfTitle: app.name,
                        isSensitive: app.isSensitive,
                        sensitiveScreenTimeOut:
                            app.sensitiveScreenTimeOut ?? 30,
                        sensitiveAlertTimeOut: app.sensitiveAlertTimeOut ?? 15);
                  },
                ),
              );
            }
            else if (app.type == "module") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KioskSubDashboard(
                          title: app.name,
                          id: int.parse(app.id),
                          color: app.color != null
                              ? app.color!
                              : ColorPallet.kPrimary,
                          textColor: app.textColor != null
                              ? app.textColor!
                              : ColorPallet.kPrimaryColor,
                        )),
              );
            }
            else if (app.type == "video" || app.type == "link") {
              String? fileLink;
              if (app.documentId != null) {
                fileLink = await getDocumentUrl(app.documentId!);
                print("this is file link $fileLink");
              }
              if (app.isSensitive) {
                debugPrint(
                    "App Type : ${app.type} || Starting the sensitive timer");
                sensState.st = St.reset;
                context.read<SensitiveTimerBloc>().add(SensitiveTimerEvent(
                    context: context,
                    sensitiveScreenTimeOut: app.sensitiveScreenTimeOut ?? 30,
                    sensitiveAlertTimeOut: app.sensitiveAlertTimeOut ?? 15));
              }
              Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return KioskScaffold(
                      onDashboard: true,
                      body: CustomInAppWebView(
                          url: fileLink ?? app.link!,
                          isSensitive: app.isSensitive,
                          sensitiveScreenTimeOut:
                              app.sensitiveScreenTimeOut ?? 30,
                          sensitiveAlertTimeOut:
                              app.sensitiveAlertTimeOut ?? 15),
                      // InAppWebView(
                      //   initialUrlRequest: URLRequest(
                      //     url: Uri.parse(widget.link),
                      //   ),
                      // ),
                      title: app.name,
                      isSensitive: app.isSensitive,
                      sensitiveScreenTimeOut: app.sensitiveScreenTimeOut ?? 30,
                      sensitiveAlertTimeOut: app.sensitiveAlertTimeOut ?? 15);
                },
              ));
            }
            else if (route == "kiosk" && id != "" && id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KioskDashboardScreen(
                    dashboardUsed: int.parse(id!),
                  ),
                ),
              );
            }
            else {
              fcRouter.navigate(route);
            }
          },
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(5, 10),
                      blurRadius: 5,
                      spreadRadius: 5,
                      color: const Color(0xff000000).withOpacity(0.15),
                      blurStyle: BlurStyle.normal),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                route == "kiosk" || route == "generic"
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.1,
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            child: FutureBuilder<String>(
                                future: getImageUrl(iconImage),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      // Handle the error state
                                      return SizedBox(
                                        // height: size.height * 0.04,
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

                                  return CachedNetworkImage(
                                    imageUrl: snapshot.data ?? "",
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment.center,
                                    // color: Colors.redAccent,
                                    // progressIndicatorBuilder: (context, url, progress) {
                                    //   return CupertinoActivityIndicator();
                                    // },
                                    errorWidget: (ctx, url, err) {
                                      return Image.asset(
                                        "assets/icons/widget_app_icon_black.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.0652,
                                      );
                                    },
                                    placeholder: (context, url) => Container(
                                        decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/icons/widget_app_icon_black.png"),
                                      ),
                                    )),
                                    // fit: BoxFit.cover,
                                  );
                                })),
                      )
                    : iconImage.endsWith(".png")
                        ? Image.asset(
                            iconImage,
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.0652,
                          )
                        : SvgPicture.asset(
                            iconImage,
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.0652,
                          ),
                SizedBox(
                  height: route == "kiosk"
                      ? MediaQuery.of(context).size.height * 0.02
                      : MediaQuery.of(context).size.height * 0.03119,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: textColor,
                      fontSize: route == "kiosk"
                          ? MediaQuery.of(context).size.height * 0.025
                          : MediaQuery.of(context).size.height * 0.03119,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
