import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famici/core/router/router_delegate.dart';

import '../../../core/screens/loading_screen/loading_screen.dart';
import '../../../core/screens/template/kiosk/rss_feed/feed.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/constants/enums.dart';
import '../education_bloc/education_bloc.dart';
import '../entity/education_type.dart';
import 'education_feed_card.dart';

class EducationFeedItem extends StatefulWidget {
  final EducationType educationFeedItem;

  const EducationFeedItem({Key? key, required this.educationFeedItem});

  @override
  State<EducationFeedItem> createState() => _EducationFeedItemState();
}

class _EducationFeedItemState extends State<EducationFeedItem> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.educationFeedItem.shouldShowList;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Sort the list of feed items based on favorite status
    List<RssFeedItem> sortedFeeds = List.from(widget.educationFeedItem.feeds);
    sortedFeeds.sort((a, b) {
      bool isAFavorite =
          context.read<EducationBloc>().state.favorites[a.id] == 1;
      bool isBFavorite =
          context.read<EducationBloc>().state.favorites[b.id] == 1;
      if (isAFavorite && !isBFavorite) {
        return -1;
      } else if (!isAFavorite && isBFavorite) {
        return 1;
      } else {
        return 0;
      }
    });

    return BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
      return Container(
        height: 0.2 * height,
        padding: EdgeInsets.fromLTRB(
            0.025 * width,
            0.019 * height,
            0.025 * width,
            state.status == Status.uploading
                ? 0.019
                : expanded
                    ? 0
                    : 0.019 * height),
        margin: EdgeInsets.only(bottom: height * 0.02),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.015 * height),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.educationFeedItem.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: expanded
                          ? ColorPallet.kThemePrimaryColor
                          : Color(0xFF7D7F81),
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.03 * width,
                ),
                GestureDetector(
                  onTap: () {
                    print(
                        "showliststate ${widget.educationFeedItem.shouldShowList}");
                    // setState(() {
                    //   expanded = !expanded;
                    // });
                    fcRouter.navigate(ExpandedEducationRoute(feeds: sortedFeeds, educationFeedItem: widget.educationFeedItem));
                  },
                  child: Container(
                    width: 0.05 * height,
                    height: 0.05 * height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        expanded ? Icons.remove : Icons.add,
                        size: 0.045 * height,
                        color: ColorPallet.kThemePrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // state.status == Status.uploading
            //     ? Container(
            //         margin: EdgeInsets.symmetric(vertical: 0.01 * height),
            //         height: 2 * (height * 0.095 + 0.18 * width),
            //         child: const LoadingScreen(),
            //       )
            //     : const SizedBox.shrink(),
            if (expanded || widget.educationFeedItem.shouldShowList)
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.01 * height),
                height: sortedFeeds.length > 2
                    ? 2 * (height * 0.095 + 0.18 * width)
                    : sortedFeeds.length * (height * 0.095 + 0.18 * width),
                child: state.status == Status.initial &&
                        (state.currRssId == 0 ||
                            state.currRssId ==
                                int.parse(widget.educationFeedItem.id))
                    ? LoadingScreen()
                    : ListView.builder(
                        itemCount: sortedFeeds.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FeedCard(
                            feed: sortedFeeds[index],
                            rssId: int.parse(widget.educationFeedItem.id),
                          );
                        }),
              )
          ],
        ),
      );
    });
  }
}
