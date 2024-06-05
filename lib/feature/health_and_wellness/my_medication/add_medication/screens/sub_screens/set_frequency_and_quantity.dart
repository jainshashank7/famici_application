part of '../add_medication_screen.dart';

class SetFrequencyAndQuantity extends StatelessWidget {
  const SetFrequencyAndQuantity({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: FCStyle.blockSizeVertical*5,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        MedicationStrings.frequency.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FCStyle.largeFontSize,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        MedicationStrings.howManyTimesADayDoYouNeedToTakeThisMedication.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: FCStyle.mediumFontSize,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              context.incrementDecrementButton(
                                  addMedicationBloc: addMedicationBloc,
                                  type: IncrementDecrementBtnType.decrement,
                                  isFrequency: true),
                              SizedBox(
                                width: 30,
                              ),
                              context.countIndicator(addMedicationBloc: addMedicationBloc,isFrequency: true),
                              SizedBox(width: 30,),
                              context.incrementDecrementButton(
                                  addMedicationBloc: addMedicationBloc,
                                  type: IncrementDecrementBtnType.increment,
                                  isFrequency: true),
                            ],
                          ),
                          (addMedicationBloc.state.frequency<=0 && addMedicationBloc.state.showErrors)?
                          Text(
                            "*"+ MedicationStrings.textFieldEmptyError.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPallet.kRed,
                              fontWeight: FontWeight.w400,
                              fontSize: FCStyle.defaultFontSize,
                            ),
                          ):SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: FCStyle.blockSizeHorizontal*10,),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MedicationStrings.quantity.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FCStyle.largeFontSize,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: FCStyle.blockSizeHorizontal*30,
                        child: Text(
                          addMedicationBloc.state.selectedMedicationType.quantityLabel??"",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorPallet.kPrimaryTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: FCStyle.mediumFontSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      addMedicationBloc.state.selectedMedicationType.hasQuantity!?
                      Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  context.incrementDecrementButton(
                                      addMedicationBloc: addMedicationBloc,
                                      type: IncrementDecrementBtnType.decrement,
                                      isFrequency: false),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  context.countIndicator(addMedicationBloc: addMedicationBloc,isFrequency: false),
                                  SizedBox(width: 30,),
                                  context.incrementDecrementButton(
                                      addMedicationBloc:addMedicationBloc,
                                      type: IncrementDecrementBtnType.increment,
                                      isFrequency: false),
                                ],
                              ),
                              (addMedicationBloc.state.quantity<=0 && addMedicationBloc.state.showErrors)?
                              Text(
                                "*"+ MedicationStrings.textFieldEmptyError.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorPallet.kRed,
                                  fontWeight: FontWeight.w400,
                                  fontSize: FCStyle.defaultFontSize,
                                ),
                              ):SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ):
                      context.asNeededFromQuantity()
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}


