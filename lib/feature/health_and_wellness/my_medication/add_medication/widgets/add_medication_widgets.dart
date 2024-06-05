import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/fc_primary_button.dart';
import '../../../../../shared/fc_text_form_field.dart';
import '../../../../../utils/barrel.dart';
import '../../../../../utils/config/color_pallet.dart';
import '../../../../../utils/config/famici.theme.dart';
import '../../../../../utils/helpers/widget_key.dart';
import '../../../../../utils/strings/medication_strings.dart';
import '../../widgets/medication_buttons.dart';
import '../blocs/add_medication/add_medication_bloc.dart';

extension AddMedicationWidgets on BuildContext {
  Widget dosageDetailsColumnHeaders() => Container(
    padding: EdgeInsets.only(left: FCStyle.blockSizeHorizontal * 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          MedicationStrings.time.tr(),
          style: TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.mediumFontSize,
              fontWeight: FontWeight.normal),
        ),
        SizedBox(
          width: FCStyle.blockSizeHorizontal * 12,
        ),
        Text(
          MedicationStrings.howMuch.tr(),
          style: TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.mediumFontSize,
              fontWeight: FontWeight.normal),
        ),
        SizedBox(
          width: FCStyle.blockSizeHorizontal * 10,
        ),
        Text(
          MedicationStrings.details.tr(),
          style: TextStyle(
              color: ColorPallet.kPrimaryTextColor,
              fontSize: FCStyle.mediumFontSize,
              fontWeight: FontWeight.normal),
        ),
      ],
    ),
  );
  Widget dosageDetails(
      BuildContext context, AddMedicationBloc addMedicationBloc) =>
      Container(
        //height: 320,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: addMedicationBloc.state.frequency,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          MedicationStrings.dose.tr() + " ${index + 1}",
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: FCStyle.blockSizeHorizontal * 3,
                        ),
                        MedicationButtons().selectTimeButton(
                            addMedicationBloc: addMedicationBloc,
                            idx: index,
                            context: context),
                      ],
                    ),
                    SizedBox(width: FCStyle.blockSizeHorizontal * 3),
                    addMedicationBloc.state.dosageList[index].hasQuantity
                        ? Container(
                      width: FCStyle.blockSizeHorizontal * 18,
                      alignment: Alignment.center,
                      child: FCTextFormField(
                        key: ValueKey(
                            "howMuchDoseInput" + index.toString()),
                        initialValue: addMedicationBloc
                            .state.dosageList[index].quantity.value,
                        hasError: addMedicationBloc
                            .state.dosageList[index].quantity.invalid,
                        error: addMedicationBloc.state.dosageList[index]
                            .quantity.error?.message,
                        hintText: MedicationStrings.howMuch.tr(),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textInputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.allow(
                            RegExp(r"^[1-9]*$"),
                          ),
                          NoLeadingSpaceFormatter(),
                        ],
                        onChanged: (value) {
                          addMedicationBloc
                              .add(HowMuchDosageChanged(value, index));
                        },
                        onComplete: () {
                          FocusScope.of(context).unfocus();
                          // _focusNode.unfocus();
                        },
                      ),
                    )
                        : Center(
                      child: SizedBox(
                        height: FCStyle.blockSizeVertical * 10,
                        width: FCStyle.blockSizeHorizontal * 18,
                        child: asNeeded(),
                      ),
                    ),
                    SizedBox(
                      width: FCStyle.blockSizeHorizontal * 3,
                    ),
                    Expanded(
                        child: MedicationButtons()
                            .selectDetailDropDown(addMedicationBloc, index)),
                    SizedBox(
                      width: FCStyle.blockSizeHorizontal * 4,
                    ),
                    addMedicationBloc.state.dosageList.length>1? deleteButton(
                        addMedicationBloc: addMedicationBloc, index: index):
                    SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        ),
      );
  Widget asNeeded() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPallet.kCardBackground,
            boxShadow: [
              BoxShadow(
                color: ColorPallet.kBlack,
                spreadRadius: -6,
                offset: Offset(0, 5),
                blurRadius: 20,
              ),
            ]),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPallet.kBrightGreen,
          ),
          child: Icon(
            Icons.done,
            color: ColorPallet.kWhite,
            size: FCStyle.blockSizeVertical * 6,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        MedicationStrings.asNeeded.tr(),
        style: TextStyle(
          color: ColorPallet.kPrimaryTextColor,
          fontWeight: FontWeight.w400,
          fontSize: FCStyle.mediumFontSize,
        ),
      )
    ],
  );

  Widget deleteButton(
      {required AddMedicationBloc addMedicationBloc, required int index}) =>
      GestureDetector(
        key: FCElementID.doseDeleteButton,
        onTap: () {
          addMedicationBloc.add(DecrementDosageCount(index));
          Future.delayed(const Duration(milliseconds: 500), () {
            addMedicationBloc.add(OnToggleLoading(false));
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            height: FCStyle.blockSizeVertical * 10,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallet.kWhite,
                boxShadow: [
                  BoxShadow(
                    color: ColorPallet.kBlack,
                    spreadRadius: -6,
                    offset: Offset(0, 5),
                    blurRadius: 20,
                  ),
                ]),
            child: Icon(
              CupertinoIcons.delete_solid,
              color: ColorPallet.kPrimaryColor,
              size: FCStyle.blockSizeVertical * 5,
            ),
          ),
        ),
      );
  Widget incrementButton({required AddMedicationBloc addMedicationBloc}) =>
      GestureDetector(
        key: FCElementID.incrementButton,
        onTap: () {
          addMedicationBloc.add(IncrementDosageCount());
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kCardBackground,
              boxShadow: [
                BoxShadow(
                  color: ColorPallet.kBlack,
                  spreadRadius: -6,
                  offset: Offset(0, 5),
                  blurRadius: 20,
                ),
              ]),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kBrightGreen,
            ),
            child: Icon(
              Icons.add,
              color: ColorPallet.kWhite,
              size: FCStyle.blockSizeVertical * 8,
            ),
          ),
        ),
      );

  Widget incrementDecrementButton(
      {required AddMedicationBloc addMedicationBloc,
        required IncrementDecrementBtnType type,
        required bool isFrequency}) =>
      GestureDetector(
        key: type == IncrementDecrementBtnType.increment
            ? FCElementID.incrementDoseButton
            : FCElementID.decrementDoseButton,
        onTap: () {
          if (isFrequency) {
            if (type == IncrementDecrementBtnType.increment) {
              addMedicationBloc.add(IncrementDosageCount());
            } else {
              addMedicationBloc.add(
                  DecrementDosageCount(addMedicationBloc.state.frequency - 1));
            }
          } else {
            if (type == IncrementDecrementBtnType.increment) {
              addMedicationBloc.add(IncrementQuantity());
            } else {
              addMedicationBloc.add(DecrementQuantity());
            }
          }
        },
        child: Container(
          height: FCStyle.blockSizeVertical * 13,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kCardBackground,
              boxShadow: [
                BoxShadow(
                  color: ColorPallet.kBlack,
                  spreadRadius: -6,
                  offset: Offset(0, 5),
                  blurRadius: 20,
                ),
              ]),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kBrightGreen,
            ),
            child: Icon(
              type == IncrementDecrementBtnType.decrement
                  ? Icons.remove
                  : Icons.add,
              color: ColorPallet.kWhite,
              size: FCStyle.blockSizeVertical * 10,
            ),
          ),
        ),
      );

  Widget countIndicator(
      {required AddMedicationBloc addMedicationBloc,
        required bool isFrequency}) =>
      Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFE7EBF0),
            border: Border.all(
                color: isFrequency
                    ? (!addMedicationBloc.state.showErrors ||
                    addMedicationBloc.state.frequency > 0)
                    ? ColorPallet.kGrey
                    : ColorPallet.kRed
                    : (!addMedicationBloc.state.showErrors ||
                    addMedicationBloc.state.quantity > 0)
                    ? ColorPallet.kGrey
                    : ColorPallet.kRed,
                width: 5)),
        child: Text(
          isFrequency
              ? addMedicationBloc.state.frequency.toString()
              : addMedicationBloc.state.quantity.toString(),
          textAlign: TextAlign.left,
          style: TextStyle(
            color: ColorPallet.kGrey,
            fontWeight: FontWeight.w400,
            fontSize: FCStyle.largeFontSize,
          ),
        ),
      );

  Widget asNeededFromQuantity() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: FCStyle.blockSizeVertical * 12,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPallet.kCardBackground,
            boxShadow: [
              BoxShadow(
                color: ColorPallet.kBlack,
                spreadRadius: -6,
                offset: Offset(0, 5),
                blurRadius: 20,
              ),
            ]),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPallet.kBrightGreen,
          ),
          child: Icon(
            Icons.done,
            color: ColorPallet.kWhite,
            size: FCStyle.blockSizeVertical * 8,
          ),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Text(
        MedicationStrings.asNeeded.tr(),
        textAlign: TextAlign.left,
        style: TextStyle(
          color: ColorPallet.kPrimaryTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 25,
        ),
      )
    ],
  );

  Widget editButton({required AddMedicationBloc addMedicationBloc}) =>
      Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.only(
          left: 32.0,
          bottom: 32.0,
        ),
        child: FCPrimaryButton(
          key: FCElementID.nextButton,
          prefixIcon: Icons.arrow_back_ios,
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ),
          onPressed: () {
            addMedicationBloc.add(GoBackInitialStep());
          },
          color: ColorPallet.kDarkYellow,
          labelColor: ColorPallet.kBackButtonTextColor,
          fontSize: FCStyle.mediumFontSize,
          fontWeight: FontWeight.bold,
          label: MedicationStrings.edit.tr(),
        ),
      );
}

enum IncrementDecrementBtnType { increment, decrement }
