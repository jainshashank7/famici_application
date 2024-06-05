import 'package:animated_emoji/animated_emoji.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/router/router_delegate.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../core/screens/multiple_user_screen/entity/window_obsever.dart';
import '../../../shared/fc_back_button.dart';
import '../../../shared/fc_bottom_status_bar.dart';
import '../../../shared/famici_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../bloc/mood_tracker_bloc.dart';

class MoodTrackerOptionalScreen extends StatefulWidget {
  const MoodTrackerOptionalScreen({super.key});

  @override
  State<MoodTrackerOptionalScreen> createState() =>
      _MoodTrackerOptionalScreenState();
}

class _MoodTrackerOptionalScreenState extends State<MoodTrackerOptionalScreen> {
  List<String> tags = [];
  TextEditingController notesController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print("WIDTHH : ${width}");

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
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
              // onPressed: () {
              //   context.read<MoodTrackerBloc>().add(
              //       ChangeEmoji(emoji: AnimatedEmojis.plusSign, title: "More"));
              //   fcRouter.pop();
              // },
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
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 0.025 * width),
                      //   child: Text(
                      //     "Optional",
                      //     softWrap: true,
                      //     style: GoogleFonts.roboto(
                      //       color: ColorPallet.kCalendarSelectedText,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: height / 38,
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0.025 * width,
                            0.01 * height, 0.025 * width, 0.005 * height),
                        child: Text(
                          "What’s reason making you feel this way?",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: ColorPallet.kPrimaryTextColor,
                            fontSize: width / 34,
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0.025 * width),
                        child: Text(
                          "Select reasons that reflect your emotion",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: ColorPallet.kPrimaryTextColor,
                            fontSize: height / 40,
                          ),
                        ),
                      ),

                      // Tags
                      Container(
                        padding: EdgeInsets.fromLTRB(0.025 * width,
                            0.008 * height, 0.025 * width, 0.03 * height),
                        // height: 0.18 * height,
                        width: 0.8 * width,
                        child: SingleChildScrollView(
                          child: ChipsChoice<String>.multiple(
                            choiceBuilder: (item, index) {
                              bool isSelected = tags.contains(item
                                  .value); // Assuming selectedChoices is a list of selected values
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      tags.remove(item.value);
                                    } else {
                                      tags.add(item.value);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.015 * width,
                                      vertical: 0.015 * height),
                                  decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorPallet.kThemePrimaryColor
                                          : ColorPallet.kWhite,
                                      borderRadius:
                                          BorderRadius.circular(0.05 * height),
                                      border: Border.all(
                                          width: 1,
                                          color: isSelected
                                              ? ColorPallet.kThemePrimaryColor
                                              : ColorPallet.kBlack
                                                  .withOpacity(0.5))),
                                  child: Text(
                                    item.label,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: height / 40,
                                      color: isSelected
                                          ? ColorPallet.kWhite
                                          : ColorPallet.kBlack,
                                    ),
                                  ),
                                ),
                              );
                            },
                            scrollPhysics: ScrollPhysics(),
                            wrapped: true,
                            spacing: 0.02 * width,
                            value: tags,
                            onChanged: (val) => setState(() => tags = val),
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: moodState.categoryWiseTags[
                                      moodState.emoticon.category] ??
                                  [],
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0.025 * width),
                        child: Text(
                          "Any thing you want to add",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color:
                                ColorPallet.kPrimaryTextColor.withOpacity(0.6),
                            fontSize: width < 500 ? height / 35 : width / 36,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(0.025 * width,
                            0.02 * height, 0.025 * width, 0.04 * height),
                        height: 0.23 * height,
                        width: 0.65 * width,
                        child: TextField(
                          onTap: () {
                            Future.delayed(const Duration(seconds: 1), () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: width / 56,
                          ),
                          keyboardType: TextInputType.name,
                          controller: notesController,
                          maxLines: 30,
                          cursorColor: ColorPallet.kFadedGrey,
                          decoration: InputDecoration(
                            hintText:
                                "Add your notes on any thought that reflect your mood",
                            hintMaxLines: 2,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: width / 56,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            // contentPadding: EdgeInsets.symmetric(
                            //     vertical: 0.10 * height,
                            //     horizontal: 0.03 * width),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(0.01 * height),
                              borderSide: BorderSide(
                                color: ColorPallet.kGrey,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(0.01 * height),
                              borderSide: BorderSide(
                                  color: ColorPallet.kGrey, width: 1),
                            ),
                          ),
                        ),
                      ),
                      // Proceed to Save Button

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              popUp(context);
                            },
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 0.05 * height),
                              alignment: Alignment.center,
                              child: Text(
                                "Skip and Update",
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  color: ColorPallet.kBlack.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: height / 38,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                print("SELECTED TAGS: $tags");
                                context.read<MoodTrackerBloc>().add(
                                    CreateMoodTrackerRecord(
                                        tags: tags,
                                        notes: notesController.text));
                                popUp(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 0.01 * width),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.02 * width),
                                width: 0.16 * width,
                                height: 0.08 * height,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(0.01 * height),
                                  color: ColorPallet.kThemePrimaryColor,
                                  border: Border.all(
                                    width: 1,
                                    color: ColorPallet.kThemePrimaryColor,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Proceed",
                                      softWrap: true,
                                      style: GoogleFonts.poppins(
                                        color: ColorPallet.kWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: width / 46,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: ColorPallet.kWhite,
                                      size: 0.04 * height,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      KeyboardVisibilityBuilder(
                        builder: (context, child, isKeyboardVisible) {
                          if (isKeyboardVisible) {
                            return SizedBox(height: 0.38 * height);
                          } else {
                            return SizedBox(height: 0.01 * height);
                          }
                        },
                        child: const Placeholder(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

void popUp(BuildContext context) {
  Map<String, List<String>> data = {
    "pleasant": ["You're on a good way !", "Your day is going amazing"],
    "neutral": ["Be kind to yourself !", "You're doing awesome"],
    "negative": [
      "One step at a time !",
      "You are capable of doing great things"
    ],
  };

  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;

      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          // insetPadding: EdgeInsets.symmetric(
          // horizontal: shortestSide < 520 ? shortestSide * 0.07 : 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.02 * height))),
          child: Container(
            width: 0.4 * width,
            height: 0.55 * height,
            padding: EdgeInsets.only(
                top: 0,
                left: 0.05 * width,
                right: 0.05 * width,
                bottom: 0.02 * height),
            child: BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
              builder: (context, stateM) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      Container(
                        height: 0.18 * height,
                        margin: EdgeInsets.symmetric(vertical: 0.02 * height),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/icons/emoji_bg.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        height: 0.1 * height,
                        width: 0.2 * width,
                        child: AnimatedEmoji(
                          context.read<MoodTrackerBloc>().state.emoticon.emoji!,
                          repeat: true,
                          size: 0.1 * height,
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        Text(
                          data[context
                              .read<MoodTrackerBloc>()
                              .state
                              .emoticon
                              .category]![0],
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: ColorPallet.kPrimaryTextColor,
                            fontSize: width / 45,
                          ),
                        ),
                        Text(
                          data[context
                              .read<MoodTrackerBloc>()
                              .state
                              .emoticon
                              .category]![1],
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: ColorPallet.kPrimaryTextColor,
                            fontSize: width / 45,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Keep tracking your mood to know how to improve your mental health.",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: ColorPallet.kPrimaryTextColor.withOpacity(0.6),
                        fontSize: width / 60,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print(fcRouter.stack);
                        Navigator.pop(context);
                        context.read<MoodTrackerBloc>().add(ChangeEmoji(
                            emoji: AnimatedEmojis.plusSign, title: "More"));

                        print(stateM.templateId);

                        if (stateM.templateId == 1) {
                          fcRouter.popUntil(
                              (route) => route.settings.name == "HomeRoute");
                        } else if (stateM.templateId == 2) {
                          fcRouter.popUntil(
                              (route) => route.settings.name == "FCHomeRoute");
                        } else if (stateM.templateId == 3) {
                          fcRouter.popUntil((route) =>
                              route.settings.name ==
                              "CustomerSupportHomeRoute");
                        }
                      },
                      child: Container(
                          width: 0.3 * width,
                          height: 0.07 * height,
                          margin:
                              EdgeInsets.symmetric(vertical: 0.015 * height),
                          decoration: BoxDecoration(
                            color: ColorPallet.kThemeTertiaryColor,
                            borderRadius: BorderRadius.circular(0.01 * height),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: ColorPallet.kBlack.withOpacity(0.03),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Got it",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              color: ColorPallet.kSecondaryText,
                              fontSize: height / 34,
                            ),
                          )),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
