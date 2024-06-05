import 'package:cached_network_image/cached_network_image.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/feature/app_info/app_info_bloc/app_info_cubit.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/screens/notion_web_view.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/strings/common_strings.dart';
import '../../my_medication/widgets/select_details_drop_down.dart';
import '../blocs/healthy_habits_bloc.dart';

extension HealthyHabitsWidgets on BuildContext {
  Widget topStoriesButton() => FocusScope(
        child: Padding(
          padding: EdgeInsets.only(top: 36, bottom: 14),
          child: FCMaterialButton(
            color: Colors.white,
            onPressed: () {
              FocusScope.of(this).unfocus();
              read<HealthyHabitsBloc>().add(FetchStoriesEvent());
            },
            elevation: 1,
            child: SizedBox(
              width: FCStyle.blockSizeHorizontal * 20,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    MedicationStrings.topStories.tr(),
                    style: FCStyle.textStyle.copyWith(
                        color: ColorPallet.kPrimaryTextColor,
                        fontFamily: 'roboto',
                        fontSize: 30 * FCStyle.fem,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget search({required VoidCallback onSearch}) =>
      BlocBuilder<HealthyHabitsBloc, HealthyHabitsState>(
        builder: (context, state) {
          return SizedBox(
            width: FCStyle.blockSizeHorizontal * 20,
            child: TextFormField(
              style: TextStyle(
                fontSize: 25 * FCStyle.fem,
                color: Color.fromARGB(255, 80, 88, 195),
              ),
              textInputAction: TextInputAction.search,
              // onChanged: (String term) {
              //   read<HealthyHabitsBloc>().add(SearchBlogEvent(term: term));
              // },
              onFieldSubmitted: (term) {
                read<HealthyHabitsBloc>().add(SearchBlogEvent(term: term));
              },
              controller: state.searchController,
              decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                fillColor: ColorPallet.kWhite,
                hintText: CommonStrings.search.tr(),
                hintStyle: TextStyle(
                  fontSize: 25 * FCStyle.fem,
                  color: ColorPallet.kPrimaryGrey,
                ),

                suffixIcon: InkWell(
                  onTap: onSearch,
                  child: Icon(
                    CupertinoIcons.search,
                    color: ColorPallet.kPrimary,
                    size: 20,
                  ),
                ),

                // prefixIconColor: ColorPallet.kPrimaryTextColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: ColorPallet.kPrimary,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: Color.fromARGB(214, 81, 85, 195),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: ColorPallet.kPrimary,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          );
        },
      );

  Widget navOptions({
    required String name,
    VoidCallback? onTap,
  }) =>
      Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              name,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: FCStyle.mediumFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
  Widget navFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Text(
          //       CommonStrings.language.tr(),
          //       style: TextStyle(
          //         color: ColorPallet.kNavFooterColor,
          //         fontSize: FCStyle.smallFontSize,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     languageDropDown()
          //   ],
          // ),
          // SizedBox(
          //   height: FCStyle.blockSizeVertical * 2,
          // ),
          BlocBuilder<AppInfoCubit, AppInfoState>(
            builder: (context, infoState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   width: 20,
                  // ),
                  // Text(
                  //   CommonStrings.settings.tr(),
                  //   style: TextStyle(
                  //     color: ColorPallet.kNavFooterColor,
                  //     fontSize: FCStyle.smallFontSize,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 15,
                  // ),
                  InkWell(
                    onTap: () async {
                      fcRouter.pushWidget(PopupScaffold(
                        child: Stack(
                          children: [
                            NotionWebView(
                              url: infoState.info.terms.url,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: CloseIconButton(),
                            )
                          ],
                        ),
                      ));
                    },
                    child: Text(
                      CommonStrings.terms.tr(),
                      style: TextStyle(
                        color: ColorPallet.kNavFooterColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  InkWell(
                    onTap: () async {
                      fcRouter.pushWidget(PopupScaffold(
                        child: Stack(
                          children: [
                            NotionWebView(
                              url: infoState.info.privacy.url,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: CloseIconButton(),
                            )
                          ],
                        ),
                      ));
                    },
                    child: Text(
                      CommonStrings.privacy.tr(),
                      style: TextStyle(
                        color: ColorPallet.kNavFooterColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.sp),
                  InkWell(
                    onTap: () async {
                      fcRouter.pushWidget(PopupScaffold(
                        child: Stack(
                          children: [
                            NotionWebView(
                              url: infoState.info.help.url,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: CloseIconButton(),
                            )
                          ],
                        ),
                      ));
                    },
                    child: Text(
                      CommonStrings.help.tr(),
                      style: TextStyle(
                        color: ColorPallet.kNavFooterColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    CommonStrings.copyRight.tr(
                      args: [DateTime.now().year.toString()],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPallet.kCopyRightColor,
                      fontSize: FCStyle.smallFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget languageDropDown() {
    List<String> dropDownItems = [
      CommonStrings.english.tr(),
    ];
    return CustomDropdown<int>(
      child: Text(
        CommonStrings.english.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: ColorPallet.kPrimaryTextColor,
          fontWeight: FontWeight.w400,
          fontSize: FCStyle.smallFontSize,
        ),
      ),
      onChange: (int value, int index) {
        DebugLogger.info("item selected: ${dropDownItems[index]}");
      },
      icon: Icon(Icons.arrow_drop_down),
      dropdownButtonStyle: DropdownButtonStyle(
          //width: 300,
          height: 25,
          elevation: 3,
          backgroundColor: ColorPallet.kCardBackground,
          primaryColor: ColorPallet.kPrimaryTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
      dropdownStyle: DropdownStyle(
        borderRadius: BorderRadius.circular(10),
        color: ColorPallet.kCardBackground,
        elevation: 6,
        padding: EdgeInsets.all(5),
      ),
      items: dropDownItems
          // [
          //   MedicationStrings.takeBeforeBreakFast.tr(),
          //   MedicationStrings.takeAfterBreakfast.tr(),
          //   MedicationStrings.takeAfterLunch.tr(),
          //   MedicationStrings.takeBeforeLunch.tr(),
          //   MedicationStrings.takeBeforeDinner.tr(),
          //   MedicationStrings.takeAfterDinner.tr(),
          //   MedicationStrings.takeItWithFood.tr(),
          //   MedicationStrings.takeBeforeBed.tr()
          // ]
          .asMap()
          .entries
          .map(
            (item) => DropdownItem<int>(
              value: item.key + 1,
              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    item.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: ColorPallet.kPrimaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: FCStyle.smallFontSize,
                    ),
                  )),
            ),
          )
          .toList(),
    );
  }

  Widget storyDetailsContent(String? url, String? heading, String? details) =>
      Expanded(
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            CachedNetworkImage(
              height: FCStyle.blockSizeVertical * 50,
              fit: BoxFit.fitWidth, alignment: Alignment.center,
              imageUrl: url ?? "",
              //httpHeaders: {"Authorization": "Bearer $token}"},
              placeholder: (context, url) => SizedBox(
                width: 150,
                height: 150,
                child: Shimmer.fromColors(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.photo,
                            size: 150,
                          ),
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
                    Container(
                      child: Icon(
                        Icons.broken_image,
                        size: 150,
                        color: ColorPallet.kLoadingColor,
                      ),
                    ),
                  ],
                ),
              ),
              fadeInCurve: Curves.easeIn,
              fadeInDuration: const Duration(milliseconds: 100),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      heading ?? "",
                      style: TextStyle(
                        //overflow: TextOverflow.ellipsis,
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize + 6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      details ?? "",
                      style: TextStyle(
                        //overflow: TextOverflow.ellipsis,
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
