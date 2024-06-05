import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famici/core/screens/template/kiosk/entity/rss_list.dart';
import 'package:famici/shared/fc_back_button.dart';

import '../../../../../utils/helpers/events_track.dart';
import '../kiosk_dashboard_bloc/kiosk_dashboard_bloc.dart';


class RSSSeeAllScreen extends StatefulWidget {
  @override
  State<RSSSeeAllScreen> createState() => _RSSSeeAllScreenState();
}

class _RSSSeeAllScreenState extends State<RSSSeeAllScreen> {
  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    context.read<KioskDashboardBloc>().add(ResetRSSFeedsCount());
    return true;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("Height ::: ${size.height}");
    print("Width ::: ${size.width}");
    Offset? clickDetails;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: GestureDetector(
        onTapDown: (details){
          clickDetails = details.globalPosition;
        },
        child: BlocBuilder<KioskDashboardBloc, KioskDashboardState>(
          builder: (context, dashboardState) {
            return AnimatedSwitcher(
              switchInCurve: Curves.bounceIn,
              duration: Duration(milliseconds: 500),
              child:  Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                    NetworkImage(dashboardState.background),
                    alignment: MediaQuery.of(context).orientation ==
                        Orientation.portrait
                        ? Alignment.topLeft
                        : Alignment.center,
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0.02239 * height,
                      left: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                          ? 0.02 * width
                          : 0.03125 * width,
                      right: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                          ? 0.02 * width
                          : 0.03125 * width,
                      child: Container(
                        height: height * 0.95,
                        width: double.infinity,
                        // margin: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(0.0074 * width),
                            color:
                            Color.fromRGBO(255, 255, 255, 0.90)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              child: Container(
                                // color: Colors.pink,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5),
                                height: MediaQuery.of(context)
                                    .orientation ==
                                    Orientation.landscape
                                    ? 0.08 * height
                                    : 0.06 * height,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0.02 * width,0,0.01 * width,0),
                                          child: GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<KioskDashboardBloc>()
                                                  .add(
                                                  ResetRSSFeedsCount());
                                              // TrackEvents().trackEvents("RSS Module", {
                                              //   "action": "Back Button Clicked",
                                              //   "url": "",
                                              //   "click_coordinates":
                                              //   "{${clickDetails?.dx.ceil().toString()}, ${clickDetails?.dy.ceil().toString()}}",
                                              //   "module_display_name": "Explore Related Articles"
                                              // });
                                              Navigator.pop(context);
                                            },
                                            child: FCBackButton(),
                                            // Icon(
                                            //   Icons.arrow_back_ios,
                                            //   size: MediaQuery.of(
                                            //       context)
                                            //       .orientation ==
                                            //       Orientation
                                            //           .landscape
                                            //       ? width / 50
                                            //       : height / 30,
                                            // ),
                                          ),
                                        ),
                                        Text(
                                          " Explore Related",
                                          textAlign: TextAlign.start,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: GoogleFonts
                                                  .poppins()
                                                  .fontFamily,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(
                                                  context)
                                                  .orientation ==
                                                  Orientation
                                                      .landscape
                                                  ? width / 50
                                                  : height / 44,
                                              decoration:
                                              TextDecoration
                                                  .none),
                                        ),
                                        Text(
                                          " Articles",
                                          textAlign: TextAlign.start,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: GoogleFonts
                                                  .poppins()
                                                  .fontFamily,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: const Color(
                                                  0xff4CBC9A),
                                              fontSize: MediaQuery.of(
                                                  context)
                                                  .orientation ==
                                                  Orientation
                                                      .landscape
                                                  ? width / 50
                                                  : height / 44,
                                              decoration:
                                              TextDecoration
                                                  .none),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context)
                                  .orientation ==
                                  Orientation.landscape
                                  ? !(dashboardState.showFeeds == dashboardState.feeds.length) ? height * 0.76: height * 0.84
                                  : !(dashboardState.showFeeds == dashboardState.feeds.length) ? height * 0.8: height * 0.880,
                              child: ListView.separated(
                                controller: _scroller,
                                separatorBuilder: (ctx, int index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                                physics: BouncingScrollPhysics(),
                                itemCount: dashboardState.showFeeds,
                                itemBuilder: (context, int index) {
                                  return RSSListItem(
                                      id: 2,
                                      title: dashboardState
                                          .feeds[index].title ??
                                          "",
                                      description: dashboardState
                                          .feeds[index]
                                          .description ??
                                          "",
                                      icon: dashboardState
                                          .feeds[index].imageUrl,
                                      buttonColor:
                                      Colors.yellow.shade100,
                                      iconColor: Colors.black,
                                      // line: 2,
                                      index: index,
                                      color: Colors.white,
                                      textColor: Colors.black,
                                      url: dashboardState
                                          .feeds[index].link);
                                },
                              ),
                            ),
                            !(dashboardState.showFeeds == dashboardState.feeds.length) ?
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.01 * height),
                              child: GestureDetector(
                                onTap: () {

                                  context.read<KioskDashboardBloc>().add(
                                      LoadMoreRSSFeeds(addFeeds: 5));
                                  // TrackEvents().trackEvents("RSS Module", {
                                  //   "action": "Load More Articles",
                                  //   "url": "",
                                  //   "click_coordinates":
                                  //   "{${clickDetails?.dx.ceil().toString()}, ${clickDetails?.dy.ceil().toString()}}",
                                  //   "module_display_name": "Explore Related Articles "
                                  // });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context)
                                      .orientation ==
                                      Orientation.landscape
                                      ? 0.08 * height
                                      : 0.052 * height,
                                  width: 0.4 * width,
                                  decoration: BoxDecoration(
                                      color: Color(0xff484CBE),
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Load More Articles",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily:
                                        GoogleFonts.poppins()
                                            .fontFamily,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        fontSize: MediaQuery.of(
                                            context)
                                            .orientation ==
                                            Orientation.landscape
                                            ? width / 50
                                            : height / 44,
                                        decoration:
                                        TextDecoration.none),
                                  ),
                                ),
                              ),
                            ):
                            SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      )
    );
  }
}
