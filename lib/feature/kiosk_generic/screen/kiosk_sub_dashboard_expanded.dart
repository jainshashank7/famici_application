import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:pdfx/pdfx.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enitity/user.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../core/screens/template/kiosk/kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';
import '../../../repositories/auth_repository.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/assets_paths.dart';
import '../entity/sub_module_link.dart';
import 'grid_items.dart';

class DashboardExpandedListItem extends StatefulWidget {
  const DashboardExpandedListItem(
      {super.key,
      required this.pageTitle,
      required this.title,
      required this.imageId,
      required this.description,
      required this.hasSubModule,
      required this.icon,
      required this.iconColor,
      required this.id,
        required this.documentId,
      required this.index,
      required this.color,
      required this.textColor});

  final String pageTitle;
  final String icon;
  final String imageId;
  final String title;
  final String description;
  final bool hasSubModule;
  final Color iconColor;
  final int id;
  final int index;
  final Color color;
  final Color textColor;
  final String? documentId;


  @override
  State<DashboardExpandedListItem> createState() =>
      _DashboardExpandedListItemState();
}

class _DashboardExpandedListItemState extends State<DashboardExpandedListItem> {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isExpanded = true;

  final _textController = TextEditingController();

  final List<StreamSubscription> _subscriptions = [];

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  final AuthRepository _authRepository = AuthRepository();

  Future<String?> getDocumentUrl(String docId) async {
    print("this is file link doc id $docId");;
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
    return BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
      builder: (context, state) {
        List<SubModuleLink> list = state.subModuleLinks[widget.id] ?? [];
        return FamiciScaffold(
          backgroundImage: state.background,
            // topRight: LogoutButton(),
            title: Container(
              width: 800,
              padding: EdgeInsets.only(left: 100),
              child: Center(
                child: Text(
                  widget.pageTitle!,
                  style: FCStyle.textStyle
                      .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            bottomNavbar: FCBottomStatusBar(),
            child: Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 10),
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
                    color: Color.fromARGB(228, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? size.height * 0.2
                                  : size.height * 0.11,
                              width: double.infinity,
                              margin: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? EdgeInsets.only(
                                      left: 20, right: 20, top: 10)
                                  : width >= 1200
                                      ? EdgeInsets.only(
                                          left: 50, right: 50, top: 50)
                                      : EdgeInsets.only(
                                          left: width * 0.04,
                                          right: width * 0.04,
                                          top: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: state.subModuleItems[widget.index]
                                                .allow3rdParty ==
                                            true &&
                                        Platform.isWindows
                                    ? Colors.grey
                                    : Colors.white,
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
                                    child: Builder(builder: (context) {
                                      return FutureBuilder<String>(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      // Icon(Icons.broken_image, size: 50 * FCStyle.fem, color: ColorPallet.kPrimaryTextColor,),
                                                      Text(snapshot.error
                                                          .toString()),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                            final imageUrl = snapshot.data;
                                            return CachedNetworkImage(
                                              imageUrl: imageUrl ?? "",
                                              placeholder: (context, url) =>
                                                  SizedBox(
                                                height: size.height * 0.04,
                                                child: Shimmer.fromColors(
                                                  baseColor: ColorPallet.kWhite,
                                                  highlightColor:
                                                      ColorPallet.kPrimaryGrey,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.photo,
                                                        size:
                                                            size.height * 0.04,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.broken_image,
                                                      color: ColorPallet
                                                          .kPrimaryTextColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              fadeInCurve: Curves.easeIn,
                                              fadeInDuration: const Duration(
                                                  milliseconds: 100),
                                            );
                                          });
                                    }),
                                  ),
                                  SizedBox(width: 0),
                                  Expanded(
                                    child: Container(
                                      margin: MediaQuery.of(context)
                                                  .orientation ==
                                              Orientation.portrait
                                          ? EdgeInsets.only(top: 10, bottom: 5)
                                          : EdgeInsets.zero,
                                      padding:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? const EdgeInsets.only(
                                                  left: 10, right: 10, top: 10)
                                              : const EdgeInsets.only(
                                                  left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.title,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                            .orientation ==
                                                        Orientation.landscape
                                                    ? width / 60
                                                    : height / 56,
                                                decoration: TextDecoration.none,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              widget.description,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                            .orientation ==
                                                        Orientation.landscape
                                                    ? width / 70
                                                    : height / 80,
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
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
                                  // Container(
                                  //   margin:
                                  //       EdgeInsets.only(right: size.width * 0.015),
                                  //   child: Icon(
                                  //     _isExpanded
                                  //         ? Icons.keyboard_arrow_down
                                  //         : Icons.keyboard_arrow_right,
                                  //     size: MediaQuery.of(context).orientation ==
                                  //             Orientation.landscape
                                  //         ? size.width / 20
                                  //         : width > 1200
                                  //             ? 120
                                  //             : 60,
                                  //     color: widget.iconColor,
                                  //   ),
                                  // ),
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
                                      ? EdgeInsets.only(
                                          left: 50, right: 50, top: 0)
                                      : EdgeInsets.only(
                                          left: width * 0.04,
                                          right: width * 0.04,
                                          top: 0),
                              // color: Colors.blue,
                              height: size.height * 0.44,
                              width: double.infinity,
                              child: GridItems(
                                gridViewItemList: list,
                                color: widget.color,
                                textColor: widget.textColor,
                              ),
                            ),
                          // )
                        ],
                      ),
                    ),
                    Positioned(
                      right: -14,
                      top: -10,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                            0 * FCStyle.fem, 0 * FCStyle.fem, 1 * FCStyle.fem),
                        child: TextButton(
                          onPressed: () {
                            fcRouter.pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFF514F5F),
                            radius: 30 * FCStyle.fem,
                            child: SvgPicture.asset(
                              AssetIconPath.closeIcon,
                              width: 30 * FCStyle.fem,
                              height: 30 * FCStyle.fem,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )));
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
