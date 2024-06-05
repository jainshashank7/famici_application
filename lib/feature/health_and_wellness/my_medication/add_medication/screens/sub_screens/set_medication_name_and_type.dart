part of '../add_medication_screen.dart';

class SetMedicationNameAndType extends StatefulWidget {
  const SetMedicationNameAndType({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  State<SetMedicationNameAndType> createState() =>
      _SetMedicationNameAndTypeState();
}

class _SetMedicationNameAndTypeState extends State<SetMedicationNameAndType> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              MedicationStrings.medicationName.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FCStyle.mediumFontSize + 4,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: 32.0,
              ),
              width: MediaQuery.of(context).size.width * 1 / 3,
              child: (widget.addMedicationBloc.state.isEditing &&
                      widget.addMedicationBloc.state.medicationName.value ==
                          "" &&
                      widget.addMedicationBloc.state.selectedMedicationType
                              .medicationTypeId ==
                          null)
                  ? Text(
                      CommonStrings.fetchingDataPleaseWait.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: FCStyle.mediumFontSize + 2,
                      ),
                    )
                  : FCTextFormField(
                      textInputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                        NoLeadingSpaceFormatter(),
                      ],
                      key: FCElementID.medicationNameInput,
                      initialValue:
                          widget.addMedicationBloc.state.medicationName.value,
                      hasError:
                          widget.addMedicationBloc.state.medicationName.invalid,
                      error: widget.addMedicationBloc.state.medicationName.error
                          ?.message,
                      focusNode: _focusNode,
                      hintText: MedicationStrings.medicationName.tr(),
                      maxLines: 1,
                      onChanged: (value) {
                        widget.addMedicationBloc
                            .add(MedicationNameChanged(value));
                      },
                      onComplete: () {
                        _focusNode.unfocus();
                      },
                    ),
            ),
            SizedBox(height: 30.0),
            Text(
              MedicationStrings.medicationType.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FCStyle.mediumFontSize + 4,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MedicationButtons().setMedicationTypeButton(
                    widget.addMedicationBloc.state.selectedMedicationType !=
                        MedicationType(),
                    context,
                    widget.addMedicationBloc,
                    EdgeInsets.only(top: 10)),
                SizedBox(
                  width: FCStyle.blockSizeHorizontal * 3,
                ),
                widget.addMedicationBloc.state.selectedMedicationType !=
                        MedicationType()
                    ? Text(
                        MedicationStrings.changeMedicationType.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: FCStyle.mediumFontSize,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
