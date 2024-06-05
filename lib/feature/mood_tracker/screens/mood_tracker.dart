import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famici/core/router/router.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../shared/fc_back_button.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../health_and_wellness/vitals_and_wellness/widgets/sliverDelegateWithFixedHeight.dart';
import '../bloc/mood_tracker_bloc.dart';

class MoodTrackerScreen extends StatefulWidget {
  final String title;

  const MoodTrackerScreen({required this.title, super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  bool isExpanded = false;
  int selectedIndex = -1;
  bool onTap = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;

    print("WIDTHH : ${width}");

    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
        builder: (context, stateM) {
      return FamiciScaffold(
        title: Center(
          child: Text(
            "Mood Tracker",
            style: TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: 45 * FCStyle.ffem,
              height: 0.8888888889 * FCStyle.ffem / FCStyle.fem,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: FCBackButton(
          onPressed: () {
            context.read<MoodTrackerBloc>().add(
                ChangeEmoji(emoji: AnimatedEmojis.plusSign, title: "More"));
            fcRouter.pop();
          },
        ),
        topRight: Row(
          children: const [
            LogoutButton(),
          ],
        ),
        bottomNavbar: stateM.templateId != 2
            ? const FCBottomStatusBar()
            : const BottomStatusBar(),
        child: BlocBuilder<MoodTrackerBloc, MoodTrackerState>(
          builder: (context, moodState) {
            return Container(
              margin: EdgeInsets.fromLTRB(20 * FCStyle.fem, 0 * FCStyle.fem,
                  20 * FCStyle.fem, 16.87 * FCStyle.fem),
              padding: EdgeInsets.fromLTRB(35 * FCStyle.fem, 27 * FCStyle.fem,
                  31 * FCStyle.fem, 5 * FCStyle.fem),
              decoration: BoxDecoration(
                color: const Color(0xBBFFFFFF),
                borderRadius: BorderRadius.circular(0.02 * height),
              ),
              height: 0.8 * height,
              width: width,
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading
                  Positioned(
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.02 * width),
                      child: Text(
                        "How are you feeling today ?",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          color: ColorPallet.kPrimaryColor,
                          fontSize: width / 34,
                        ),
                      ),
                    ),
                  ),

                  // Sub-heading
                  Positioned(
                    top: 0.05 * height,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0.02 * width, 0.01 * height, 0.02 * width, 0),
                      child: Text(
                        "Choose one emoji that expresses how you feel today",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          color: ColorPallet.kPrimaryTextColor,
                          fontSize: height / 40,
                        ),
                      ),
                    ),
                  ),

                  // Emoji's Grid
                  Positioned(
                    top: 0.1 * height,
                    child: Container(
                      // margin: EdgeInsets.fromLTRB(
                      //     0, 0.05 * height, 0, 0.05 * height),
                      padding: EdgeInsets.fromLTRB(0.005 * width, 0.01 * height,
                          0.005 * width, 0.005 * height),
                      height: 0.7 * height,
                      width: 0.8 * width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(0.015 * height),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(1,2),
                        //     color: ColorPallet.kThemeSecondaryColor.withOpacity(0.3),
                        //     blurRadius: 5,
                        //     spreadRadius: 5,
                        //   )
                        // ]
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: isExpanded ? 19 : 12,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                          crossAxisCount: 7,
                          crossAxisSpacing: 0.01 * width,
                          mainAxisSpacing: 0.01 * height,
                          height: 0.2 * height,
                        ),
                        physics: isExpanded
                            ? const ScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        // padding: EdgeInsets.symmetric(vertical: 0.005 * width),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (index == 11 && !isExpanded) {
                                setState(() {
                                  context.read<MoodTrackerBloc>().add(ChangeEmoji(
                                      emoji: AnimatedEmojis.cry, title: "Cry"));
                                  isExpanded = true;
                                });
                              } else {
                                setState(() {
                                  if (selectedIndex == index) {
                                    selectedIndex =
                                        -1; // Deselect if already selected
                                  } else {
                                    selectedIndex =
                                        index; // Select the tapped item
                                  }
                                });
                              }
                              setState(() {
                                onTap = false;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 0.01 * height),
                                  padding: EdgeInsets.all(0.02 * width),
                                  decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? ColorPallet.kThemePrimaryColor.withOpacity(0.90)
                                        : ColorPallet.kWhite,
                                    shape: BoxShape.circle,
                                  ),
                                  child: AnimatedEmoji(
                                    moodState.emojiList[index].emoji!,
                                    size: 0.04 * width,
                                    repeat: (index == 11 && !isExpanded)
                                        ? false
                                        : true,
                                  ),
                                ),
                                Text(
                                  moodState.emojiList[index].title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    color: ColorPallet.kPrimaryTextColor,
                                    fontSize: width / 50,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  selectedIndex == -1 && onTap
                      ? Positioned(
                    top: 0.59 * height,
                        right: 0,
                        child: Center(
                            child: Text(
                              "Please select an emotion!",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                color: ColorPallet.kRed,
                                fontSize: height / 40,
                              ),
                            ),
                          ),
                      )
                      : SizedBox.shrink(),

                  // Proceed to Next Button
                  Positioned(
                    bottom: 0.02 * height,
                    right: 0.001 * width,
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndex != -1) {
                          setState(() {});
                          fcRouter.navigate(MoodTrackerOptionalRoute());
                          context.read<MoodTrackerBloc>().add(UpdateEmoticon(
                              emoticon: moodState.emojiList[selectedIndex]));
                        } else {
                          setState(() {
                            onTap = true;
                          });
                        }
                      },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: selectedIndex == -1 && onTap
                                  ? 0.01 * height
                                  : 0.05 * height),
                          padding: EdgeInsets.symmetric(horizontal: 0.01 * width),
                          width: 0.16 * width,
                          height: 0.08 * height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.01 * height),
                            color: ColorPallet.kThemePrimaryColor,
                            border: Border.all(
                              width: 1,
                              color: ColorPallet.kCardBorderColor,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Proceed",
                                  softWrap: true,
                                  style: GoogleFonts.poppins(
                                    color: ColorPallet.kSecondaryText,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width / 46,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: ColorPallet.kSecondaryText,
                                size: 0.04 * height,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
