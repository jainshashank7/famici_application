import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:famici/shared/concave_card.dart';
import 'package:famici/shared/fc_done_indicator.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/strings/medication_strings.dart';

import '../add_medication/entity/dosage.dart';

extension MedicationDetailsWidgets on BuildContext {
  Widget getDetailsBar(
          {required BuildContext context,
          required String duration,
          required String remaining,
          required String startDate,
          required String endDate,
          required String notes,
          required bool reminderActivated}) =>
      ConcaveCard(
        radius: 20,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
              ),
              Container(
                width: FCStyle.blockSizeHorizontal * 13,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Effective date",
                      //MedicationStrings.startDate.tr(),
                      style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontSize: FCStyle.mediumFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      startDate,
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   MedicationStrings.endDate.tr(),
                    //   style: TextStyle(
                    //       color: ColorPallet.kPrimaryTextColor,
                    //       fontSize:  FCStyle.mediumFontSize,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // Text(
                    //   endDate,
                    //   style: TextStyle(
                    //     color: ColorPallet.kPrimaryTextColor,
                    //     fontSize:  FCStyle.mediumFontSize,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 2,
                height: 110,
                color: ColorPallet.kPrimaryTextColor,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  constraints: BoxConstraints(maxHeight: 150),
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MedicationStrings.notes.tr(),
                        style: TextStyle(
                            color: ColorPallet.kPrimaryTextColor,
                            fontSize: FCStyle.mediumFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        notes,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontSize: FCStyle.mediumFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 2,
                height: 110,
                color: ColorPallet.kPrimaryTextColor,
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: FCStyle.blockSizeHorizontal * 13,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      MedicationStrings.reminder.tr(),
                      style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      reminderActivated
                          ? MedicationStrings.activated.tr()
                          : MedicationStrings.deActivated.tr(),
                      style: TextStyle(
                        color: reminderActivated
                            ? ColorPallet.kBrightGreen
                            : ColorPallet.kDarkRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget doseDetails({required List<Dosage> dosageList}) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: 40),
            child: Row(
              children: [
                SizedBox(
                  width: FCStyle.largeFontSize * 6,
                ),
                Text(
                  MedicationStrings.when.tr(),
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: FCStyle.blockSizeHorizontal * 12,
                ),
                Text(
                  MedicationStrings.howMuch.tr() + "?",
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: FCStyle.blockSizeHorizontal * 3,
                ),
                Text(
                  MedicationStrings.taken.tr() + "?",
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.mediumFontSize,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: FCStyle.blockSizeHorizontal * 4,
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
          ),
          Container(
            //height: FCStyle.blockSizeVertical*40,
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: dosageList.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: FCStyle.largeFontSize * 4,
                        child: Text(
                          MedicationStrings.dose.tr() + " ${index + 1}",
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize + 2,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: FCStyle.blockSizeHorizontal * 2,
                      ),
                      ConcaveCard(
                        radius: 20,
                        child: Container(
                          width: FCStyle.blockSizeHorizontal * 15,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 20, top: 20),
                          child: Text(
                            DateFormat("hh:mm a").format(DateFormat("HH:mm")
                                .parse(dosageList[index].time)),
                            style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: FCStyle.blockSizeHorizontal * 3,
                      ),
                      ConcaveCard(
                        radius: 20,
                        child: Container(
                          width: FCStyle.blockSizeHorizontal * 15,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 20, top: 20),
                          child: Text(
                            dosageList[index].quantity.value,
                            style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: FCStyle.blockSizeHorizontal * 3,
                      ),
                      FCDoneIndicator(
                        isDone: dosageList[index].hasTaken ?? false,
                      ),
                      SizedBox(
                        width: FCStyle.blockSizeHorizontal * 3,
                      ),
                      Text(
                        dosageList[index].detail,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontSize: FCStyle.mediumFontSize - 2,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
  Widget colorCodes() => Container(
      height: 300,
      width: FCStyle.blockSizeHorizontal * 30.5,
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Color Status',
              style: TextStyle(
                fontFamily: 'roboto',
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 35 * FCStyle.fem,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorCode(
                      color: Color.fromARGB(255, 76, 188, 154),
                      text: MedicationStrings.fullyTaken.tr()),
                  colorCode(
                      color: Color.fromARGB(255, 89, 91, 196),
                      text: MedicationStrings.partiallyTaken.tr()),
                  colorCode(
                      color: ColorPallet.kFadedRed,
                      text: MedicationStrings.missed.tr()),
                ])
          ],
        ),
      ));

  Widget colorCode({required Color color, required String text}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45 * FCStyle.fem,
            height: 45 * FCStyle.fem,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            text,
            style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontSize: 26 * FCStyle.fem,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w600),
          ),
        ],
      );
}
