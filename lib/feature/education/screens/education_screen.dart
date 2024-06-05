import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../core/screens/loading_screen/loading_screen.dart';
import '../../../shared/fc_back_button.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/constants/enums.dart';
import '../education_bloc/education_bloc.dart';
import '../entity/education_type.dart';
import 'education_item.dart';
import 'link_item.dart';

@immutable
class EducationScreen extends StatefulWidget {
  final String title;

  const EducationScreen({required this.title, super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<EducationItem> pinnedLinks = [];
  List<EducationItem> notPinnedLinks = [];
  List<EducationItem> educationFeedItems = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<EducationBloc, EducationState>(
      buildWhen: (cur, prev) => cur.status != prev.status,
      builder: (context, state) {
        pinnedLinks = state.items
            .where((item) => item.status == 1 && item.type != "rssfeed")
            .toList();
        notPinnedLinks = state.items
            .where((item) => item.status != 1 && item.type != "rssfeed")
            .toList();
        educationFeedItems =
            state.items.where((item) => item.type == "rssfeed").toList();

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
            builder: (context, stateM) {
              return FamiciScaffold(
                title: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: 45 * FCStyle.ffem,
                      height: 0.8888888889 * FCStyle.ffem / FCStyle.fem,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                leading: FCBackButton(
                    // onPressed: () {
                    //   fcRouter.pop();
                    // },
                    ),
                topRight: Row(
                  children: const [
                    LogoutButton(),
                  ],
                ),
                bottomNavbar:
                    // stateM.templateId != 2 ?
                    const FCBottomStatusBar(),
                // : const BottomStatusBar(),
                child: state.status == Status.loading
                    ? LoadingScreen()
                    : state.status == Status.failure
                        ? Center(
                            child: Container(
                              child: Text("No Results Found!",
                                  style: GoogleFonts.roboto(
                                      fontSize: 17, color: Colors.black)),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(
                                20 * FCStyle.fem,
                                0 * FCStyle.fem,
                                20 * FCStyle.fem,
                                16.87 * FCStyle.fem),
                            padding: EdgeInsets.fromLTRB(
                                35 * FCStyle.fem,
                                27 * FCStyle.fem,
                                31 * FCStyle.fem,
                                5 * FCStyle.fem),
                            decoration: BoxDecoration(
                              color: const Color(0xBBFFFFFF),
                              borderRadius:
                                  BorderRadius.circular(0.02 * height),
                            ),
                            height: 0.8 * height,
                            width: width,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.fromLTRB(0.055 * width,
                                  //       0.01 * height, 0.055 * width, 0),
                                  //   child: TextField(
                                  //     onSubmitted: (searchTerm) {
                                  //       DebugLogger.info("SEARCH TERM ${searchTerm}");
                                  //
                                  //       if (searchTerm != "" ||
                                  //           searchTerm.isNotEmpty) {
                                  //         context.read<EducationBloc>().add(
                                  //             ShowEducationSearchResults(
                                  //                 searchTerm: searchTerm));
                                  //       } else {
                                  //         context
                                  //             .read<EducationBloc>()
                                  //             .add(ResetSearchResults());
                                  //         // context.read<EducationBloc>().add(OnGetEducationData());
                                  //       }
                                  //     },
                                  //     onChanged: (searchTerm) {
                                  //       DebugLogger.warning(
                                  //           "SINGLE TERM::: $searchTerm");
                                  //       if (searchTerm == "" || searchTerm.isEmpty) {
                                  //         DebugLogger.warning(
                                  //             "Empty SINGLE TERM::: $searchTerm");
                                  //         context
                                  //             .read<EducationBloc>()
                                  //             .add(ResetSearchResults());
                                  //         // context.read<EducationBloc>().add(OnGetEducationData());
                                  //       }
                                  //     },
                                  //     decoration: InputDecoration(
                                  //       fillColor: Colors.white,
                                  //       filled: true,
                                  //       hintText:
                                  //           'Search for topics, latest articles...',
                                  //       hintStyle: TextStyle(
                                  //           fontSize: 18.0, color: Colors.grey),
                                  //       // prefixIcon: Icon(Icons.search),
                                  //       isDense: true,
                                  //       contentPadding: EdgeInsets.symmetric(
                                  //           horizontal: 0.025 * width,
                                  //           vertical: 0.02 * height),
                                  //       border: OutlineInputBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(0.25 * height),
                                  //         borderSide: BorderSide(
                                  //             color: Colors.grey, width: 0.0),
                                  //       ),
                                  //       // enabledBorder: OutlineInputBorder(
                                  //       //   borderRadius: BorderRadius.circular(30.0),
                                  //       //   borderSide: BorderSide(color: Colors.grey, width: 0.0),
                                  //       // ),
                                  //     ),
                                  //   ),
                                  // ),

                                  //Todo pinned
                                  // CustomScrollView(
                                  //   shrinkWrap: true,
                                  //   physics:
                                  //       const NeverScrollableScrollPhysics(),
                                  //   slivers: [
                                  //     SliverList(
                                  //       delegate: SliverChildBuilderDelegate(
                                  //         (BuildContext context, int index) {
                                  //           return LinkItem(
                                  //             item: pinnedLinks[index],
                                  //           );
                                  //         },
                                  //         childCount: pinnedLinks.length,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  state.searchResults.isEmpty
                                      ? CustomScrollView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          slivers: [
                                            SliverGrid(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 4,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: height / 90,
                                              ),
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (BuildContext context,
                                                    int index) {
                                                  print(
                                                      "SEARCH RESULTS LENGTH ::: ${state.searchResults.length}");
                                                  return EducationFeedItem(
                                                    educationFeedItem:
                                                        EducationType(
                                                      title: educationFeedItems[
                                                              index]
                                                          .title,
                                                      id: educationFeedItems[
                                                              index]
                                                          .rssfeedid,
                                                      feeds: educationFeedItems[
                                                              index]
                                                          .rssFeeds,
                                                      shouldShowList: false,
                                                    ),
                                                  );
                                                },
                                                childCount:
                                                    educationFeedItems.length,
                                              ),
                                            ),
                                          ],
                                        )
                                      : CustomScrollView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          slivers: [
                                            SliverGrid(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 8.0,
                                                crossAxisSpacing: 8.0,
                                                childAspectRatio: 1.0,
                                              ),
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (BuildContext context,
                                                    int index) {
                                                  print(
                                                      "SEARCH RESULTS NOT EMPTY LENGTH ::: ${state.searchResults.length}");
                                                  return EducationFeedItem(
                                                    educationFeedItem:
                                                        EducationType(
                                                      title: state
                                                          .searchResults[index]
                                                          .title,
                                                      id: state
                                                          .searchResults[index]
                                                          .rssfeedid,
                                                      feeds: state
                                                          .searchResults[index]
                                                          .rssFeeds,
                                                      shouldShowList: true,
                                                    ),
                                                  );
                                                },
                                                childCount:
                                                    state.searchResults.length,
                                              ),
                                            ),
                                          ],
                                        ),
                                  //Todo unpinned
                                  // CustomScrollView(
                                  //   shrinkWrap: true,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  //   slivers: [
                                  //     SliverList(
                                  //       delegate: SliverChildBuilderDelegate(
                                  //         (BuildContext context, int index) {
                                  //           return LinkItem(
                                  //             item: notPinnedLinks[index],
                                  //           );
                                  //         },
                                  //         childCount: notPinnedLinks.length,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
              );
            },
          ),
        );
      },
    );
  }
}
