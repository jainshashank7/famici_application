import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../core/screens/template/kiosk/kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../health_and_wellness/vitals_and_wellness/widgets/sliverDelegateWithFixedHeight.dart';
import 'dashboard_list.dart';

class KioskSubDashboard extends StatefulWidget {
  const KioskSubDashboard(
      {super.key,
      required this.title,
      required this.id,
      required this.color,
      required this.textColor});

  final String? title;
  final int id;
  final Color color;
  final Color textColor;

  @override
  State<KioskSubDashboard> createState() => _KioskSubDashboardState();
}

class _KioskSubDashboardState extends State<KioskSubDashboard> {
  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    context
        .read<KioskDashboardBloc>()
        .add(FetchSubModuleDetailsEvent(id: widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("Height ::: ${size.height}");
    print("Width ::: ${size.width}");
    print("Kiosk dashboard screen");

    return BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
      builder: (context, themeState) {
        return FamiciScaffold(
          backgroundImage: themeState.background,
          // topRight: LogoutButton(),
          title: Container(
            width: 800,
            padding: EdgeInsets.only(left: 100),
            child: Center(
              child: Text(
                widget.title!,
                style: FCStyle.textStyle
                    .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          bottomNavbar: FCBottomStatusBar(),
          child: BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
            builder: (context, dashboardState) {
              return AnimatedSwitcher(
                  switchInCurve: Curves.bounceIn,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          height: height * 0.9,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              right: 20, left: 20, top: 0, bottom: 10),
                          // margin: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(0.0074 * width),
                              color: Color.fromRGBO(255, 255, 255, 0.85)),
                          // child: Expanded(
                          // height: CustomScreenUtil.screenHeight * 0.1,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: 20, right: 5, bottom: 5),
                              // child:
                              // : MediaQuery.of(context).orientation ==
                              //         Orientation.portrait
                              //     ?
                              child: RawScrollbar(
                                trackVisibility: true,
                                radius: Radius.circular(10),
                                thumbColor: ColorPallet.kPrimary,
                                thickness: 5,
                                thumbVisibility: true,
                                child: GridView.builder(
                                  controller: _scroller,
                                  // separatorBuilder: (ctx, int index) {
                                  //   return SizedBox(
                                  //     height: 10,
                                  //   );
                                  // },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                    height: 135.0,
                                    crossAxisCount: 2,
                                  ),
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      dashboardState.subModuleItems.length,
                                  itemBuilder: (context, int index) {
                                    print("this is document id ${dashboardState
                                        .subModuleItems[index].documentId}");
                                    return dashboardState.subModuleItems[index]
                                                    .allow3rdParty ==
                                                true &&
                                            Platform.isWindows
                                        ? SizedBox.shrink()
                                        : DashboardListItem(
                                            imageId: dashboardState
                                                .subModuleItems[index].image,
                                            pageTitle: widget.title!,
                                            hasSubModule: false,
                                            title: dashboardState
                                                .subModuleItems[index].title,
                                            description: dashboardState
                                                .subModuleItems[index]
                                                .description,
                                            icon: dashboardState
                                                .subModuleItems[index].imageUrl,
                                            iconColor: Colors.black,
                                            id: dashboardState
                                                .subModuleItems[index].id,
                                            index: index,
                                            color: widget.color,
                                            textColor: widget.textColor,
                                            documentId: dashboardState
                                                .subModuleItems[index].documentId,
                                            isSensitive: dashboardState
                                            .subModuleItems[index].isSensitive,
                                            sensitiveScreenTimeOut: dashboardState.subModuleItems[index].sensitiveScreenTimeOut ?? 0,
                                            sensitiveAlertTimeOut: dashboardState.subModuleItems[index].sensitiveAlertTimeOut ?? 0,
                                          );
                                  },
                                ),
                              )
                              // : Container(
                              //     // height: height * 0.1,
                              //     // width: double.infinity,
                              //     child: GridView.builder(
                              //         shrinkWrap: true,
                              //         itemCount: dashboardState
                              //             .subModuleItems.length,
                              //         gridDelegate:
                              //             SliverGridDelegateWithFixedCrossAxisCount(
                              //           crossAxisCount: 1,
                              //         ),
                              //         itemBuilder:
                              //             (BuildContext context,
                              //                 int index) {
                              //           return DashboardListItem(
                              //             hasSubModule: false,
                              //             title: dashboardState
                              //                 .subModuleItems[index]
                              //                 .title,
                              //             description: dashboardState
                              //                 .subModuleItems[index]
                              //                 .description,
                              //             icon: dashboardState
                              //                 .subModuleItems[index]
                              //                 .imageUrl,
                              //             iconColor: Colors.black,
                              //             id: dashboardState
                              //                 .subModuleItems[index]
                              //                 .id,
                              //             index: index,
                              //           );
                              //         }),
                              //   ),
                              // ],
                              ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        );
      },
    );
  }
}
