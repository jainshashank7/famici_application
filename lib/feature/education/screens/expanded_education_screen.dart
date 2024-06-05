import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/shared/famici_scaffold.dart';

import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../core/screens/template/kiosk/rss_feed/feed.dart';
import '../../../shared/fc_back_button.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/enums.dart';
import '../education_bloc/education_bloc.dart';
import '../entity/education_type.dart';
import 'education_feed_card.dart';

class ExpandedEducationScreen extends StatefulWidget {
  final List<RssFeedItem> feeds;
  final EducationType educationFeedItem;

  const ExpandedEducationScreen(
      {super.key, required this.feeds, required this.educationFeedItem});

  @override
  State<ExpandedEducationScreen> createState() =>
      _ExpandedEducationScreenState();
}

class _ExpandedEducationScreenState extends State<ExpandedEducationScreen> {
  ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    print("sordted ${widget.feeds}");
    return FamiciScaffold(
      title: Center(
        child: Text(
          "Education",
          style: TextStyle(
            color: ColorPallet.kPrimaryTextColor,
            fontSize: 45 * FCStyle.ffem,
            height: 0.8888888889 * FCStyle.ffem / FCStyle.fem,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      leading: FCBackButton(),
      topRight: Row(
        children: const [
          LogoutButton(),
        ],
      ),
      bottomNavbar:
          // stateM.templateId != 2 ?
          const FCBottomStatusBar(),
      // : const BottomStatusBar(),
      child: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
          return
            // state.status == Status.initial ||
            //       state.status == Status.loading
            //   ? LoadingScreen() :
            Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          20 * FCStyle.fem,
                          10 * FCStyle.fem,
                          20 * FCStyle.fem,
                          16.87 * FCStyle.fem),
                      padding: EdgeInsets.fromLTRB(35 * FCStyle.fem,
                          27 * FCStyle.fem, 31 * FCStyle.fem, 5 * FCStyle.fem),
                      decoration: BoxDecoration(
                        color: const Color(0xBBFFFFFF),
                        borderRadius: BorderRadius.circular(0.02 * height),
                      ),
                      height: 0.8 * height,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _scroll.animateTo(0,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn);
                            },
                            child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  size: 35,
                                  color: Colors.black45,
                                )),
                          ),
                          SizedBox(
                            width: width * 0.8,
                            child: ListView.builder(
                                controller: _scroll,
                                itemCount: widget.feeds.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return FeedCard(
                                    feed: widget.feeds[index],
                                    rssId:
                                        int.parse(widget.educationFeedItem.id),
                                  );
                                }),
                          ),
                          GestureDetector(
                            onTap: () {
                              _scroll.animateTo(
                                  _scroll.position.maxScrollExtent,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn);
                            },
                            child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 35,
                                  color: Colors.black45,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          fcRouter.pop();
                        },
                        child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
