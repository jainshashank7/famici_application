import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/blocs/add_medication/add_medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/medication_type.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/screens/select_medication_type_popup_handler.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/select_details_drop_down.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/offline/local_database/notifiction_db.dart';
import '../add_medication/screens/select_medication_time_popup.dart';

class MedicationButtons {
  Widget addNewMedicationButton({required BuildContext context}) => Align(
        alignment: Alignment.centerRight,
        child: NeumorphicButton(
          key: FCElementID.addNewMedicationButton,
          style: FCStyle.primaryButtonStyle,
          onPressed: () {
            // context
            //     .read<ScreenDistributorBloc>()
            //     .add(ShowAddMedicationScreen());
            fcRouter.navigate(AddMedicationRoute());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                size: FCStyle.largeFontSize,
                color: ColorPallet.kPrimaryTextColor,
              ),
              SizedBox(
                width: FCStyle.blockSizeHorizontal * 18,
                child: Text(
                  MedicationStrings.addMedication.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: FCStyle.mediumFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget addNewMedicationButtonFromEmpty(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: NeumorphicButton(
          key: FCElementID.addNewMedicationFromEmptyButton,
          style: FCStyle.primaryButtonStyle,
          onPressed: () {
            fcRouter.navigate(AddMedicationRoute());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, top: 6),
                child: Icon(
                  Icons.add_circle,
                  size: FCStyle.blockSizeVertical * 7,
                  color: ColorPallet.kPrimaryTextColor,
                ),
              ),
              Text(
                MedicationStrings.addANewMedication.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: FCStyle.mediumFontSize + 5,
                ),
              ),
            ],
          ),
        ),
      );

