import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/shared/time_ago_text.dart';
import 'package:famici/utils/barrel.dart';
import 'package:shimmer/shimmer.dart';

import '../blocs/rss_feed_bloc.dart';
import '../entity/feed.dart';

class StoryTopics extends StatefulWidget {
  const StoryTopics({Key? key}) : super(key: key);

  @override
  State<StoryTopics> createState() => _StoryTopicsState();
}

class _StoryTopicsState extends State<StoryTopics> {
  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scroller.addListener(() {
    //   if (_scroller.position.pixels >
    //       0.9 * _scroller.position.maxScrollExtent) {
    //     context.read<HealthyHabitsBloc>().add(LoadMoreBlogsEvent());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RssFeedBloc, RssFeedState>(
      builder: (context,  state) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 13),
              child: Text(
                state.selectedCategory.name,
                style: TextStyle(
                  color: ColorPallet.kPrimary,
                  fontSize: 40 * FCStyle.fem,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: _scroller,
                separatorBuilder: (ctx, int index) {
                  return SizedBox(
                    height: 16,
                  );
                },
                physics: BouncingScrollPhysics(),
                itemCount: state.stories.length,
                itemBuilder: (context, int idx) {
                  return StoryListItem(
                    story: state.stories[idx],
                    onTap: () {
                      context.read<RssFeedBloc>().add(
                            ViewStoryEvent(state.stories[idx], idx),
                          );
                    },
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    Key? key,
    required this.story,
    this.onTap,
  }) : super(key: key);

  final RssFeedItem story;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 0,
        color: ColorPallet.kHealthyHabitsStoryCardColor,
        borderRadius: BorderRadius.circular(15 * FCStyle.fem),
        child: InkWell(
          borderRadius: BorderRadius.circular(FCStyle.defaultFontSize),
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 11 * FCStyle.fem,
                      top: 11 * FCStyle.fem,
                      bottom: 11 * FCStyle.fem,
                      right: 15 * FCStyle.fem,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15 * FCStyle.fem),
                        bottomLeft: Radius.circular(15 * FCStyle.fem),
                        bottomRight: Radius.circular(70 * FCStyle.fem),
                        topRight: Radius.circular(15 * FCStyle.fem),
                      ),
                      child: CachedNetworkImage(
                        height: FCStyle.blockSizeVertical * 32,
                        width: 290 * FCStyle.fem,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        imageUrl: story.imageUrl,
                        placeholder: (context, url) => SizedBox(
                          width: 150,
                          height: 150,
                          child: Shimmer.fromColors(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.photo,
                                    size: 150,
                                  ),
                                ],
                              ),
                              baseColor: ColorPallet.kWhite,
                              highlightColor: ColorPallet.kPrimaryGrey),
                        ),
                        errorWidget: (context, url, error) => SizedBox(
                          width: 150,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                            children: <Widget>[
                              Icon(
                                Icons.image_rounded,
                                size: 150,
                                color: ColorPallet.kLoadingColor,
                              ),
                              Text("No image")
                            ],
                          ),
                        ),
                        fadeInCurve: Curves.easeIn,
                        fadeInDuration: const Duration(milliseconds: 100),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     child: SvgPicture.asset(
                  //       VitalIcons.blogImageIcon,
                  //       color: Color.fromARGB(254, 79, 204, 167),
                  //     ),
                  //     width: 61 * FCStyle.fem,
                  //     height: 74 * FCStyle.fem,
                  //     right: 1,
                  //     top: 18),
                  // Positioned(
                  //     child: SvgPicture.asset(VitalIcons.blogImageCircle),
                  //     width: 61 * FCStyle.fem,
                  //     height: 74 * FCStyle.fem,
                  //     left: -10,
                  //     bottom: -18),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: FCStyle.blockSizeVertical * 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child:

                          Text(
                            story.title,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: 35 * FCStyle.fem,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: FCStyle.blockSizeVertical * 18,
                        ),
                        child:
                        Html(data: story.description),
                        // Text(
                        //   story.description,
                        //   style: TextStyle(
                        //     //overflow: TextOverflow.ellipsis,
                        //     color: Color.fromARGB(255, 87, 88, 92),
                        //     fontSize: 24 * FCStyle.fem,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        //   maxLines: 4,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                      // Row(
                      //   children: [
                      //     Flexible(
                      //       child: Row(
                      //         children: [
                      //           Container(
                      //             width: 30,
                      //             child: SvgPicture.asset(
                      //                 VitalIcons.blogImageLine,
                      //                 color: ColorPallet.kTertiary,
                      //                 fit: BoxFit.fill),
                      //           ),
                      //           const SizedBox(
                      //             width: 5,
                      //           ),
                      //           Container(
                      //             width: 230,
                      //             child: Text(
                      //               "story.author",
                      //               style: TextStyle(
                      //                 //overflow: TextOverflow.ellipsis,
                      //                 color: ColorPallet.kPrimaryTextColor,
                      //                 fontSize: 24 * FCStyle.fem,
                      //                 fontWeight: FontWeight.w400,
                      //               ),
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     // SizedBox(width: 15),
                      //     // Row(
                      //     //   children: [
                      //     //     SvgPicture.asset(
                      //     //       VitalIcons.blogImageClock,
                      //     //       color: ColorPallet.kPrimary,
                      //     //       width: 20,
                      //     //       height: 20,
                      //     //     ),
                      //     //     SizedBox(
                      //     //       width: 5,
                      //     //     ),
                      //     //     TimeAgoText(
                      //     //       isDefault: true,
                      //     //       startTime: 0,
                      //     //           // story.createdAt.millisecondsSinceEpoch,
                      //     //       textStyle: FCStyle.textStyle.copyWith(
                      //     //         fontSize: 24 * FCStyle.fem,
                      //     //         fontWeight: FontWeight.w400,
                      //     //       ),
                      //     //     ),
                      //     //   ],
                      //     // ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
