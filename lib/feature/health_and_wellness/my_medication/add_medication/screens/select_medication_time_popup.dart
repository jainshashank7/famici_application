import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/shared/fc_primary_button.dart';
import 'package:famici/shared/popup_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/medication_strings.dart';

import '../blocs/add_medication/add_medication_bloc.dart';

class SelectMedicationTimePopup extends StatefulWidget {
  const SelectMedicationTimePopup(
      {Key? key, required this.addMedicationBloc, required this.index})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;
  final int index;

  @override
  State<SelectMedicationTimePopup> createState() =>
      _SelectMedicationTimePopupState();
}

class _SelectMedicationTimePopupState extends State<SelectMedicationTimePopup> {
  int hour = 1, min = 20;
  bool isPm = true;

  void incrementHour() {
    setState(() {
      if (hour < 12) {
        hour += 1;
      } else {
        hour = 1;
      }
    });
  }

  void decrementHour() {
    setState(() {
      if (hour > 1) {
        hour -= 1;
      } else {
        hour = 12;
      }
    });
  }

  void incrementMin() {
    setState(() {
      if (min > 58) {
        min = 0;
      } else {
        min += 1;
      }
    });
  }

  void decrementMin() {
    setState(() {
      if (min > 0) {
        min -= 1;
      } else {
        min = 59;
      }
    });
  }

  void toggleAmPm() {
    setState(() {
      isPm = !isPm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.addMedicationBloc,
      child: BlocConsumer(
          bloc: widget.addMedicationBloc,
          listener: (context, AddMedicationState state) {
            if (state.status == MedicationFormStatus.success) {
              Navigator.pop(context);
            }
          },
          builder:
              (BuildContext context, AddMedicationState addMedicationState) {
            return Scaffold(
              backgroundColor: ColorPallet.kBlack.withOpacity(0.5),
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0.0,
                      ),
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.95,
                      color: Colors.transparent,
                      constraints: BoxConstraints(
                        minHeight: 500,
                        minWidth: 600,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 60, right: 20, top: 10),
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close,
                                      color: ColorPallet.kWhite,
                                      size: FCStyle.blockSizeVertical * 10),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: ColorPallet.kWhite,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                MedicationStrings.selectTime.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorPallet.kPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: FCStyle.mediumFontSize,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: ColorPallet.kWhite,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      incrementDecrementButton(
                                          type: IncrementDecrementBtnType
                                              .increment,
                                          onTap: incrementHour),
                                      timeIndicator(time: hour.toString()),
                                      incrementDecrementButton(
                                          type: IncrementDecrementBtnType
                                              .decrement,
                                          onTap: decrementHour),
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Text(
                                      ":",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ColorPallet.kGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: FCStyle.largeFontSize,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      incrementDecrementButton(
                                          type: IncrementDecrementBtnType
                                              .increment,
                                          onTap: incrementMin),
                                      timeIndicator(
                                          time: min.toString().padLeft(2, '0')),
                                      incrementDecrementButton(
                                          type: IncrementDecrementBtnType
                                              .decrement,
                                          onTap: decrementMin),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Column(
                                    children: [
                                      incrementDecrementButton(
                                          type: IncrementDecrementBtnType
                                              .increment,
                                          onTap: toggleAmPm),
                                      timeIndicator(
                                          time: isPm
                                              ? CommonStrings.pm.tr()
                                              : CommonStrings.am.tr()),
                                      incrementDecrementButton(
                                          type: IncrementDecrementBtnType
                                              .decrement,
                                          onTap: toggleAmPm),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            FCPrimaryButton(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 32.0,
                              ),
                              onPressed: () {

                                String currTime = "${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} ${isPm ? CommonStrings.pm.tr() : CommonStrings.am.tr()}";
                                widget.addMedicationBloc.add(DosageTimeSelected(
                                    DateFormat("HH:mm")
                                        .format(DateFormat("hh:mm a").parse(
                                      "${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} ${isPm ? CommonStrings.pm.tr() : CommonStrings.am.tr()}",
                                    )),
                                    widget.index));
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  widget.addMedicationBloc
                                      .add(OnToggleLoading(false));
                                });
                                Navigator.pop(context, true);
                              },
                              color: ColorPallet.kGreen,
                              labelColor: ColorPallet.kLightBackGround,
                              fontSize: FCStyle.mediumFontSize,
                              fontWeight: FontWeight.bold,
                              label: CommonStrings.done.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget incrementDecrementButton(
          {required IncrementDecrementBtnType type,
          required Function() onTap}) =>
      GestureDetector(
        key: type == IncrementDecrementBtnType.increment
            ? FCElementID.incrementDoseButton
            : FCElementID.decrementDoseButton,
        onTap: onTap,
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
              type == IncrementDecrementBtnType.decrement
                  ? Icons.remove
                  : Icons.add,
              color: ColorPallet.kWhite,
              size: FCStyle.blockSizeVertical * 8,
            ),
          ),
        ),
      );

  Widget timeIndicator({required String time}) => Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        margin: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFE7EBF0),
            border: Border.all(color: Color(0xFF7D7D7D), width: 5)),
        child: Text(
          time.toString(),
          textAlign: TextAlign.left,
          style: TextStyle(
            color: ColorPallet.kGrey,
            fontWeight: FontWeight.w400,
            fontSize: FCStyle.largeFontSize,
          ),
        ),
      );
}

enum IncrementDecrementBtnType { increment, decrement }