  Widget viewMedicationDate({required String date, Function()? onTap}) =>
      NeumorphicButton(
        key: FCElementID.viewMedicationDateButton,
        style: FCStyle.primaryButtonStyle,
        onPressed: onTap ?? () {},
        padding: EdgeInsets.symmetric(
            vertical: FCStyle.blockSizeVertical * 2, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: FCStyle.blockSizeHorizontal * 13,
              child: Center(
                child: Text(
                  date,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: FCStyle.defaultFontSize + 3,
                  ),
                ),
              ),
            ),
            // RotatedBox(
            //   quarterTurns: 45,
            //   child: Icon(
            //     Icons.play_arrow,
            //     size: FCStyle.largeFontSize,
            //     color: ColorPallet.kPrimaryTextColor,
            //   ),
            // ),
          ],
        ),
      );

  Widget medicineItemButton({
    required Medication medication,
    required BuildContext context,
    required VoidCallback onPressed,
  }) =>
      Padding(
        padding:
            const EdgeInsets.only(left: 25, top: 10, bottom: 10, right: 20),
        child: NeumorphicButton(
          key: ValueKey('medicineItemButton+${medication.medicationId}'),
          style: FCStyle.buttonCardStyleWithBorderRadius(borderRadius: 20),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: FCStyle.blockSizeVertical),
                child: Text(
                  medication.medicationName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontSize: FCStyle.mediumFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              CachedNetworkImage(
                height: FCStyle.blockSizeVertical * 10,
                fit: BoxFit.fitHeight,
                imageUrl: medication.imgUrl ?? "",
                //httpHeaders: {"Authorization": "Bearer $token}"},
                placeholder: (context, url) => Container(
                  height: FCStyle.blockSizeVertical * 12,
                  child: Shimmer.fromColors(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.photo,
                              size: FCStyle.blockSizeVertical * 10,
                            ),
                          ),
                        ],
                      ),
                      baseColor: ColorPallet.kWhite,
                      highlightColor: ColorPallet.kPrimaryGrey),
                ),
                errorWidget: (context, url, error) => Container(
                  height: FCStyle.blockSizeVertical * 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.broken_image,
                          size: FCStyle.blockSizeVertical * 10,
                          color: ColorPallet.kPrimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                fadeInCurve: Curves.easeIn,
                fadeInDuration: const Duration(milliseconds: 100),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: FCStyle.blockSizeVertical),
                  child: Text(
                    "Next Dose: ${DateFormat(time12hFormat).format(DateFormat('HH:mm').parse(medication.nextDosage?.time ?? ''))}",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.smallFontSize + 6,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget editMedication(
          BuildContext context, MedicationState medicationState) =>
      NeumorphicButton(
        key: FCElementID.editMedicationButton,
        style: FCStyle.primaryButtonStyle,
        onPressed: () {
          fcRouter.navigate(AddMedicationRoute(
            fromEditing: true,
            medicationStateForEditing: medicationState,
          ));
        },
        child: SizedBox(
          width: FCStyle.blockSizeHorizontal * 15,
          height: FCStyle.blockSizeVertical * 6,
          child: Center(
            child: Text(
              MedicationStrings.editMedication.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
          ),
        ),
      );

  // Widget deleteMedication(BuildContext context) => NeumorphicButton(
  //       key: FCElementID.deleteMedicationButton,
  //       style: FCStyle.primaryButtonStyle,
  //       padding: EdgeInsets.all(10),
  //       onPressed: () {
  //         showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return FCConfirmDialog(
  //                 message: CommonStrings.areYouSureWantToDelete.tr(),
  //               );
  //             }).then((value) {
  //           if (value) {
  //             Navigator.pop(context);
  //             context.read<MedicationBloc>().add(DeleteMedications());
  //           } else {
  //             //Navigator.pop(context);
  //           }
  //         });
  //       },
  //       child: Container(
  //         width: 40,
  //         height: 40,
  //         alignment: Alignment.center,
  //         child: Icon(
  //           CupertinoIcons.delete_solid,
  //           color: ColorPallet.kPrimaryTextColor,
  //           size: 40,
  //         ),
  //       ),
  //     );

  static Widget intakeHistoryButton({required BuildContext context}) =>
      NeumorphicButton(
        key: FCElementID.viewIntakeHistoryButton,
        style: FCStyle.primaryButtonStyle,
        onPressed: () {
          fcRouter.navigate(IntakeHistoryRoute());
        },
        child: SizedBox(
          width: FCStyle.blockSizeHorizontal * 13,
          height: FCStyle.blockSizeVertical * 8,
          child: Center(
            child: Text(
              MedicationStrings.intakeHistory.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
          ),
        ),
      );

  Widget setMedicationTypeButton(bool selected, BuildContext context,
          AddMedicationBloc addMedicationBloc, EdgeInsets? padding) =>
      selected
          ? Padding(
              padding: padding ??
                  const EdgeInsets.only(
                      left: 25, bottom: 20, top: 50, right: 20),
              child: NeumorphicButton(
                key: FCElementID.setMedicationTypeButton,
                style:
                    FCStyle.buttonCardStyleWithBorderRadius(borderRadius: 20),
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                onPressed: () {
                  SelectMedicationTypePopupHandler()
                      .showSelectMedicationTypePopup(
                          context: context,
                          addMedicationBloc: addMedicationBloc);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      height: FCStyle.blockSizeVertical * 10,
                      fit: BoxFit.fitWidth,
                      imageUrl: addMedicationBloc
                          .state.selectedMedicationType.imageUrl
                          .toString(),
                      //httpHeaders: {"Authorization": "Bearer $token}"},
                      placeholder: (context, url) => Container(
                        child: Shimmer.fromColors(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.photo,
                                    size: FCStyle.blockSizeVertical * 10,
                                  ),
                                ),
                              ],
                            ),
                            baseColor: ColorPallet.kWhite,
                            highlightColor: ColorPallet.kPrimaryGrey),
                      ),
                      errorWidget: (context, url, error) => Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.broken_image,
                                size: FCStyle.blockSizeVertical * 10,
                                color: ColorPallet.kWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      fadeInCurve: Curves.easeIn,
                      fadeInDuration: const Duration(milliseconds: 100),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      child: Text(
                        addMedicationBloc
                            .state.selectedMedicationType.medicationType
                            .toString(),
                        softWrap: true,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            color: ColorPallet.kPrimaryTextColor,
                            fontSize: FCStyle.mediumFontSize,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addMedicationBloc.state.showErrors
                      ? Text(
                          "*" + MedicationStrings.textFieldEmptyError.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorPallet.kRed,
                            fontWeight: FontWeight.w400,
                            fontSize: FCStyle.defaultFontSize,
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 10,
                  ),
                  NeumorphicButton(
                    style: FCStyle.primaryButtonStyle,
                    onPressed: () {
                      SelectMedicationTypePopupHandler()
                          .showSelectMedicationTypePopup(
                              context: context,
                              addMedicationBloc: addMedicationBloc);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0, top: 6),
                          child: Icon(
                            Icons.add_circle,
                            size: FCStyle.mediumFontSize + 5,
                            color: ColorPallet.kPrimaryTextColor,
                          ),
                        ),
                        SizedBox(
                          width: FCStyle.blockSizeHorizontal * 22,
                          child: Text(
                            MedicationStrings.setAMedicationType.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: FCStyle.mediumFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

  Widget nextButton({
    required Function() onPressed,
    String? buttonText,
    bool? isEnd,
    bool disabled = false,
  }) =>
      Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(
            right: 32.0,
            bottom: 32.0,
          ),
          child: IgnorePointer(
            ignoring: disabled,
            child: FCPrimaryButton(
              key: FCElementID.nextButton,
              suffixIcon: Icons.arrow_forward_ios_rounded,
              width: FCStyle.blockSizeHorizontal * 7,
              height: FCStyle.blockSizeVertical * 4,
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              onPressed: onPressed,
              color: disabled ? ColorPallet.kGrey : ColorPallet.kGreen,
              labelColor: ColorPallet.kBackButtonTextColor,
              fontSize: FCStyle.mediumFontSize,
              fontWeight: FontWeight.bold,
              label: buttonText ?? CommonStrings.next.tr(),
            ),
          ));

  Widget selectMedicationTypeButton({
    required MedicationType medicationType,
    required BuildContext context,
    required AddMedicationBloc addMedicationBloc,
    EdgeInsets? padding,
    VoidCallback? onPressed,
    bool isSelected = false,
  }) =>
      Padding(
        padding: padding ??
            EdgeInsets.only(
                bottom: FCStyle.blockSizeVertical * 3,
                top: FCStyle.blockSizeVertical * 3,
                right: FCStyle.blockSizeVertical * 2,
                left: FCStyle.blockSizeVertical * 2),
        child: NeumorphicButton(
          key: ValueKey("selectMedicationTypeButton" +
              medicationType.medicationTypeId.toString()),
          style: isSelected
              ? FCStyle.buttonCardStyleWithBorderRadius(
                  hasBorder: false,
                  color: ColorPallet.kPrimary.withOpacity(0.4),
                  borderRadius: 20,
                )
              : FCStyle.buttonCardStyleWithBorderRadius(
                  depth: 5,
                  hasBorder: false,
                  borderRadius: 20,
                  color: Colors.white,
                ),
          padding: EdgeInsets.only(left: 0, right: 0),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                height: FCStyle.blockSizeVertical * 9,
                fit: BoxFit.fitHeight,
                imageUrl: medicationType.imageUrl ?? "",
                //httpHeaders: {"Authorization": "Bearer $token}"},
                placeholder: (context, url) => Container(
                  child: Shimmer.fromColors(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.photo,
                              size: FCStyle.blockSizeVertical * 13,
                            ),
                          ),
                        ],
                      ),
                      baseColor: ColorPallet.kPrimaryGrey,
                      highlightColor: ColorPallet.kBottomStatusBarColor),
                ),
                errorWidget: (context, url, error) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.broken_image,
                          size: FCStyle.blockSizeVertical * 13,
                          color: ColorPallet.kWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                fadeInCurve: Curves.easeIn,
                fadeInDuration: const Duration(milliseconds: 100),
              ),
              SizedBox(
                height: FCStyle.blockSizeVertical * 2,
              ),
              Container(
                child: Text(
                  medicationType.medicationType ?? "",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                      color: isSelected
                          ? Color.fromARGB(255, 89, 91, 196)
                          : ColorPallet.kPrimaryTextColor,
                      fontSize:
                          isSelected ? 26 * FCStyle.fem : 24 * FCStyle.fem,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );

  Widget selectTimeButton({
    required AddMedicationBloc addMedicationBloc,
    required int idx,
    required BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeumorphicButton(
            key: FCElementID.selectTimeButton,
            style: FCStyle.primaryButtonStyle,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SelectMedicationTimePopup(
                    addMedicationBloc: addMedicationBloc,
                    index: idx,
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              height: FCStyle.blockSizeVertical * 8,
              width: FCStyle.blockSizeHorizontal * 10,
              child: Text(
                addMedicationBloc.state.dosageList[idx].time == ""
                    ? MedicationStrings.time.tr()
                    : DateFormat("hh:mm a").format(DateFormat("HH:mm")
                        .parse(addMedicationBloc.state.dosageList[idx].time)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: FCStyle.mediumFontSize,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          addMedicationBloc.state.showErrors &&
                  addMedicationBloc.state.dosageList[idx].time == ""
              ? Padding(
                  padding:
                      EdgeInsets.only(left: FCStyle.blockSizeHorizontal * 1.5),
                  child: Text(
                    "*" + MedicationStrings.textFieldEmptyError.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPallet.kRed,
                      fontWeight: FontWeight.w400,
                      fontSize: FCStyle.defaultFontSize,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      );

  static List<String> dropDownItems = [
    MedicationStrings.takeBeforeBreakFast.tr(),
    MedicationStrings.takeAfterBreakfast.tr(),
    MedicationStrings.takeBeforeLunch.tr(),
    MedicationStrings.takeAfterLunch.tr(),
    MedicationStrings.takeBeforeDinner.tr(),
    MedicationStrings.takeAfterDinner.tr(),
    MedicationStrings.takeItWithFood.tr(),
    MedicationStrings.takeBeforeBed.tr()
  ];

  Widget selectDetailDropDown(AddMedicationBloc addMedicationBloc, int idx) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<int>(
            key: ValueKey('selectDetailDropDown' + idx.toString()),
            child: Text(
              addMedicationBloc.state.dosageList[idx].detail == ""
                  ? MedicationStrings.selectDetail.tr()
                  : addMedicationBloc.state.dosageList[idx].detail,
              textAlign: TextAlign.center,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: addMedicationBloc.state.showErrors &&
                          addMedicationBloc.state.dosageList[idx].detail == ""
                      ? ColorPallet.kRed
                      : ColorPallet.kPrimaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: FCStyle.mediumFontSize),
            ),
            onChange: (int value, int index) {
              addMedicationBloc
                  .add(DosageDetailsSelected(dropDownItems[index], idx));
            },
            dropdownButtonStyle: DropdownButtonStyle(
                height: FCStyle.blockSizeVertical * 10,
                width: FCStyle.blockSizeHorizontal * 28,
                elevation: 8,
                backgroundColor: ColorPallet.kCardBackground,
                primaryColor: ColorPallet.kPrimaryTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
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
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          item.value,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: ColorPallet.kPrimaryTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: FCStyle.mediumFontSize,
                          ),
                        )),
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: 10,
          ),
          // addMedicationBloc.state.showErrors &&
          //     addMedicationBloc.state.dosageList[idx].detail == ""
          // ? Padding(
          //   padding: EdgeInsets.only(left: FCStyle.blockSizeHorizontal*1.5),
          //   child: Text(
          //     "*" + MedicationStrings.textFieldEmptyError.tr(),
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: ColorPallet.kRed,
          //       fontWeight: FontWeight.w400,
          //       fontSize: FCStyle.defaultFontSize,
          //     ),
          //   ),
          // )
          //     : SizedBox.shrink(),
        ],
      );

  // NeumorphicButton(
  //   style: FCStyle.primaryButtonStyle,
  //   padding: EdgeInsets.only(top: 10,bottom: 10),
  //   onPressed: () {},
  //   child: Container(
  //     padding: EdgeInsets.only(top: 10,bottom: 10),
  //     alignment: Alignment.center,
  //     width: 250,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           MedicationStrings.selectDetail.tr(),
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             color: ColorPallet.kPrimaryTextColor,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 25,
  //           ),
  //         ),
  //         SizedBox(width: 10,),
  //         RotatedBox(quarterTurns: 45,
  //           child: Icon(Icons.play_arrow,size: 30,
  //             color: ColorPallet.kPrimaryTextColor,))
  //       ],
  //     ),
  //   ),
  // );

  Widget howDoYouFeelTodayButton({required BuildContext context}) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: NeumorphicButton(
          key: FCElementID.howDoYouFeelTocayButton,
          style: FCStyle.primaryButtonStyle,
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, top: 6),
                child: Icon(
                  Icons.favorite,
                  size: 40,
                  color: ColorPallet.kRed,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Text(
                  MedicationStrings.howDoYouFeelToday.tr(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 23,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

extension HealthAndWellnessScreeButtons on BuildContext {
  Widget howDoYouFeelTodayButton({VoidCallback? onPressed}) {
    return FCMaterialButton(
      key: FCElementID.howDoYouFeelTocayButton,
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: FCStyle.xLargeFontSize,
              color: ColorPallet.kRed,
            ),
            SizedBox(width: 8.0),
            Text(
              MedicationStrings.howDoYouFeelToday.tr(),
              textAlign: TextAlign.left,
              style: FCStyle.textStyle.copyWith(
                fontSize: FCStyle.defaultFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineListItem extends StatefulWidget {
  MedicineListItem({
    Key? key,
    required this.medication,
  }) : super(key: key);

  final Medication medication;

  @override
  State<MedicineListItem> createState() => _MedicineListItemState();
}

class _MedicineListItemState extends State<MedicineListItem> {
  final DatabaseHelperForNotifications notificationDb =
      DatabaseHelperForNotifications();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (widget.medication.createdByUserType == "client") {
            context
                .read<MedicationBloc>()
                .add(SelectMedication(widget.medication));
            context.read<MedicationBloc>().add(FetchMedicationDetails());
            await Future.delayed(const Duration(seconds: 1));
            print('med nammmmmme ' +
                widget.medication.medicationName.toString() +
                ' and selected med ' +
                context
                    .read<MedicationBloc>()
                    .state
                    .selectedMedication
                    .medicationName!);
          }
          else {
            context
                .read<MedicationBloc>()
                .add(SelectMedication(widget.medication));
            // MedicationDetailsPopupHandler().showMedicationDetailsPopup(
            //   context: context,
            //   medication: medication,
            // );

            List<Map<String, dynamic>> data =
                await notificationDb.getRemindersByMedicationId(
                    widget.medication.medicationId ?? "");
            String timeString = "0";
            if (data.isNotEmpty) {
              timeString = data[0]["time"];
            }
            context
                .read<MedicationBloc>()
                .add(SetSelectedMedicationReminder(timeString));

            fcRouter.navigate(const MedicationDetailsRoute());
          }
        },
        child: ((widget.medication.medicationId ==
                    context
                        .read<MedicationBloc>()
                        .state
                        .selectedMedication
                        .medicationId) &&
                widget.medication.createdByUserType == "client")
            ? Container(
                margin: EdgeInsets.only(
                    right: 16 * FCStyle.fem, bottom: 16 * FCStyle.fem),
                padding: EdgeInsets.fromLTRB(31 * FCStyle.fem, 10 * FCStyle.fem,
                    5 * FCStyle.fem, 10 * FCStyle.fem),
                height: 164 * FCStyle.fem,
                decoration: BoxDecoration(
                  color: ColorPallet.kPrimary,
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x286c6974),
                      offset: Offset(0 * FCStyle.fem, 10 * FCStyle.fem),
                      blurRadius: 15 * FCStyle.fem,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                    //       6 * FCStyle.fem, 23 * FCStyle.fem, 0 * FCStyle.fem),
                    //   padding: EdgeInsets.fromLTRB(
                    //       23 * FCStyle.fem,
                    //       19 * FCStyle.fem,
                    //       22 * FCStyle.fem,
                    //       16.95 * FCStyle.fem),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xffe8f0fd),
                    //     borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    //   ),
                    //   child: Center(
                    //     child: SizedBox(
                    //       width: 62 * FCStyle.fem,
                    //       height: 61.05 * FCStyle.fem,
                    //       child: CachedNetworkImage(
                    //         imageUrl: widget.medication.imgUrl ?? "",
                    //         width: 62 * FCStyle.fem,
                    //         height: 61.05 * FCStyle.fem,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                          0 * FCStyle.fem, 0 * FCStyle.fem, 5 * FCStyle.fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 225 * FCStyle.fem,
                            margin: EdgeInsets.fromLTRB(
                                0 * FCStyle.fem,
                                15 * FCStyle.fem,
                                0 * FCStyle.fem,
                                8 * FCStyle.fem),
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.medication.medicationName ?? "",
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 28 * FCStyle.ffem,
                                fontWeight: FontWeight.w700,
                                height:
                                    1.4285714286 * FCStyle.ffem / FCStyle.fem,
                                color: ColorPallet.kPrimaryText,
                              ),
                            ),
                          ),
                          Container(
                            width: 270 * FCStyle.fem,
                            margin: EdgeInsets.fromLTRB(
                                0 * FCStyle.fem,
                                6 * FCStyle.fem,
                                0 * FCStyle.fem,
                                10 * FCStyle.fem),
                            child: Text(
                              "${widget.medication.nextDosage?.detail ?? ""}",
                              softWrap: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 23 * FCStyle.ffem,
                                fontWeight: FontWeight.w500,
                                color: ColorPallet.kPrimaryText,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 225 * FCStyle.fem,
                          //   child: Text(
                          //     medication.nextDosage?.detail ?? "",
                          //     textAlign: TextAlign.center,
                          //     softWrap: true,
                          //     style: TextStyle(
                          //       fontFamily: 'Roboto',
                          //       fontSize: 20 * FCStyle.ffem,
                          //       fontWeight: FontWeight.w400,
                          //       height: 0.8 * FCStyle.ffem / FCStyle.fem,
                          //       color: Color(0xff001221),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  fcRouter.navigate(AddEditMedicationRoute(
                                      medicine: context
                                          .read<MedicationBloc>()
                                          .state
                                          .selectedMedicationDetails));
                                },
                                child: Container(
                                  width: 60,
                                  child: Icon(
                                    Icons.edit,
                                    color: ColorPallet.kPrimary,
                                  ),
                                  color: ColorPallet.kPrimaryText,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  // context
                                  //     .read<MedicationBloc>()
                                  //     .add(SelectMedication(widget.medication));
                                  // MedicationDetailsPopupHandler().showMedicationDetailsPopup(
                                  //   context: context,
                                  //   medication: medication,
                                  // );

                                  List<Map<String, dynamic>> data =
                                      await notificationDb
                                          .getRemindersByMedicationId(
                                              widget.medication.medicationId ??
                                                  "");
                                  String timeString = "0";
                                  if (data.isNotEmpty) {
                                    timeString = data[0]["time"];
                                  }
                                  context.read<MedicationBloc>().add(
                                      SetSelectedMedicationReminder(
                                          timeString));

                                  fcRouter
                                      .navigate(const MedicationDetailsRoute());
                                },
                                child: Container(
                                  width: 60,
                                  child: Icon(
                                    Icons.remove_red_eye_rounded,
                                    color: ColorPallet.kPrimary,
                                  ),
                                  color: ColorPallet.kPrimaryText,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FCConfirmDialog(
                                        height: 430,
                                        width: 850,
                                        submitText: 'Delete',
                                        cancelText: 'Cancel',
                                        icon: VitalIcons.deleteIcon,
                                        message:
                                            "Are you sure you want to delete the selected Medication?",
                                      );
                                    }).then((value) async {
                                  if (value) {
                                    context.read<MedicationBloc>().add(
                                        DeleteMedications(
                                            medicationId: widget
                                                .medication.medicationId!));
                                  }
                                });
                              },
                              child: Container(
                                width: 60,
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.delete,
                                    color: Color.fromARGB(255, 149, 30, 21)),
                                color: ColorPallet.kPrimaryText,
                              ),
                            )
                          ]),
                    )
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                    right: 16 * FCStyle.fem, bottom: 16 * FCStyle.fem),
                padding: EdgeInsets.fromLTRB(31 * FCStyle.fem, 10 * FCStyle.fem,
                    41 * FCStyle.fem, 10 * FCStyle.fem),
                height: 164 * FCStyle.fem,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.medication.createdByUserType == "client"
                          ? ColorPallet.kTertiary
                          : Colors.transparent,
                      width: widget.medication.createdByUserType == "client"
                          ? 1
                          : 0),
                  color: widget.medication.createdByUserType == "client"
                      ? ColorPallet.kTertiary.withOpacity(0.1)
                      : const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x286c6974),
                      offset: Offset(0 * FCStyle.fem, 10 * FCStyle.fem),
                      blurRadius: 15 * FCStyle.fem,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                          6 * FCStyle.fem, 23 * FCStyle.fem, 0 * FCStyle.fem),
                      padding: EdgeInsets.fromLTRB(
                          23 * FCStyle.fem,
                          19 * FCStyle.fem,
                          22 * FCStyle.fem,
                          16.95 * FCStyle.fem),
                      decoration: BoxDecoration(
                        color: widget.medication.createdByUserType == "client"
                            ? Color.fromARGB(255, 255, 255, 255)
                            : ColorPallet.kPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 62 * FCStyle.fem,
                          height: 61.05 * FCStyle.fem,
                          child: CachedNetworkImage(
                            imageUrl: widget.medication.imgUrl ?? "",
                            width: 62 * FCStyle.fem,
                            height: 61.05 * FCStyle.fem,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                          0 * FCStyle.fem, 0 * FCStyle.fem, 5 * FCStyle.fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 222 * FCStyle.fem,
                            margin: EdgeInsets.fromLTRB(
                                0 * FCStyle.fem,
                                15 * FCStyle.fem,
                                0 * FCStyle.fem,
                                8 * FCStyle.fem),
                            child: Text(
                              widget.medication.medicationName ?? "",
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 28 * FCStyle.ffem,
                                fontWeight: FontWeight.w700,
                                height:
                                    1.4285714286 * FCStyle.ffem / FCStyle.fem,
                                color: Color(0xff001221),
                              ),
                            ),
                          ),
                          Container(
                            width: 222 * FCStyle.fem,
                            margin: EdgeInsets.fromLTRB(
                                0 * FCStyle.fem,
                                6 * FCStyle.fem,
                                0 * FCStyle.fem,
                                10 * FCStyle.fem),
                            child: Text(
                              "${widget.medication.nextDosage?.detail ?? ""}",
                              softWrap: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 25 * FCStyle.ffem,
                                fontWeight: FontWeight.w500,
                                height: FCStyle.ffem / FCStyle.fem,
                                color: Color(0xff001221),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 225 * FCStyle.fem,
                          //   child: Text(
                          //     medication.nextDosage?.detail ?? "",
                          //     textAlign: TextAlign.center,
                          //     softWrap: true,
                          //     style: TextStyle(
                          //       fontFamily: 'Roboto',
                          //       fontSize: 20 * FCStyle.ffem,
                          //       fontWeight: FontWeight.w400,
                          //       height: 0.8 * FCStyle.ffem / FCStyle.fem,
                          //       color: Color(0xff001221),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
