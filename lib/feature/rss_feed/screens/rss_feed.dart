import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/feature/rss_feed/blocs/rss_feed_bloc.dart';
import 'package:famici/feature/rss_feed/screens/story_details.dart';
import 'package:famici/feature/rss_feed/screens/story_topics.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/router/router_delegate.dart';
import '../../../../core/screens/loading_screen/loading_screen.dart';
import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../entity/feed_category.dart';

class RssFeedScreen extends StatefulWidget {
  const RssFeedScreen({Key? key}) : super(key: key);

  @override
  _RssFeedScreenState createState() => _RssFeedScreenState();
}

class _RssFeedScreenState extends State<RssFeedScreen> {
  late RssFeedBloc _rssFeedBloc;
  final FocusScopeNode _node = FocusScopeNode();

  @override
  void initState() {
    context.read<RssFeedBloc>().add(FetchCategoriesEvent());
    _rssFeedBloc = context.read<RssFeedBloc>();
    _rssFeedBloc.add(FetchStoriesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _rssFeedBloc.add(ResetRssFeedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivity) {
        if (connectivity.hasInternet) {
          return FocusScope(
            node: _node,
            child: FamiciScaffold(
              toolbarHeight: 0,
              bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
              // resizeToAvoidBottomInset: false,
              child: BlocBuilder<RssFeedBloc, RssFeedState>(
                builder: (
                  context,
                  RssFeedState state,
                ) {
                  return Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height - 50,
                    margin: EdgeInsets.only(
                        left: 20, right: 0, top: 20, bottom: 20),
                    // decoration: BoxDecoration(
                    //   color: ColorPallet.kHealthyHabitsNavBarColor,
                    // ),

                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(235, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10)),
                          width: 210,
                          margin: EdgeInsets.only(
                            right: 8,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: FCBackButton(
                                    onPressed: state.detailsViewing
                                        ? () {
                                            context.read<RssFeedBloc>().add(
                                                BackFromViewStoryDetails());
                                          }
                                        : null,
                                    size: Size(210.w, 90.h),
                                  ),
                                ),
                              ),
                              // context.topStoriesButton(),
                              const SizedBox(
                                height: 30,
                              ),
                              // context.search(onSearch: () {
                              //   FocusScope.of(context).unfocus();
                              //   context.read<HealthyHabitsBloc>().add(
                              //         SearchBlogEvent(
                              //           term: context
                              //               .read<HealthyHabitsBloc>()
                              //               .state
                              //               .searchController
                              //               .text,
                              //         ),
                              //       );
                              // }),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Expanded(
                                child: BlocBuilder<RssFeedBloc, RssFeedState>(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: ListView.builder(
                                        padding:
                                            EdgeInsets.only(top: 6, bottom: 6),
                                        itemCount: state.categories.length,
                                        itemBuilder: (ctx, int idx) {
                                          return SidebarOption(
                                            category: state.categories[idx],
                                            selected:
                                                state.categories[idx].id ==
                                                    state.selectedCategory.id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // context.navFooter(),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: state.detailsViewing ? 0 : 25,
                                horizontal: state.detailsViewing ? 0 : 25),
                            margin: EdgeInsets.only(
                                left: state.detailsViewing ? 0 : 10,
                                right: state.detailsViewing ? 0 : 10),
                            width: state.detailsViewing
                                ? FCStyle.xLargeFontSize * 18.5
                                : FCStyle.xLargeFontSize * 18.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: state.detailsViewing
                                  ? Colors.transparent
                                  : Color.fromARGB(235, 255, 255, 255),
                            ),
                            child: Builder(builder: (context) {
                              if (state.isLoading) {
                                return Center(child: LoadingScreen());
                              } else if (state.detailsViewing) {
                                return StoryDetails();
                              } else if (state.hasNoResult) {
                                return Center(
                                  child: Text(
                                    "not found.",
                                    style: FCStyle.textStyle,
                                  ),
                                );
                              }
                              return StoryTopics();
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }

        return PopupScaffold(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPallet.kDarkYellow,
                ),
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.wifi_off,
                  color: ColorPallet.kBackground,
                  size: 64,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 48.0),
                child: Text(
                  "No Internet!\n Please check your network connection.",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: FCStyle.textStyle.copyWith(
                    fontSize: FCStyle.mediumFontSize,
                  ),
                ),
              ),
              FCBackButton(
                onPressed: () {
                  fcRouter.pop();
                },
                label: CommonStrings.back.tr(),
              )
            ],
          ),
        );
      },
    );
  },
);
  }
}

class SidebarOption extends StatelessWidget {
  const SidebarOption({
    Key? key,
    required this.category,
    this.selected = false,
  }) : super(key: key);

  final FeedCategory category;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: OutlinedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.read<RssFeedBloc>().add(
                  ViewBlogsByCategoryEvent(category),
                );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: selected
                ? ColorPallet.kPrimary
                : Color.fromARGB(255, 255, 255, 255),
            side:
                BorderSide(width: 1, color: Color.fromARGB(255, 217, 217, 255)),
          ),

          // overlayColor: MaterialStateColor.resolveWith(
          //   (states) => Theme.of(context).splashColor,
          // // ),
          // padding:
          //     MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: selected ? ColorPallet.kPrimaryText : Colors.black,
                      fontSize: 23 * FCStyle.fem,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
