part of '../add_medication_screen.dart';

class MedicationSafetyDisclaimer extends StatefulWidget {
  const MedicationSafetyDisclaimer({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  State<MedicationSafetyDisclaimer> createState() =>
      _MedicationSafetyDisclaimerState();
}

class _MedicationSafetyDisclaimerState
    extends State<MedicationSafetyDisclaimer> {
  AddMedicationBloc get addMedicationBloc => widget.addMedicationBloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              MedicationStrings.medicationSafetyDisclaimer.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: 15.0,
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              child: BlocBuilder<AddMedicationBloc, AddMedicationState>(
                bloc: addMedicationBloc,
                builder: (context, state) {
                  return FCTextFormField(
                    readOnly: true,
                    key: FCElementID.medicationAdditionalInput,
                    //initialValue: widget.addMedicationBloc.state.medicationAdditionalDetails.value,
                    initialValue:
                        widget.addMedicationBloc.state.safetyDisclaimerContent,
                    hasError: widget.addMedicationBloc.state
                        .medicationAdditionalDetails.invalid,
                    error: widget.addMedicationBloc.state
                        .medicationAdditionalDetails.error?.message,
                    maxLines: 10,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicButton(
                  minDistance: 4,
                  style: FCStyle.buttonCardStyle.copyWith(
                      shadowLightColor:
                          ColorPallet.kCardShadowColor.withOpacity(0.4),
                      border: widget.addMedicationBloc.state
                              .safetyDisclaimerToggleInput.invalid
                          ? NeumorphicBorder(
                              width: 2.0,
                              color: ColorPallet.kRed,
                            )
                          : NeumorphicBorder.none(),
                      boxShape: NeumorphicBoxShape.circle(),
                      lightSource: LightSource.top),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget
                              .addMedicationBloc.state.safetyDisclaimerAccepted
                          ? ColorPallet.kGreen
                          : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 45,
                      color: widget
                              .addMedicationBloc.state.safetyDisclaimerAccepted
                          ? ColorPallet.kLightBackGround
                          : Colors.transparent,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.addMedicationBloc
                          .add(OnToggleMedicationSafetyDisclaimer());
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.addMedicationBloc
                          .add(OnToggleMedicationSafetyDisclaimer());
                    });
                  },
                  child: Text(
                    MedicationStrings
                        .confirmThatYouHaveReadAllOfTheInformationAbove
                        .tr(),
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicButton(
                  minDistance: 4,
                  style: FCStyle.buttonCardStyle.copyWith(
                      shadowLightColor:
                          ColorPallet.kCardShadowColor.withOpacity(0.4),
                      border: widget.addMedicationBloc.state
                              .safetyDisclaimerToggleInput.invalid
                          ? NeumorphicBorder(
                              width: 2.0,
                              color: ColorPallet.kRed,
                            )
                          : NeumorphicBorder.none(),
                      boxShape: NeumorphicBoxShape.circle(),
                      lightSource: LightSource.top),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !widget
                              .addMedicationBloc.state.safetyDisclaimerAccepted
                          ? ColorPallet.kGreen
                          : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 45,
                      color: !widget
                              .addMedicationBloc.state.safetyDisclaimerAccepted
                          ? ColorPallet.kLightBackGround
                          : Colors.transparent,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.addMedicationBloc
                          .add(OnToggleMedicationSafetyDisclaimer());
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.addMedicationBloc
                          .add(OnToggleMedicationSafetyDisclaimer());
                    });
                  },
                  child: Text(
                    MedicationStrings
                        .declineThatYouHaveReadAllOfTheInformationAbove
                        .tr(),
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold),
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
